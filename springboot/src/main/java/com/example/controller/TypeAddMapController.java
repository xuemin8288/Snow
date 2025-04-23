package com.example.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.common.Result;
import com.example.entity.TestRecord;
import com.example.entity.TypeAddMap;
import com.example.entity.User;
import com.example.service.TestRecordService;
import com.example.service.TypeAddMapService;
import com.example.service.UserService;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

@RestController
@RequestMapping("/typeaddmap")
public class TypeAddMapController {
    private static final Logger logger = LoggerFactory.getLogger(TestRecordController.class);
    @Autowired
    private TypeAddMapService typeAddMapService;

    @Autowired
    private TestRecordService testRecordService;

    @Autowired
    private UserService userService;

    // 证型名称与typekey的映射关系已移至TestRecordService，此处可保留或删除
    private static final Map<String, String> TYPE_NAME_TO_TYPE_KEY = new HashMap<>();
    static {
        TYPE_NAME_TO_TYPE_KEY.put("肝阳上亢", "1");
        TYPE_NAME_TO_TYPE_KEY.put("肝肾阴虚", "2");
        TYPE_NAME_TO_TYPE_KEY.put("阴阳两虚", "3");
        TYPE_NAME_TO_TYPE_KEY.put("痰瘀内蕴", "4");
        TYPE_NAME_TO_TYPE_KEY.put("瘀血内停", "5");
    }

    @GetMapping("/all")
    public Result getAllTypeAddMaps() {
        List<TypeAddMap> typeAddMaps = typeAddMapService.getAllTypeAddMaps();
        return Result.success(typeAddMaps);
    }

    @GetMapping("/uniqueAddresses")
    public Result getUniqueAddresses() {
        List<TypeAddMap> typeAddMaps = typeAddMapService.getAllTypeAddMaps();
        List<String> uniqueAddresses = typeAddMaps.stream()
                .map(TypeAddMap::getAddress)
                .distinct()
                .collect(Collectors.toList());
        return Result.success(uniqueAddresses);
    }

    /**
     * 此方法仅用于查询数据，不再自动更新统计
     */
    @GetMapping("/selectPage")
    public Result selectPage(TestRecord testRecord,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<TestRecord> pageInfo = testRecordService.selectPage1(testRecord, pageNum, pageSize);
        return Result.success(pageInfo);
    }
    
    /**
     * 此方法用于手动更新统计数据
     */
    @GetMapping("/updateStats")
    public Result updateStats(TestRecord testRecord,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<TestRecord> pageInfo = testRecordService.selectPage1(testRecord, pageNum, pageSize);
        List<TestRecord> testRecordList = pageInfo.getList();
        Multimap<Integer, String> idToAddressMultiMap = ArrayListMultimap.create();

        logger.info("手动触发统计数据更新，查询到 {} 条记录", testRecordList.size());
        
        for (TestRecord record : testRecordList) {
            Integer userId = record.getUserId();
            try {
                User user = userService.selectById(userId);
                if (user != null) {
                    String address = user.getTypeAddress();
                    idToAddressMultiMap.put(record.getId(), address);
                    
                    // 只处理得分大于80分的记录
                    if (record.getScore() == null || record.getScore() <= 80) {
                        logger.info("记录ID: {}, 得分: {}，低于80分阈值，跳过更新", record.getId(), record.getScore());
                        continue;
                    }

                    String typeName = record.getTypeName();
                    logger.info("处理记录ID: {}, 用户ID: {}, 地址: {}, 证型: {}, 得分: {}", 
                               record.getId(), userId, address, typeName, record.getScore());
                    
                    String typeKey = null;
                    for (Map.Entry<String, String> entry : TYPE_NAME_TO_TYPE_KEY.entrySet()) {
                        if (typeName != null && typeName.contains(entry.getKey())) {
                            typeKey = entry.getValue();
                            break;
                        }
                    }
                    
                    if (typeKey != null) {
                        TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, Integer.valueOf(typeKey));
                        if (typeAddMap != null) {
                            int newValue = typeAddMap.getValue() + 1;
                            typeAddMapService.updateValueByAddressAndTypeKey(address, typeKey, newValue);
                            logger.info("成功更新 type_add_map 记录，address: {}, typeKey: {}, 新 value: {}", address, typeKey, newValue);
                        } else {
                            logger.warn("未找到 address: {}, typeKey: {} 对应的 type_add_map 记录", address, typeKey);
                        }
                    } else {
                        logger.warn("无法映射证型名称: {} 到typeKey", typeName);
                    }
                } else {
                    idToAddressMultiMap.put(record.getId(), "未找到对应的用户信息");
                    logger.warn("未找到 userId: {} 对应的用户信息", userId);
                }
            } catch (Exception e) {
                logger.error("处理 userId: {} 时出现异常", userId, e);
                e.printStackTrace();
            }
        }
        
        for (Integer id : idToAddressMultiMap.keySet()) {
            for (String address : idToAddressMultiMap.get(id)) {
                System.out.println("TestRecord ID: " + id + ", 用户 type_address: " + address);
            }
        }
        return Result.success(pageInfo);
    }

    @GetMapping("/debug")
    public Result debugTypeAddMap(@RequestParam String address, @RequestParam Integer typekey) {
        try {
            logger.info("调试 type_add_map 表: address={}, typekey={}", address, typekey);
            
            // 查询指定地址和证型的记录
            TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, typekey);
            
            if (typeAddMap != null) {
                logger.info("找到记录: address={}, typekey={}, value={}", 
                          typeAddMap.getAddress(), typeAddMap.getTypekey(), typeAddMap.getValue());
                return Result.success(typeAddMap);
            } else {
                logger.warn("未找到记录: address={}, typekey={}", address, typekey);
                
                // 列出所有记录供参考
                List<TypeAddMap> allMaps = typeAddMapService.getAllTypeAddMaps();
                logger.info("当前表中有 {} 条记录", allMaps.size());
                for (TypeAddMap map : allMaps) {
                    if (map.getAddress().equals(address) || map.getTypekey() == typekey) {
                        logger.info("发现相关记录: address={}, typekey={}, value={}", 
                                  map.getAddress(), map.getTypekey(), map.getValue());
                    }
                }
                
                return Result.error("500", "未找到记录");
            }
        } catch (Exception e) {
            logger.error("调试端点异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }

    @GetMapping("/update")
    public Result manualUpdate(@RequestParam String address, @RequestParam Integer typekey) {
        try {
            logger.info("手动更新 type_add_map 表: address={}, typekey={}", address, typekey);
            
            TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, typekey);
            if (typeAddMap != null) {
                int newValue = typeAddMap.getValue() + 1;
                typeAddMapService.updateValueByAddressAndTypeKey(address, String.valueOf(typekey), newValue);
                logger.info("成功手动更新: address={}, typekey={}, 新value={}", address, typekey, newValue);
                return Result.success("更新成功");
            } else {
                logger.warn("未找到要更新的记录: address={}, typekey={}", address, typekey);
                return Result.error("500", "未找到记录");
            }
        } catch (Exception e) {
            logger.error("手动更新异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }

    @GetMapping("/init")
    public Result initTypeAddMap() {
        try {
            logger.info("开始初始化 type_add_map 表数据");
            
            // 删除所有现有记录
            // 注意：如果没有提供删除全表的方法，可能需要先实现
            
            // 定义地区和证型
            String[] addresses = {"厦门", "福州", "莆田", "漳州", "泉州", "宁德", "三明", "南平", "龙岩"};
            Integer[] typekeys = {1, 2, 3, 4, 5}; // 肝阳上亢, 肝肾阴虚, 阴阳两虚, 痰瘀内蕴, 瘀血内停
            
            // 创建初始记录，所有值都设为0
            for (String address : addresses) {
                for (Integer typekey : typekeys) {
                    try {
                        // 检查记录是否已存在
                        TypeAddMap existingMap = typeAddMapService.getByAddressAndTypeKey(address, typekey);
                        
                        if (existingMap == null) {
                            // 使用新的createTypeAddMap方法创建记录
                            logger.info("创建记录: address={}, typekey={}, value=0", address, typekey);
                            typeAddMapService.createTypeAddMap(address, typekey, 0);
                            
                            // 不再需要临时解决方案
                            // logger.info("需要手动在数据库中插入记录: INSERT INTO type_add_map (typekey, address, value) VALUES ({}, '{}', 0)", typekey, address);
                        } else {
                            // 如果已存在，将值重置为0
                            typeAddMapService.updateValueByAddressAndTypeKey(address, String.valueOf(typekey), 0);
                            logger.info("重置记录: address={}, typekey={}, value=0", address, typekey);
                        }
                    } catch (Exception e) {
                        logger.error("处理记录时出错: address={}, typekey={}", address, typekey, e);
                    }
                }
            }
            
            logger.info("type_add_map 表数据初始化完成");
            return Result.success("初始化完成");
        } catch (Exception e) {
            logger.error("初始化 type_add_map 表数据时出错", e);
            return Result.error("500", "初始化错误: " + e.getMessage());
        }
    }

    @GetMapping("/checkTypeKey")
    public Result checkTypeKey(@RequestParam Integer typekey) {
        try {
            logger.info("检查特定证型的所有地区记录: typekey={}", typekey);
            
            List<TypeAddMap> allMaps = typeAddMapService.getAllTypeAddMaps();
            List<TypeAddMap> filteredMaps = new ArrayList<>();
            
            for (TypeAddMap map : allMaps) {
                if (map.getTypekey() == typekey) {
                    filteredMaps.add(map);
                    logger.info("找到记录: address={}, typekey={}, value={}", 
                             map.getAddress(), map.getTypekey(), map.getValue());
                }
            }
            
            logger.info("证型 {} 共有 {} 条记录", typekey, filteredMaps.size());
            return Result.success(filteredMaps);
        } catch (Exception e) {
            logger.error("检查证型记录异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }

    @GetMapping("/checkAddress")
    public Result checkAddress(@RequestParam String address) {
        try {
            logger.info("检查特定地区的所有证型记录: address={}", address);
            
            List<TypeAddMap> allMaps = typeAddMapService.getAllTypeAddMaps();
            List<TypeAddMap> filteredMaps = new ArrayList<>();
            
            for (TypeAddMap map : allMaps) {
                if (map.getAddress().equals(address)) {
                    filteredMaps.add(map);
                    logger.info("找到记录: address={}, typekey={}, value={}", 
                             map.getAddress(), map.getTypekey(), map.getValue());
                }
            }
            
            logger.info("地区 {} 共有 {} 条记录", address, filteredMaps.size());
            return Result.success(filteredMaps);
        } catch (Exception e) {
            logger.error("检查地区记录异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }

    @GetMapping("/resetValue")
    public Result resetValue(@RequestParam String address, @RequestParam Integer typekey, @RequestParam(defaultValue = "0") Integer value) {
        try {
            logger.info("重置特定记录值: address={}, typekey={}, value={}", address, typekey, value);
            
            TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, typekey);
            if (typeAddMap != null) {
                typeAddMapService.updateValueByAddressAndTypeKey(address, String.valueOf(typekey), value);
                logger.info("成功重置值: address={}, typekey={}, value={}", address, typekey, value);
                return Result.success("重置成功");
            } else {
                logger.warn("未找到要重置的记录: address={}, typekey={}", address, typekey);
                return Result.error("500", "未找到记录");
            }
        } catch (Exception e) {
            logger.error("重置值异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }

    @GetMapping("/initTypeKey")
    public Result initTypeKey(@RequestParam Integer typekey) {
        try {
            logger.info("初始化特定证型的所有记录: typekey={}", typekey);
            
            // 查询现有记录
            List<TypeAddMap> existingRecords = typeAddMapService.getByTypeKey(typekey);
            logger.info("找到 {} 条相关记录", existingRecords.size());
            
            // 输出所有记录信息
            for (TypeAddMap record : existingRecords) {
                logger.info("记录: typekey={}, address={}, value={}", 
                        record.getTypekey(), record.getAddress(), record.getValue());
            }
            
            // 重置所有记录的值为0
            for (TypeAddMap record : existingRecords) {
                typeAddMapService.updateValueByAddressAndTypeKey(
                        record.getAddress(), 
                        String.valueOf(record.getTypekey()), 
                        0);
                logger.info("已重置记录: address={}, typekey={}, value=0", 
                        record.getAddress(), record.getTypekey());
            }
            
            return Result.success("重置完成，共处理 " + existingRecords.size() + " 条记录");
        } catch (Exception e) {
            logger.error("初始化证型记录异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }
    
    @GetMapping("/testUpdate")
    public Result testUpdate(@RequestParam String address, @RequestParam Integer typekey) {
        try {
            logger.info("测试更新特定记录: address={}, typekey={}", address, typekey);
            
            // 查询记录
            TypeAddMap record = typeAddMapService.getByAddressAndTypeKey(address, typekey);
            if (record != null) {
                int oldValue = record.getValue();
                int newValue = oldValue + 1;
                
                logger.info("找到记录，当前值: {}", oldValue);
                logger.info("准备更新为: {}", newValue);
                
                // 更新记录
                typeAddMapService.updateValueByAddressAndTypeKey(address, String.valueOf(typekey), newValue);
                
                // 验证更新结果
                TypeAddMap updated = typeAddMapService.getByAddressAndTypeKey(address, typekey);
                if (updated != null) {
                    logger.info("更新后的值: {}", updated.getValue());
                    if (updated.getValue() == newValue) {
                        logger.info("更新成功!");
                    } else {
                        logger.warn("更新失败，值未变化");
                    }
                } else {
                    logger.warn("更新后记录不存在");
                }
                
                return Result.success("测试更新完成");
            } else {
                logger.warn("未找到记录: address={}, typekey={}", address, typekey);
                return Result.error("500", "记录不存在");
            }
        } catch (Exception e) {
            logger.error("测试更新异常", e);
            return Result.error("500", "异常: " + e.getMessage());
        }
    }

    /**
     * 重置所有统计数据并重新计算
     */
    @GetMapping("/resetAndRecount")
    public Result resetAndRecount() {
        try {
            logger.info("开始重置并重新计算所有统计数据");
            
            // 1. 重置所有记录的值为0
            List<TypeAddMap> allMaps = typeAddMapService.getAllTypeAddMaps();
            logger.info("找到 {} 条记录，准备重置", allMaps.size());
            
            for (TypeAddMap map : allMaps) {
                map.setValue(0);
                typeAddMapService.updateValueByAddressAndTypeKey(
                        map.getAddress(), 
                        String.valueOf(map.getTypekey()), 
                        0);
            }
            logger.info("已重置所有记录值为0");
            
            // 2. 调用updateStats重新计算所有统计
            TestRecord testRecord = new TestRecord();
            PageInfo<TestRecord> pageInfo = testRecordService.selectPage1(testRecord, 1, 1000); // 获取前1000条记录
            List<TestRecord> testRecordList = pageInfo.getList();
            Multimap<Integer, String> idToAddressMultiMap = ArrayListMultimap.create();

            logger.info("准备重新计算统计数据，找到 {} 条测试记录", testRecordList.size());
            
            for (TestRecord record : testRecordList) {
                Integer userId = record.getUserId();
                try {
                    User user = userService.selectById(userId);
                    if (user != null) {
                        String address = user.getTypeAddress();
                        idToAddressMultiMap.put(record.getId(), address);
                        
                        // 只处理得分大于80分的记录
                        if (record.getScore() == null || record.getScore() <= 80) {
                            continue;
                        }

                        String typeName = record.getTypeName();
                        logger.info("处理记录ID: {}, 用户ID: {}, 地址: {}, 证型: {}, 得分: {}", 
                                  record.getId(), userId, address, typeName, record.getScore());
                        
                        String typeKey = null;
                        for (Map.Entry<String, String> entry : TYPE_NAME_TO_TYPE_KEY.entrySet()) {
                            if (typeName != null && typeName.contains(entry.getKey())) {
                                typeKey = entry.getValue();
                                break;
                            }
                        }
                        
                        if (typeKey != null) {
                            TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, Integer.valueOf(typeKey));
                            if (typeAddMap != null) {
                                int newValue = typeAddMap.getValue() + 1;
                                typeAddMapService.updateValueByAddressAndTypeKey(address, typeKey, newValue);
                                logger.info("更新统计数据: address: {}, typeKey: {}, 新 value: {}", address, typeKey, newValue);
                            }
                        }
                    }
                } catch (Exception e) {
                    logger.error("处理记录ID: {} 时出错", record.getId(), e);
                }
            }
            
            logger.info("统计数据重新计算完成");
            return Result.success("重置并重新计算统计数据完成");
        } catch (Exception e) {
            logger.error("重置并重新计算统计数据时出错", e);
            return Result.error("500", "操作失败: " + e.getMessage());
        }
    }
}
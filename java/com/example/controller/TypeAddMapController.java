package com.example.controller;

import com.example.common.Result;
import com.example.entity.TestRecord;
import com.example.entity.Type;
import com.example.entity.TypeAddMap;
import com.example.entity.User;
import com.example.service.TestRecordService;
import com.example.service.TypeAddMapService;
import com.example.service.UserService;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;
import java.util.stream.Collectors;

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

    // 定义 typeName 与 typekey 的映射关系
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

    @GetMapping("/selectPage")
    public Result selectPage(TestRecord testRecord,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<TestRecord> pageInfo = testRecordService.selectPage1(testRecord, pageNum, pageSize);
        List<TestRecord> testRecordList = pageInfo.getList();
        Multimap<Integer, String> idToAddressMultiMap = ArrayListMultimap.create();

        Set<String> processedAddresses = new HashSet<>();

        for (TestRecord record : testRecordList) {
            Integer userId = record.getUserId();
            try {
                User user = userService.selectById(userId);
                if (user != null) {
                    String address = user.getTypeAddress();
                    idToAddressMultiMap.put(record.getId(), address);
                    if (processedAddresses.contains(address)) {
                        logger.info("address: {} 已经处理过，跳过更新", address);
                        continue;
                    }

                    String typeName = record.getTypeName();
                    String typeKey = null;
                    for (Map.Entry<String, String> entry : TYPE_NAME_TO_TYPE_KEY.entrySet()) {
                        if (typeName.contains(entry.getKey())) {
                            typeKey = entry.getValue();
                            break;
                        }
                    }
                    if (typeKey != null) {
                        TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, Integer.valueOf(typeKey));
                        if (typeAddMap != null) {
                            int newValue = typeAddMap.getValue() + 1;
                            typeAddMapService.updateValueByAddressAndTypeKey( typeKey, newValue);
                            logger.info("更新 type_add_map 记录，address: {}, typeKey: {}, 新 value: {}", address, typeKey, newValue);
                        } else {
                            logger.info("未找到 address: {}, typeKey: {} 对应的 type_add_map 记录", address, typeKey);
                        }
                    }

                    processedAddresses.add(address);
                    break;
                } else {
                    idToAddressMultiMap.put(record.getId(), "未找到对应的用户信息");
                    logger.info("未找到 userId: {} 对应的用户信息", userId);
                }
            } catch (Exception e) {
                logger.error("处理 userId: {} 时出现异常", userId, e);
            }
        }
        for (Integer id : idToAddressMultiMap.keySet()) {
            for (String address : idToAddressMultiMap.get(id)) {
                System.out.println("TestRecord ID: " + id + ", 用户 type_address: " + address);
            }
        }
        return Result.success(pageInfo);
    }
}
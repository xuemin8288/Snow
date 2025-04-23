package com.example.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.TestPaper;
import com.example.entity.TestRecord;
import com.example.entity.Topic;
import com.example.entity.TypeAddMap;
import com.example.entity.User;
import com.example.exception.CustomException;
import com.example.mapper.TestPaperMapper;
import com.example.mapper.TestRecordMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.ObjectUtil;
import jakarta.annotation.Resource;

/**
 * 测试记录业务层方法
 */
@Service
public class TestRecordService {

    @Resource
    private TestRecordMapper testRecordMapper;
    @Resource
    private TestPaperMapper testPaperMapper;
    
    // 添加TypeAddMapService和UserService的依赖
    @Resource
    private TypeAddMapService typeAddMapService;
    @Resource
    private UserService userService;
    
    // 定义证型名称与typekey的映射关系
    private static final Map<String, String> TYPE_NAME_TO_TYPE_KEY = new HashMap<>();
    static {
        TYPE_NAME_TO_TYPE_KEY.put("肝阳上亢", "1");
        TYPE_NAME_TO_TYPE_KEY.put("肝肾阴虚", "2");
        TYPE_NAME_TO_TYPE_KEY.put("阴阳两虚", "3");
        TYPE_NAME_TO_TYPE_KEY.put("痰瘀内蕴", "4");
        TYPE_NAME_TO_TYPE_KEY.put("瘀血内停", "5");
    }

    public void add(TestPaper testPaper) {
        System.out.println("======= 开始处理用户提交的测试 =======");
        // 校验用户是否将所有题目都答完了
        List<Topic> topicList = testPaper.getTopicList();
        List<Topic> collect = topicList.stream().filter(x -> ObjectUtil.isNotEmpty(x.getUserAnswer())).toList();
        if (topicList.size() != collect.size()) {
            throw new CustomException("500", "请您务必答完所有题目才能提交");
        }

        Account currentUser = TokenUtils.getCurrentUser();
        TestRecord testRecord = new TestRecord();
        testRecord.setTestPaperId(testPaper.getId());
        testRecord.setDoctorId(testPaper.getDoctorId());
        testRecord.setUserId(currentUser.getId());
        testRecord.setTime(DateUtil.now());

        // 计算用户获得的总分数：遍历topicList里面的每一个题目，把用户的答案和ABCD四个答案做比较，选中的是哪个就算哪个选项的分数
        Integer score = 0;
        for (Topic topic : topicList) {
            String userAnswer = topic.getUserAnswer();
            if (userAnswer.equals(topic.getaName())) {
                score += topic.getaScore();
            }
            if (userAnswer.equals(topic.getbName())) {
                score += topic.getbScore();
            }
            if (userAnswer.equals(topic.getcName())) {
                score += topic.getcScore();
            }
            if (userAnswer.equals(topic.getdName())) {
                score += topic.getdScore();
            }
        }
        testRecord.setScore(score);

        // 根据试卷的分数区间，获取到对应分数的结果
        String aRange = testPaper.getaRange();
        String bRange = testPaper.getbRange();
        String cRange = testPaper.getcRange();
        if (score >= Integer.parseInt(aRange.split("~")[0]) && score <= Integer.parseInt(aRange.split("~")[1])) {
            testRecord.setResult(testPaper.getaAnswer());
        }
        if (score >= Integer.parseInt(bRange.split("~")[0]) && score <= Integer.parseInt(bRange.split("~")[1])) {
            testRecord.setResult(testPaper.getbAnswer());
        }
        if (score >= Integer.parseInt(cRange.split("~")[0]) && score <= Integer.parseInt(cRange.split("~")[1])) {
            testRecord.setResult(testPaper.getcAnswer());
        }

        testRecordMapper.insert(testRecord);

        // 测试题的测试人数+1
        testPaper.setTestNum(testPaper.getTestNum() + 1);
        testPaperMapper.updateById(testPaper);
        
        // 新增: 如果得分大于80分，更新对应地区的证型统计
        if (score > 80) {
            try {
                System.out.println("得分>80，符合更新统计条件: " + score);
                // 获取用户的地址信息
                User user = userService.selectById(currentUser.getId());
                if (user != null && user.getTypeAddress() != null) {
                    String address = user.getTypeAddress();
                    
                    // 根据试卷的类型ID获取证型名称
                    String typeName = testPaper.getTypeName();
                    System.out.println("用户ID: " + currentUser.getId() + ", 地址: " + address + ", 证型: " + typeName + ", 得分: " + score);
                    System.out.println("试卷详情: ID=" + testPaper.getId() + ", 标题=" + testPaper.getTitle() + ", 类型ID=" + testPaper.getTypeId());
                    
                    if (typeName != null) {
                        // 查找匹配的证型key
                        String typeKey = null;
                        for (Map.Entry<String, String> entry : TYPE_NAME_TO_TYPE_KEY.entrySet()) {
                            if (typeName.contains(entry.getKey())) {
                                typeKey = entry.getValue();
                                System.out.println("匹配证型: " + entry.getKey() + " -> " + typeKey);
                                break;
                            }
                        }
                        
                        // 如果找到了对应的证型key，更新统计数据
                        if (typeKey != null) {
                            System.out.println("找到证型映射: " + typeName + " -> typeKey: " + typeKey);
                            try {
                                TypeAddMap typeAddMap = typeAddMapService.getByAddressAndTypeKey(address, Integer.valueOf(typeKey));
                                System.out.println("查询结果: typeAddMap = " + (typeAddMap != null ? "存在" : "不存在"));
                                
                                if (typeAddMap != null) {
                                    int oldValue = typeAddMap.getValue();
                                    int newValue = oldValue + 1;
                                    System.out.println("准备更新: address=" + address + ", typeKey=" + typeKey + ", oldValue=" + oldValue + ", newValue=" + newValue);
                                    
                                    try {
                                        typeAddMapService.updateValueByAddressAndTypeKey(address, typeKey, newValue);
                                        System.out.println("更新调用已执行");
                                        
                                        // 验证更新是否成功
                                        TypeAddMap updatedMap = typeAddMapService.getByAddressAndTypeKey(address, Integer.valueOf(typeKey));
                                        if (updatedMap != null) {
                                            System.out.println("更新后检查: value = " + updatedMap.getValue() + (updatedMap.getValue() == newValue ? " (成功)" : " (失败)"));
                                        }
                                        
                                        System.out.println("成功更新 type_add_map 记录，address: " + address + ", typeKey: " + typeKey + ", 新 value: " + newValue);
                                    } catch (Exception e) {
                                        System.err.println("调用更新方法时出错: " + e.getMessage());
                                        e.printStackTrace();
                                    }
                                } else {
                                    System.out.println("未找到 address: " + address + ", typeKey: " + typeKey + " 对应的 type_add_map 记录");
                                    System.out.println("尝试创建新记录...");
                                    typeAddMapService.createTypeAddMap(address, Integer.valueOf(typeKey), 1);
                                    System.out.println("新记录创建完成");
                                }
                            } catch (Exception e) {
                                System.err.println("处理typeAddMap时出错: " + e.getMessage());
                                e.printStackTrace();
                            }
                        } else {
                            System.out.println("无法映射证型名称: " + typeName + " 到typeKey");
                        }
                    } else {
                        System.out.println("试卷没有关联的证型名称");
                    }
                } else {
                    System.out.println("用户 " + currentUser.getId() + " 没有设置地址或用户信息不存在");
                }
            } catch (Exception e) {
                System.err.println("更新证型地区统计时出错: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("用户得分 " + score + " 不大于80分，不更新地区证型统计");
        }
        System.out.println("======= 测试处理完成 =======");
    }

    public void updateById(TestRecord testRecord) {
        testRecordMapper.updateById(testRecord);
    }

    public void deleteById(Integer id) {
        testRecordMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            testRecordMapper.deleteById(id);
        }
    }

    public TestRecord selectById(Integer id) {
        return testRecordMapper.selectById(id);
    }

    public List<TestRecord> selectAll(TestRecord testRecord) {
        return testRecordMapper.selectAll(testRecord);
    }

    public PageInfo<TestRecord> selectPage(TestRecord testRecord, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.DOCTOR.name().equals(currentUser.getRole())) {
            testRecord.setDoctorId(currentUser.getId());
        }
        if (RoleEnum.USER.name().equals(currentUser.getRole())) {
            testRecord.setUserId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<TestRecord> list = testRecordMapper.selectAll(testRecord);
        return PageInfo.of(list);
    }

    public PageInfo<TestRecord> selectPage1(TestRecord testRecord, Integer pageNum, Integer pageSize) {

        PageHelper.startPage(pageNum, pageSize);
        List<TestRecord> list = testRecordMapper.selectAll(testRecord);
        return PageInfo.of(list);
    }

}

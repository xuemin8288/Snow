package com.example.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.entity.TypeAddMap;
import com.example.mapper.TypeAddMapMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class TypeAddMapService {
    private static final Logger logger = LoggerFactory.getLogger(TypeAddMapService.class);

    @Autowired
    private TypeAddMapMapper typeAddMapMapper;

    public List<TypeAddMap> getAllTypeAddMaps() {
        return typeAddMapMapper.getAllTypeAddMaps();
    }


    public TypeAddMap getByAddress(String address) {
        return typeAddMapMapper.selectByAddress(address);
    }


    /**
     * 根据地址和证型键获取记录
     * @param address 地址
     * @param typeKey 证型键
     * @return TypeAddMap记录
     */
    public TypeAddMap getByAddressAndTypeKey(String address, Integer typeKey) {
        try {
            logger.debug("查询特定记录：address={}, typeKey={}", address, typeKey);
            return typeAddMapMapper.selectByAddressAndTypeKey(address, typeKey);
        } catch (Exception e) {
            logger.error("查询特定记录异常", e);
            return null;
        }
    }


    public void updateValueByAddressAndTypeKey(String address, String typeKey, int newValue) {
        System.out.println("DEBUG - 更新 type_add_map 记录: address=" + address + ", typeKey=" + typeKey + ", newValue=" + newValue);
        try {
            typeAddMapMapper.updateValueByAddressAndTypeKey(address, typeKey, newValue);
            System.out.println("DEBUG - 更新成功");
        } catch (Exception e) {
            System.err.println("DEBUG - 更新失败: " + e.getMessage());
            e.printStackTrace();
        }
    }



    public void updateValueByAddress(String address, int newValue) {
        typeAddMapMapper.updateValueByAddress(address, newValue);
    }


    public boolean areAllValuesZero() {
        List<TypeAddMap> allRecords = typeAddMapMapper.selectAll();
        for (TypeAddMap record : allRecords) {
            if (record.getValue() != 0) {
                return false;
            }
        }
        return true;
    }


    public void createTypeAddMap(String address, Integer typekey, int value) {
        System.out.println("DEBUG - 创建新 type_add_map 记录: address=" + address + ", typekey=" + typekey + ", value=" + value);
        try {
            TypeAddMap map = new TypeAddMap();
            map.setAddress(address);
            map.setTypekey(typekey);
            map.setValue(value);
            typeAddMapMapper.insert(map);
            System.out.println("DEBUG - 创建成功");
        } catch (Exception e) {
            System.err.println("DEBUG - 创建失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<TypeAddMap> getByTypeKey(Integer typeKey) {
        System.out.println("DEBUG - 查询特定证型的所有地区记录: typeKey=" + typeKey);
        List<TypeAddMap> results = typeAddMapMapper.selectByTypeKey(typeKey);
        System.out.println("DEBUG - 找到 " + results.size() + " 条记录");
        for (TypeAddMap map : results) {
            System.out.println("DEBUG - 记录: address=" + map.getAddress() + ", typekey=" + map.getTypekey() + ", value=" + map.getValue());
        }
        return results;
    }

    /**
     * 初始化指定证型的所有记录
     * @param typeKey 证型键
     * @return 处理的记录数量
     */
    public int initTypeKey(Integer typeKey) {
        try {
            logger.info("开始初始化证型 typeKey={} 的所有记录", typeKey);
            List<TypeAddMap> records = typeAddMapMapper.selectByTypeKey(typeKey);
            logger.info("找到 {} 条相关记录", records.size());
            
            int count = 0;
            for (TypeAddMap record : records) {
                logger.debug("重置记录: address={}, typeKey={}, 当前值={}", 
                        record.getAddress(), record.getTypekey(), record.getValue());
                record.setValue(0);
                typeAddMapMapper.updateByPrimaryKey(record);
                count++;
            }
            
            logger.info("成功初始化 {} 条记录", count);
            return count;
        } catch (Exception e) {
            logger.error("初始化证型记录异常", e);
            return -1;
        }
    }

}
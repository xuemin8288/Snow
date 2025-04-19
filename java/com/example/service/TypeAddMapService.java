package com.example.service;

import com.example.entity.TypeAddMap;
import com.example.mapper.TypeAddMapMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TypeAddMapService {
    @Autowired
    private TypeAddMapMapper typeAddMapMapper;

    public List<TypeAddMap> getAllTypeAddMaps() {
        return typeAddMapMapper.getAllTypeAddMaps();
    }


    public TypeAddMap getByAddress(String address) {
        return typeAddMapMapper.selectByAddress(address);
    }


    public TypeAddMap getByAddressAndTypeKey(String address,Integer typeKey) {
        System.out.println("address: " + address);
        System.out.println("typeKey: " + typeKey);
        return typeAddMapMapper.selectByAddressAndTypeKey(address,typeKey);
    }


    public void updateValueByAddressAndTypeKey( String typeKey, int newValue) {
        typeAddMapMapper.updateValueByAddressAndTypeKey( typeKey, newValue);
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



}
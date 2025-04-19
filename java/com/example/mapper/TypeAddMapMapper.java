package com.example.mapper;

import com.example.entity.TypeAddMap;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface TypeAddMapMapper {
    List<TypeAddMap> getAllTypeAddMaps();
    TypeAddMap selectByAddress(String address);
    // 新增的根据地址和 typekey 查询方法
//    TypeAddMap selectByAddressAndTypeKey(@Param("address") String address,@Param("typeKey") Integer typeKey);
    @Select("SELECT typekey, address, value FROM type_add_map WHERE address = #{address} AND typekey = #{typekey}")
    TypeAddMap selectByAddressAndTypeKey(@Param("address") String address, @Param("typekey") Integer typekey);
    // 新增的根据地址和 typekey 更新记录的方法
//    @Update("UPDATE type_add_map SET value = #{newValue} WHERE address = #{address} AND typekey = #{typeKey}")
    @Update("UPDATE type_add_map SET value = #{newValue} WHERE typekey = #{typeKey}")
    void updateValueByAddressAndTypeKey(@Param("typeKey") String typeKey, @Param("newValue") int newValue);
    void updateValueByAddress(@Param("address") String address, @Param("newValue") int newValue);
    List<TypeAddMap> selectAll();
}
package com.example.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.entity.User;

public interface UserMapper {

    int insert(User user);

    @Update("update `user` set username=#{username}, password=#{password}, name=#{name}, " +
           "avatar=#{avatar}, role=#{role}, phone=#{phone}, email=#{email}, " +
           "type_address=#{typeAddress}, Age=#{Age}, Gender=#{Gender} where id=#{id}")
    void updateById(User user);

    @Delete("delete from `user` where id=#{id}")
    void deleteById(Integer id);

    @Select("select * from `user` where id = #{id}")
    User selectById(Integer id);

    @Select("select * from `user` where username = #{username}")
    User selectByUsername(String username);

    List<User> selectAll(User user);

}

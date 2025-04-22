package com.example.service;

import java.util.List;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.example.common.Constants;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.User;
import com.example.exception.CustomException;
import com.example.mapper.UserMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.hutool.core.util.ObjectUtil;
import jakarta.annotation.Resource;

/**
 * 用户信息业务层方法
 */
@Service
public class UserService {

    @Resource
    private UserMapper userMapper;

    public void add(User user) {
        User dbUser = userMapper.selectByUsername(user.getUsername());
        if (ObjectUtil.isNotNull(dbUser)) {
            throw new CustomException(ResultCodeEnum.USER_EXIST_ERROR);
        }
        if (ObjectUtil.isEmpty(user.getPassword())) {
            user.setPassword(Constants.USER_DEFAULT_PASSWORD);
        }
        if (ObjectUtil.isEmpty(user.getName())) {
            user.setName(user.getUsername());
        }
        user.setRole(RoleEnum.USER.name());
        userMapper.insert(user);
    }

    public void updateById(User user) {
        if (ObjectUtil.isNotEmpty(user.getId())) {
            User dbUser = userMapper.selectById(user.getId());
            if (ObjectUtil.isNull(dbUser)) {
                throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
            }
            
            if (ObjectUtil.isEmpty(user.getUsername())) {
                user.setUsername(dbUser.getUsername());
            }
            if (ObjectUtil.isEmpty(user.getPassword())) {
                user.setPassword(dbUser.getPassword());
            }
            if (ObjectUtil.isEmpty(user.getName())) {
                user.setName(dbUser.getName());
            }
            if (ObjectUtil.isEmpty(user.getAvatar())) {
                user.setAvatar(dbUser.getAvatar());
            }
            if (ObjectUtil.isEmpty(user.getRole())) {
                user.setRole(dbUser.getRole());
            }
            if (ObjectUtil.isEmpty(user.getPhone())) {
                user.setPhone(dbUser.getPhone());
            }
            if (ObjectUtil.isEmpty(user.getEmail())) {
                user.setEmail(dbUser.getEmail());
            }
            if (ObjectUtil.isEmpty(user.getTypeAddress())) {
                user.setTypeAddress(dbUser.getTypeAddress());
            }
            if (ObjectUtil.isEmpty(user.getAge())) {
                user.setAge(dbUser.getAge());
            }
            if (ObjectUtil.isEmpty(user.getGender())) {
                user.setGender(dbUser.getGender());
            }
        }
        userMapper.updateById(user);
    }

    public void deleteById(Integer id) {
        User user = userMapper.selectById(id);
        if (ObjectUtil.isNull(user)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        userMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            deleteById(id);
        }
    }

//    public User selectById(Integer id) {
//        return userMapper.selectById(id);
//    }

    public User selectById(Integer userId) {
        User user = userMapper.selectById(userId);
        System.out.println("查询用户 ID: " + userId + ", 返回用户信息: " + user);
        return user;
    }

    public List<User> selectAll(User user) {
        return userMapper.selectAll(user);
    }

    public PageInfo<User> selectPage(User user, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<User> list = userMapper.selectAll(user);
        return PageInfo.of(list);
    }

    /**
     * 登录
     */
    public User login(Account account) {
        User dbUser = userMapper.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(dbUser)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if (!dbUser.getPassword().equals(account.getPassword())) {
            throw new CustomException(ResultCodeEnum.USER_ACCOUNT_ERROR);
        }
        // 生成token
        String token = TokenUtils.createToken(dbUser.getId() + "-" + dbUser.getRole(), dbUser.getPassword());
        dbUser.setToken(token);
        return dbUser;
    }

    /**
     * 修改密码
     */
    public void updatePassword(Account account) {
        User dbUser = userMapper.selectByUsername(account.getUsername());
        if (ObjectUtil.isNull(dbUser)) {
            throw new CustomException(ResultCodeEnum.USER_NOT_EXIST_ERROR);
        }
        if (!account.getPassword().equals(dbUser.getPassword())) {
            throw new CustomException(ResultCodeEnum.PARAM_PASSWORD_ERROR);
        }
        dbUser.setPassword(account.getNewPassword());
        userMapper.updateById(dbUser);
    }

    public void register(Account account) {
        User user = new User();
        BeanUtils.copyProperties(account, user);
        add(user);
    }
}

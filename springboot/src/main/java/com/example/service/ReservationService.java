package com.example.service;

import cn.hutool.core.date.DateUtil;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Reservation;
import com.example.exception.CustomException;
import com.example.mapper.ReservationMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 *专家咨询信息业务层方法
 */
@Service
public class ReservationService {

    @Resource
    private ReservationMapper reservationMapper;

    public void add(Reservation reservation) {
        Account currentUser = TokenUtils.getCurrentUser();
        reservation.setUserId(currentUser.getId());
        reservation.setTime(DateUtil.now());
        reservation.setStatus("待审核");
        // 处理一下时间段的数据
        List<String> timeRange = reservation.getTimeRange();
        reservation.setStart(DateUtil.now());
        reservation.setEnd(DateUtil.now());

        List<Reservation> list = reservationMapper.selectByUserIdAndDoctorId(currentUser.getId(), reservation.getDoctorId());
        long count = list.stream().filter(v -> "待审核".equals(v.getStatus()) || "审核通过".equals(v.getStatus())).count();
        if (count > 0) {
            throw new CustomException("500", "您已经咨询了该医生，请耐心等待该医生审核");
        }

        reservationMapper.insert(reservation);
    }

    public void updateById(Reservation reservation) {
        reservationMapper.updateById(reservation);
    }

    public void deleteById(Integer id) {
        reservationMapper.deleteById(id);
    }

    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            reservationMapper.deleteById(id);
        }
    }

    public Reservation selectById(Integer id) {
        return reservationMapper.selectById(id);
    }

    public List<Reservation> selectAll(Reservation reservation) {
        return reservationMapper.selectAll(reservation);
    }

    public PageInfo<Reservation> selectPage(Reservation reservation, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.DOCTOR.name().equals(currentUser.getRole())) {
            reservation.setDoctorId(currentUser.getId());
        }
        if (RoleEnum.USER.name().equals(currentUser.getRole())) {
            reservation.setUserId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Reservation> list = reservationMapper.selectAll(reservation);
        return PageInfo.of(list);
    }

}

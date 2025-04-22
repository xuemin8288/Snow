<template>
  <view class="consult-container">
    
    <!-- 内容区域 -->
    <view class="content-wrapper">
        <view class="title-section">
          <view class="main-title">专家咨询</view>
          <view class="sub-title">高血压可防可控，健康生活不是梦</view>
      </view>
      
      <!-- 医生列表 -->
        <view class="doctor-grid">
          <view class="doctor-card" v-for="(item, index) in doctorList" :key="index">
          <image :src="item.avatar || '../../static/logo.png'" mode="aspectFill" class="doctor-avatar"></image>
            <view class="doctor-info">
          <!-- <view class="doctor-name">{{ item.name }}</view> -->
          <view class="doctor-name">{{ item.name.split('（')[0] }}</view>
          <view class="doctor-specialty" v-if="item.name.includes('（')">{{ item.name.split('（')[1].replace('）', '') }}</view>
              <view class="doctor-help">累计帮助 10 人</view>
              <view class="doctor-year">医生工龄：<text class="doctor-tag">{{ item.seniority }} 年</text></view>
              <view class="doctor-intro" @click.stop="toggleExpand(index)" 
                    :class="{ 'expanded': expandedIndex === index }">
                医生简介：{{ item.content || '暂无简介' }}
              </view>
            </view>
            <view class="consult-btn-wrapper">
              <button class="consult-btn" @click.stop="makeAppointment(item)">立即咨询</button>
            </view>
        </view>
      </view>
      
      <view class="empty-view" v-if="doctorList.length === 0">
        <image src="../../static/logo.png" mode="aspectFit" class="empty-icon"></image>
        <text class="empty-text">暂无医生信息</text>
      </view>
    </view>
    
    <!-- 预约弹窗 -->
    <view class="appointment-popup" v-if="showAppointmentPopup">
      <view class="popup-mask" @click="cancelAppointment"></view>
      <view class="popup-content">
        <view class="popup-form">
          <view class="popup-title">咨询信息</view>
          
            <!-- 增加时间显示 -->
          <view class="form-item">
              <view class="form-label">时间</view>
              <view class="time-input">{{ nowDataFormat }}</view>
          </view>
          
          <view class="form-item">
              <view class="form-label">问题描述</view>
              <textarea class="form-textarea" v-model="appointmentForm.question" placeholder="在描述您目前的问题之前，先提供历史诊断的记录" />
          </view>
          
          <!-- 操作按钮 -->
          <view class="action-buttons">
            <button class="cancel-btn" @click="cancelAppointment">取 消</button>
            <button class="save-btn" @click="saveAppointment">提 交</button>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import request from '../../utils/request.js';

export default {
  data() {
      const now = new Date();
      const nowDataFormat = now.toLocaleDateString('zh-CN', { year: '2-digit', month: '2-digit', day: '2-digit', hour:'2-digit', minute:'2-digit' });
      
    return {
      doctorList: [],
      expandedIndex: -1,
      showAppointmentPopup: false,
      currentDoctor: null,
      appointmentForm: {
        doctorId: null,
        question: '',
          timeRange: ''
        },
        nowDataFormat: nowDataFormat
    }
  },
  onLoad() {
    this.getDoctorList();
  },
  methods: {
    // 切换展开状态
    toggleExpand(index) {
      this.expandedIndex = this.expandedIndex === index ? -1 : index;
    },
    
    // 获取医生列表
    getDoctorList() {
      const token = uni.getStorageSync('token');
      if (!token) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        });
        return;
      }
      
      request.get('/doctor/selectAll', { status: '审批通过' }, { token }).then(res => {
        if (res.code === 200 || res.code === "200") {
          this.doctorList = res.data || [];
        } else {
          uni.showToast({
            title: res.msg || '获取医生列表失败',
            icon: 'none'
          });
        }
      }).catch(err => {
        console.error('获取医生列表失败', err);
        // 加载失败时使用默认数据
        this.loadMockData();
      });
    },
    
    // 加载模拟数据
    loadMockData() {
      this.doctorList = [
        {
          id: 1,
          username: "zhanghua",
          name: "张华（阴阳两虚）",
          avatar: "../../static/logo.png",
          phone: "18899997777",
          email: "zhanghua@HTN.com",
          seniority: 8,
          content: "张华，毕业于北京中医药大学，获得中医学博士学位，擅长运用中医理论和方法治疗高血压及相关并发症。张华医师深耕高血压的辨证施治，尤其擅长肝阳上亢型、高血压引发的头痛眩晕等症状的调理。",
          code: "321324**********28",
          status: "审批通过"
        },
        {
          id: 2,
          username: "limei",
          name: "李梅（肝肾阴虚、肝阳上亢）",
          avatar: "../../static/logo.png",
          phone: "18877776666",
          email: "limei@HTN.com",
          seniority: 15,
          content: "李梅，教授，主任医师，长期从事高血压相关疾病的中医治疗和研究。她在肝肾两虚型及痰瘀内蕴型高血压的治疗方面有深厚的造诣。",
          code: "324115**********11",
          status: "审批通过"
        }
      ];
    },
    
    // 预约医生
    makeAppointment(doctor) {
      this.currentDoctor = doctor;
        this.appointmentForm = {
          doctorId: doctor.id,
          question: '',
          timeRange: this.nowDataFormat
        };
      
      this.showAppointmentPopup = true;
    },
    
    // 取消预约
    cancelAppointment() {
      this.showAppointmentPopup = false;
    },
    
    // 保存预约
    saveAppointment() {
      if (!this.appointmentForm.question.trim()) {
        uni.showToast({
          title: '请描述您的问题',
          icon: 'none',
          duration: 2000
        });
        return;
      }
      
      const token = uni.getStorageSync('token');
      if (!token) {
        uni.showToast({
          title: '请先登录',
          icon: 'none',
          duration: 2000
        });
        return;
      }
      
      const reservationData = {
        doctorId: this.appointmentForm.doctorId,
        timeRange: [this.appointmentForm.timeRange, this.appointmentForm.timeRange], // 修改为数组格式，使用相同的时间值作为开始和结束
        question: this.appointmentForm.question
      };
      
      uni.showLoading({
        title: '提交中...'
      });
      
      // 使用与Doctor.vue页面相同的接口
      request.post('/reservation/add', reservationData, { token }).then(res => {
        uni.hideLoading();
        if (res.code === 200 || res.code === "200") {
          uni.showToast({
            title: '操作成功，等待医生审核',
            icon: 'success',
            duration: 2000
          });
          this.showAppointmentPopup = false;
        } else {
          uni.showToast({
            title: res.msg || '预约失败',
            icon: 'none',
            duration: 2000
          });
        }
      }).catch(err => {
        uni.hideLoading();
        console.error('预约失败', err);
        uni.showToast({
          title: '网络异常，请稍后重试',
          icon: 'none',
          duration: 2000
        });
      });
      }
  }
}
</script>

<style lang="scss">
.consult-container {
  min-height: 100vh;
    background-color: #f3f4f5;
  padding-bottom: 30rpx;
    
    // 标题区域
    .title-section {
      width: 90%;
      margin: 0 auto;
      padding: 30rpx 0;
      display: flex;
      align-items: center;
      
      .main-title {
        font-size: 36rpx;
        font-weight: bold;
        color: #0b8bff;
        width: 180rpx;
      }
      
      .sub-title {
        font-size: 28rpx;
        color: #8c939d;
        margin-left: 20rpx;
        flex: 1;
      }
    }
    
    // 内容区域
    .content-wrapper {
      padding: 20rpx 0;
      width: 90%;
      margin: 0 auto;
    }
    
    // 医生卡片网格
    .doctor-grid {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      
      .doctor-card {
        width: 48%;
        background-color: #ffffff;
        border-top-left-radius: 20rpx;
        border-top-right-radius: 20rpx;
        overflow: hidden;
        box-shadow: 0 0 20rpx rgba(0,0,0,.1);
        margin-bottom: 30rpx;
        
        .doctor-avatar {
          width: 100%;
          height: 300rpx;
          border-top-left-radius: 20rpx;
          border-top-right-radius: 20rpx;
        }
        
        .doctor-info {
          padding: 20rpx 30rpx;
          
        //   .doctor-name {
        //     font-size: 30rpx;
        //     height: 60rpx;
        //     line-height: 60rpx;
        //     font-weight: bold;
        //   }
          
        //   .doctor-help {
        //     font-size: 28rpx;
        // height: 60rpx;
        // line-height: 60rpx;
        //   }

          .doctor-name {
            font-size: 30rpx;
            height: 40rpx;
            line-height: 40rpx;
            font-weight: bold;
            margin-bottom: 5rpx;
          }

          .doctor-specialty {
            font-size: 24rpx;
            height: 34rpx;
            line-height: 34rpx;
            color: #0b8bff;
            margin-bottom: 5rpx;
            background-color: #ecf5ff;
            display: inline-block;
            padding: 0 10rpx;
            border-radius: 4rpx;
          }

          .doctor-help {
            font-size: 28rpx;
            height: 50rpx;
            line-height: 50rpx;
          }
          
          .doctor-year {
            margin-top: 10rpx;
            font-size: 26rpx;
            
            .doctor-tag {
              background-color: #67c23a;
              color: white;
              padding: 4rpx 12rpx;
              border-radius: 6rpx;
              font-size: 24rpx;
            }
          }
          
          .doctor-intro {
            margin-top: 20rpx;
            color: #666666;
            line-height: 40rpx;
            height: 120rpx;
            word-break: break-all;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3;
            overflow: hidden;
            font-size: 26rpx;
            
            &.expanded {
              -webkit-line-clamp: initial;
              height: auto;
            }
          }
        }
        
        .consult-btn-wrapper {
          text-align: center;
          margin: 30rpx 0;
          
          .consult-btn {
            background-color: #909399;
            color: white;
            font-size: 28rpx;
            padding: 15rpx 40rpx;
            border-radius: 8rpx;
            display: inline-block;
          }
      }
    }
  }
  
  // 空视图
  .empty-view {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 100rpx 0;
    
    .empty-icon {
      width: 200rpx;
      height: 200rpx;
      margin-bottom: 20rpx;
    }
    
    .empty-text {
      font-size: 28rpx;
      color: #999;
    }
  }
  
  // 预约弹窗
  .appointment-popup {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 999;
    
    .popup-mask {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: rgba(0, 0, 0, 0.5);
    }
    
    .popup-content {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 80%;
      max-width: 600rpx;
      background-color: #fff;
      border-radius: 12rpx;
      overflow: hidden;
      box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.1);
      
      .popup-form {
        padding: 30rpx;
        
        .popup-title {
          font-size: 32rpx;
          color: #333;
          text-align: center;
          font-weight: bold;
          margin-bottom: 30rpx;
        }
        
        .form-item {
          margin-bottom: 20rpx;
          
          .form-label {
            font-size: 28rpx;
            color: #333;
            margin-bottom: 10rpx;
            font-weight: bold;
          }
          
            .time-input {
            font-size: 28rpx;
            color: #666;
              background-color: #f5f5f5;
              padding: 20rpx;
              border-radius: 8rpx;
          }
          
          .form-textarea {
            width: 100%;
            height: 200rpx;
            background-color: #f5f5f5;
            border-radius: 8rpx;
            padding: 20rpx;
            font-size: 28rpx;
            box-sizing: border-box;
          }
        }
        
        .action-buttons {
          display: flex;
          justify-content: center;
          margin-top: 40rpx;
          
          button {
            margin: 0 20rpx;
            font-size: 28rpx;
            padding: 15rpx 40rpx;
            border-radius: 5rpx;
          }
          
          .cancel-btn {
            background-color: #f5f5f5;
            color: #666;
          }
          
          .save-btn {
            background-color: #0b8bff;
            color: #fff;
          }
        }
      }
    }
  }
}
</style> 
<template>
  <view class="consultation-container">
    <view class="page-header">
      <!-- <text class="page-title">问诊记录</text> -->
      <!-- <view class="back-btn" @click="goBack">返回</view> -->
    </view>
    
    <!-- <view class="filter-box">
      <picker @change="statusChange" :value="statusIndex" :range="statusOptions">
        <view class="picker-item">
          <text>{{ currentStatus || '全部状态' }}</text>
          <text class="arrow-down">▼</text>
        </view>
      </picker>
      <button class="filter-btn query" @click="loadData">查询</button>
      <button class="filter-btn reset" @click="resetFilter">重置</button>
    </view> -->
    
    <view class="list-container">
      <view v-if="consultations.length === 0" class="empty-tip">
        <text>暂无问诊记录</text>
      </view>
      
      <view v-else class="consultation-list">
        <view 
          v-for="(item, index) in consultations" 
          :key="index" 
          class="consultation-item"
        >
          <view class="item-header">
            <text class="doctor-name">医生：{{ item.doctorName }}</text>
            <view class="status-tag" :class="getStatusClass(item.status)">{{ item.status }}</view>
          </view>
          
          <view class="item-content">
            <view class="info-row">
              <text class="info-label">开始时间：</text>
              <text class="info-value">{{ item.start }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">结束时间：</text>
              <text class="info-value">{{ item.end }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">咨询时间：</text>
              <text class="info-value">{{ item.time }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">问题描述：</text>
              <text class="info-value description">{{ item.question }}</text>
            </view>
            
            <view class="info-row" v-if="item.status === '审核拒绝'">
              <text class="info-label">拒绝理由：</text>
              <text class="info-value">{{ item.reason }}</text>
            </view>
            
            <view class="info-row" v-if="item.status === '已结束' || item.status === '审核通过'">
              <text class="info-label">专家建议：</text>
              <text class="info-value">{{ item.reason || "暂无建议" }}</text>
            </view>
          </view>
          
          <view class="item-footer">
            <button class="delete-btn" @click="deleteConsultation(item.id)">删除</button>
          </view>
        </view>
      </view>
    </view>
    
    <!-- <view class="pagination" v-if="total > 0">
      <view class="page-btn prev" :class="{ disabled: current <= 1 }" @click="prevPage">上一页</view>
      <text class="page-info">{{ current }}/{{ Math.ceil(total / pageSize) }}</text>
      <view class="page-btn next" :class="{ disabled: current >= Math.ceil(total / pageSize) }" @click="nextPage">下一页</view>
    </view> -->
  </view>
</template>

<script>
import request from '@/utils/request.js';

export default {
  data() {
    return {
      current: 1,
      pageSize: 5,
      total: 0,
      consultations: [],
      statusOptions: ['全部', '待审核', '审核通过', '审核拒绝', '已结束'],
      statusIndex: 0,
      currentStatus: ''
    }
  },
  onLoad() {
    this.loadData();
  },
  methods: {
    loadData() {
      const params = {
        pageNum: this.current,
        pageSize: this.pageSize
      };
      
      if (this.currentStatus && this.currentStatus !== '全部') {
        params.status = this.currentStatus;
      }
      
      uni.showLoading({
        title: '加载中...'
      });
      
      request.get('/reservation/selectPage', {
        params: params
      }).then(res => {
        uni.hideLoading();
        if (res.code === 200 || res.code === '200') {
          this.consultations = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          uni.showToast({
            title: res.msg || '加载失败',
            icon: 'none'
          });
          // 加载失败时显示模拟数据
          this.loadMockData();
        }
      }).catch(err => {
        uni.hideLoading();
        console.error(err);
        uni.showToast({
          title: '网络异常，请稍后再试',
          icon: 'none'
        });
        // 加载失败时显示模拟数据
        this.loadMockData();
      });
    },
    
    loadMockData() {
      this.consultations = [
        {
          id: 1,
          doctorName: '张医生',
          start: '2023-07-01 09:00',
          end: '2023-07-01 10:00',
          time: '60分钟',
          question: '最近睡眠质量不好，经常感到疲劳，请问可能是什么原因导致的？',
          status: '已结束',
          reason: '建议保持规律作息，避免熬夜，睡前一小时不要使用电子设备，可以尝试喝一杯温牛奶帮助入睡。'
        },
        {
          id: 2,
          doctorName: '李医生',
          start: '2023-07-15 14:00',
          end: '2023-07-15 15:00',
          time: '60分钟',
          question: '最近工作压力大，容易焦虑，有什么缓解方法吗？',
          status: '审核通过',
          reason: '可以尝试冥想和深呼吸练习来缓解焦虑，每天抽出15-20分钟进行有氧运动也很有帮助。'
        },
        {
          id: 3,
          doctorName: '王医生',
          start: '2023-07-20 10:30',
          end: '2023-07-20 11:00',
          time: '30分钟',
          question: '如何调整饮食改善肠胃问题？',
          status: '待审核'
        },
        {
          id: 4,
          doctorName: '刘医生',
          start: '2023-07-25 16:00',
          end: '2023-07-25 17:00',
          time: '60分钟',
          question: '高血压患者应该注意什么？',
          status: '审核拒绝',
          reason: '您的问题需要更专业的心血管科医生进行解答，建议重新预约相关专科医生。'
        }
      ];
      this.total = this.consultations.length;
    },
    
    statusChange(e) {
      this.statusIndex = e.detail.value;
      this.currentStatus = this.statusOptions[this.statusIndex];
    },
    
    resetFilter() {
      this.statusIndex = 0;
      this.currentStatus = '';
      this.current = 1;
      this.loadData();
    },
    
    prevPage() {
      if (this.current > 1) {
        this.current--;
        this.loadData();
      }
    },
    
    nextPage() {
      if (this.current < Math.ceil(this.total / this.pageSize)) {
        this.current++;
        this.loadData();
      }
    },
    
    getStatusClass(status) {
      switch (status) {
        case '待审核':
          return 'warning';
        case '审核通过':
          return 'success';
        case '审核拒绝':
          return 'danger';
        case '已结束':
          return 'primary';
        default:
          return '';
      }
    },
    
    deleteConsultation(id) {
      uni.showModal({
        title: '删除确认',
        content: '删除后数据无法恢复，您确定删除吗？',
        success: (res) => {
          if (res.confirm) {
            uni.showLoading({
              title: '删除中...'
            });
            
            request.delete('/reservation/delete/' + id).then(res => {
              uni.hideLoading();
              if (res.code === 200 || res.code === '200') {
                uni.showToast({
                  title: '删除成功',
                  icon: 'success'
                });
                this.loadData();
              } else {
                uni.showToast({
                  title: res.msg || '删除失败',
                  icon: 'none'
                });
              }
            }).catch(err => {
              uni.hideLoading();
              console.error(err);
              uni.showToast({
                title: '网络异常，请稍后再试',
                icon: 'none'
              });
            });
          }
        }
      });
    },
    
    goBack() {
      uni.navigateBack();
    }
  }
}
</script>

<style lang="scss">
.consultation-container {
  min-height: 100vh;
  background-color: #f8f8f8;
  padding: 30rpx;
  
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30rpx;
    
    .page-title {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
    }
    
    .back-btn {
      font-size: 28rpx;
      color: #0b8bff;
      padding: 10rpx 20rpx;
      
      &:active {
        opacity: 0.8;
      }
    }
  }
  
  .filter-box {
    background-color: #fff;
    border-radius: 10rpx;
    padding: 20rpx;
    margin-bottom: 20rpx;
    display: flex;
    align-items: center;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
    
    .picker-item {
      height: 70rpx;
      width: 240rpx;
      border: 1rpx solid #e0e0e0;
      border-radius: 6rpx;
      padding: 0 20rpx;
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 28rpx;
      color: #333;
      margin-right: 20rpx;
      
      .arrow-down {
        font-size: 24rpx;
        color: #999;
      }
    }
    
    .filter-btn {
      height: 70rpx;
      line-height: 70rpx;
      font-size: 28rpx;
      padding: 0 30rpx;
      margin: 0 10rpx;
      border-radius: 6rpx;
      
      &.query {
        background-color: #0b8bff;
        color: #fff;
      }
      
      &.reset {
        background-color: #f0f0f0;
        color: #666;
      }
    }
  }
  
  .list-container {
    background-color: #fff;
    border-radius: 10rpx;
    padding: 20rpx;
    margin-bottom: 20rpx;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
    
    .empty-tip {
      text-align: center;
      padding: 80rpx 0;
      color: #999;
      font-size: 28rpx;
    }
    
    .consultation-item {
      border-bottom: 1rpx solid #eee;
      padding: 20rpx 0;
      
      &:last-child {
        border-bottom: none;
      }
      
      .item-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20rpx;
        
        .doctor-name {
          font-size: 32rpx;
          font-weight: bold;
          color: #333;
        }
        
        .status-tag {
          padding: 6rpx 20rpx;
          border-radius: 30rpx;
          font-size: 24rpx;
          
          &.warning {
            background-color: #fff7e6;
            color: #faad14;
          }
          
          &.success {
            background-color: #f6ffed;
            color: #52c41a;
          }
          
          &.danger {
            background-color: #fff1f0;
            color: #f5222d;
          }
          
          &.primary {
            background-color: #e6f7ff;
            color: #1890ff;
          }
        }
      }
      
      .item-content {
        .info-row {
          display: flex;
          margin-bottom: 10rpx;
          
          .info-label {
            width: 160rpx;
            font-size: 26rpx;
            color: #666;
          }
          
          .info-value {
            flex: 1;
            font-size: 26rpx;
            color: #333;
            
            &.description {
              word-break: break-all;
            }
          }
        }
      }
      
      .item-footer {
        margin-top: 20rpx;
        display: flex;
        justify-content: flex-end;
        
        .delete-btn {
          height: 60rpx;
          line-height: 60rpx;
          font-size: 26rpx;
          padding: 0 30rpx;
          background-color: #ff4d4f;
          color: #fff;
          border-radius: 30rpx;
        }
      }
    }
  }
  
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20rpx 0;
    
    .page-btn {
      width: 120rpx;
      height: 60rpx;
      line-height: 60rpx;
      text-align: center;
      font-size: 26rpx;
      background-color: #0b8bff;
      color: #fff;
      border-radius: 6rpx;
      
      &.disabled {
        background-color: #e0e0e0;
        color: #999;
      }
    }
    
    .page-info {
      margin: 0 20rpx;
      font-size: 26rpx;
      color: #666;
    }
  }
}
</style> 
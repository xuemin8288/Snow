<template>
  <view class="feedback-container">
    <view class="page-header">
      <text class="page-title">我的反馈</text>
    </view>
    
    <!-- <view class="filter-box">
      <input 
        type="text" 
        class="filter-input" 
        v-model="question" 
        placeholder="请输入反馈问题" 
      />
      <picker 
        @change="statusChange" 
        :value="statusIndex" 
        :range="statusOptions"
        class="status-picker"
      >
        <view class="picker-item">
          <text>{{ currentStatus || '全部状态' }}</text>
          <text class="arrow-down">▼</text>
        </view>
      </picker>
      <view class="btn-group">
        <button class="filter-btn query" @click="loadData">查询</button>
        <button class="filter-btn reset" @click="resetFilter">重置</button>
      </view>
    </view> -->
    
    <view class="list-container">
      <view v-if="feedbacks.length === 0" class="empty-tip">
        <text>暂无反馈记录</text>
      </view>
      
      <view v-else class="feedback-list">
        <view 
          v-for="(item, index) in feedbacks" 
          :key="index" 
          class="feedback-item"
        >
          <view class="item-header">
            <text class="feedback-question">{{ item.question }}</text>
            <view class="status-tag" :class="item.status === '待回复' ? 'warning' : 'primary'">
              {{ item.status }}
            </view>
          </view>
          
          <view class="item-content">
            <view class="info-row">
              <text class="info-label">用户想法：</text>
              <text class="info-value">{{ item.content }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">提交时间：</text>
              <text class="info-value">{{ item.time }}</text>
            </view>
            
            <view v-if="item.status === '已回复'" class="reply-section">
              <view class="reply-header">回复信息</view>
              <view class="info-row">
                <text class="info-label">回复人：</text>
                <text class="info-value">{{ item.replyName }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">回复内容：</text>
                <text class="info-value">{{ item.replyContent }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">回复时间：</text>
                <text class="info-value">{{ item.replyTime }}</text>
              </view>
            </view>
          </view>
          
          <view class="item-footer">
            <button class="delete-btn" @click="deleteFeedback(item.id)">删除</button>
          </view>
        </view>
      </view>
    </view>
    
    <view class="pagination" v-if="total > 0">
      <view class="page-btn prev" :class="{ disabled: current <= 1 }" @click="prevPage">上一页</view>
      <text class="page-info">{{ current }}/{{ Math.ceil(total / pageSize) }}</text>
      <view class="page-btn next" :class="{ disabled: current >= Math.ceil(total / pageSize) }" @click="nextPage">下一页</view>
    </view>
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
      feedbacks: [],
      statusOptions: ['全部', '待回复', '已回复'],
      statusIndex: 0,
      currentStatus: '',
      question: ''
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
      
      if (this.question) {
        params.question = this.question;
      }
      
      uni.showLoading({
        title: '加载中...'
      });
      
      request.get('/feedback/selectPage', {
        params: params
      }).then(res => {
        uni.hideLoading();
        if (res.code === 200 || res.code === '200') {
          this.feedbacks = res.data.list || [];
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
      this.feedbacks = [
        {
          id: 1,
          question: '网站加载速度问题',
          content: '使用应用时发现页面加载较慢，尤其是在查看详细信息时会有明显卡顿，希望能够优化',
          time: '2023-07-15 10:30',
          status: '已回复',
          replyName: '技术支持',
          replyContent: '感谢您的反馈，我们已经对服务器进行了升级，并优化了数据加载逻辑，请问现在使用是否有改善？如仍有问题，欢迎再次反馈。',
          replyTime: '2023-07-16 14:25'
        },
        {
          id: 2,
          question: '建议增加更多心理测评量表',
          content: '目前平台上的心理测评种类较少，希望能增加更多专业的心理健康评估量表，比如MMPI等',
          time: '2023-07-20 16:45',
          status: '待回复'
        },
        {
          id: 3,
          question: '咨询预约功能改进建议',
          content: '建议在预约咨询时能够显示医生的可用时间段，避免选择后发现时间冲突的情况',
          time: '2023-07-22 09:15',
          status: '已回复',
          replyName: '产品经理',
          replyContent: '您好，非常感谢您的建议。我们已将此功能列入下一版本的更新计划中，预计将在一个月内上线，届时将优化预约流程，显示医生的实时可用时间段。',
          replyTime: '2023-07-23 11:30'
        }
      ];
      this.total = this.feedbacks.length;
    },
    
    statusChange(e) {
      this.statusIndex = e.detail.value;
      this.currentStatus = this.statusOptions[this.statusIndex];
    },
    
    resetFilter() {
      this.statusIndex = 0;
      this.currentStatus = '';
      this.question = '';
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
    
    deleteFeedback(id) {
      uni.showModal({
        title: '删除确认',
        content: '删除后数据无法恢复，您确定删除吗？',
        success: (res) => {
          if (res.confirm) {
            uni.showLoading({
              title: '删除中...'
            });
            
            request.delete('/feedback/delete/' + id).then(res => {
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
.feedback-container {
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
    flex-direction: column;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
    
    .filter-input {
      height: 70rpx;
      border: 1rpx solid #e0e0e0;
      border-radius: 6rpx;
      padding: 0 20rpx;
      font-size: 28rpx;
      margin-bottom: 20rpx;
    }
    
    .status-picker {
      margin-bottom: 20rpx;
      
      .picker-item {
        height: 70rpx;
        border: 1rpx solid #e0e0e0;
        border-radius: 6rpx;
        padding: 0 20rpx;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 28rpx;
        color: #333;
        
        .arrow-down {
          font-size: 24rpx;
          color: #999;
        }
      }
    }
    
    .btn-group {
      display: flex;
      justify-content: space-between;
      
      .filter-btn {
        flex: 1;
        height: 70rpx;
        line-height: 70rpx;
        font-size: 28rpx;
        border-radius: 6rpx;
        margin: 0 10rpx;
        
        &:first-child {
          margin-left: 0;
        }
        
        &:last-child {
          margin-right: 0;
        }
        
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
    
    .feedback-item {
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
        
        .feedback-question {
          font-size: 32rpx;
          font-weight: bold;
          color: #333;
          flex: 1;
        }
        
        .status-tag {
          padding: 6rpx 20rpx;
          border-radius: 30rpx;
          font-size: 24rpx;
          margin-left: 20rpx;
          
          &.warning {
            background-color: #fff7e6;
            color: #faad14;
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
            word-break: break-all;
          }
        }
        
        .reply-section {
          margin-top: 20rpx;
          background-color: #f9f9f9;
          padding: 15rpx;
          border-radius: 8rpx;
          
          .reply-header {
            font-size: 28rpx;
            color: #333;
            margin-bottom: 10rpx;
            font-weight: bold;
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
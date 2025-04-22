<template>
  <view class="feedback-container">
    <!-- <view class="feedback-header">
      <text class="page-title">反馈与建议</text>
    </view> -->
    
    <view class="feedback-card">
      <view class="card-title">提交您的反馈信息</view>
      
      <view class="form-item">
        <text class="form-label">反馈问题</text>
        <textarea 
          class="form-textarea" 
          v-model="feedbackForm.question" 
          placeholder="请输入您反馈的问题（最多100字）" 
          maxlength="100"
          :style="{borderColor: questionError ? '#ff4d4f' : '#eee'}"
        ></textarea>
        <text class="word-count">{{feedbackForm.question.length}}/100</text>
        <text v-if="questionError" class="error-text">请输入您反馈的问题</text>
      </view>
      
      <view class="form-item">
        <text class="form-label">我的想法</text>
        <textarea 
          class="form-textarea" 
          v-model="feedbackForm.content" 
          placeholder="请输入您对上述问题的想法（最多300字）" 
          maxlength="300"
          :style="{borderColor: contentError ? '#ff4d4f' : '#eee'}"
        ></textarea>
        <text class="word-count">{{feedbackForm.content.length}}/300</text>
        <text v-if="contentError" class="error-text">请输入您对反馈问题的想法</text>
      </view>
      
      <view class="submit-btn-container">
        <button class="submit-btn" @click="submitFeedback">提 交</button>
      </view>
    </view>
    
    <!-- 加载状态 -->
    <view class="loading-container" v-if="isLoading">
      <text class="loading-text">加载中...</text>
    </view>
    
    <!-- 操作提示 -->
    <view class="tip-container" v-if="showTip">
      <text class="tip-text">{{tipText}}</text>
    </view>
  </view>
</template>

<script>
import request from '../../utils/request.js';

export default {
  data() {
    return {
      feedbackForm: {
        question: '',
        content: ''
      },
      questionError: false,
      contentError: false,
      isLoading: false,
      showTip: false,
      tipText: ''
    }
  },
  methods: {
    // 验证表单
    validateForm() {
      let isValid = true;
      
      if (!this.feedbackForm.question.trim()) {
        this.questionError = true;
        isValid = false;
      } else {
        this.questionError = false;
      }
      
      if (!this.feedbackForm.content.trim()) {
        this.contentError = true;
        isValid = false;
      } else {
        this.contentError = false;
      }
      
      return isValid;
    },
    
    // 提交反馈
    submitFeedback() {
      if (!this.validateForm()) {
        return;
      }
      
      const token = uni.getStorageSync('token');
      if (!token) {
        this.showTipMessage('请先登录');
        setTimeout(() => {
          uni.navigateTo({
            url: '/pages/index/index'
          });
        }, 1500);
        return;
      }
      
      this.isLoading = true;
      
      // 提交反馈
      request.post('/feedback/add', this.feedbackForm, { token }).then(res => {
        this.isLoading = false;
        
        if (res.code === 200 || res.code === '200') {
          this.showTipMessage('反馈成功，等待管理员回复');
          this.feedbackForm.question = '';
          this.feedbackForm.content = '';
        } else {
          this.showTipMessage(res.msg || '提交失败，请稍后再试');
        }
      }).catch(err => {
        this.isLoading = false;
        console.error('提交反馈失败:', err);
        this.showTipMessage('网络异常，请稍后再试');
      });
    },
    
    // 显示提示信息
    showTipMessage(message) {
      this.tipText = message;
      this.showTip = true;
      
      setTimeout(() => {
        this.showTip = false;
      }, 3000);
    }
  }
}
</script>

<style lang="scss">
.feedback-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 30rpx;
  
  .feedback-header {
    margin-bottom: 30rpx;
    
    .page-title {
      font-size: 40rpx;
      font-weight: bold;
      color: #333;
    }
  }
  
  .feedback-card {
    background-color: #fff;
    border-radius: 12rpx;
    padding: 30rpx;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
    margin-bottom: 40rpx;
    
    .card-title {
      font-size: 34rpx;
      font-weight: bold;
      color: #333;
      text-align: center;
      margin-bottom: 40rpx;
    }
    
    .form-item {
      margin-bottom: 30rpx;
      position: relative;
      
      .form-label {
        display: block;
        font-size: 28rpx;
        color: #333;
        margin-bottom: 15rpx;
        font-weight: bold;
      }
      
      .form-textarea {
        width: 100%;
        height: 200rpx;
        background-color: #f8f8f8;
        border: 1px solid #eee;
        border-radius: 8rpx;
        padding: 20rpx;
        font-size: 28rpx;
        box-sizing: border-box;
      }
      
      .word-count {
        position: absolute;
        right: 10rpx;
        bottom: 10rpx;
        font-size: 24rpx;
        color: #999;
      }
      
      .error-text {
        font-size: 24rpx;
        color: #ff4d4f;
        margin-top: 10rpx;
        display: block;
      }
    }
    
    .submit-btn-container {
      display: flex;
      justify-content: center;
      margin-top: 40rpx;
      
      .submit-btn {
        background-color: #0b8bff;
        color: #fff;
        font-size: 30rpx;
        padding: 20rpx 60rpx;
        border-radius: 45rpx;
        font-weight: bold;
        border: none;
        
        &:active {
          opacity: 0.9;
        }
      }
    }
  }
  
  .loading-container {
    text-align: center;
    padding: 30rpx 0;
    
    .loading-text {
      font-size: 28rpx;
      color: #999;
    }
  }
  
  .tip-container {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: rgba(0, 0, 0, 0.7);
    padding: 20rpx 40rpx;
    border-radius: 8rpx;
    z-index: 999;
    
    .tip-text {
      color: #fff;
      font-size: 28rpx;
    }
  }
}
</style> 
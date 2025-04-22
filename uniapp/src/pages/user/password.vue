<template>
  <view class="password-container">
    <view class="page-header">
      <text class="page-title">修改密码</text>
    </view>
    
    <view class="password-form">
      <view class="form-item">
        <text class="form-label">原密码</text>
        <input 
          type="password" 
          class="form-input" 
          v-model="passwordForm.password" 
          placeholder="请输入原密码" 
        />
        <text class="error-tip" v-if="errors.password">{{ errors.password }}</text>
      </view>
      <view class="form-item">
        <text class="form-label">新密码</text>
        <input 
          type="password" 
          class="form-input" 
          v-model="passwordForm.newPassword" 
          placeholder="请输入新密码" 
        />
        <text class="error-tip" v-if="errors.newPassword">{{ errors.newPassword }}</text>
      </view>
      <view class="form-item">
        <text class="form-label">确认密码</text>
        <input 
          type="password" 
          class="form-input" 
          v-model="passwordForm.confirmPassword" 
          placeholder="请再次输入新密码" 
        />
        <text class="error-tip" v-if="errors.confirmPassword">{{ errors.confirmPassword }}</text>
      </view>
      
      <!-- <view class="form-tips">
        <text>密码安全提示：</text>
        <text>• 密码长度至少8位</text>
        <text>• 建议包含大小写字母、数字和特殊符号</text>
        <text>• 请勿使用与其他网站相同的密码</text>
      </view> -->
      
      <button class="submit-btn" @click="updatePassword">确认修改</button>
      <button class="cancel-btn" @click="goBack">返回</button>
    </view>
  </view>
</template>

<script>
import request from '@/utils/request.js';

export default {
  data() {
    return {
      passwordForm: {
        password: '',
        newPassword: '',
        confirmPassword: ''
      },
      errors: {
        password: '',
        newPassword: '',
        confirmPassword: ''
      }
    }
  },
  methods: {
    // 验证表单
    validateForm() {
      let isValid = true;
      
      // 重置错误信息
      this.errors = {
        password: '',
        newPassword: '',
        confirmPassword: ''
      };
      
      // 验证原密码
      if (!this.passwordForm.password) {
        this.errors.password = '请输入原密码';
        isValid = false;
      }
      
      // 验证新密码
      if (!this.passwordForm.newPassword) {
        this.errors.newPassword = '请输入新密码';
        isValid = false;
      } else if (this.passwordForm.newPassword.length < 6) {
        this.errors.newPassword = '新密码长度至少6位';
        isValid = false;
      }
      
      // 验证确认密码
      if (!this.passwordForm.confirmPassword) {
        this.errors.confirmPassword = '请确认新密码';
        isValid = false;
      } else if (this.passwordForm.confirmPassword !== this.passwordForm.newPassword) {
        this.errors.confirmPassword = '两次输入的密码不一致';
        isValid = false;
      }
      
      return isValid;
    },
    
    // 更新密码
    updatePassword() {
      if (!this.validateForm()) {
        return;
      }
      
      // 获取当前用户信息
      const userInfoStr = uni.getStorageSync('userInfo');
      if (!userInfoStr) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        });
        uni.redirectTo({
          url: '/pages/index/index'
        });
        return;
      }
      
      const userInfo = JSON.parse(userInfoStr);
      
      
      // 构建请求数据 - 直接使用整个用户对象，添加新密码和确认密码字段
      const requestData = {
        ...userInfo,  // 包含id, username, name, avatar, email, phone, role, token, typeAddress等字段
        password: this.passwordForm.password,       // 原密码
        newPassword: this.passwordForm.newPassword, // 新密码
        confirmPassword: this.passwordForm.confirmPassword // 确认密码
      };
      
      uni.showLoading({
        title: '修改中...'
      });
      
      // 调用API修改密码
      console.log('发送密码修改请求，数据:', requestData);
      request.put('/updatePassword', requestData).then(res => {
        uni.hideLoading();
        // console.log('TEST 1');
        // console.log('密码修改响应userInfo哈哈哈哈哈哈:', JSON.stringify(userInfo));
        // console.log('TEST 2');
        // console.log('密码修改响应:', res);
        // console.log('TEST 3');
        if (res.code === 200 || res.code === '200') {
          uni.showToast({
            title: '密码修改成功，请重新登录',
            icon: 'success',
            duration: 2000
          });
          
          // 2秒后清除登录信息并跳转到登录页
          setTimeout(() => {
            this.logout();
          }, 2000);
        } else {
          uni.showToast({
            title: res.msg || '修改失败，请检查原密码是否正确',
            icon: 'none'
          });
        }
      }).catch(err => {
        uni.hideLoading();
        console.error('密码修改失败:', err);
        uni.showToast({
          title: '修改失败，请稍后再试',
          icon: 'none'
        });
      });
    },
    
    // 退出登录
    logout() {
      // 清除登录信息
      uni.removeStorageSync('token');
      uni.removeStorageSync('userInfo');
      
      // 跳转到登录页
      uni.reLaunch({
        url: '/pages/index/index'
      });
    },
    
    goBack() {
      uni.navigateBack();
    }
  }
}
</script>

<style lang="scss">
.password-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #64b3f4 0%, #c2e59c 100%);
  padding: 30rpx;
  
  .page-header {
    margin-bottom: 30rpx;
    
    .page-title {
      font-size: 36rpx;
      font-weight: bold;
      color: #fff;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }
  }
  
  .password-form {
    background: rgba(255, 255, 255, 0.9);
    border-radius: 15rpx;
    padding: 30rpx;
    box-shadow: 0 4rpx 15rpx rgba(0, 0, 0, 0.1);
    
    .form-item {
      margin-bottom: 30rpx;
      
      .form-label {
        display: block;
        font-size: 28rpx;
        color: #333;
        margin-bottom: 15rpx;
        font-weight: bold;
      }
      
      .form-input {
        width: 100%;
        height: 80rpx;
        background-color: #f8f8f8;
        border: 1px solid #eee;
        border-radius: 8rpx;
        padding: 0 20rpx;
        box-sizing: border-box;
      }
      
      .error-tip {
        display: block;
        font-size: 24rpx;
        color: #ff4d4f;
        margin-top: 8rpx;
      }
    }
    
    .form-tips {
      background-color: #f8f8f8;
      border-radius: 8rpx;
      padding: 20rpx;
      margin-bottom: 30rpx;
      
      text {
        display: block;
        font-size: 24rpx;
        color: #666;
        line-height: 1.6;
        
        &:first-child {
          color: #333;
          margin-bottom: 10rpx;
        }
      }
    }
    
    .submit-btn {
      background-color: #0b8bff;
      color: #fff;
      font-size: 28rpx;
      height: 80rpx;
      line-height: 80rpx;
      width: 100%;
      border-radius: 8rpx;
      margin-bottom: 20rpx;
    }
    
    .cancel-btn {
      background-color: #f0f0f0;
      color: #666;
      font-size: 28rpx;
      height: 80rpx;
      line-height: 80rpx;
      width: 100%;
      border-radius: 8rpx;
    }
  }
}
</style> 
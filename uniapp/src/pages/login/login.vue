<template>
  <view class="login-container">
    <view class="logo-area">
      <image src="../../static/logo.png" mode="aspectFit" class="logo" :animation="logoAnimation"></image>
      <text class="app-title" :animation="titleAnimation">高血压义诊系统</text>
    </view>
    <view class="login-box" :animation="animationData">
      <view class="title">欢 迎 注 册</view>
      
      <view class="form-area">
        <view class="el-form">
          <view class="el-form-item">
            <text class="el-form-item__label">账号:</text>
            <view class="el-form-item__content">
              <view class="el-input">
                <input type="text" v-model="formData.username" placeholder="请输入账号" class="el-input__inner" />
              </view>
            </view>
          </view>
          
          <view class="el-form-item">
            <text class="el-form-item__label">姓名:</text>
            <view class="el-form-item__content">
              <view class="el-input">
                <input type="text" v-model="formData.name" placeholder="请输入姓名" class="el-input__inner" />
              </view>
            </view>
          </view>
          
          <view class="el-form-item">
            <text class="el-form-item__label">密码:</text>
            <view class="el-form-item__content">
              <view class="el-input">
                <input type="password" v-model="formData.password" placeholder="请输入密码" class="el-input__inner" />
              </view>
            </view>
          </view>
          
          <view class="el-form-item">
            <text class="el-form-item__label">确认密码:</text>
            <view class="el-form-item__content">
              <view class="el-input">
                <input type="password" v-model="formData.confirmPassword" placeholder="请再次输入密码" class="el-input__inner" />
              </view>
            </view>
          </view>
          
          <button class="el-button el-button--primary el-button--large is-round register-btn" @click="handleRegister">注 册</button>
          
          <view class="login-link" @click="handleLogin">
            已有账号？去<text class="el-link el-link--primary">登录</text>
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
    return {
      formData: {
        username: '',
        name: '',
        password: '',
        confirmPassword: '',
        role: 'USER'
      },
      roleOptions: [
        { value: 'USER', label: '用户' }
      ],
      roleIndex: 0,
      animationData: {},
      logoAnimation: {},
      titleAnimation: {}
    }
  },
  onReady() {
    // 创建动画实例
    setTimeout(() => {
      this.animateLogo();
      setTimeout(() => {
        this.animateTitle();
        setTimeout(() => {
          this.animateBox();
        }, 200);
      }, 200);
    }, 100);
  },
  methods: {
    // 动画方法
    animateLogo() {
      const animation = uni.createAnimation({
        duration: 600,
        timingFunction: 'ease',
      });
      animation.opacity(1).translateY(0).step();
      this.logoAnimation = animation.export();
    },
    animateTitle() {
      const animation = uni.createAnimation({
        duration: 600,
        timingFunction: 'ease',
      });
      animation.opacity(1).translateY(0).step();
      this.titleAnimation = animation.export();
    },
    animateBox() {
      const animation = uni.createAnimation({
        duration: 600,
        timingFunction: 'ease',
      });
      animation.opacity(1).translateY(0).step();
      this.animationData = animation.export();
    },
    
    // 角色选择
    roleChange(e) {
      this.roleIndex = e.detail.value;
      this.formData.role = this.roleOptions[this.roleIndex].value;
    },
    
    // 表单验证
    validateForm() {
      if (!this.formData.username) {
        uni.showToast({
          title: '请输入账号',
          icon: 'none'
        });
        return false;
      }
      
      if (!this.formData.name) {
        uni.showToast({
          title: '请输入姓名',
          icon: 'none'
        });
        return false;
      }
      
      if (!this.formData.password) {
        uni.showToast({
          title: '请输入密码',
          icon: 'none'
        });
        return false;
      }
      
      if (!this.formData.confirmPassword) {
        uni.showToast({
          title: '请确认密码',
          icon: 'none'
        });
        return false;
      }
      
      if (this.formData.password !== this.formData.confirmPassword) {
        uni.showToast({
          title: '两次密码输入不一致',
          icon: 'none'
        });
        return false;
      }
      
      return true;
    },
    
    // 处理注册
    handleRegister() {
      if (!this.validateForm()) {
        return;
      }
      
      uni.showLoading({
        title: '注册中...'
      });
      
      // 调用注册接口
      request.post('/register', this.formData).then(res => {
        uni.hideLoading();
        
        if (res.code === '200' || res.code === 200) {
          uni.showToast({
            title: '注册成功',
            icon: 'success'
          });
          
          // 注册成功后延迟跳转到登录页
          setTimeout(() => {
            uni.navigateBack();
          }, 1500);
        } else {
          uni.showToast({
            title: res.msg || '注册失败',
            icon: 'none'
          });
        }
      }).catch(err => {
        uni.hideLoading();
        console.error('注册失败:', err);
        uni.showToast({
          title: '注册失败，请稍后再试',
          icon: 'none'
        });
      });
    },
    
    // 返回登录页
    handleLogin() {
      uni.navigateBack();
    }
  }
}
</script>

<style lang="scss">
.login-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  min-height: 100vh;
  background: linear-gradient(135deg, #64b3f4 0%, #c2e59c 100%);
  padding: 40rpx;
  box-sizing: border-box;
  
  .logo-area {
    margin-bottom: 40rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    
    .logo {
      width: 160rpx;
      height: 160rpx;
      margin-bottom: 20rpx;
      opacity: 0;
      transform: translateY(20rpx);
    }
    
    .app-title {
      font-size: 40rpx;
      font-weight: bold;
      color: #fff;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      opacity: 0;
      transform: translateY(20rpx);
    }
  }
  
  .login-box {
    width: 100%;
    background: rgba(255, 255, 255, 0.9);
    border-radius: 20rpx;
    padding: 40rpx 30rpx;
    box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    align-items: center;
    opacity: 0;
    transform: translateY(20rpx);
    
    .title {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 30rpx;
      position: relative;
      
      &::after {
        content: '';
        position: absolute;
        bottom: -10rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 60rpx;
        height: 4rpx;
        background: var(--el-color-primary);
        border-radius: 2rpx;
      }
    }
    
    .form-area {
      width: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      
      .el-form {
        width: 100%;
      }
      
      .el-form-item {
        display: flex;
        margin-bottom: 25rpx;
        
        .el-form-item__label {
          width: 150rpx;
          text-align: right;
          padding-right: 20rpx;
          color: #333;
          font-size: 28rpx;
        }
        
        .el-form-item__content {
          flex: 1;
        }
      }
      
      .el-input__inner {
        height: 70rpx;
        background-color: #f5f5f5;
        border-radius: 8rpx;
        padding: 0 30rpx;
        color: #333;
        font-size: 28rpx;
        border: 1px solid #e0e0e0;
      }
      
      .el-select {
        width: 100%;
        
        .picker-wrapper {
          width: 100%;
        }
        
        .el-select__inner {
          height: 70rpx;
          line-height: 70rpx;
          background-color: #f5f5f5;
          border-radius: 8rpx;
          padding: 0 30rpx;
          color: #333;
          font-size: 28rpx;
          border: 1px solid #e0e0e0;
          position: relative;
          
          &::after {
            content: "";
            position: absolute;
            right: 20rpx;
            top: 50%;
            transform: translateY(-50%);
            border-width: 8rpx;
            border-style: solid;
            border-color: #999 transparent transparent transparent;
          }
        }
      }
      
      .register-btn {
        width: 80%;
        height: 90rpx;
        margin-top: 30rpx;
        margin-bottom: 20rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32rpx;
        border: none;
        background: var(--el-color-primary);
        color: white;
        border-radius: 45rpx;
        transition: all 0.3s;
        
        &:active {
          background: var(--el-color-primary-dark-2);
        }
      }
      
      .login-link {
        margin-top: 20rpx;
        color: #666;
        font-size: 28rpx;
        
        .el-link {
          margin-left: 5rpx;
          color: var(--el-color-primary);
          cursor: pointer;
          text-decoration: none;
          
          &:hover {
            color: var(--el-color-primary-light-3);
          }
        }
      }
    }
  }
}
</style> 
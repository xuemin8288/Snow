<template>
  <view class="index-container">
    <view class="logo-area">
      <image src="../../static/logo.png" mode="aspectFit" class="logo" :animation="logoAnimation"></image>
      <text class="app-title" :animation="titleAnimation">高血压义诊系统</text>
    </view>
    
    <view class="login-box" :animation="animationData">
      <view class="form-area">
        <view class="el-form">
          <view class="el-form-item">
            <text class="el-form-item__label">账号:</text>
            <view class="el-form-item__content">
              <view class="el-input">
                <input 
                  type="text" 
                  v-model="formData.account" 
                  placeholder="请输入账号" 
                  class="el-input__inner" 
                />
              </view>
            </view>
          </view>
          
          <view class="el-form-item">
            <text class="el-form-item__label">密码:</text>
            <view class="el-form-item__content">
              <view class="el-input">
                <input 
                  type="password" 
                  v-model="formData.password" 
                  placeholder="请输入密码" 
                  class="el-input__inner" 
                />
              </view>
            </view>
          </view>
          
          <button class="el-button el-button--primary el-button--large is-round login-btn" @click="handleLogin">登录</button>
        </view>
      </view>
    </view>
    
    <view class="register-area">
      <view class="el-link el-link--primary register-btn" @click="toRegister">注册</view>
    </view>
  </view>
</template>

<script>
import request from '../../utils/request.js';
import apiConfig from '../../config/api.js';

export default {
  data() {
    return {
      formData: {
        account: '',
        password: ''
      },
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
    
    handleLogin() {
      // 验证登录信息
      if (!this.formData.account || !this.formData.password) {
        uni.showToast({
          title: '请输入账号和密码',
          icon: 'none'
        })
        return
      }
      
      // 登录请求数据
      const loginData = {
        username: this.formData.account,
        password: this.formData.password,
        role: 'USER'  // 添加角色参数，指定为普通用户角色
      }
      
      console.log('登录请求数据:', loginData)
      
      // 调用登录接口
      request.post(apiConfig.user.login, loginData)
        .then(res => {
          console.log('登录响应:', res)
          if (res.code === '200' || res.code === 200) {
            // 保存登录状态和用户信息
            uni.setStorageSync('token', res.data.token)
            uni.setStorageSync('userInfo', JSON.stringify(res.data))
            
            uni.showToast({
              title: '登录成功',
              icon: 'success'
            })
            // 跳转到主页
            setTimeout(() => {
              uni.reLaunch({
                url: '/pages/layout/layout'
              })
            }, 1500)
          } else {
            uni.showToast({
              title: res.message || res.msg || '登录失败',
              icon: 'none'
            })
          }
        })
        .catch((error) => {
          console.error('登录请求失败:', error)
          uni.showToast({
            title: '网络错误，请确保后端服务已启动',
            icon: 'none'
          })
        })
    },
    
    toRegister() {
      console.log('注册按钮被点击');
      
      // 使用最简单的方式尝试跳转
      uni.navigateTo({
        url: '../login/login',
        success: function() {
          console.log('跳转成功');
        },
        fail: function(err) {
          console.error('跳转失败:', err);
          uni.showToast({
            title: '跳转失败',
            icon: 'none'
          });
        }
      });
    }
  }
}
</script>

<style lang="scss">
.index-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  min-height: 100vh;
  background: linear-gradient(135deg, #64b3f4 0%, #c2e59c 100%);
  padding: 60rpx 40rpx;
  box-sizing: border-box;
  
  .logo-area {
    margin-bottom: 60rpx;
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
    padding: 50rpx 0;
    box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    align-items: center;
    opacity: 0;
    transform: translateY(20rpx);
    margin-bottom: 40rpx;
    
    .form-area {
      width: 85%;
      display: flex;
      flex-direction: column;
      align-items: center;
      
      .el-form {
        width: 100%;
      }
      
      .el-form-item {
        display: flex;
        margin-bottom: 40rpx;
        
        .el-form-item__label {
          width: 80rpx;
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
        border-radius: 35rpx;
        padding: 0 30rpx;
        color: #333;
        font-size: 28rpx;
        border: 1px solid #e0e0e0;
      }
      
      .login-btn {
        width: 80%;
        height: 90rpx;
        margin-top: 20rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32rpx;
        font-weight: 600;
        border: none;
        background: #1e88e5;
        box-shadow: 0 4rpx 10rpx rgba(30, 136, 229, 0.4);
        color: white;
        transition: all 0.3s;
        
        &:active {
          background: #1565c0;
          transform: translateY(2rpx);
        }
      }
    }
  }
  
  .register-area {
    margin-top: 30rpx;
    
    .register-btn {
      color: #ffffff;
      font-size: 32rpx;
      font-weight: 600;
      padding: 15rpx 40rpx;
      text-decoration: none;
      background-color: rgba(0, 0, 0, 0.3);
      border-radius: 50rpx;
      box-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.2);
      
      &:active {
        background-color: rgba(0, 0, 0, 0.5);
        transform: translateY(2rpx);
      }
    }
  }
}
</style>

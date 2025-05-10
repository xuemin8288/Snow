<template>
  <view class="user-container">
    <!-- 左侧侧边栏 -->
    <view class="sidebar">
      <view class="menu-item logo-item" @click="navigateToHome">
        <image src="../../static/logo.png" mode="aspectFit" class="logo-image"></image>
      </view>
      
      <!-- 个人中心菜单 -->
      <!-- <view class="menu-item sub-menu-item" @click="handleUserAction('appointment')">
        <text>预约记录</text>
      </view> -->
      <view class="menu-item sub-menu-item" @click="handleUserAction('consultation')">
        <text>问诊记录</text>
      </view>
      <view class="menu-item sub-menu-item" @click="handleUserAction('testRecord')">
        <text>测试记录</text>
      </view>
      <view class="menu-item sub-menu-item" @click="handleUserAction('feedback')">
        <text>我的反馈</text>
      </view>
      <view class="menu-item sub-menu-item" @click="handleUserAction('password')">
        <text>修改密码</text>
      </view>
      <view class="menu-item sub-menu-item active" @click="handleUserAction('edit')">
        <text>个人信息编辑</text>
      </view>
      <view class="menu-item sub-menu-item logout-item" @click="logout">
        <text>退出登录</text>
      </view>
      <!-- <view class="menu-item back-item" @click="navigateToHome">
        <text>返回主菜单</text>
      </view> -->
    </view>
    
    <!-- 右侧内容区 -->
    <view class="content-area">
      <view class="page-content">
        <text class="page-title">个人信息编辑</text>
        
        <!-- 编辑表单 -->
        <view class="edit-form">
          <view class="form-item">
            <text class="form-label">头像</text>
            <view class="avatar-upload" @click="chooseAvatar">
              <image :src="userForm.avatar || '../../static/default-avatar.png'" class="avatar-preview" mode="aspectFill"></image>
              <view class="avatar-btn">选择图片</view>
            </view>
          </view>
          
          <view class="form-item">
            <text class="form-label">用户名</text>
            <input type="text" class="form-input disabled" v-model="userForm.username" placeholder="用户名" disabled />
          </view>
          
          <view class="form-item">
            <text class="form-label">姓名</text>
            <input type="text" class="form-input" v-model="userForm.name" placeholder="请输入姓名" />
          </view>
          
          <view class="form-item">
            <text class="form-label">手机号</text>
            <input type="text" class="form-input" v-model="userForm.phone" placeholder="请输入手机号" maxlength="11" />
          </view>
          
          <view class="form-item">
            <text class="form-label">邮箱</text>
            <input type="text" class="form-input" v-model="userForm.email" placeholder="请输入邮箱" />
          </view>
          
          <view class="form-item">
            <text class="form-label">性别</text>
            <input type="text" class="form-input" v-model="userForm.gender" placeholder="请输入性别" />
          </view>
          
          <view class="form-item">
            <text class="form-label">年龄</text>
            <input type="number" class="form-input" v-model="userForm.age" placeholder="请输入年龄" />
          </view>
          
          <view class="form-item" v-if="addressList.length > 0">
            <text class="form-label">地址</text>
            <picker @change="addressChange" :value="addressIndex" :range="addressList">
              <view class="uni-input form-picker">
                <text>{{ userForm.typeAddress || '请选择地址' }}</text>
                <text class="picker-arrow">▼</text>
              </view>
            </picker>
          </view>
          
          <button class="submit-btn" @click="updateUserInfo">保存信息</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import request from '@/utils/request.js';

export default {
  data() {
    return {
      userInfo: {},
      currentAction: 'edit',
      userStats: {
        appointmentCount: 0,
        consultationCount: 0,
        assessmentCount: 0
      },
      activities: [],
      passwordForm: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      userForm: {
        name: '',
        phone: '',
        email: '',
        typeAddress: '',
        username: '',
        avatar: '',
        role: '',
        gender: '',
        age: ''
      },
      addressList: [],
      baseUrl: '',
      addressIndex: 0
    }
  },
  onLoad() {
    this.loadUserInfo();
    this.loadUserStats();
    this.loadRecentActivities();
    this.fetchAddresses();
    this.baseUrl = 'http://localhost:9090';
  },
  methods: {
    loadUserInfo() {
      const userInfoStr = uni.getStorageSync('userInfo');
      const token = uni.getStorageSync('token');
      
      if (userInfoStr && token) {
        try {
          this.userInfo = JSON.parse(userInfoStr);
          this.userForm.name = this.userInfo.name || '';
          this.userForm.phone = this.userInfo.phone || '';
          this.userForm.email = this.userInfo.email || '';
          this.userForm.username = this.userInfo.username || '';
          this.userForm.avatar = this.userInfo.avatar || '';
          this.userForm.role = this.userInfo.role || 'USER';
          this.userForm.typeAddress = this.userInfo.typeAddress || '';
          this.userForm.gender = this.userInfo.gender || '';
          this.userForm.age = this.userInfo.age || '';
          this.userForm.id = this.userInfo.id;
        } catch (e) {
          console.error('解析用户信息失败:', e);
        }
      } else {
        uni.redirectTo({
          url: '/pages/index/index'
        });
      }
    },
    
    fetchAddresses() {
      request.get('/typeaddmap/uniqueAddresses').then(res => {
        if (res.code === 200 || res.code === '200') {
          this.addressList = res.data || [];
          if (this.userForm.typeAddress) {
            const index = this.addressList.findIndex(addr => addr === this.userForm.typeAddress);
            if (index !== -1) {
              this.addressIndex = index;
            }
          }
        } else {
          uni.showToast({
            title: res.msg || '获取地址列表失败',
            icon: 'none'
          });
        }
      }).catch(err => {
        console.error('获取地址列表失败:', err);
        uni.showToast({
          title: '获取地址列表失败',
          icon: 'none'
        });
      });
    },
    
    chooseAvatar() {
      uni.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: (res) => {
          const tempFilePaths = res.tempFilePaths;
          this.uploadAvatar(tempFilePaths[0]);
        }
      });
    },
    
    uploadAvatar(filePath) {
      uni.showLoading({
        title: '上传中...'
      });
      
      uni.uploadFile({
        url: this.baseUrl + '/files/upload',
        filePath: filePath,
        name: 'file',
        success: (uploadRes) => {
          uni.hideLoading();
          const result = JSON.parse(uploadRes.data);
          if (result.code === 200 || result.code === '200') {
            this.userForm.avatar = result.data;
            uni.showToast({
              title: '头像上传成功',
              icon: 'success'
            });
          } else {
            uni.showToast({
              title: result.msg || '上传失败',
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          uni.hideLoading();
          console.error('头像上传失败:', err);
          uni.showToast({
            title: '头像上传失败',
            icon: 'none'
          });
        }
      });
    },
    
    loadUserStats() {
      this.userStats = {
        appointmentCount: 3,
        consultationCount: 2,
        assessmentCount: 5
      };
    },
    
    loadRecentActivities() {
      this.activities = [
        {
          type: 'assessment',
          title: '完成测评',
          description: '完成了"高血压自我评估表"',
          time: '2023-07-10 14:30'
        },
        {
          type: 'appointment',
          title: '咨询专家',
          description: '预约了张华医生的咨询',
          time: '2023-07-08 09:15'
        }
      ];
    },
    
    navigateToHome() {
      uni.switchTab({
        url: '/pages/layout/layout',
        fail: (err) => {
          console.error('跳转到首页失败:', err);
          uni.showToast({
            title: '跳转失败，请稍后再试',
            icon: 'none'
          });
        }
      });
    },
    
    handleUserAction(action) {
      if (action === 'consultation') {
        uni.navigateTo({
          url: '/pages/user/consultation',
          fail: (err) => {
            console.error('跳转到问诊记录页面失败:', err);
            uni.showToast({
              title: '跳转失败，请稍后再试',
              icon: 'none'
            });
          }
        });
      } else if (action === 'testRecord') {
        uni.navigateTo({
          url: '/pages/user/testRecord',
          fail: (err) => {
            console.error('跳转到测试记录页面失败:', err);
            uni.showToast({
              title: '跳转失败，请稍后再试',
              icon: 'none'
            });
          }
        });
      } else if (action === 'appointment') {
        uni.navigateTo({
          url: '/pages/user/appointment',
          fail: (err) => {
            console.error('跳转到预约记录页面失败:', err);
            uni.showToast({
              title: '跳转失败，请稍后再试',
              icon: 'none'
            });
          }
        });
      } else if (action === 'feedback') {
        uni.navigateTo({
          url: '/pages/user/feedback',
          fail: (err) => {
            console.error('跳转到我的反馈页面失败:', err);
            uni.showToast({
              title: '跳转失败，请稍后再试',
              icon: 'none'
            });
          }
        });
      } else if (action === 'password') {
        uni.navigateTo({
          url: '/pages/user/password',
          fail: (err) => {
            console.error('跳转到修改密码页面失败:', err);
            uni.showToast({
              title: '跳转失败，请稍后再试',
              icon: 'none'
            });
          }
        });
      } else {
        this.currentAction = action;
      }
    },
    
    updateUserInfo() {
      if (!this.userForm.name) {
        uni.showToast({
          title: '请输入姓名',
          icon: 'none'
        });
        return;
      }
      
      if (!this.userForm.phone) {
        uni.showToast({
          title: '请输入手机号',
          icon: 'none'
        });
        return;
      }
      
      if (!/^1\d{10}$/.test(this.userForm.phone)) {
        uni.showToast({
          title: '请输入正确的手机号',
          icon: 'none'
        });
        return;
      }
      
      if (this.userForm.email && !/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/.test(this.userForm.email)) {
        uni.showToast({
          title: '请输入正确的邮箱格式',
          icon: 'none'
        });
        return;
      }
      
      uni.showLoading({
        title: '保存中...'
      });
      
      request.put('/user/update', this.userForm).then(res => {
        uni.hideLoading();
        if (res.code === 200 || res.code === '200') {
          this.userInfo = {...this.userInfo, ...this.userForm};
          uni.setStorageSync('userInfo', JSON.stringify(this.userInfo));
          
          uni.showToast({
            title: '保存成功',
            icon: 'success'
          });
        } else {
          uni.showToast({
            title: res.msg || '保存失败',
            icon: 'none'
          });
        }
      }).catch(err => {
        uni.hideLoading();
        console.error('保存用户信息失败:', err);
        uni.showToast({
          title: '保存失败，请稍后再试',
          icon: 'none'
        });
      });
    },
    
    logout() {
      uni.showModal({
        title: '提示',
        content: '确定要退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            uni.removeStorageSync('token');
            uni.removeStorageSync('userInfo');
            
            uni.reLaunch({
              url: '/pages/index/index'
            });
          }
        }
      });
    },
    
    addressChange(e) {
      this.addressIndex = e.detail.value;
      this.userForm.typeAddress = this.addressList[this.addressIndex];
    }
  }
}
</script>

<style lang="scss">
.user-container {
  display: flex;
  height: 100vh;
  background: linear-gradient(135deg, #64b3f4 0%, #c2e59c 100%);
  position: relative;
  
  .sidebar {
    width: 240rpx;
    background: rgba(0, 0, 0, 0.7);
    box-shadow: 0 0 15rpx rgba(0, 0, 0, 0.2);
    
    .menu-item {
      height: 100rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0 20rpx;
      border-bottom: 2rpx solid rgba(255, 255, 255, 0.1);
      
      &.logo-item {
        height: 120rpx;
        padding: 10rpx;
      }
      
      .logo-image {
        width: 80rpx;
        height: 80rpx;
        border-radius: 10rpx;
      }
      
      text {
        font-size: 28rpx;
        color: #fff;
        text-align: center;
      }
      
      &:active {
        background-color: rgba(255, 255, 255, 0.1);
      }
      
      &.active {
        background-color: rgba(255, 255, 255, 0.2);
      }
    }
    
    .sub-menu-item {
      font-size: 26rpx;
      padding-left: 40rpx;
      justify-content: flex-start;
      background-color: rgba(0, 0, 0, 0.04);
    }
    
    .back-item {
      margin-top: 40rpx;
      border-top: 1px solid rgba(255, 255, 255, 0.2);
      padding-top: 20rpx;
    }
    
    .logout-item {
      color: #ff4d4f;
      
      text {
        color: #ff4d4f;
      }
    }
  }
  
  .content-area {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    padding: 30rpx;
    
    .page-content {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      padding: 40rpx;
      display: flex;
      flex-direction: column;
      align-items: center;
      overflow-y: auto;
      
      .page-title {
        font-size: 36rpx;
        font-weight: bold;
        color: #fff;
        margin-bottom: 30rpx;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        align-self: flex-start;
      }
      
      .edit-form {
        width: 100%;
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
            
            &.disabled {
              background-color: #f0f0f0;
              color: #999;
            }
          }
          
          .avatar-upload {
            display: flex;
            align-items: center;
            
            .avatar-preview {
              width: 120rpx;
              height: 120rpx;
              border-radius: 60rpx;
              margin-right: 20rpx;
              border: 2px solid #eee;
            }
            
            .avatar-btn {
              background-color: #f8f8f8;
              color: #666;
              font-size: 26rpx;
              padding: 10rpx 20rpx;
              border-radius: 8rpx;
              border: 1px solid #eee;
            }
          }
        }
        
        .form-picker {
          width: 100%;
          height: 80rpx;
          background-color: #f8f8f8;
          border: 1px solid #eee;
          border-radius: 8rpx;
          padding: 0 20rpx;
          box-sizing: border-box;
          display: flex;
          align-items: center;
          justify-content: space-between;
          
          .picker-arrow {
            font-size: 24rpx;
            color: #999;
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
          margin-top: 20rpx;
        }
      }
    }
  }
}
</style> 
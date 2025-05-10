<template>
  <view class="layout-container">
    <!-- 左侧侧边栏 -->
    <view class="sidebar el-menu">
      <view class="menu-item logo-item" @click="sidebarClick('home')">
        <image src="../../static/logo.png" mode="aspectFit" class="logo-image"></image>
      </view>
      
      <!-- 常规导航菜单 - 当不是个人中心页面时显示 -->
      <template v-if="currentPage !== 'user'">
        <view class="el-menu-item menu-item" @click="sidebarClick('user')">
          <text>个人中心</text>
        </view>
        <view class="el-menu-item menu-item" @click="sidebarClick('assessment')">
          <text>填写问诊单</text>
        </view>
        <view class="el-menu-item menu-item" @click="sidebarClick('consult')">
          <text>咨询专家</text>
        </view>
        <view class="el-menu-item menu-item" @click="sidebarClick('feedback')">
          <text>反馈和建议</text>
        </view>
      </template>
      
      <!-- 个人中心菜单 - 当是个人中心页面时显示 -->
      <template v-else>
        <view class="el-menu-item sub-menu-item" @click="handleUserAction('appointment')">
          <text>预约记录</text>
        </view>
        <view class="el-menu-item sub-menu-item" @click="handleUserAction('consultation')">
          <text>问诊记录</text>
        </view>
        <view class="el-menu-item sub-menu-item" @click="handleUserAction('feedback')">
          <text>我的反馈</text>
        </view>
        <view class="el-menu-item sub-menu-item" @click="handleUserAction('password')">
          <text>修改密码</text>
        </view>
        <view class="el-menu-item sub-menu-item" @click="handleUserAction('edit')">
          <text>个人信息编辑</text>
        </view>
        <view class="el-menu-item sub-menu-item logout-item" @click="logout">
          <text>退出登录</text>
        </view>
        <view class="el-menu-item menu-item back-item" @click="backToMainMenu">
          <text>返回主菜单</text>
        </view>
      </template>
    </view>
    
    <!-- 右侧内容区 -->
    <scroll-view class="content-area" scroll-y="true">
      <view v-if="currentPage === 'home'" class="page-content">
        <!-- 添加轮播图 -->
        <swiper class="banner-swiper" :indicator-dots="true" :autoplay="true" :interval="3000" :duration="500" circular>
          <swiper-item v-for="(item, index) in sideshowData" :key="item.id" @click="viewArticleDetail(item.id)">
            <image :src="item.img" mode="aspectFill" class="banner-image"></image>
          </swiper-item>
        </swiper>
        
        <text class="page-title">高血压知识宣传</text>
        <scroll-view scroll-y class="articles-container">
          <!-- 使用v-for动态显示文章 -->
          <view v-for="(item, index) in propagateData" :key="item.id" class="el-card article-card" @click="viewArticleDetail(item.id)">
            <image :src="item.img" mode="aspectFill" class="article-image"></image>
            <view class="el-card__body article-content">
              <text class="article-title">{{ item.title }}</text>
              <text class="article-desc">{{ item.content }}</text>
              <view class="article-meta">
                <text class="article-date">{{ formatDate(item.createTime) }}</text>
                <view class="el-tag" v-if="item.doctorName">{{ item.doctorName }}</view>
                <view class="el-tag" v-if="item.num">阅读：{{ item.num }}</view>
              </view>
            </view>
          </view>
        </scroll-view>
      </view>
      
      <view v-else-if="currentPage === 'user'" class="page-content">
        <text class="page-title">个人中心</text>
        
        <view class="el-card user-info-card">
          <view class="el-card__body">
            <image :src="userInfo.avatar || '../../static/default-avatar.png'" class="user-card-avatar" mode="aspectFill"></image>
            <view class="user-card-info">
              <text class="user-name">{{userInfo.name || '用户名'}}</text>
              <text class="user-account">账号: {{userInfo.username || ''}}</text>
              <text class="user-contact">联系方式: {{userInfo.phone || '未设置'}}</text>
            </view>
          </view>
        </view>
      </view>
      
      <view v-else-if="currentPage === 'assessment'" class="page-content">
        <text class="page-title">高血压测评</text>
        <view class="el-empty">
          <text class="coming-soon">测评功能开发中...</text>
        </view>
      </view>
      
      <view v-else-if="currentPage === 'consult'" class="page-content">
        <text class="page-title">高血压咨询</text>
        <view class="el-empty">
          <text class="coming-soon">咨询功能开发中...</text>
        </view>
      </view>
      
      <view v-else-if="currentPage === 'feedback'" class="page-content">
        <text class="page-title">反馈与建议</text>
        <view class="el-empty">
          <text class="coming-soon">反馈功能开发中...</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      currentPage: 'home',
      sidebarExpanded: true,
      userInfo: {},
      propagateData: [], // 添加宣传文章数据数组
      sideshowData: [], // 添加轮播图数据数组
      pageNum: 1,
      pageSize: 5,
      total: 0
    }
  },
  onLoad() {
    // 获取token
    const token = uni.getStorageSync('token');
    if (!token) {
      uni.showToast({
        title: '请先登录',
        icon: 'none'
      });
      setTimeout(() => {
        uni.redirectTo({
          url: '/pages/index/index'
        });
      }, 1500);
      return;
    }
    
    // 获取登录用户信息
    const userInfoStr = uni.getStorageSync('userInfo');
    if (userInfoStr) {
      try {
        this.userInfo = JSON.parse(userInfoStr);
        console.log('获取到用户信息:', this.userInfo);
      } catch (e) {
        console.error('解析用户信息失败:', e);
      }
    } else {
      // 如果未登录，跳转到登录页
      uni.redirectTo({
        url: '/pages/index/index'
      });
      return;
    }
    
    // 加载轮播图数据
    this.loadSideshow();
    // 加载宣传文章数据
    this.loadPropagate();
  },
  methods: {
    // 加载轮播图
    loadSideshow() {
      const token = uni.getStorageSync('token');
      
      uni.request({
        url: 'http://localhost:9090/sideshow/selectAll',
        method: 'GET',
        header: {
          'Content-Type': 'application/json',
          'token': token
        },
        success: (res) => {
          if (res.data.code === '200') {
            this.sideshowData = res.data.data;
          } else if (res.data.code === '401') {
            // token无效或过期
            uni.showToast({
              title: '登录已过期，请重新登录',
              icon: 'none'
            });
            uni.removeStorageSync('token');
            uni.removeStorageSync('userInfo');
            setTimeout(() => {
              uni.redirectTo({
                url: '/pages/index/index'
              });
            }, 1500);
          } else {
            uni.showToast({
              title: res.data.msg || '加载轮播图失败',
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          console.error('请求失败:', err);
        }
      });
    },
    
    // 加载宣传文章
    loadPropagate() {
      uni.showLoading({
        title: '加载中...'
      });
      
      // 获取token
      const token = uni.getStorageSync('token');
      if (!token) {
        uni.showToast({
          title: '请先登录',
          icon: 'none'
        });
        setTimeout(() => {
          uni.redirectTo({
            url: '/pages/index/index'
          });
        }, 1500);
        return;
      }
      
      uni.request({
        url: 'http://localhost:9090/propagate/selectPageFront',
        method: 'GET',
        data: {
          pageNum: this.pageNum,
          pageSize: this.pageSize
        },
        header: {
          'Content-Type': 'application/json',
          'token': token
        },
        success: (res) => {
          if (res.data.code === '200') {
            this.propagateData = res.data.data.list;
            this.total = res.data.data.total;
          } else if (res.data.code === '401') {
            // token无效或过期
            uni.showToast({
              title: '登录已过期，请重新登录',
              icon: 'none'
            });
            // 清除登录信息
            uni.removeStorageSync('token');
            uni.removeStorageSync('userInfo');
            // 延迟跳转到登录页
            setTimeout(() => {
              uni.redirectTo({
                url: '/pages/index/index'
              });
            }, 1500);
          } else {
            uni.showToast({
              title: res.data.msg || '加载失败',
              icon: 'none'
            });
          }
        },
        fail: (err) => {
          console.error('请求失败:', err);
          uni.showToast({
            title: '网络请求失败',
            icon: 'none'
          });
        },
        complete: () => {
          uni.hideLoading();
        }
      });
    },
    
    // 格式化日期
    formatDate(dateStr) {
      if (!dateStr) return '';
      const date = new Date(dateStr);
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
    },
    
    // 侧边栏菜单点击
    sidebarClick(action) {
      console.log('菜单点击:', action);
      
      switch(action) {
        case 'home':
          this.currentPage = action;
          break;
        case 'user':
          // 跳转到个人中心页面
          uni.switchTab({
            url: '/pages/user/user',
            fail: (err) => {
              console.error('跳转个人中心页面失败:', err);
              uni.showToast({
                title: '跳转失败，请稍后再试',
                icon: 'none'
              });
            }
          });
          break;
        case 'feedback':
          // 跳转到反馈页面
          uni.navigateTo({
            url: '/pages/feedback/feedback',
            fail: (err) => {
              console.error('跳转反馈页面失败:', err);
              uni.showToast({
                title: '跳转失败，请稍后再试',
                icon: 'none'
              });
            }
          });
          break;
        case 'assessment':
          // 使用switchTab跳转到测评页面，因为它是tabBar页面
          uni.switchTab({
            url: '/pages/test/test',
            fail: (err) => {
              console.error('跳转测评页面失败:', err);
              uni.showToast({
                title: '跳转失败，请稍后再试',
                icon: 'none'
              });
            }
          });
          break;
        case 'consult':
          // 使用switchTab跳转到咨询页面，因为它是tabBar页面
          uni.switchTab({
            url: '/pages/consult/consult',
            fail: (err) => {
              console.error('跳转咨询页面失败:', err);
              uni.showToast({
                title: '跳转失败，请稍后再试',
                icon: 'none'
              });
            }
          });
          break;
        default:
          break;
      }
    },
    
    // 查看文章详情
    viewArticleDetail(articleId) {
      console.log('查看文章详情:', articleId);
      // 跳转到文章详情页，传递文章ID
      uni.navigateTo({
        url: `/pages/article/detail?id=${articleId}`,
        fail: (err) => {
          console.error('跳转文章详情页失败:', err);
          uni.showToast({
            title: '跳转失败，请稍后再试',
            icon: 'none'
          });
        }
      });
    },
    
    // 退出登录
    logout() {
      uni.showModal({
        title: '提示',
        content: '确定要退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            // 清除登录信息
            uni.removeStorageSync('token');
            uni.removeStorageSync('userInfo');
            
            // 跳转到登录页
            uni.reLaunch({
              url: '/pages/index/index'
            });
          }
        }
      });
    },
    
    // 返回主菜单
    backToMainMenu() {
      this.currentPage = 'home';
    },
    
    // 处理用户中心操作
    handleUserAction(action) {
      console.log('用户中心操作:', action);
      
      switch(action) {
        case 'appointment':
          // 跳转到预约记录
          uni.navigateTo({
            url: '/pages/user/appointment'
          });
          break;
        case 'consultation':
          // 跳转到问诊记录
          uni.navigateTo({
            url: '/pages/user/consultation'
          });
          break;
        case 'feedback':
          // 跳转到我的反馈
          uni.navigateTo({
            url: '/pages/user/feedback'
          });
          break;
        case 'password':
          // 跳转到修改密码
          uni.navigateTo({
            url: '/pages/user/password'
          });
          break;
        case 'edit':
          // 编辑个人信息
          uni.showToast({
            title: '编辑个人信息功能开发中',
            icon: 'none'
          });
          break;
        default:
          break;
      }
    }
  }
}
</script>

<style lang="scss">
.layout-container {
  width: 100%;
  height: 100vh;
  display: flex;
  overflow: hidden;
  background-color: #f5f7fa;
  
  .sidebar {
    width: 180rpx;
    height: 100%;
    background-color: #fff;
    box-shadow: 2rpx 0 10rpx rgba(0, 0, 0, 0.1);
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    z-index: 10;
    
    .menu-item {
      width: 100%;
      height: 100rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      color: #303133;
      font-size: 28rpx;
      padding: 0 10rpx;
      box-sizing: border-box;
      
      &::after {
        content: '';
        position: absolute;
        left: 0;
        bottom: 0;
        width: 100%;
        height: 1px;
        background-color: #f0f0f0;
        transform: scaleY(0.5);
      }
      
      &:active {
        background-color: var(--el-color-primary-light-9);
      }
    }
    
    .el-menu-item {
      color: #303133;
      transition: color 0.3s;
      
      &:hover {
        color: var(--el-color-primary);
      }
    }
    
    .logo-item {
      height: 120rpx;
      padding: 20rpx 0;
      
      .logo-image {
        width: 80rpx;
        height: 80rpx;
      }
    }
    
    .sub-menu-item {
      padding-left: 20rpx;
      font-size: 26rpx;
      color: #606266;
    }
    
    .logout-item {
      margin-top: 40rpx;
      color: #f56c6c;
      
      &:active {
        background-color: #fef0f0;
      }
    }
    
    .back-item {
      margin-top: 20rpx;
      color: var(--el-color-primary);
    }
  }
  
  .content-area {
    flex: 1;
    height: 100vh;
    box-sizing: border-box;
    
    .page-content {
      padding: 30rpx;
      
      // 轮播图样式
      .banner-swiper {
        width: 100%;
        height: 350rpx;
        border-radius: 20rpx;
        overflow: hidden;
        margin-bottom: 40rpx;
        box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
        
        .banner-image {
          width: 100%;
          height: 100%;
        }
      }
      
      .page-title {
        font-size: 40rpx;
        font-weight: bold;
        color: #303133;
        margin-bottom: 40rpx;
        position: relative;
        padding-left: 20rpx;
        
        &::before {
          content: '';
          position: absolute;
          left: 0;
          top: 10rpx;
          bottom: 10rpx;
          width: 8rpx;
          background-color: var(--el-color-primary);
          border-radius: 4rpx;
        }
      }
      
      .articles-container {
        height: auto;
        min-height: 600rpx;
        overflow: visible;
        padding-bottom: 80rpx;
        
        .article-card {
          margin-bottom: 30rpx;
          border-radius: 12rpx;
          overflow: hidden;
          display: flex;
          flex-direction: column;
          box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
          
          .article-image {
            width: 100%;
            height: 320rpx;
          }
          
          .article-content {
            padding: 30rpx;
            display: flex;
            flex-direction: column;
            
            .article-title {
              font-size: 32rpx;
              font-weight: bold;
              color: #303133;
              margin-bottom: 20rpx;
              line-height: 1.4;
            }
            
            .article-desc {
              font-size: 28rpx;
              color: #606266;
              line-height: 1.6;
              margin-bottom: 20rpx;
              overflow: hidden;
              text-overflow: ellipsis;
              display: -webkit-box;
              -webkit-line-clamp: 2;
              -webkit-box-orient: vertical;
            }
            
            .article-meta {
              display: flex;
              align-items: center;
              flex-wrap: wrap;
              
              .article-date {
                font-size: 24rpx;
                color: #909399;
                margin-right: 20rpx;
              }
              
              .el-tag {
                font-size: 22rpx;
                padding: 2rpx 12rpx;
                background-color: var(--el-color-primary-light-9);
                color: var(--el-color-primary);
                border-radius: 4rpx;
                margin-right: 10rpx;
                display: inline-block;
              }
            }
          }
        }
      }
      
      .user-info-card {
        padding: 40rpx;
        display: flex;
        border-radius: 12rpx;
        margin-bottom: 40rpx;
        
        .el-card__body {
          display: flex;
          align-items: center;
        }
        
        .user-card-avatar {
          width: 160rpx;
          height: 160rpx;
          border-radius: 80rpx;
          margin-right: 40rpx;
          border: 4rpx solid var(--el-color-primary-light-9);
        }
        
        .user-card-info {
          display: flex;
          flex-direction: column;
          
          .user-name {
            font-size: 36rpx;
            font-weight: bold;
            color: #303133;
            margin-bottom: 20rpx;
          }
          
          .user-account, .user-contact {
            font-size: 28rpx;
            color: #606266;
            margin-bottom: 10rpx;
          }
        }
      }
      
      .el-empty {
        width: 100%;
        height: 600rpx;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        
        .coming-soon {
          font-size: 32rpx;
          color: #909399;
        }
      }
    }
  }
}
</style> 
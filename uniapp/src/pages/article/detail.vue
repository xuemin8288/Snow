<template>
  <view class="article-detail-container">
    <view class="article-header">
      <view class="back-button" @click="goBack">
        <text class="back-icon">←</text>
        <!-- <text class="back-text">返回</text> -->
      </view>
      <text class="article-title">{{ article.title || '文章详情' }}</text>
    </view>
    
    <scroll-view scroll-y class="article-content">
      <view class="article-info">
        <image :src="article.coverImg || '../../static/default-image.png'" mode="aspectFill" class="article-image"></image>
        <view class="article-meta">
          <text class="article-date">发布日期: {{ article.time || '未知日期' }}</text>
          <text class="article-author">发布人: {{ article.doctorName || '未知作者' }}</text>
          <text class="article-views">浏览量: {{ article.num || 0 }}</text>
        </view>
      </view>
      
      <view class="article-body">
        <rich-text :nodes="article.content || '加载中...'"></rich-text>
      </view>
    </scroll-view>
  </view>
</template>

<script>
import request from '@/utils/request.js';

export default {
  data() {
    return {
      articleId: null,
      article: {
        title: '',
        coverImg: '',
        content: '',
        time: '',
        doctorName: '',
        num: 0
      }
    }
  },
  onLoad(options) {
    // 获取路由参数中的文章ID
    if (options && options.id) {
      this.articleId = options.id;
      this.loadArticleDetail();
    } else {
      uni.showToast({
        title: '缺少文章ID参数',
        icon: 'none'
      });
      setTimeout(() => {
        this.goBack();
      }, 1500);
    }
  },
  methods: {
    // 加载文章详情
    loadArticleDetail() {
      uni.showLoading({
        title: '加载中...'
      });
      
      // 调用后端API获取文章详情
      request.get('/propagate/selectById/' + this.articleId).then(res => {
        uni.hideLoading();
        
        if (res.code === 200 || res.code === '200') {
          // 处理内容中的&nbsp;
          if (res.data && res.data.content) {
            res.data.content = res.data.content.replace(/&nbsp/g, ' ');
          }
          
          this.article = res.data;
          
          // 增加浏览量
          if (this.article.num !== undefined) {
            this.article.num = this.article.num + 1;
            // 更新浏览量
            request.put('/propagate/update', this.article).then(updateRes => {
              console.log('浏览量已更新');
            }).catch(err => {
              console.error('更新浏览量失败:', err);
            });
          }
        } else {
          uni.showToast({
            title: res.msg || '获取文章详情失败',
            icon: 'none'
          });
          setTimeout(() => {
            this.goBack();
          }, 1500);
        }
      }).catch(err => {
        uni.hideLoading();
        console.error('获取文章详情失败:', err);
        uni.showToast({
          title: '获取文章详情失败',
          icon: 'none'
        });
        setTimeout(() => {
          this.goBack();
        }, 1500);
      });
    },
    
    // 返回上一页
    goBack() {
      uni.navigateBack();
    }
  }
}
</script>

<style lang="scss">
.article-detail-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(135deg, #64b3f4 0%, #c2e59c 100%);
  
  .article-header {
    height: 100rpx;
    display: flex;
    align-items: center;
    padding: 0 30rpx;
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(5px);
    position: relative;
    
    .back-button {
      position: absolute;
      left: 30rpx;
      display: flex;
      align-items: center;
      
      .back-icon {
        font-size: 36rpx;
        color: #fff;
        margin-right: 10rpx;
      }
      
      .back-text {
        font-size: 28rpx;
        color: #fff;
      }
    }
    
    .article-title {
      flex: 1;
      font-size: 34rpx;
      font-weight: bold;
      color: #fff;
      text-align: center;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin: 0 80rpx;
    }
  }
  
  .article-content {
    flex: 1;
    padding: 30rpx;
    
    .article-info {
      margin-bottom: 30rpx;
      
      .article-image {
        width: 100%;
        height: 350rpx;
        border-radius: 15rpx;
        margin-bottom: 20rpx;
      }
      
      .article-meta {
        display: flex;
        // flex-wrap: wrap;
        // justify-content: space-between;
        flex-direction: column;
        
        .article-date, .article-author, .article-views {
          font-size: 24rpx;
          color: rgba(255, 255, 255, 0.8);
          margin-bottom: 10rpx;
        }
      }
    }
    
    .article-body {
      background: rgba(255, 255, 255, 0.9);
      border-radius: 15rpx;
      padding: 30rpx;
      margin-bottom: 30rpx;
      
      :deep(h1) {
        font-size: 36rpx;
        font-weight: bold;
        margin-bottom: 30rpx;
        color: #333;
      }
      
      :deep(h2) {
        font-size: 32rpx;
        font-weight: bold;
        margin: 30rpx 0 20rpx;
        color: #333;
      }
      
      :deep(p) {
        margin-bottom: 20rpx;
        line-height: 1.8;
        color: #333;
      }
      
      :deep(img) {
        max-width: 100%;
        margin: 20rpx 0;
        border-radius: 10rpx;
      }
    }
  }
}
</style> 
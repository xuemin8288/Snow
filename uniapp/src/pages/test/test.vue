<template>
  <view class="test-container">
    
    <view class="test-list">
      <view class="test-item" v-for="(item, index) in testList" :key="index" @click="startTest(item)">
        <image :src="item.imageUrl || '../../static/test-default.png'" mode="aspectFill" class="test-img" @error="handleImageError(index)"></image>
        <view class="test-info">
          <view class="test-title">{{ item.title }}</view>
          <view class="test-desc">{{ item.description }}</view>
          <view class="test-meta">
            <text class="test-time">用时：{{ item.timeRequired || '10-15' }}分钟</text>
            <text class="test-count">{{ item.participantCount || 0 }}人已测</text>
          </view>
          <button class="test-btn">开始测评</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import request from '../../utils/request.js';
import apiConfig from '../../config/api.js';

export default {
  data() {
    return {
      testList: []
    }
  },
  onLoad() {
    this.getTestList();
  },
  methods: {
    // 返回到layout页面
    goToLayout() {
      uni.switchTab({
        url: '/pages/layout/layout',
        fail: (err) => {
          console.error('跳转布局页面失败:', err);
          uni.showToast({
            title: '跳转失败，请稍后再试',
            icon: 'none'
          });
        }
      });
    },
    
    // 获取测评列表
    getTestList() {
      // 检查是否存在token，如果没有直接使用默认数据
      const token = uni.getStorageSync('token');
      if (!token) {
        console.log('未找到token，使用默认数据');
        this.loadDefaultData();
        return;
      }
      
      uni.showLoading({ title: '加载中...' });
      
      // 测试服务器API是否可用
      request.get(apiConfig.assessment.getTestPaperList)
        .then(res => {
          uni.hideLoading();
          if ((res.code === 200 || res.code === "200") && res.data && res.data.length > 0) {
            // 映射后端数据字段到前端所需字段
            this.testList = res.data.map(item => {
              return {
                id: item.id,
                title: item.title || '未命名测评',
                description: item.content || '暂无描述',
                imageUrl: item.img || '../../static/test-default.png',
                timeRequired: item.time || '10',
                participantCount: item.testNum || Math.floor(Math.random() * 2000 + 1000)
              };
            });
            console.log('成功加载测评列表:', this.testList);
          } else {
            console.log('API响应成功但没有数据，使用默认数据');
            this.loadDefaultData();
          }
        })
        .catch(err => {
          uni.hideLoading();
          console.error('加载测评列表失败:', err);
          // 如果是401错误，提示用户登录
          if (err && err.code === 401) {
            console.log('登录已过期，将使用默认数据');
          }
          this.loadDefaultData();
        });
    },
    
    // 加载默认数据
    loadDefaultData() {
      this.testList = [
        {
          id: 7,
          title: '测试题_肝阳上亢',
          description: '此类高血压通常伴随头痛、眩晕、面红目赤、易怒等症状。患者常感到脾气急躁、焦虑，且有耳鸣、睡眠不安等表现。通过评估这些症状的严重程度，可以帮助判断肝阳上亢的高血压风险。',
          imageUrl: 'http://localhost:9090/files/download/1739675516210-OIP-C.jpg',
          timeRequired: '10',
          participantCount: 1865
        },
        {
          id: 8,
          title: '测试题_肝肾阴虚',
          description: '肝肾阴虚型高血压表现为乏力、腰膝酸软、耳鸣、失眠等症状。此类患者常感到体力不支、精神萎靡，且容易出现水肿、记忆力减退等问题。通过评估这些症状来判断肝肾两虚的可能性。',
          imageUrl: 'http://localhost:9090/files/download/1739692746496-R.jpg',
          timeRequired: '10',
          participantCount: 1657
        },
        {
          id: 9,
          title: '测试题_阴阳两虚',
          description: '该类型的高血压通常表现为手脚冰凉、疲劳、浮肿、气短等症状。患者常感到体力和精神双重疲惫，且容易感到寒冷、失眠等。此问卷帮助评估阴阳两虚的体质及其与高血压的关系。',
          imageUrl: 'http://localhost:9090/files/download/1739692948443-OIP.jpg',
          timeRequired: '10',
          participantCount: 1432
        },
        {
          id: 10,
          title: '测试题_痰瘀内蕴',
          description: '痰瘀内蕴型高血压多见于身体沉重、胸闷、头晕、水肿等症状。患者可能有消化不良、体重增加等问题，且常伴有胸口压迫感。此问卷帮助评估痰湿、血瘀的可能性以及它们对高血压的影响。',
          imageUrl: 'http://localhost:9090/files/download/1739693108813-v2-3901f48267a748ec3e7e7bb9d618fcd1_b.jpg',
          timeRequired: '10',
          participantCount: 1298
        },
        {
          id: 11,
          title: '测试题_瘀血内停',
          description: '瘀血内停型高血压表现为头痛、胸闷、下肢浮肿、面色暗沉等症状。患者常感到疲劳、便秘、手脚麻木，舌质可能出现暗红或紫点。通过评估这些症状，可以帮助识别瘀血内停型高血压的风险。',
          imageUrl: 'http://localhost:9090/files/download/1739693263984-OIP (1).jpg',
          timeRequired: '10',
          participantCount: 1175
        }
      ];
    },
    
    // 开始测评
    startTest(item) {
      uni.navigateTo({
        url: `/pages/test/detail?id=${item.id}`
      });
    },
    
    // 处理图片加载错误
    handleImageError(index) {
      console.error(`图片加载失败，索引：${index}`);
      // 将加载失败的图片替换为默认图片
      if (this.testList[index]) {
        this.testList[index].imageUrl = '/static/test-default.png';
      }
    }
  }
}
</script>

<style lang="scss">
.test-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-top: 88rpx; // 为导航栏留出空间
  
  // 顶部导航栏
  .nav-bar {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 88rpx;
    background-color: #64b3f4;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 999;
    
    .nav-back {
      position: absolute;
      left: 30rpx;
      width: 60rpx;
      height: 60rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      
      .nav-back-arrow {
        color: #FFFFFF;
        font-size: 36rpx;
        font-weight: bold;
      }
    }
    
    .nav-title {
      color: #FFFFFF;
      font-size: 34rpx;
      font-weight: 500;
    }
  }
  
  .test-list {
    padding: 20rpx;
    
    .test-item {
      background-color: #ffffff;
      border-radius: 12rpx;
      box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
      margin-bottom: 30rpx;
      overflow: hidden;
      
      .test-img {
        width: 100%;
        height: 300rpx;
      }
      
      .test-info {
        padding: 20rpx;
        
        .test-title {
          font-size: 32rpx;
          font-weight: bold;
          color: #333;
          margin-bottom: 10rpx;
        }
        
        .test-desc {
          font-size: 28rpx;
          color: #666;
          line-height: 1.4;
          margin-bottom: 20rpx;
          display: -webkit-box;
          -webkit-box-orient: vertical;
          -webkit-line-clamp: 2;
          line-clamp: 2;
          overflow: hidden;
        }
        
        .test-meta {
          display: flex;
          justify-content: space-between;
          margin-bottom: 20rpx;
          
          .test-time, .test-count {
            font-size: 24rpx;
            color: #999;
          }
        }
        
        .test-btn {
          background: linear-gradient(to right, #4facfe 0%, #00f2fe 100%);
          color: #ffffff;
          border-radius: 40rpx;
          font-size: 28rpx;
          height: 70rpx;
          line-height: 70rpx;
          margin-top: 10rpx;
          padding: 0 30rpx;
          display: flex;
          align-items: center;
          justify-content: center;
          width: 40%;
          border: none;
          
          &:active {
            opacity: 0.9;
          }
        }
      }
    }
  }
}
</style> 
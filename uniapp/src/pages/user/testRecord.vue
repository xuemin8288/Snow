<template>
  <view class="test-record-container">
    <!-- <view class="page-title">测试记录</view> -->
    
    <view class="search-bar">
      <input type="text" v-model="searchForm.testPaperName" placeholder="请输入试卷名称查询" class="search-input" />
      <button class="search-btn" @click="loadData">查询</button>
      <button class="reset-btn" @click="resetSearch">重置</button>
    </view>
    
    <view class="record-list">
      <view v-if="tableData.length === 0" class="empty-data">
        <text>暂无测试记录</text>
      </view>
      
      <view v-else class="record-table">
        <view class="table-header">
          <text class="header-cell name-column">试卷名称</text>
          <text class="header-cell">分数</text>
          <text class="header-cell">测试结果</text>
          <text class="header-cell">测试时间</text>
          <text class="header-cell action-column">操作</text>
        </view>
        
        <view v-for="(item, index) in tableData" :key="index" class="table-row">
          <view class="table-cell name-column" @click="goToDetail(item.testPaperId)">
            <text class="test-name">{{ item.testPaperName }}</text>
          </view>
          <view class="table-cell">{{ item.score }}</view>
          <view class="table-cell">{{ item.result }}</view>
          <view class="table-cell">{{ item.time }}</view>
          <view class="table-cell action-column">
            <view class="delete-btn" @click="deleteRecord(item.id)">删除</view>
          </view>
        </view>
      </view>
    </view>
    
    <view class="pagination" v-if="total > 0">
      <view class="page-info">
        <text>共 {{ total }} 条</text>
      </view>
      <view class="page-controls">
        <view class="prev-page" :class="{ disabled: pageNum <= 1 }" @click="prevPage">上一页</view>
        <view class="current-page">{{ pageNum }}</view>
        <view class="next-page" :class="{ disabled: pageNum >= totalPages }" @click="nextPage">下一页</view>
      </view>
    </view>
  </view>
</template>

<script>
import request from '@/utils/request.js';

export default {
  data() {
    return {
      searchForm: {
        testPaperName: ''
      },
      pageNum: 1,
      pageSize: 5,
      total: 0,
      tableData: [],
      userId: null
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.total / this.pageSize);
    }
  },
  onLoad() {
    this.getUserId();
    this.loadData();
  },
  methods: {
    // 获取用户ID
    getUserId() {
      const userInfoStr = uni.getStorageSync('userInfo');
      if (userInfoStr) {
        try {
          const userInfo = JSON.parse(userInfoStr);
          this.userId = userInfo.id;
        } catch (e) {
          console.error('解析用户信息失败:', e);
        }
      }
    },
    
    // 加载测试记录数据
    loadData() {
      uni.showLoading({
        title: '加载中...'
      });
      
      request.get('/testRecord/selectPage', {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        testPaperName: this.searchForm.testPaperName,
        userId: this.userId // 只查询当前用户的测试记录
      }).then(res => {
        uni.hideLoading();
        
        if (res.code === 200 || res.code === '200') {
          this.tableData = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          uni.showToast({
            title: res.msg || '获取测试记录失败',
            icon: 'none'
          });
        }
      }).catch(err => {
        uni.hideLoading();
        console.error('获取测试记录失败:', err);
        uni.showToast({
          title: '获取测试记录失败',
          icon: 'none'
        });
      });
    },
    
    // 跳转到测试详情页
    goToDetail(testPaperId) {
      if (!testPaperId) return;
      
      uni.navigateTo({
        url: `/pages/test/detail?id=${testPaperId}`,
        fail: (err) => {
          console.error('跳转到测试详情页失败:', err);
          uni.showToast({
            title: '跳转失败，请稍后再试',
            icon: 'none'
          });
        }
      });
    },
    
    // 删除测试记录
    deleteRecord(id) {
      if (!id) return;
      
      uni.showModal({
        title: '提示',
        content: '删除后数据无法恢复，您确定删除吗？',
        success: (res) => {
          if (res.confirm) {
            uni.showLoading({
              title: '删除中...'
            });
            
            request.delete(`/testRecord/delete/${id}`).then(res => {
              uni.hideLoading();
              
              if (res.code === 200 || res.code === '200') {
                uni.showToast({
                  title: '删除成功',
                  icon: 'success'
                });
                this.loadData(); // 重新加载数据
              } else {
                uni.showToast({
                  title: res.msg || '删除失败',
                  icon: 'none'
                });
              }
            }).catch(err => {
              uni.hideLoading();
              console.error('删除测试记录失败:', err);
              uni.showToast({
                title: '删除失败，请稍后再试',
                icon: 'none'
              });
            });
          }
        }
      });
    },
    
    // 重置搜索条件
    resetSearch() {
      this.searchForm.testPaperName = '';
      this.pageNum = 1;
      this.loadData();
    },
    
    // 上一页
    prevPage() {
      if (this.pageNum > 1) {
        this.pageNum--;
        this.loadData();
      }
    },
    
    // 下一页
    nextPage() {
      if (this.pageNum < this.totalPages) {
        this.pageNum++;
        this.loadData();
      }
    }
  }
}
</script>

<style lang="scss">
.test-record-container {
  padding: 20px;
  
  .page-title {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 20px;
  }
  
  .search-bar {
    display: flex;
    margin-bottom: 20px;
    
    .search-input {
      flex: 1;
      height: 40px;
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 0 10px;
    }
    
    .search-btn, .reset-btn {
      width: 80px;
      height: 40px;
      margin-left: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 4px;
    }
    
    .search-btn {
      background-color: #3498db;
      color: #fff;
    }
    
    .reset-btn {
      background-color: #f39c12;
      color: #fff;
    }
  }
  
  .record-list {
    background-color: #fff;
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 20px;
    
    .empty-data {
      padding: 30px;
      text-align: center;
      color: #999;
    }
    
    .record-table {
      width: 100%;
      
      .table-header {
        display: flex;
        background-color: #f5f5f5;
        padding: 15px 10px;
        font-weight: bold;
      }
      
      .table-row {
        display: flex;
        border-bottom: 1px solid #eee;
        padding: 15px 10px;
        
        &:last-child {
          border-bottom: none;
        }
      }
      
      .header-cell, .table-cell {
        flex: 1;
        text-align: center;
      }
      
      .name-column {
        flex: 2;
        text-align: left;
      }
      
      .action-column {
        flex: 0.8;
      }
      
      .test-name {
        color: #3498db;
        text-decoration: underline;
      }
      
      .delete-btn {
        display: inline-block;
        padding: 5px 10px;
        background-color: #e74c3c;
        color: #fff;
        border-radius: 4px;
        font-size: 14px;
      }
    }
  }
  
  .pagination {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .page-info {
      color: #666;
    }
    
    .page-controls {
      display: flex;
      align-items: center;
      
      .prev-page, .next-page, .current-page {
        padding: 5px 10px;
        margin: 0 5px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      
      .current-page {
        background-color: #3498db;
        color: #fff;
        border-color: #3498db;
      }
      
      .disabled {
        color: #ccc;
        pointer-events: none;
      }
    }
  }
}
</style> 
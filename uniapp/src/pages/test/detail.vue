<template>
  <view class="test-detail-container">
    <view class="test-header">
      <text class="test-title">{{ testData.title || '问诊单' }}</text>
      <text class="test-score">满分：{{ testData.score || 100 }}分</text>
    </view>
    
    <view class="question-list">
      <view 
        v-for="(question, index) in testData.topicList" 
        :key="index" 
        class="question-item"
      >
        <view class="question-title">{{ index + 1 }}、{{ question.title }}</view>
        <view class="options">
          <radio-group @change="(e) => handleAnswer(index, e.detail.value)">
            <label class="option-item" v-if="question.aName">
              <radio :value="question.aName" :checked="question.userAnswer === question.aName" />
              <text class="option-text">A. {{ question.aName }}</text>
            </label>
            <label class="option-item" v-if="question.bName">
              <radio :value="question.bName" :checked="question.userAnswer === question.bName" />
              <text class="option-text">B. {{ question.bName }}</text>
            </label>
            <label class="option-item" v-if="question.cName">
              <radio :value="question.cName" :checked="question.userAnswer === question.cName" />
              <text class="option-text">C. {{ question.cName }}</text>
            </label>
            <label class="option-item" v-if="question.dName">
              <radio :value="question.dName" :checked="question.userAnswer === question.dName" />
              <text class="option-text">D. {{ question.dName }}</text>
            </label>
          </radio-group>
        </view>
      </view>
    </view>
    
    <view class="test-footer">
      <button class="submit-btn" @click="submitTest">提交测试</button>
    </view>
  </view>
</template>

<script>
import request from '../../utils/request.js';
import apiConfig from '../../config/api.js';

export default {
  data() {
    return {
      testData: {
        id: 0,
        title: '',
        img: '',
        content: '',
        typeId: 0,
        doctorId: 0,
        num: 0,
        score: 100,
        testNum: 0,
        time: '',
        aRange: '',
        bRange: '',
        cRange: '',
        aAnswer: '',
        bAnswer: '',
        cAnswer: '',
        status: 'NORMAL',
        typeName: '',
        doctorName: '',
        doctorAvatar: '',
        topicList: []
      },
      answers: [],
      loading: false
    }
  },
  onLoad(options) {
    if (options.id) {
      this.loadTestDetail(options.id)
    }
  },
  methods: {
    loadTestDetail(id) {
      this.loading = true
      request.get('/testPaper/selectById/' + id).then(res => {
        console.log('获取测评详情响应:', res)
        if (res.code === '200' && res.data) {
          this.testData = res.data
          // 初始化答案数组
          if (this.testData.topicList) {
            this.answers = new Array(this.testData.topicList.length).fill('')
          }
        } else {
          uni.showToast({
            title: res.msg || '获取测评详情失败',
            icon: 'none'
          })
        }
      }).catch(err => {
        console.error('获取测评详情错误:', err)
        uni.showToast({
          title: '获取测评详情失败',
          icon: 'none'
        })
      }).finally(() => {
        this.loading = false
      })
    },

    handleAnswer(index, answer) {
      if (this.testData.topicList[index]) {
        this.testData.topicList[index].userAnswer = answer
      }
    },

    submitTest() {
      // 检查是否所有问题都已回答
      const unansweredQuestions = this.testData.topicList.filter(q => !q.userAnswer);
      
      if (unansweredQuestions.length > 0) {
        uni.showModal({
          title: '提示',
          content: `您还有 ${unansweredQuestions.length} 个问题未回答，确定要提交吗？`,
          success: (res) => {
            if (res.confirm) {
              this.calculateAndSubmit();
            }
          }
        });
      } else {
        this.calculateAndSubmit();
      }
    },

    calculateAndSubmit() {
      // 计算总分
      let totalScore = 0
      const answers = []
      this.testData.topicList.forEach(topic => {
        // 根据用户选择的答案确定分数
        let answerScore = 0
        if (topic.userAnswer === topic.aName) {
          answerScore = topic.aScore
        } else if (topic.userAnswer === topic.bName) {
          answerScore = topic.bScore
        } else if (topic.userAnswer === topic.cName) {
          answerScore = topic.cScore
        } else if (topic.userAnswer === topic.dName) {
          answerScore = topic.dScore
        }
        
        // 累加总分
        totalScore += answerScore
        answers.push(topic.userAnswer)
      })

      console.log('测评总分计算结果:', totalScore)

      // 提交数据
      const submitData = {
        ...this.testData,
        userScore: totalScore,
        answers: answers.join(','),
        userResult: this.getResultByScore(totalScore)
      }

      // 提交测评
      request.post('/testRecord/add', submitData).then(res => {
        console.log('后端返回完整响应:', res)
        if (res.code === '200' || res.code === 200) {
          console.log('测评提交成功:', res.data)
          uni.showToast({
            title: '提交成功',
            icon: 'success'
          })
          // 跳转到结果页
          setTimeout(() => {
            uni.navigateTo({
              url: `/pages/test/result?id=${this.testData.id}&score=${totalScore}&result=${submitData.userResult}&aRange=${encodeURIComponent(this.testData.aRange)}&bRange=${encodeURIComponent(this.testData.bRange)}&cRange=${encodeURIComponent(this.testData.cRange)}&aAnswer=${encodeURIComponent(this.testData.aAnswer)}&bAnswer=${encodeURIComponent(this.testData.bAnswer)}&cAnswer=${encodeURIComponent(this.testData.cAnswer)}`
            })
          }, 1500)
        } else {
          uni.showToast({
            title: res.msg || '提交失败',
            icon: 'none'
          })
        }
      }).catch(err => {
        console.error('提交测评错误:', err)
        uni.showToast({
          title: '提交失败',
          icon: 'none'
        })
      })
    },

    getResultByScore(score) {
      const aRange = this.parseRange(this.testData.aRange)
      const bRange = this.parseRange(this.testData.bRange)
      const cRange = this.parseRange(this.testData.cRange)

      if (score >= aRange[0] && score <= aRange[1]) {
        return this.testData.aAnswer
      } else if (score >= bRange[0] && score <= bRange[1]) {
        return this.testData.bAnswer
      } else if (score >= cRange[0] && score <= cRange[1]) {
        return this.testData.cAnswer
      }
      return '未知'
    },

    parseRange(rangeStr) {
      if (!rangeStr) return [0, 0]
      const parts = rangeStr.split('~')
      return [parseInt(parts[0]), parseInt(parts[1])]
    }
  }
}
</script>

<style lang="scss">
.test-detail-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 20rpx;
  
  .test-header {
    background-color: #ffffff;
    padding: 30rpx;
    border-radius: 12rpx;
    box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
    text-align: center;
    margin-bottom: 30rpx;
    
    .test-title {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      display: block;
      margin-bottom: 10rpx;
    }
    
    .test-score {
      font-size: 28rpx;
      color: #666;
    }
  }
  
  .question-list {
    .question-item {
      background-color: #ffffff;
      padding: 30rpx;
      border-radius: 12rpx;
      box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
      margin-bottom: 20rpx;
      
      .question-title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
        line-height: 1.4;
        margin-bottom: 20rpx;
        background-color: #f8f8f8;
        padding: 15rpx;
        border-radius: 8rpx;
      }
      
      .options {
        .option-item {
          display: flex;
          align-items: center;
          padding: 20rpx 0;
          border-bottom: 1px solid #f0f0f0;
          
          &:last-child {
            border-bottom: none;
          }
          
          .option-text {
            margin-left: 10rpx;
            font-size: 30rpx;
            color: #333;
          }
        }
      }
    }
  }
  
  .test-footer {
    padding: 40rpx 0;
    display: flex;
    justify-content: center;
    
    .submit-btn {
      background: linear-gradient(to right, #4facfe 0%, #00f2fe 100%);
      color: #ffffff;
      border-radius: 40rpx;
      font-size: 32rpx;
      height: 80rpx;
      line-height: 80rpx;
      padding: 0 80rpx;
      border: none;
      
      &:active {
        opacity: 0.9;
      }
    }
  }
}
</style> 
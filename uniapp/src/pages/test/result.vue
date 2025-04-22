<template>
  <view class="result-container">
    <view class="result-card">
      <view class="result-header">
        <text class="result-title">{{ testData.title }}</text>
        <view class="score-circle">
          <text class="score-text">{{ score }}</text>
          <text class="score-label">分</text>
        </view>
      </view>
      
      <view class="result-content">
        <view class="result-level">
          <text class="level-label">测评结果：</text>
          <text class="level-value" :class="levelClass">{{ resultLevel }}</text>
        </view>
        
        <view class="result-analysis">
          <view class="analysis-title">结果分析</view>
          <view class="analysis-content">{{ analysis }}</view>
        </view>
        
        <view class="result-suggestion">
          <view class="suggestion-title">专业建议</view>
          <view class="suggestion-content">{{ suggestion }}</view>
        </view>
      </view>
    </view>
    
    <view class="action-buttons">
      <!-- <button class="action-btn share-btn" @click="shareResult">分享结果</button> -->
      <button class="action-btn consult-btn" @click="consultDoctor">咨询医生</button>
      <button class="action-btn home-btn" @click="goBack">返回测评</button>
    </view>
  </view>
</template>

<script>
import request from '../../utils/request.js';
import apiConfig from '../../config/api.js';

export default {
  data() {
    return {
      testId: null,
      score: 0,
      testData: {
        title: '中医体质测评结果',
        type: ''
      },
      _resultLevel: null  // 存储预设的结果级别
    }
  },
  computed: {
    // 根据分数计算结果等级
    resultLevel() {
      // 如果有预设结果，直接返回
      if (this._resultLevel) {
        return this._resultLevel;
      }
      
      if (!this.testData.type) return '未知';
      
      // 对中医体质测评使用特定的评分标准
      if (this.testData.type === 'ChineseMedicine') {
        // 解析范围字符串，例如 "0~40" => [0, 40]
        const parseRange = (rangeStr) => {
          if (!rangeStr) return [0, 0];
          const parts = rangeStr.split('~');
          return [parseInt(parts[0]), parseInt(parts[1])];
        };
        
        console.log('测评结果范围Debug信息:');
        console.log('原始数据:', {
          aRange: this.testData.aRange,
          bRange: this.testData.bRange, 
          cRange: this.testData.cRange,
          score: this.score,
          testData: this.testData
        });
        
        const aRange = parseRange(this.testData.aRange);
        const bRange = parseRange(this.testData.bRange);
        const cRange = parseRange(this.testData.cRange);
        
        console.log('解析后范围:', {
          aRange,
          bRange,
          cRange,
          score: this.score
        });
        
        if (this.score >= aRange[0] && this.score <= aRange[1]) {
          return this.testData.aAnswer || '较低风险';
        } else if (this.score >= bRange[0] && this.score <= bRange[1]) {
          return this.testData.bAnswer || '中等风险';
        } else if (this.score >= cRange[0] && this.score <= cRange[1]) {
          return this.testData.cAnswer || '较高风险';
        } else {
          return '未知风险';
        }
      }
      
      // 如果没有匹配，返回默认值
      return '未知风险';
    },
    
    // 结果级别对应的样式类
    levelClass() {
      if (this.testData.type === 'ChineseMedicine') {
        const level = this.resultLevel;
        if (level.includes('很小') || level.includes('很低')) {
          return 'level-normal';
        } else if (level.includes('中等')) {
          return 'level-mild';
        } else {
          return 'level-severe';
        }
      }
      
      const level = this.resultLevel;
      if (level.includes('正常') || level.includes('良好') || level.includes('较小')) {
        return 'level-normal';
      } else if (level.includes('轻度') || level.includes('一般') || level.includes('中等')) {
        return 'level-mild';
      } else if (level.includes('中度') || level.includes('较差')) {
        return 'level-moderate';
      } else {
        return 'level-severe';
      }
    },
    
    // 根据测评类型和结果提供分析
    analysis() {
      if (!this.testData.type) return '暂无分析数据';
      
      // 对中医体质测评使用特定的分析内容
      if (this.testData.type === 'ChineseMedicine') {
        return this.testData.analysis || '根据您的测试结果，建议您关注自身的中医体质特点，保持健康的生活方式。';
      }
      
      const level = this.resultLevel;
      switch(this.testData.type) {
        case 'SAS': // 焦虑自测量表
          if (level.includes('正常')) {
            return '您的焦虑水平处于正常范围，心理状态良好，能够有效应对日常压力。';
          } else if (level.includes('轻度')) {
            return '您出现了轻度焦虑症状，可能会偶尔感到紧张和担忧，但这些症状通常不会显著影响日常生活。';
          } else if (level.includes('中度')) {
            return '您的焦虑症状达到中度水平，这可能会对您的情绪、思维和日常功能产生明显影响，建议寻求专业帮助。';
          } else {
            return '您的焦虑症状已达到严重程度，可能会经常感到恐惧、担忧，并伴有明显的身体症状，强烈建议尽快咨询专业医生。';
          }
          
        case 'SDS': // 抑郁自测量表
          if (level.includes('正常')) {
            return '您的抑郁指数在正常范围内，心理状态健康，能够保持积极的情绪和正常的社会功能。';
          } else if (level.includes('轻度')) {
            return '您表现出轻度抑郁症状，可能会偶尔感到情绪低落，但不会严重影响生活和工作。';
          } else if (level.includes('中度')) {
            return '您的抑郁症状达到中度水平，可能会经常感到悲伤、失落，兴趣减低，精力下降，建议寻求专业心理咨询。';
          } else {
            return '您的抑郁症状已达到严重程度，可能会持续感到绝望、无助，并可能伴有自伤想法，强烈建议立即就医。';
          }
          
        case 'PSQI': // 睡眠质量指数
          if (level.includes('良好')) {
            return '您的睡眠质量良好，能够获得充分的休息，有助于保持良好的身心健康。';
          } else if (level.includes('一般')) {
            return '您的睡眠质量一般，可能偶尔会有入睡困难或睡眠中断的情况，但不会严重影响日常生活。';
          } else if (level.includes('较差')) {
            return '您的睡眠质量较差，经常出现入睡困难、早醒或睡眠不深的问题，这可能会影响您的情绪和日间功能。';
          } else {
            return '您可能存在睡眠障碍，长期睡眠问题会对身心健康产生严重影响，建议咨询专业医生。';
          }
          
        case 'PSS': // 压力知觉量表
          if (level.includes('较小')) {
            return '您的压力水平较低，能够有效应对生活中的挑战，维持良好的心理平衡。';
          } else if (level.includes('中等')) {
            return '您的压力处于中等水平，这是常见的状态，适度的压力可以提高效率，但需要注意自我调节。';
          } else {
            return '您的压力水平较高，长期处于高压状态可能会影响身心健康，建议学习压力管理技巧并适当寻求帮助。';
          }
          
        default:
          return '根据您的测评结果，建议您关注自己的心理健康状况，保持良好的生活习惯和积极的心态。';
      }
    },
    
    // 根据测评结果提供建议
    suggestion() {
      if (!this.testData.type) return '建议您保持良好的生活习惯，定期关注自己的体质健康状况。';
      
      if (this.testData.type === 'ChineseMedicine') {
        const level = this.resultLevel;
        if (level.includes('很小') || level.includes('很低')) {
          return '您的体质状况较好，建议保持健康的生活习惯，合理膳食，适当运动，保持良好的作息规律。定期进行体质检测，预防疾病发生。';
        } else if (level.includes('中等')) {
          return '您存在一定的体质异常倾向，建议调整生活方式，注意饮食平衡，增加适合的运动，保证充足睡眠。可考虑咨询中医专家，获取个性化的调理建议。';
        } else {
          return '您的体质状况需要引起重视，建议尽快咨询中医专家，接受专业指导。同时，调整日常生活习惯，避免加重症状的因素，遵循医嘱进行适当的中药调理或其他治疗。';
        }
      }
      
      // 保留原有心理测评的建议
      const level = this.resultLevel;
      if (level.includes('正常') || level.includes('良好') || level.includes('较小')) {
        return '建议您继续保持当前的良好状态，定期进行自我评估，培养健康的生活方式和积极的心态。适当的运动、充足的睡眠和良好的社交关系都有助于维持心理健康。';
      } else if (level.includes('轻度') || level.includes('一般') || level.includes('中等')) {
        return '建议您关注自己的心理状态变化，学习简单的自我调适技巧，如深呼吸、放松训练、正念冥想等。保持规律的生活作息，增加体育锻炼，适当寻求亲友的支持和理解。如症状持续或加重，可考虑寻求专业心理咨询。';
      } else {
        return '强烈建议您寻求专业的心理咨询或医疗帮助。通过我们平台可预约专业心理医生进行在线咨询。同时，建立健康的生活习惯，避免过度焦虑和压力，寻求家人和朋友的支持。请记住，及时寻求帮助是勇敢和负责任的表现。';
      }
    }
  },
  onLoad(options) {
    // 获取测试ID和分数
    if (options.id) {
      this.testId = options.id;
    }
    
    if (options.score) {
      this.score = parseInt(options.score) || 0;
    }
    
    // 从URL参数中获取测评范围和答案数据
    const {aRange, bRange, cRange, aAnswer, bAnswer, cAnswer, result} = options;
    
    // 如果URL中有这些参数，直接使用这些值
    if (aRange && bRange && cRange) {
      this.testData = {
        ...this.testData,
        type: 'ChineseMedicine',
        aRange: decodeURIComponent(aRange),
        bRange: decodeURIComponent(bRange),
        cRange: decodeURIComponent(cRange),
        aAnswer: decodeURIComponent(aAnswer || '较低风险'),
        bAnswer: decodeURIComponent(bAnswer || '中等风险'),
        cAnswer: decodeURIComponent(cAnswer || '较高风险')
      };
      
      console.log('从URL参数加载测评数据:', this.testData);
      
      // 如果URL中提供了结果，直接使用
      if (result) {
        this._resultLevel = decodeURIComponent(result);
      }
    } else {
      // 否则从API加载数据
      this.loadResultData();
    }
  },
  methods: {
    // 加载结果数据
    loadResultData() {
      // 检查是否存在token，如果没有直接使用模拟数据
      const token = uni.getStorageSync('token');
      if (!token) {
        console.log('未找到token，使用模拟数据');
        this.loadMockData();
        return;
      }
      
      uni.showLoading({
        title: '加载中...'
      });
      
      // 尝试从API获取测评结果
      const userId = this.getUserId();
      request.get(apiConfig.assessment.getRecordById + '/' + this.testId)
        .then(res => {
          uni.hideLoading();
          if ((res.code === 200 || res.code === "200") && res.data) {
            console.log('成功获取测评结果:', res.data);
            // 需要将后端返回的数据格式转换为前端使用的格式
            const backendData = res.data;
            
            // 获取完整的测评信息，包括范围和答案描述
            request.get('/testPaper/selectById/' + this.testId)
              .then(paperRes => {
                if ((paperRes.code === 200 || paperRes.code === "200") && paperRes.data) {
                  console.log('成功获取测评详情:', paperRes.data);
                  const paperData = paperRes.data;
                  
                  // 使用测评详情中的范围和答案数据
                  this.testData = {
                    title: backendData.typeName || backendData.title || paperData.title || '心理测评结果',
                    type: 'ChineseMedicine',
                    aRange: paperData.aRange,
                    bRange: paperData.bRange,
                    cRange: paperData.cRange,
                    aAnswer: paperData.aAnswer,
                    bAnswer: paperData.bAnswer,
                    cAnswer: paperData.cAnswer,
                    analysis: paperData.content || ''
                  };
                  
                  // 确保有score
                  if (!this.score && backendData.score) {
                    this.score = parseInt(backendData.score);
                  }
                  
                  console.log('完整测评数据:', this.testData);
                } else {
                  console.log('获取测评详情失败，使用简化数据');
                  this.testData = {
                    title: backendData.typeName || backendData.title || '心理测评结果',
                    type: 'ChineseMedicine'
                  };
                  
                  if (!this.score && backendData.score) {
                    this.score = parseInt(backendData.score);
                  }
                  
                  // 如果无法获取范围数据，使用模拟数据
                  this.loadMockData();
                }
              })
              .catch(paperErr => {
                console.error('获取测评详情失败:', paperErr);
                this.testData = {
                  title: backendData.typeName || backendData.title || '心理测评结果',
                  type: 'ChineseMedicine'
                };
                
                if (!this.score && backendData.score) {
                  this.score = parseInt(backendData.score);
                }
                
                // 如果无法获取范围数据，使用模拟数据
                this.loadMockData();
              });
          } else {
            console.log('API响应但未返回有效数据，使用模拟数据');
            this.loadMockData();
          }
        })
        .catch(err => {
          uni.hideLoading();
          console.error('获取测评结果失败:', err);
          // 如果是401错误，提示用户
          if (err && err.code === 401) {
            console.log('登录已过期，将使用模拟数据');
          }
          this.loadMockData();
        });
    },
    
    // 根据测评标题推断类型
    inferTypeFromTitle(title) {
      if (!title) return 'ChineseMedicine';
      
      title = title.toLowerCase();
      if (title.includes('焦虑') || title.includes('sas')) return 'SAS';
      if (title.includes('抑郁') || title.includes('sds')) return 'SDS';
      if (title.includes('睡眠') || title.includes('psqi')) return 'PSQI';
      if (title.includes('压力') || title.includes('pss')) return 'PSS';
      
      // 默认为中医体质测评
      return 'ChineseMedicine';
    },
    
    // 加载模拟数据
    loadMockData() {
      // 根据测试ID设置不同的测试类型和结果范围
      const mockTests = {
        7: {
          title: '测试题_肝阳上亢',
          type: 'ChineseMedicine',
          aRange: '0~40',
          bRange: '41~70',
          cRange: '71~100',
          aAnswer: '很少有肝阳上亢型高血压的风险',
          bAnswer: '中等风险患肝阳上亢型高血压的风险',
          cAnswer: '可能存在肝阳上亢型高血压的风险',
          analysis: '肝阳上亢型高血压通常伴随头痛、眩晕、面红目赤、易怒等症状。患者常感到脾气急躁、焦虑，且有耳鸣、睡眠不安等表现。'
        },
        8: {
          title: '测试题_肝肾阴虚',
          type: 'ChineseMedicine',
          aRange: '0~40',
          bRange: '41~70',
          cRange: '71~100',
          aAnswer: '你有很小概率为肝肾阴虚型高血压',
          bAnswer: '你有中等概率为肝肾阴虚型高血压',
          cAnswer: '可能存在肝肾阴虚型高血压的风险',
          analysis: '肝肾阴虚型高血压表现为乏力、腰膝酸软、耳鸣、失眠等症状。此类患者常感到体力不支、精神萎靡，且容易出现水肿、记忆力减退等问题。'
        },
        9: {
          title: '测试题_阴阳两虚',
          type: 'ChineseMedicine',
          aRange: '0~40',
          bRange: '41~70',
          cRange: '71~100',
          aAnswer: '您有很小概率为阴阳两虚型高血压',
          bAnswer: '您有中等概率为阴阳两虚型高血压',
          cAnswer: '可能存在阴阳两虚型高血压的风险',
          analysis: '阴阳两虚型高血压通常表现为手脚冰凉、疲劳、浮肿、气短等症状。患者常感到体力和精神双重疲惫，且容易感到寒冷、失眠等。'
        },
        10: {
          title: '测试题_痰瘀内蕴',
          type: 'ChineseMedicine',
          aRange: '0~40',
          bRange: '41~70',
          cRange: '71~100',
          aAnswer: '您有很低概率为痰瘀内蕴型高血压',
          bAnswer: '您有中等概率为痰瘀内蕴型高血压',
          cAnswer: '可能存在痰瘀内蕴型高血压的风险',
          analysis: '痰瘀内蕴型高血压多见于身体沉重、胸闷、头晕、水肿等症状。患者可能有消化不良、体重增加等问题，且常伴有胸口压迫感。'
        },
        11: {
          title: '测试题_瘀血内停',
          type: 'ChineseMedicine',
          aRange: '0~40',
          bRange: '41~70',
          cRange: '71~100',
          aAnswer: '您有很小概率为瘀血内停型高血压',
          bAnswer: '您有中等概率为瘀血内停型高血压',
          cAnswer: '可能存在瘀血内停型高血压的风险',
          analysis: '瘀血内停型高血压表现为头痛、胸闷、下肢浮肿、面色暗沉等症状。患者常感到疲劳、便秘、手脚麻木，舌质可能出现暗红或紫点。'
        },
        // 保留原有的心理测评类型
        1: {
          title: '焦虑自测量表 (SAS)',
          type: 'SAS'
        },
        2: {
          title: '抑郁自测量表 (SDS)',
          type: 'SDS'
        },
        3: {
          title: '匹兹堡睡眠质量指数 (PSQI)',
          type: 'PSQI'
        },
        4: {
          title: '压力知觉量表 (PSS)',
          type: 'PSS'
        }
      };
      
      // 如果有匹配的模拟数据，则使用它
      if (mockTests[this.testId]) {
        this.testData = mockTests[this.testId];
      } else {
        // 默认使用第一个测试的数据
        this.testData = {
          title: '心理健康测评',
          type: 'General'
        };
      }
    },
    
    // // 分享结果
    // shareResult() {
    //   uni.showToast({
    //     title: '分享功能开发中',
    //     icon: 'none'
    //   });
    // },
    
    // 咨询医生
    consultDoctor() {
      uni.switchTab({
        url: '/pages/consult/consult'
      });
    },
    
    // 返回测评列表
    goBack() {
      uni.navigateBack({
        delta: 2 // 返回两级，跳过详情页直接到列表页
      });
    },
    
    // 获取用户ID
    getUserId() {
      try {
        const userInfo = uni.getStorageSync('userInfo');
        if (userInfo) {
          const user = JSON.parse(userInfo);
          return user.id || 1;
        }
      } catch (e) {
        console.error('获取用户信息失败:', e);
      }
      return 1; // 默认用户ID
    }
  }
}
</script>

<style lang="scss">
.result-container {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 30rpx;
  
  .result-card {
    background: #ffffff;
    border-radius: 15rpx;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.08);
    overflow: hidden;
    margin-bottom: 40rpx;
    
    .result-header {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      padding: 40rpx 30rpx;
      display: flex;
      flex-direction: column;
      align-items: center;
      color: #ffffff;
      
      .result-title {
        font-size: 36rpx;
        font-weight: bold;
        margin-bottom: 30rpx;
        text-align: center;
      }
      
      .score-circle {
        width: 180rpx;
        height: 180rpx;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 50%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        border: 4rpx solid rgba(255, 255, 255, 0.5);
        
        .score-text {
          font-size: 64rpx;
          font-weight: bold;
          line-height: 1;
        }
        
        .score-label {
          font-size: 28rpx;
          margin-top: 6rpx;
        }
      }
    }
    
    .result-content {
      padding: 30rpx;
      
      .result-level {
        display: flex;
        align-items: center;
        padding: 20rpx 0;
        border-bottom: 1px solid #f0f0f0;
        margin-bottom: 20rpx;
        
        .level-label {
          font-size: 32rpx;
          color: #333;
          font-weight: bold;
        }
        
        .level-value {
          font-size: 32rpx;
          font-weight: bold;
          padding: 8rpx 20rpx;
          border-radius: 30rpx;
          margin-left: 10rpx;
          
          &.level-normal {
            background-color: #e7f7ee;
            color: #28c76f;
          }
          
          &.level-mild {
            background-color: #fff4de;
            color: #ff9f43;
          }
          
          &.level-moderate {
            background-color: #ffe4e5;
            color: #ea5455;
          }
          
          &.level-severe {
            background-color: #f0e0ff;
            color: #9c27b0;
          }
        }
      }
      
      .result-analysis, .result-suggestion {
        margin-top: 30rpx;
        
        .analysis-title, .suggestion-title {
          font-size: 32rpx;
          color: #333;
          font-weight: bold;
          margin-bottom: 15rpx;
          position: relative;
          padding-left: 20rpx;
          
          &::before {
            content: '';
            position: absolute;
            left: 0;
            top: 10rpx;
            bottom: 10rpx;
            width: 6rpx;
            background: linear-gradient(to bottom, #4facfe 0%, #00f2fe 100%);
            border-radius: 3rpx;
          }
        }
        
        .analysis-content, .suggestion-content {
          font-size: 30rpx;
          color: #666;
          line-height: 1.6;
          text-align: justify;
          letter-spacing: 1rpx;
        }
      }
      
      .result-suggestion {
        margin-top: 30rpx;
        padding-top: 30rpx;
        border-top: 1px dashed #e0e0e0;
      }
    }
  }
  
  .action-buttons {
    display: flex;
    justify-content: space-between;
    
    .action-btn {
      flex: 1;
      margin: 0 10rpx;
      height: 80rpx;
      line-height: 80rpx;
      border-radius: 40rpx;
      font-size: 28rpx;
      font-weight: normal;
      
      &.share-btn {
        background-color: #f8f8f8;
        color: #333;
        border: 1px solid #e0e0e0;
      }
      
      &.consult-btn {
        background: linear-gradient(to right, #4facfe 0%, #00f2fe 100%);
        color: #ffffff;
      }
      
      &.home-btn {
        background-color: #f1f1f1;
        color: #666;
      }
      
      &:first-child {
        margin-left: 0;
      }
      
      &:last-child {
        margin-right: 0;
      }
    }
  }
}
</style> 
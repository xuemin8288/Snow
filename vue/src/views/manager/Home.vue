<template>
  <div>
    <div style="display: flex">
      <div class="card" style="flex: 1; display: flex; align-items: center; padding: 20px">
        <div style="flex: 1; text-align: center">
          <img src="@/assets/imgs/题目图片.png" alt="" style="width: 80px; height: 80px; margin-right: 5px">
        </div>
        <div style="margin-left: 5px; flex: 1">
          <div style="font-size: 20px">题目数量</div>
          <div style="font-size: 20px; font-weight: bold">{{ data.baseData.topicNum }}</div>
        </div>
      </div>
      <div class="card" style="flex: 1; display: flex; align-items: center; padding: 20px; margin: 0 10px">
        <div style="flex: 1; text-align: center">
          <img src="@/assets/imgs/试卷图片.png" alt="" style="width: 80px; height: 80px; margin-right: 5px">
        </div>
        <div style="margin-left: 5px; flex: 1">
          <div style="font-size: 20px">试卷数量</div>
          <div style="font-size: 20px; font-weight: bold">{{ data.baseData.testPaperNum }}</div>
        </div>
      </div>
      <div class="card" style="flex: 1; display: flex; align-items: center; padding: 10px">
        <div style="flex: 1; text-align: center">
          <img src="@/assets/imgs/医生图片.png" alt="" style="width: 80px; height: 80px; margin-right: 5px">
        </div>
        <div style="margin-left: 5px; flex: 1">
          <div style="font-size: 20px">入驻专家数</div>
          <div style="font-size: 20px; font-weight: bold">{{ data.baseData.doctorNum }}</div>
        </div>
      </div>
      <div class="card" style="flex: 1; display: flex; align-items: center; padding: 10px; margin: 0 10px">
        <div style="flex: 1; text-align: center">
          <img src="@/assets/imgs/宣传图片.png" alt="" style="width: 80px; height: 80px; margin-right: 5px">
        </div>
        <div style="margin-left: 5px; flex: 1">
          <div style="font-size: 20px">科普文章</div>
          <div style="font-size: 20px; font-weight: bold">{{ data.baseData.propagateNum }}</div>
        </div>
      </div>
      <div class="card" style="flex: 1; display: flex; align-items: center; padding: 10px">
        <div style="flex: 1; text-align: center">
          <img src="@/assets/imgs/用户图片.png" alt="" style="width: 80px; height: 80px; margin-right: 5px">
        </div>
        <div style="margin-left: 5px; flex: 1">
          <div style="font-size: 20px">用户人数</div>
          <div style="font-size: 20px; font-weight: bold">{{ data.baseData.userNum }}</div>
        </div>
      </div>
    </div>
    <div class="card" style="height: 400px; margin-top: 10px" id="line"></div>
    <div style="display: flex; margin-top: 10px">
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie"></div>

      <div class="card" style="flex: 3; height: 400px; margin-left: 5px" id="bar"></div>
    </div>


    <!-- TESTING -->
    <div style="margin-top: 10px">
      <div class="card" style="margin-bottom: 15px; padding: 10px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
          <h2 style="margin: 0;">疾病证型地区分布统计</h2>
          <el-button type="primary" size="small" @click="refreshData" :loading="refreshLoading">
            <i class="el-icon-refresh"></i> 刷新数据
          </el-button>
        </div>
        <div style="display: flex; flex-wrap: wrap; justify-content: space-around;">
          <div style="width: 48%; height: 350px; margin-bottom: 15px;" id="pie2"></div>
          <div style="width: 48%; height: 350px; margin-bottom: 15px;" id="pie3"></div>
          <div style="width: 48%; height: 350px; margin-bottom: 15px;" id="pie4"></div>
          <div style="width: 48%; height: 350px; margin-bottom: 15px;" id="pie5"></div>
          <div style="width: 48%; height: 350px; margin-bottom: 15px;" id="pie6"></div>
        </div>
      </div>
    </div>
    <!-- TESTING -->
  </div>


</template>

<script setup>

import {reactive, ref, onMounted, onUnmounted} from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import * as echarts from "echarts";

const data = reactive({
  baseData: {}
})

// 添加刷新按钮的loading状态
const refreshLoading = ref(false);

const loadBaseData = () => {
  request.get('/statistics/base').then(res => {
    if (res.code === '200') {
      data.baseData = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
const loadLine = () => {
  request.get('/statistics/line').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('line')
      let myChart = echarts.init(chartDom)
      lineOptions.xAxis.data = res.data.xAxis
      lineOptions.series[0].data = res.data.yAxis
      myChart.setOption(lineOptions)
    } else {
      ElMessage.error(res.msg)
    }
  })
}
const loadBar = () => {
  request.get('/statistics/bar').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('bar')
      let myChart = echarts.init(chartDom)
      barOptions.xAxis.data = res.data.xAxis
      barOptions.series[0].data = res.data.yAxis
      myChart.setOption(barOptions)
    } else {
      ElMessage.error(res.msg)
    }
  })
}
const loadPie = () => {
  request.get('/statistics/pie').then(res => {
    if (res.code === '200') {
      let chartDom = document.getElementById('pie')
      let myChart = echarts.init(chartDom)
      pieOptions.series[0].data = res.data
      myChart.setOption(pieOptions)
    } else {
      ElMessage.error(res.msg)
    }
  })
}



// 五个饼图
let fetchedData = null;
function fetchData(forceRefresh = false) {
  // 如果强制刷新或缓存为空，则重新获取数据
  if (forceRefresh || !fetchedData) {
    console.log("从服务器获取最新数据");
    return request.get('/typeaddmap/all').then(res => {
      if (res.code === '200') {
        fetchedData = res.data;
        return fetchedData;
      } else {
        ElMessage.error(res.msg);
        return [];
      }
    }).catch(error => {
      console.error('Error fetching data:', error);
      return [];
    });
  } else {
    console.log("使用缓存数据");
    return Promise.resolve(fetchedData);
  }
}

// 添加刷新数据的方法
function refreshData() {
  console.log("刷新数据");
  // 设置loading状态
  refreshLoading.value = true;
  
  // 调用重置并重新计算统计接口
  ElMessage.info('正在重置并重新计算统计数据...');
  
  request.get('/typeaddmap/resetAndRecount').then(res => {
    if (res.code === '200') {
      ElMessage.success('统计数据已重置并重新计算');
      console.log("统计数据已重置并重新计算");
      
      // 清除缓存
      fetchedData = null;
      
      // 刷新所有饼图
      return fetchData(true).then(() => {
        loadPie2();
        loadPie3();
        loadPie4();
        loadPie5();
        loadPie6();
        console.log("所有饼图已刷新");
      });
    } else {
      ElMessage.error('操作失败: ' + res.msg);
      console.error("操作失败:", res.msg);
    }
  }).catch(error => {
    ElMessage.error('请求出错: ' + error);
    console.error("请求出错:", error);
  }).finally(() => {
    // 无论成功失败，都取消loading状态
    refreshLoading.value = false;
  });
}

function filterDataByTypeKey(data, typekey) {
  return data.filter(item => item.typekey === typekey).map(item => ({
    value: item.value,
    name: item.address
  }));
}

// 保存图表实例以便后续清理
const chartInstances = [];

function loadPieChart(domId, titleText, typekey) {
  fetchData().then(data => {
    let chartDom = document.getElementById(domId);
    let myChart = echarts.init(chartDom);
    // 保存图表实例
    chartInstances.push(myChart);
    
    let pieOptions = {
      title: {
        text: titleText,
        subtext: '统计维度：地区',
        left: 'center',
        top: 10,
        textStyle: {
          fontSize: 16,
          fontWeight: 'bold'
        },
        subtextStyle: {
          fontSize: 12
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b} : {c} ({d}%)',
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        borderColor: '#ccc',
        borderWidth: 1,
        textStyle: {
          color: '#333'
        }
      },
      legend: {
        type: 'scroll',
        orient: 'horizontal',
        bottom: 10,
        left: 'center',
        itemWidth: 15,
        itemHeight: 10,
        textStyle: {
          fontSize: 12
        }
      },
      color: ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272', '#fc8452', '#9a60b4', '#ea7ccc'],
      series: [
        {
          name: '数量占比',
          type: 'pie',
          radius: ['35%', '60%'],  // 内外半径，形成环形图
          center: ['50%', '50%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: true,
            formatter: '{b}: {c} ({d}%)',
            fontSize: 12
          },
          labelLine: {
            show: true,
            length: 15,
            length2: 10
          },
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },
          data: filterDataByTypeKey(data, typekey)
        }
      ]
    };
    myChart.setOption(pieOptions);
    
    // 添加响应式调整
    window.addEventListener('resize', function() {
      myChart.resize();
    });
  });
}
const loadPie2 = () => {
  loadPieChart('pie2', '肝阳上亢地区统计', 1);
};
const loadPie3 = () => {
  loadPieChart('pie3', '肝肾阴虚地区统计', 2);
};
const loadPie4 = () => {
  loadPieChart('pie4', '阴阳两虚地区统计', 3);
};

const loadPie5 = () => {
  loadPieChart('pie5', '痰瘀内蕴地区统计', 4);
};

const loadPie6 = () => {
  loadPieChart('pie6', '淤血内停地区统计', 5);
};


loadBaseData()

// 声明一个变量来存储定时器ID
let refreshInterval = null;

onMounted(() => {
  loadLine()
  loadBar()
  loadPie()
  
  // 使用强制刷新加载饼图
  fetchData(true).then(() => {
    loadPie2()
    loadPie3()
    loadPie4()
    loadPie5()
    loadPie6()
  })
  
  // 每30秒自动刷新一次数据
  refreshInterval = setInterval(() => {
    console.log("定时刷新数据");
    refreshData();
  }, 30000);
})

// 组件卸载时清理
onUnmounted(() => {
  // 移除所有事件监听器
  window.removeEventListener('resize', () => {});
  
  // 清除定时器
  if (refreshInterval) {
    clearInterval(refreshInterval);
  }
  
  // 销毁所有图表实例
  chartInstances.forEach(chart => {
    chart.dispose();
  });
})


// 平滑折线图
let lineOptions = {
  title: {
    text: '最近一周问诊测试数量统计',
    left: 'left'
  },
  legend: {
    data: [],
    template:""
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  tooltip: {
    trigger: 'item'
  },
  xAxis: {
    name: '日期',
    type: 'category',
    data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  },
  yAxis: {
    name: '次数',
    type: 'value'
  },
  series: [
    {
      name: '问诊测试次数',
      data: [820, 932, 901, 934, 1290, 1330, 1320],
      type: 'line',
      smooth: true,
      markLine: {
        data: [{ type: 'average', name: '问诊测试次数平均值' }]
      },
      markPoint: {
        data: [
          { type: 'max', name: '最大值' },
          { type: 'min', name: '最小值' }
        ]
      },
    },
  ]
};
// 柱状图
let barOptions = {
  title: {
    text: '不同证型测试次数', // 主标题
    subtext: '统计维度：疾病证型', // 副标题
    left: 'center'
  },
  grid : {   // ---------------------------增加这个属性，bottom就是距离底部的距离
    bottom : '30%'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  xAxis: {
    type: 'category',
    data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], // 示例数据：统计的维度（横坐标）
    name: '证型名称',
    axisLabel: {
      show: true, // 是否显示刻度标签，默认显示
      interval: 0, // 坐标轴刻度标签的显示间隔，在类目轴中有效；默认会采用标签不重叠的策略间隔显示标签；可以设置成0强制显示所有标签；如果设置为1，表示『隔一个标签显示一个标签』，如果值为2，表示隔两个标签显示一个标签，以此类推。
      rotate: -60, // 刻度标签旋转的角度，在类目轴的类目标签显示不下的时候可以通过旋转防止标签之间重叠；旋转的角度从-90度到90度
      inside: false, // 刻度标签是否朝内，默认朝外
      margin: 6, // 刻度标签与轴线之间的距离
    },
  },
  yAxis: {
    type: 'value',
    name: '次数',
  },
  tooltip: {
    trigger: 'item',
  },
  series: [
    {
      data: [120, 200, 150, 80, 70, 110, 130], // 示例数据：横坐标维度对应的值（纵坐标）
      type: 'bar',
      itemStyle: {
        normal: {
          color: function () {
            return "#" + Math.floor(Math.random() * (256 * 256 * 256 - 1)).toString(16);
          }
        },
      },
    }
  ]
};
// 饼图
let pieOptions = {
  title: {
    text: '不同类型题库题目数量分布统计', // 主标题
    subtext: '统计维度：疾病证型', // 副标题
    left: 'center'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '数量占比', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [
        {value: 1, name: '瑞幸咖啡'}, // 示例数据：name表示维度，value表示对应的值
        {value: 735, name: '雀巢咖啡'},
        {value: 580, name: '星巴克咖啡'},
        {value: 484, name: '栖巢咖啡'},
        {value: 300, name: '小武哥咖啡'}
      ]
    }
  ]
}

let pieOptions2 = {
  title: {
    text: '肝阳上亢地区统计', // 主标题
    subtext: '统计维度：地区', // 副标题
    right: '10%'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '数量占比', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [
        {value: 1, name: '瑞幸咖啡'}, // 示例数据：name表示维度，value表示对应的值
        {value: 735, name: '雀巢咖啡'},
        {value: 580, name: '星巴克咖啡'},
        {value: 484, name: '栖巢咖啡'},
        {value: 300, name: '小武哥咖啡'}
      ]
    }
  ]
}

let pieOptions3 = {
  title: {
    text: '肝肾阴虚地区统计', // 主标题
    subtext: '统计维度：地区', // 副标题
    right: '10%'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '数量占比', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [
        {value: 1, name: '瑞幸咖啡'}, // 示例数据：name表示维度，value表示对应的值
        {value: 735, name: '雀巢咖啡'},
        {value: 580, name: '星巴克咖啡'},
        {value: 484, name: '栖巢咖啡'},
        {value: 300, name: '小武哥咖啡'}
      ]
    }
  ]
}


let pieOptions4 = {
  title: {
    text: '阴阳两虚地区统计', // 主标题
    subtext: '统计维度：地区', // 副标题
    right: '10%'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '数量占比', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [
        {value: 1, name: '瑞幸咖啡'}, // 示例数据：name表示维度，value表示对应的值
        {value: 735, name: '雀巢咖啡'},
        {value: 580, name: '星巴克咖啡'},
        {value: 484, name: '栖巢咖啡'},
        {value: 300, name: '小武哥咖啡'}
      ]
    }
  ]
}


let pieOptions5 = {
  title: {
    text: '阴阳两虚地区统计', // 主标题
    subtext: '统计维度：地区', // 副标题
    right: '10%'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '数量占比', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [
        {value: 1, name: '瑞幸咖啡'}, // 示例数据：name表示维度，value表示对应的值
        {value: 735, name: '雀巢咖啡'},
        {value: 580, name: '星巴克咖啡'},
        {value: 484, name: '栖巢咖啡'},
        {value: 300, name: '小武哥咖啡'}
      ]
    }
  ]
}

let pieOptions6 = {
  title: {
    text: '痰瘀内蕴地区统计', // 主标题
    subtext: '统计维度：地区', // 副标题
    right: '10%'
  },
  tooltip: {
    trigger: 'item',
    formatter: '{a} <br/>{b} : {c} ({d}%)'
  },
  legend: {
    orient: 'vertical',
    left: 'left'
  },
  series: [
    {
      name: '数量占比', // 鼠标移上去显示内容
      type: 'pie',
      radius: '50%',
      center: ['50%', '60%'],
      data: [
        {value: 1, name: '瑞幸咖啡'}, // 示例数据：name表示维度，value表示对应的值
        {value: 735, name: '雀巢咖啡'},
        {value: 580, name: '星巴克咖啡'},
        {value: 484, name: '栖巢咖啡'},
        {value: 300, name: '小武哥咖啡'}
      ]
    }
  ]
}
</script>

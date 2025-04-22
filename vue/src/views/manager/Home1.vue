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
          <div style="font-size: 20px; font-weight: bold">{{ data.baseData.propagateNum }}</div>
        </div>
      </div>
    </div>
    <div class="card" style="height: 400px; margin-top: 10px" id="line"></div>
    <div style="display: flex; margin-top: 10px">
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie"></div>

      <div class="card" style="flex: 3; height: 400px; margin-left: 5px" id="bar"></div>
    </div>


  <!-- TESTING -->
    <div style="display: flex; margin-top: 10px">
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie2"></div>
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie3"></div>
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie4"></div>
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie5"></div>
      <div class="card" style="flex: 2; height: 400px; margin-right: 5px" id="pie6"></div>
    </div>
  <!-- TESTING -->
  </div>


</template>

<script setup>

import {reactive, onMounted} from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
import * as echarts from "echarts";

const data = reactive({
  baseData: {}
})

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



//pie2 loader
// const loadPie2 = () => {
//   request.get('/statistics/pie').then(res => {
//     if (res.code === '200') {
//       let chartDom = document.getElementById('pie2')
//       let myChart = echarts.init(chartDom)
//       pieOptions2.series[0].data = res.data
//       myChart.setOption(pieOptions2)
//     } else {
//       ElMessage.error(res.msg)
//     }
//   })
// }

// 五个证型的调用函数  静态版本，未开数据接口  记得删除（
  //  static pie2 loader
 const loadPie2 = () => {
  let chartDom = document.getElementById('pie2'); 
  let myChart = echarts.init(chartDom); 
  let pieOptions2 = {
    title: {
      text: '肝阳上亢地区统计', 
      subtext: '统计维度：地区', 
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
        name: '数量占比', 
        type: 'pie',
        radius: '50%',
        center: ['50%', '60%'],
        data: [  
          {value: 12, name: '漳州'},
          {value: 42, name: '厦门'},
          {value: 20, name: '福州'},
          {value: 33, name: '南平'}
        ]
      }
    ]
  };
  myChart.setOption(pieOptions2);
};

 const loadPie3 = () => {
  let chartDom = document.getElementById('pie3'); 
  let myChart = echarts.init(chartDom); 
  let pieOptions3 = {
    title: {
      text: '肝肾阴虚地区统计', 
      subtext: '统计维度：地区', 
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
        name: '数量占比', 
        type: 'pie',
        radius: '50%',
        center: ['50%', '60%'],
        data: [  
          {value: 32, name: '三明'},
          {value: 41, name: '厦门'},
          {value: 2, name: '莆田'},
          {value: 9, name: '泉州'}
        ]
      }
    ]
  };
  myChart.setOption(pieOptions3);
};

 const loadPie4 = () => {
  let chartDom = document.getElementById('pie4'); 
  let myChart = echarts.init(chartDom); 
  let pieOptions4 = {
    title: {
      text: '阴阳两虚地区统计', 
      subtext: '统计维度：地区', 
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
        name: '数量占比', 
        type: 'pie',
        radius: '50%',
        center: ['50%', '60%'],
        data: [  
          {value: 32, name: '宁德'},
          {value: 41, name: '厦门'},
          {value: 29, name: '漳州'},
        ]
      }
    ]
  };
  myChart.setOption(pieOptions4);
};


 const loadPie5 = () => {
  let chartDom = document.getElementById('pie5'); 
  let myChart = echarts.init(chartDom); 
  let pieOptions5 = {
    title: {
      text: '阴阳两虚地区统计', 
      subtext: '统计维度：地区', 
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
        name: '数量占比', 
        type: 'pie',
        radius: '50%',
        center: ['50%', '60%'],
        data: [  
          {value: 32, name: '福州'},
          {value: 41, name: '莆田'},
          {value: 29, name: '泉州'},
          {value: 2, name: '宁德'},
          {value: 10, name: '漳州'},
        ]
      }
    ]
  };
  myChart.setOption(pieOptions5);
};

 const loadPie6 = () => {
  let chartDom = document.getElementById('pie6'); 
  let myChart = echarts.init(chartDom); 
  let pieOptions6 = {
    title: {
      text: '阴阳两虚地区统计', 
      subtext: '统计维度：地区', 
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
        name: '数量占比', 
        type: 'pie',
        radius: '50%',
        center: ['50%', '60%'],
        data: [  
          {value: 32, name: '宁德'},
          {value: 12, name: '南平'},
        ]
      }
    ]
  };
  myChart.setOption(pieOptions6);
};
// const loadPie2 = () => {
//   request.get('/statistics/pie').then(res => {
//     if (res.code === '200') {
//       let chartDom = document.getElementById('pie2')
//       let myChart = echarts.init(chartDom)
//       pieOptions2.series[0].data = res.data
//       myChart.setOption(pieOptions2)
//     } else {
//       ElMessage.error(res.msg)
//     }
//   })
// }

// const loadPie3 = () => {
//   request.get('/statistics/pie').then(res => {
//     if (res.code === '200') {
//       let chartDom = document.getElementById('pie3')
//       let myChart = echarts.init(chartDom)
//       pieOptions3.series[0].data = res.data
//       myChart.setOption(pieOptions3)
//     } else {
//       ElMessage.error(res.msg)
//     }
//   }) 
// }

// const loadPie4 = () => {
//   request.get('/statistics/pie').then(res => {
//     if (res.code === '200') {
//       let chartDom = document.getElementById('pie4')
//       let myChart = echarts.init(chartDom)
//       pieOptions4.series[0].data = res.data
//       myChart.setOption(pieOptions4)
//     } else {
//       ElMessage.error(res.msg)
//     }
//   })
// }

// const loadPie5 = () => {
//   request.get('/statistics/pie').then(res => {
//     if (res.code === '200') {
//       let chartDom = document.getElementById('pie5')
//       let myChart = echarts.init(chartDom)
//       pieOptions5.series[0].data = res.data
//       myChart.setOption(pieOptions5)
//     } else {
//       ElMessage.error(res.msg)
//     }
//   })
// }

// const loadPie6 = () => {
//   request.get('/statistics/pie').then(res => {
//     if (res.code === '200') {
//       let chartDom = document.getElementById('pie6')
//       let myChart = echarts.init(chartDom)
//       pieOptions6.series[0].data = res.data
//       myChart.setOption(pieOptions6)
//     } else {
//       ElMessage.error(res.msg)
//     }
//   })
// }


loadBaseData()
onMounted(() => {
  loadLine()
  loadBar()
  loadPie()
  loadPie2()
  loadPie3()
  loadPie4()
  loadPie5()
  loadPie6()
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
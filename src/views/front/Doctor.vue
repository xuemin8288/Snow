<template>
  <div style="margin: 0 auto; background-color: #f3f4f5; padding: 30px 0">
    <div style="width: 60%; margin: 0 auto; display: flex; align-items: center">
      <div style="font-size: 24px; width: 180px; font-weight: bold; color: #0b8bff">专家咨询</div>
      <div style="font-size: 18px; color: #8c939d; margin-left: 20px; flex: 1">高血压可防可控，健康生活不是梦</div>
    </div>
    <div style="width: 60%; margin: 20px auto">
      <el-row :gutter="10">
        <el-col :span="6" v-for="item in data.doctorData" style="margin-bottom: 20px">
          <div style="border-top-left-radius: 10px; border-top-right-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,.1); padding-bottom: 15px">
            <img :src="item.avatar" alt="" style="width: 100%; height: 250px; border-top-left-radius: 10px; border-top-right-radius: 10px">
            <div style="padding: 10px 15px">
              <div style="font-size: 16px; height: 30px; line-height: 30px">{{ item.name }}</div>
              <div style="font-size: 16px; height: 30px; line-height: 30px">累计帮助 10 人</div>
              <div style="margin-top: 5px">医生工龄：<el-tag type="success">{{ item.seniority }} 年</el-tag></div>
              <el-popover
                  placement="top-start"
                  title="医生简介："
                  :width="300"
                  trigger="hover"
                  :content="item.content"
              >
                <template #reference>
                  <div style="margin-top: 10px; color: #666666; line-height: 20px; height: 60px" class="line3">医生简介：{{ item.content }}</div>
                </template>
              </el-popover>
            </div>
            <div style="text-align: center; margin-top: 15px">
              <el-button type="info" style="padding: 20px 30px" @click="reservationInit(item)">立即咨询</el-button>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
    <el-dialog title="咨询信息" v-model="data.formVisible" width="40%" destroy-on-close>
      <el-form ref="formRef" :rules="data.rules" :model="data.form" label-width="80px" style="padding: 20px">


<!-- TESTING -->
<el-form-item label="时间">
  <!-- 添加 ID 用于定位 -->
  <el-input id="timeInput" :placeholder="nowdataformat" :readonly="true"></el-input>
</el-form-item>

<!-- TESTING -->


        <el-form-item prop="question" label="问题描述">
          <el-input type="textarea" :rows="5" v-model="data.form.question" placeholder="在描述您目前的问题之前，先提供历史诊断的记录"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="data.formVisible = false">取 消</el-button>
          <el-button type="primary" @click="submit">提 交</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import {reactive, ref} from "vue";
import request from "@/utils/request.js";
import {ElMessage} from "element-plus";
const formRef = ref()
const nowdata = new Date();
const nowdataformat = nowdata.toLocaleDateString('zh-CN',{ year: '2-digit', month: '2-digit', day: '2-digit',hour:'2-digit',minute:'2-digit'});
const data = reactive({
  doctorData: [],
  form: {},
  formVisible:false,
  rules: {
    timeRange: [
      { required: true, message: '请选择咨询时间', trigger: 'blur' }
    ],
    question: [
      { required: true, message: '请选描述问题', trigger: 'blur' }
    ],
  }
})

const loadDoctor = () => {
  request.get('/doctor/selectAll', {
                el:"#app",
            data:{
                date:new Date()
            },
            mounted:function(){
                var _this=this;
                this.timer=setInterval(function(){
                    _this.date=new Date();
                },1000);
                },
                computed: {
                formattedDate: function() {
                    var date = this.date;
                    var year = date.getFullYear();
                    var month = (date.getMonth() + 1).toString().padStart(2, '0');
                    var day = date.getDate().toString().padStart(2, '0');
                    var hours = date.getHours().toString().padStart(2, '0');
                    var minutes = date.getMinutes().toString().padStart(2, '0');
                    var seconds = date.getSeconds().toString().padStart(2, '0');

                    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
                }
            },
    params: {
      status: '审批通过'
    }
  }).then(res => {
    if (res.code === '200') {
      data.doctorData = res.data
    } else {
      ElMessage.error(res.msg)
    }
  })
}
const reservationInit = (item) => {
  data.form = JSON.parse(JSON.stringify(item))
  data.formVisible = true
}
const submit = () => {
  formRef.value.validate(valid => {
    if (valid) {
      let reservationData = {
        doctorId: data.form.id,
        timeRange: data.form.timeRange,
        question: data.form.question
      }
      request.post('/reservation/add', reservationData).then(res => {
        if (res.code === '200') {
          ElMessage.success('操作成功，等待医生审核')
          data.formVisible = false
        } else {
          ElMessage.error(res.msg)
        }
      })
    }
  })
}





loadDoctor()
</script>

<style scoped>
.line3 {
  word-break: break-all;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3; /* 超出几行省略 */
  overflow: hidden;
}
</style>



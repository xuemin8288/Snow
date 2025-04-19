<template>
  <div>
    <div class="front-header">
      <div class="front-header-left">
        <img src="@/assets/imgs/logo.png" alt="">
        <div class="title">高血压义诊系统</div>
      </div>
      <div class="front-header-center">
        <el-menu :default-active="router.currentRoute.value.path" router mode="horizontal">
          <el-menu-item index="/front/home">首页</el-menu-item>
          <el-menu-item index="/front/testPaper">证型自测</el-menu-item>
          <el-menu-item index="/front/doctor">专家</el-menu-item>
          <el-menu-item index="/front/propagate">高血压知识科普</el-menu-item>
          <el-menu-item index="/front/feedback">反馈与建议</el-menu-item>
          <el-menu-item index="/front/person">个人中心</el-menu-item>
        </el-menu>
      </div>
      <div class="front-header-right">
        <div v-if="!data.user.id">
          <el-button @click="router.push('/login')">登录</el-button>
          <el-button @click="router.push('/register')">注册</el-button>
        </div>
        <div v-else>
          <el-dropdown style="cursor: pointer; height: 60px">
            <div style="display: flex; align-items: center">
              <img style="width: 40px; height: 40px; border-radius: 50%;" :src="data.user.avatar" alt="">
              <span style="margin-left: 5px;">{{ data.user.name }}</span><el-icon><arrow-down /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="navTo('/front/reservation')">咨询记录</el-dropdown-item>
                <el-dropdown-item @click="navTo('/front/testRecord')">测试记录</el-dropdown-item>
                <el-dropdown-item @click="navTo('/front/myFeedback')">我的反馈</el-dropdown-item>
                <el-dropdown-item @click="navTo('/front/password')">修改密码</el-dropdown-item>
                <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </div>
    <div class="main-body">
      <RouterView @updateUser="updateUser" />
      <div style="background-color: #3c3c3c;height: 400px;">
        <div style="width: 50%;margin: 0 auto;display: flex;color: #c2c2c2">
          <div style="flex: 1;margin-top: 20px">
            <div style="padding: 10px 0;font-size: 18px">高血压义诊系统</div>
            <div style="padding: 5px 0">上亿医生共同打造的"血压健康"</div>
            <div style="padding: 5px 0">6,000 多次咨询次数</div>
            <div style="padding: 5px 0">76,000 次问诊测试</div>
            <div style="padding: 5px 0">800+ 测试试卷</div>
          </div>
          <div style="flex: 1;margin-top: 20px">
            <div style="padding: 10px 0;font-size: 18px">关于我们</div>
            <div style="padding: 5px 0">关于高血压义诊系统联系我们</div>
            <div style="padding: 5px 0">隐私政策商标声明</div>
            <div style="padding: 5px 0">服务协议</div>
            <div style="padding: 5px 0">高血压义诊系统服务协议</div>
            <div style="padding: 5px 0">网络信息侵权通知指引</div>
            <div style="padding: 5px 0">高血压义诊系统服务监督员</div>
            <div style="padding: 5px 0">网站地图加入高血压义诊系统</div>
          </div>
          <div style="flex: 1;margin-top: 20px">
            <div style="padding: 10px 0;font-size: 18px">咨询服务</div>
            <div style="display: flex">
              <div style="flex: 1;padding: 10px 0">高血压问题咨询</div>
              <div style="flex: 1;padding: 5px 0">高血压证型检测</div>
            </div>
            <div style="display: flex">
              <div style="flex: 1;padding: 10px 0">专家问答</div>
              <div style="flex: 1;padding: 5px 0">答疑解惑</div>
            </div>
            <div style="display: flex">
              <div style="flex: 1;padding: 10px 0">健康宣传</div>
              <div style="flex: 1;padding: 5px 0">自测问卷</div>
            </div>

            <div style="padding: 5px 0">友情链接： <a style="margin-left:10px;color: red" href="https://www.dayi.org.cn/symptom/1012764">中国医药信息查询平台 高血压</a> </div>
          </div>
        </div>
        <div style="width: 100%;text-align: center;color: #c2c2c2;margin-top: 40px;font-size: 20px">
          血压平稳，快乐相伴，健康生活，从此无忧。
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
  import router from "@/router/index.js";
  import { reactive } from "vue";
  import request from "@/utils/request.js";

  const data = reactive({
    user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
  })

  const navTo = (url) => {
    location.href = url
  }

  const logout = () => {
    localStorage.removeItem('xm-user')
    router.push('/login')
  }

  const updateUser = () => {
    data.user =  JSON.parse(localStorage.getItem('xm-user') || '{}')
  }

</script>

<style scoped>
@import "@/assets/css/front.css";
</style>
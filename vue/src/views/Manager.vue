<template>
  <div class="manager-container">
    <div class="manager-header">
      <div class="manager-header-left">
        <img src="@/assets/imgs/logo.png" alt="">
        <div class="title">高血压义诊系统</div>
      </div>
      <div class="manager-header-center">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/manager/home' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>{{ router.currentRoute.value.meta.name }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="manager-header-right">
        <el-dropdown style="cursor: pointer">
          <div style="padding-right: 20px; display: flex; align-items: center">
            <img style="width: 40px; height: 40px; border-radius: 50%;" :src="data.user.avatar" alt="">
            <span style="margin-left: 5px; color: white">{{ data.user.name }}</span><el-icon color="#fff"><arrow-down /></el-icon>
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item @click="router.push('/manager/person')">个人资料</el-dropdown-item>
              <el-dropdown-item @click="router.push('/manager/doctorAuthentication')" v-if="data.user.role === 'DOCTOR'">资格认证</el-dropdown-item>
              <el-dropdown-item @click="router.push('/manager/password')">修改密码</el-dropdown-item>
              <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>
    <!-- 下面部分开始 -->
    <div style="display: flex">
      <div class="manager-main-left">
        <el-menu :default-active="router.currentRoute.value.path"
                 :default-openeds="['1', '2']"
                 router
        >
          <el-menu-item index="/manager/Home" v-if="data.user.role === 'ADMIN'" >
            <el-icon><HomeFilled /></el-icon>
            <span>系统首页</span>
          </el-menu-item>
          <el-menu-item index="/manager/DoctorHome" v-if="data.user.role === 'DOCTOR'" >
            <el-icon><HomeFilled /></el-icon>
            <span>系统首页</span>
          </el-menu-item>


          <el-sub-menu index="1">
            <template #title>
              <el-icon><Menu /></el-icon>
              <span>信息管理</span>
            </template>
            <el-menu-item index="/manager/sideshow" v-if="data.user.role === 'ADMIN'">轮播图信息</el-menu-item>
            <el-menu-item index="/manager/type" v-if="data.user.role === 'ADMIN'">疾病证型</el-menu-item>
            <el-menu-item index="/manager/topic" v-if="data.user.role === 'ADMIN'">问卷题库</el-menu-item>
            <el-menu-item index="/manager/topic" v-if="data.user.role === 'DOCTOR' && data.user.status === '审批通过'">问卷题库</el-menu-item>
            <el-menu-item index="/manager/testPaper" v-if="data.user.role === 'ADMIN'">发布问卷</el-menu-item>
            <el-menu-item index="/manager/testPaper" v-if="data.user.role === 'DOCTOR' && data.user.status === '审批通过'">发布问卷</el-menu-item>
            <el-menu-item index="/manager/testRecord" v-if="data.user.role === 'ADMIN'">测试记录</el-menu-item>
            <el-menu-item index="/manager/testRecord" v-if="data.user.role === 'DOCTOR' && data.user.status === '审批通过'">测试记录</el-menu-item>

            <el-menu-item index="/manager/reservation" v-if="data.user.role === 'ADMIN'">专家咨询记录</el-menu-item>
            <el-menu-item index="/manager/reservation" v-if="data.user.role === 'DOCTOR' && data.user.status === '审批通过'">咨询记录审批</el-menu-item>

            <el-menu-item index="/manager/propagate" v-if="data.user.role === 'ADMIN'">高血压知识科普</el-menu-item>
            <el-menu-item index="/manager/propagate" v-if="data.user.role === 'DOCTOR' && data.user.status === '审批通过'">高血压知识科普</el-menu-item>
            <el-menu-item index="/manager/feedback" v-if="data.user.role === 'ADMIN'">反馈与建议</el-menu-item>
            <el-menu-item index="/manager/notice" v-if="data.user.role === 'ADMIN'">系统公告</el-menu-item>
          </el-sub-menu>
          <el-sub-menu index="2" v-if="data.user.role === 'ADMIN'">
            <template #title>
              <el-icon><Menu /></el-icon>
              <span>用户管理</span>
            </template>
            <el-menu-item index="/manager/user">用户信息</el-menu-item>
            <el-menu-item index="/manager/doctor">专家信息</el-menu-item>
            <el-menu-item index="/manager/admin">管理员信息</el-menu-item>
          </el-sub-menu>
        </el-menu>
      </div>
      <div class="manager-main-right">
        <RouterView @updateUser="updateUser" />
      </div>
    </div>
    <!-- 下面部分结束 -->


  </div>
</template>

<script setup>
import { reactive } from "vue";
import router from "@/router/index.js";
import {ElMessage} from "element-plus";

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}')
})

const logout = () => {
  localStorage.removeItem('xm-user')
  router.push('/login')
}

const updateUser = () => {
  data.user =  JSON.parse(localStorage.getItem('xm-user') || '{}')
}

if (!data.user) {
  logout()
  ElMessage.error('请登录！')
}
</script>

<style scoped>
@import "@/assets/css/manager.css";
</style>
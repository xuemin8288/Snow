<template>
  <div style="width: 50%" class="card">
    <el-form ref="user" :model="data.user" label-width="70px" style="padding: 20px">
      <el-form-item prop="avatar" label="头像">
        <el-upload
            :action="baseUrl + '/files/upload'"
            :on-success="handleFileUpload"
            :show-file-list="false"
            class="avatar-uploader"
        >
          <img v-if="data.user.avatar" :src="data.user.avatar" class="avatar" />
          <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
        </el-upload>
      </el-form-item>
      <el-form-item prop="username" label="用户名">
        <el-input disabled v-model="data.user.username" placeholder="请输入用户名"></el-input>
      </el-form-item>
      <el-form-item prop="name" label="姓名">
        <el-input v-model="data.user.name" placeholder="请输入姓名"></el-input>
      </el-form-item>
      <el-form-item prop="phone" label="电话">
        <el-input v-model="data.user.phone" placeholder="请输入电话"></el-input>
      </el-form-item>
      <el-form-item prop="email" label="邮箱">
        <el-input v-model="data.user.email" placeholder="请输入邮箱"></el-input>
      </el-form-item>
      <!-- address -->
      <el-form-item prop="typeAddress" label="地址：">
        <el-select v-model="data.user.typeAddress" placeholder="请选择地址">
          <el-option v-for="address in addressList" :key="address" :label="address" :value="address"></el-option>
        </el-select>
      </el-form-item>
      <!-- address -->

      <div style="text-align: center">
        <el-button type="primary" @click="update">保 存</el-button>
      </div>
    </el-form>
  </div>
</template>

<script setup>
import { reactive, onMounted } from "vue";
import request from "@/utils/request.js";
import { ElMessage } from "element-plus";

const baseUrl = import.meta.env.VITE_BASE_URL;

const data = reactive({
  user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
});

const addressList = reactive([]);

// 获取地址
const fetchAddresses = async () => {
  try {
    const res = await request.get('/typeaddmap/uniqueAddresses');
    if (res.code === '200') {
      addressList.length = 0;
      addressList.push(...res.data);
    } else {
      ElMessage.error(res.msg);
    }
  } catch (error) {
    console.error('获取地址列表失败:', error);
    ElMessage.error('获取地址列表失败');
  }
};

const handleFileUpload = (res) => {
  data.user.avatar = res.data;
};

const emit = defineEmits(['updateUser']);
const update = () => {
  if (data.user.role === 'ADMIN') {
    request.put('/admin/update', data.user).then(res => {
      if (res.code === '200') {
        ElMessage.success('保存成功');
        localStorage.setItem('xm-user', JSON.stringify(data.user));
        emit('updateUser');
      } else {
        ElMessage.error(res.msg);
      }
    });
  }
  if (data.user.role === 'DOCTOR') {
    request.put('/doctor/update', data.user).then(res => {
      if (res.code === '200') {
        ElMessage.success('保存成功');
        localStorage.setItem('xm-user', JSON.stringify(data.user));
        emit('updateUser');
      } else {
        ElMessage.error(res.msg);
      }
    });
  }
};

onMounted(() => {
  fetchAddresses();
});
</script>

<style>
.avatar-uploader {
  height: 120px;
}
.avatar-uploader .avatar {
  width: 120px;
  height: 120px;
  display: block;
}
.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  text-align: center;
}
</style>

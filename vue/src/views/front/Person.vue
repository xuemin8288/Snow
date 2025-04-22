<template>
  <div style="width: 40%; margin: 25px auto" class="card">
    <el-form ref="user" :model="data.user" label-width="60px" style="padding: 20px">
      <div style="text-align: center; margin-bottom: 20px">
        <el-upload
            :action="baseUrl + '/files/upload'"
            :on-success="handleFileUpload"
            :show-file-list="false"
            class="avatar-uploader"
        >
          <img v-if="data.user.avatar" :src="data.user.avatar" class="avatar" />
          <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
        </el-upload>
      </div>
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
      <el-form-item prop="email" label="性别">
        <el-input v-model="data.user.gender" placeholder="请输入性别"></el-input>
      </el-form-item>
      <el-form-item prop="email" label="年龄">
        <el-input v-model="data.user.age" placeholder="请输入年龄"></el-input>
      </el-form-item>
      <el-form-item prop="address" label="地址：">
        <el-select v-model="data.user.typeAddress" placeholder="请选择地址">
          <el-option v-for="address in addressList" :key="address" :label="address" :value="address"></el-option>
        </el-select>
      </el-form-item>
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

// 定义响应式变量存储地址列表
const addressList = reactive([]);

// 定义函数获取地址列表
const fetchAddresses = async () => {
  try {
    const res = await request.get('/typeaddmap/uniqueAddresses');
    if (res.code === '200') {
      // 清空原有的地址列表
      addressList.length = 0;
      // 将新的地址列表添加到 addressList 中
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
  if (data.user.role === 'USER') {
    request.put('/user/update', data.user).then(res => {
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

// 在组件挂载后获取地址列表
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
  border-radius: 50%;
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

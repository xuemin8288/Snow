/**
 * Element Plus 组件在小程序环境中的适配工具
 * 由于小程序环境与Web环境不同，Element Plus的部分功能需要适配
 */

// 消息提示
export const ElMessage = {
  success(options) {
    const content = typeof options === 'string' ? options : options.message;
    uni.showToast({
      title: content,
      icon: 'success',
      duration: 2000
    });
  },
  error(options) {
    const content = typeof options === 'string' ? options : options.message;
    uni.showToast({
      title: content,
      icon: 'error',
      duration: 2000
    });
  },
  warning(options) {
    const content = typeof options === 'string' ? options : options.message;
    uni.showToast({
      title: content,
      icon: 'none',
      duration: 2000
    });
  },
  info(options) {
    const content = typeof options === 'string' ? options : options.message;
    uni.showToast({
      title: content,
      icon: 'none',
      duration: 2000
    });
  }
};

// 确认对话框
export const ElMessageBox = {
  confirm(message, title = '提示', options = {}) {
    return new Promise((resolve, reject) => {
      uni.showModal({
        title,
        content: message,
        confirmText: options.confirmButtonText || '确定',
        cancelText: options.cancelButtonText || '取消',
        success: (res) => {
          if (res.confirm) {
            resolve('confirm');
          } else {
            reject(new Error('cancel'));
          }
        },
        fail: () => {
          reject(new Error('cancel'));
        }
      });
    });
  },
  alert(message, title = '提示', options = {}) {
    return new Promise((resolve) => {
      uni.showModal({
        title,
        content: message,
        showCancel: false,
        confirmText: options.confirmButtonText || '确定',
        success: () => {
          resolve();
        }
      });
    });
  }
};

// 加载提示
export const ElLoading = {
  service(options = {}) {
    const text = options.text || '加载中';
    uni.showLoading({
      title: text,
      mask: options.lock || true
    });
    
    return {
      close: () => {
        uni.hideLoading();
      }
    };
  }
};

// 表单校验规则
export const ElFormRules = {
  // 必填
  required: (message = '该字段为必填项') => ({
    required: true,
    message,
    trigger: ['blur', 'change']
  }),
  
  // 最小长度
  minLength: (min, message) => ({
    min,
    message: message || `长度不能少于${min}个字符`,
    trigger: ['blur', 'change']
  }),
  
  // 最大长度
  maxLength: (max, message) => ({
    max,
    message: message || `长度不能超过${max}个字符`,
    trigger: ['blur', 'change']
  }),
  
  // 手机号验证
  phone: (message = '请输入正确的手机号码') => ({
    pattern: /^1[3-9]\d{9}$/,
    message,
    trigger: ['blur', 'change']
  }),
  
  // 邮箱验证
  email: (message = '请输入正确的邮箱地址') => ({
    type: 'email',
    message,
    trigger: ['blur', 'change']
  })
};

export default {
  ElMessage,
  ElMessageBox,
  ElLoading,
  ElFormRules
}; 
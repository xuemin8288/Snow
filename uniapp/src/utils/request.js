import apiConfig from '../config/api.js';

// 请求拦截器
const requestInterceptor = (config) => {
  // 获取token
  const token = uni.getStorageSync('token');
  if (token) {
    config.header = {
      ...config.header,
      'token': token
    };
  }
  return config;
};

// 响应拦截器
const responseInterceptor = (response) => {
  // 统一处理响应
  if (response.statusCode === 200) {
    // 业务状态码处理
    if (response.data.code === 401) {
      // token失效，清除登录状态并跳转到登录页
      uni.removeStorageSync('token');
      uni.removeStorageSync('userInfo');
      uni.showToast({
        title: '登录已过期，请重新登录',
        icon: 'none'
      });
      setTimeout(() => {
        uni.reLaunch({
          url: '/pages/login/login'
        });
      }, 1500);
      return Promise.reject(response.data);
    }
    return response.data;
  } else {
    // HTTP错误状态码处理
    uni.showToast({
      title: `请求失败: ${response.statusCode}`,
      icon: 'none'
    });
    return Promise.reject(response);
  }
};

// 错误处理
const errorHandler = (error) => {
  uni.showToast({
    title: '网络错误，请稍后再试',
    icon: 'none'
  });
  return Promise.reject(error);
};

// 封装请求方法
const request = (options) => {
  // 构建完整URL
  const url = options.url.startsWith('http') 
    ? options.url 
    : `${apiConfig.baseUrl}${options.url}`;
  
  // 应用请求拦截器
  let config = {
    ...options,
    url
  };
  config = requestInterceptor(config);
  
  // 发起请求
  return new Promise((resolve, reject) => {
    uni.request({
      ...config,
      success: (res) => {
        try {
          const result = responseInterceptor(res);
          resolve(result);
        } catch (error) {
          reject(error);
        }
      },
      fail: (err) => {
        errorHandler(err);
        reject(err);
      }
    });
  });
};

// 封装常用请求方法
export default {
  get: (url, data = {}, options = {}) => {
    return request({
      url,
      data,
      method: 'GET',
      ...options
    });
  },
  post: (url, data = {}, options = {}) => {
    return request({
      url,
      data,
      method: 'POST',
      ...options
    });
  },
  put: (url, data = {}, options = {}) => {
    return request({
      url,
      data,
      method: 'PUT',
      ...options
    });
  },
  delete: (url, data = {}, options = {}) => {
    return request({
      url,
      data,
      method: 'DELETE',
      ...options
    });
  }
}; 
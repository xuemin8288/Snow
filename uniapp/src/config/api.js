// API配置文件
const isDev = process.env.NODE_ENV === 'development';

// 开发环境和生产环境的API地址
const API_BASE = {
  development: 'http://localhost:9090',
  production: 'https://api.example.com'
};

export default {
  baseUrl: isDev ? API_BASE.development : API_BASE.production,
  
  // 用户相关接口
  user: {
    register: '/register',
    login: '/login',
    getUserInfo: '/user/getUserInfo',
    updateUserInfo: '/user/updateUserInfo',
    getMyCollections: '/user/collections',
    addCollection: '/user/collection/add',
    removeCollection: '/user/collection/remove'
  },
  
  // 高血压测评相关接口
  assessment: {
    // TestPaper相关接口
    getTestPaperList: '/testPaper/selectAll',
    getTestPaperListDesc: '/testPaper/selectAllDesc',
    getTestPaperById: '/testPaper/selectById',
    getTestPaperPage: '/testPaper/selectPage',
    addTestPaper: '/testPaper/add',
    updateTestPaper: '/testPaper/update',
    deleteTestPaper: '/testPaper/delete',
    deleteTestPaperBatch: '/testPaper/delete/batch',
    
    // TestRecord相关接口
    getRecordList: '/testRecord/selectAll',
    getRecordById: '/testRecord/selectById',
    getRecordPage: '/testRecord/selectPage',
    addRecord: '/testRecord/add',
    updateRecord: '/testRecord/update',
    deleteRecord: '/testRecord/delete',
    deleteRecordBatch: '/testRecord/delete/batch',
    
    // TypeAddMap相关接口
    getAllTypeAddMaps: '/typeaddmap/all',
    getUniqueAddresses: '/typeaddmap/uniqueAddresses',
    getTypeAddMapPage: '/typeaddmap/selectPage'
  },
  
  // 预约相关接口
  appointment: {
    create: '/appointment/create',
    list: '/appointment/list',
    cancel: '/appointment/cancel',
    approve: '/appointment/approve',
    getDoctorList: '/doctor/list',
    getDoctorDetail: '/doctor/detail',
    getMyAppointments: '/appointment/my-appointments'
  },
  
  // 健康知识相关接口
  knowledge: {
    list: '/knowledge/list',
    detail: '/knowledge/detail',
    getCategories: '/knowledge/categories'
  },
  
  // 系统设置
  system: {
    getBanner: '/system/banner',
    getAnnouncement: '/system/announcement',
    feedback: '/system/feedback'
  }
} 
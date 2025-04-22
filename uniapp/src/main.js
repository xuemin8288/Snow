import {
	createSSRApp
} from "vue";
import App from "./App.vue";
// 不再引入Element Plus组件库
// import ElementPlus from 'element-plus';
// 仅使用我们自定义的Element Plus样式
import './uni_modules/element-plus/styles/index.scss';
// Element组件适配工具
import ElementAdapter from './utils/element-adapter';

export function createApp() {
	const app = createSSRApp(App);
	
	// 不再使用Element Plus组件库
	// app.use(ElementPlus);
	
	// 全局注册Element适配器
	app.config.globalProperties.$ELEMENT = {
		size: 'small', // 设置默认组件大小
	};
	app.config.globalProperties.$message = ElementAdapter.ElMessage;
	app.config.globalProperties.$msgbox = ElementAdapter.ElMessageBox;
	app.config.globalProperties.$loading = ElementAdapter.ElLoading;
	
	return {
		app,
	};
}

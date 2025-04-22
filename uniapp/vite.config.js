import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    uni(),
  ],
  css: {
    preprocessorOptions: {
      scss: {
        // 移除这里对element-theme.scss的全局引用，避免循环引用
        // 我们将在需要的地方手动引入
        additionalData: ``
      }
    }
  },
  server: {
    port: 5174,
    host: true,
    open: true
  }
})

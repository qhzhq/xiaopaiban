<script setup lang="ts">
import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'

onLaunch(() => {
  console.log('App Launch')
  // 初始化应用设置
  initAppSettings()
})

onShow(() => {
  console.log('App Show')
})

onHide(() => {
  console.log('App Hide')
})

// 初始化应用设置
function initAppSettings() {
  // 从本地存储加载设置
  const settings = uni.getStorageSync('appSettings')
  if (settings) {
    // 应用保存的设置
    console.log('加载已保存的设置:', settings)
  } else {
    // 使用默认设置
    const defaultSettings = {
      indentation: 2,
      spaces: 0,
      lineBreaks: 1,
      fullHalf: 1,
      punctuation: 1,
      wave: 0,
      theme: 'auto',
      fontSize: 14,
      autoTypeset: true,
      showLineNumbers: false,
      wordWrap: true,
      syncScroll: true,
      autoSave: true,
      lastPreset: ''
    }
    uni.setStorageSync('appSettings', defaultSettings)
    console.log('使用默认设置')
  }
}
</script>

<style>
/* 全局样式 */
page {
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display",
               "Helvetica Neue", "PingFang SC", "Noto Sans SC", sans-serif;
  font-size: 14px;
  line-height: 1.5;
  color: #1d1d1f;
  background-color: #f5f5f7;
}

/* 暗色主题 */
page.dark-theme {
  color: #f5f5f7;
  background-color: #1c1c1e;
}

/* 自动主题 */
@media (prefers-color-scheme: dark) {
  page.auto-theme {
    color: #f5f5f7;
    background-color: #1c1c1e;
  }
}

/* 全局组件样式 */
.container {
  width: 100%;
  min-height: 100vh;
  padding: 0;
  margin: 0;
}

/* 工具类 */
.text-primary {
  color: #1d1d1f;
}

.text-secondary {
  color: #6e6e73;
}

.text-accent {
  color: #007aff;
}

.bg-primary {
  background-color: #ffffff;
}

.bg-secondary {
  background-color: #f5f5f7;
}

/* 按钮样式 */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s ease;
}

.btn-primary {
  background-color: #007aff;
  color: #ffffff;
}

.btn-primary:hover {
  background-color: #0062cc;
}

.btn-secondary {
  background-color: #e5e5ea;
  color: #1d1d1f;
}

.btn-secondary:hover {
  background-color: #d1d1d6;
}

/* 输入框样式 */
.input {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #d1d1d6;
  border-radius: 6px;
  font-size: 14px;
  color: #1d1d1f;
  background-color: #ffffff;
  transition: border-color 0.15s ease;
}

.input:focus {
  border-color: #007aff;
  outline: none;
}

/* 文本域样式 */
.textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #d1d1d6;
  border-radius: 6px;
  font-size: 14px;
  color: #1d1d1f;
  background-color: #ffffff;
  resize: vertical;
  min-height: 200px;
  transition: border-color 0.15s ease;
}

.textarea:focus {
  border-color: #007aff;
  outline: none;
}

/* 卡片样式 */
.card {
  background-color: #ffffff;
  border-radius: 10px;
  padding: 16px;
  margin-bottom: 12px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

/* 分割线 */
.divider {
  height: 1px;
  background-color: #e5e5ea;
  margin: 12px 0;
}

/* 工具栏 */
.toolbar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background-color: #ffffff;
  border-bottom: 1px solid #e5e5ea;
}

/* 设置面板 */
.settings-panel {
  background-color: #ffffff;
  border-radius: 10px;
  padding: 16px;
  margin: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* 暗色主题覆盖 */
.dark-theme .card,
.dark-theme .toolbar,
.dark-theme .settings-panel,
.dark-theme .input,
.dark-theme .textarea {
  background-color: #2c2c2e;
  border-color: #48484a;
  color: #f5f5f7;
}

.dark-theme .btn-secondary {
  background-color: #3a3a3c;
  color: #f5f5f7;
}

.dark-theme .btn-secondary:hover {
  background-color: #48484a;
}

.dark-theme .divider {
  background-color: #48484a;
}

/* 自动主题覆盖 */
@media (prefers-color-scheme: dark) {
  .auto-theme .card,
  .auto-theme .toolbar,
  .auto-theme .settings-panel,
  .auto-theme .input,
  .auto-theme .textarea {
    background-color: #2c2c2e;
    border-color: #48484a;
    color: #f5f5f7;
  }

  .auto-theme .btn-secondary {
    background-color: #3a3a3c;
    color: #f5f5f7;
  }

  .auto-theme .btn-secondary:hover {
    background-color: #48484a;
  }

  .auto-theme .divider {
    background-color: #48484a;
  }
}
</style>
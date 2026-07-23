<template>
  <view class="container" :class="themeClass">
    <!-- 标题栏 -->
    <view class="titlebar">
      <view class="titlebar-left">
        <text class="app-title">小排版</text>
        <text class="app-version">v2.0.1</text>
      </view>
      <view class="titlebar-right">
        <view class="titlebar-btn" @click="toggleTheme">
          <text class="icon">{{ themeIcon }}</text>
        </view>
        <view class="titlebar-btn" @click="toggleSettings">
          <text class="icon">⚙️</text>
        </view>
        <view class="titlebar-btn" @click="showAbout">
          <text class="icon">ℹ️</text>
        </view>
      </view>
    </view>

    <!-- 工具栏 -->
    <view class="toolbar">
      <view class="toolbar-left">
        <button class="toolbar-btn" @click="typesetText" :disabled="!hasText">
          <text class="btn-icon">🔄</text>
          <text class="btn-text">排版</text>
        </button>
        <button class="toolbar-btn" @click="copyResult" :disabled="!hasResult">
          <text class="btn-icon">📋</text>
          <text class="btn-text">复制</text>
        </button>
        <button class="toolbar-btn" @click="clearText">
          <text class="btn-icon">🗑️</text>
          <text class="btn-text">清空</text>
        </button>
      </view>
      <view class="toolbar-right">
        <button class="toolbar-btn" @click="showExportDialog = true" :disabled="!hasResult">
          <text class="btn-icon">💾</text>
          <text class="btn-text">导出</text>
        </button>
        <button class="toolbar-btn" @click="showImportDialog = true">
          <text class="btn-icon">📂</text>
          <text class="btn-text">导入</text>
        </button>
      </view>
    </view>

    <!-- 主内容区 -->
    <view class="main-content">
      <!-- 左侧输入区 -->
      <view class="input-panel">
        <view class="panel-header">
          <text class="panel-title">原始文本</text>
          <view class="panel-actions">
            <text class="char-count">{{ charCount }} 字</text>
            <button class="action-btn" @click="pasteText">
              <text class="icon">📥</text>
            </button>
          </view>
        </view>
        <textarea
          class="text-input"
          v-model="inputText"
          placeholder="请输入要排版的文本..."
          :maxlength="-1"
          @input="onInputChange"
          @blur="onInputBlur"
        ></textarea>
      </view>

      <!-- 右侧输出区 -->
      <view class="output-panel">
        <view class="panel-header">
          <text class="panel-title">排版结果</text>
          <view class="panel-actions">
            <text class="char-count">{{ resultCharCount }} 字</text>
            <button class="action-btn" @click="copyResult" :disabled="!hasResult">
              <text class="icon">📋</text>
            </button>
          </view>
        </view>
        <textarea
          class="text-output"
          v-model="outputText"
          placeholder="排版结果将显示在这里..."
          :disabled="true"
        ></textarea>
      </view>
    </view>

    <!-- 状态栏 -->
    <view class="statusbar">
      <view class="status-left">
        <text class="status-item">字数: {{ charCount }}</text>
        <text class="status-item">行数: {{ lineCount }}</text>
        <text class="status-item">段落: {{ paragraphCount }}</text>
      </view>
      <view class="status-right">
        <text class="status-item">预设: {{ currentPresetName }}</text>
        <text class="status-item">主题: {{ themeName }}</text>
      </view>
    </view>

    <!-- 设置面板 -->
    <view class="settings-overlay" v-if="showSettings" @click="toggleSettings">
      <view class="settings-panel" @click.stop>
        <view class="settings-header">
          <text class="settings-title">排版设置</text>
          <button class="close-btn" @click="toggleSettings">
            <text class="icon">✕</text>
          </button>
        </view>
        
        <scroll-view class="settings-content" scroll-y="true">
          <!-- 预设选择 -->
          <view class="settings-section">
            <text class="section-title">快速预设</text>
            <view class="preset-grid">
              <view
                class="preset-item"
                v-for="preset in presetsList"
                :key="preset.id"
                :class="{ active: currentPreset === preset.id }"
                @click="applyPreset(preset.id)"
              >
                <text class="preset-icon">{{ preset.icon }}</text>
                <text class="preset-name">{{ preset.name }}</text>
              </view>
            </view>
          </view>

          <!-- 排版参数 -->
          <view class="settings-section">
            <text class="section-title">排版参数</text>
            
            <view class="setting-item">
              <text class="setting-label">段首缩进</text>
              <view class="setting-control">
                <slider
                  :value="settings.indentation"
                  :min="0"
                  :max="8"
                  :step="1"
                  @change="updateSetting('indentation', $event.detail.value)"
                />
                <text class="setting-value">{{ settings.indentation }} 字符</text>
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">段间空行</text>
              <view class="setting-control">
                <slider
                  :value="settings.spaces"
                  :min="0"
                  :max="3"
                  :step="1"
                  @change="updateSetting('spaces', $event.detail.value)"
                />
                <text class="setting-value">{{ settings.spaces }} 行</text>
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">段内换行</text>
              <view class="setting-control">
                <slider
                  :value="settings.lineBreaks"
                  :min="1"
                  :max="5"
                  :step="1"
                  @change="updateSetting('lineBreaks', $event.detail.value)"
                />
                <text class="setting-value">{{ settings.lineBreaks }} 模式</text>
              </view>
            </view>
          </view>

          <!-- 转换选项 -->
          <view class="settings-section">
            <text class="section-title">转换选项</text>
            
            <view class="setting-item">
              <text class="setting-label">全角半角</text>
              <view class="setting-control">
                <picker
                  :value="settings.fullHalf"
                  :range="fullHalfOptions"
                  range-key="label"
                  @change="updateSetting('fullHalf', $event.detail.value)"
                >
                  <view class="picker-value">
                    <text>{{ fullHalfOptions[settings.fullHalf].label }}</text>
                    <text class="picker-arrow">▼</text>
                  </view>
                </picker>
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">标点修正</text>
              <view class="setting-control">
                <picker
                  :value="settings.punctuation"
                  :range="punctuationOptions"
                  range-key="label"
                  @change="updateSetting('punctuation', $event.detail.value)"
                >
                  <view class="picker-value">
                    <text>{{ punctuationOptions[settings.punctuation].label }}</text>
                    <text class="picker-arrow">▼</text>
                  </view>
                </picker>
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">波浪线修正</text>
              <view class="setting-control">
                <picker
                  :value="settings.wave"
                  :range="waveOptions"
                  range-key="label"
                  @change="updateSetting('wave', $event.detail.value)"
                >
                  <view class="picker-value">
                    <text>{{ waveOptions[settings.wave].label }}</text>
                    <text class="picker-arrow">▼</text>
                  </view>
                </picker>
              </view>
            </view>
          </view>

          <!-- 显示选项 -->
          <view class="settings-section">
            <text class="section-title">显示选项</text>
            
            <view class="setting-item">
              <text class="setting-label">主题</text>
              <view class="setting-control">
                <picker
                  :value="themeIndex"
                  :range="themeOptions"
                  range-key="label"
                  @change="updateTheme($event.detail.value)"
                >
                  <view class="picker-value">
                    <text>{{ themeOptions[themeIndex].label }}</text>
                    <text class="picker-arrow">▼</text>
                  </view>
                </picker>
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">字体大小</text>
              <view class="setting-control">
                <slider
                  :value="settings.fontSize"
                  :min="12"
                  :max="20"
                  :step="1"
                  @change="updateSetting('fontSize', $event.detail.value)"
                />
                <text class="setting-value">{{ settings.fontSize }}px</text>
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">自动排版</text>
              <view class="setting-control">
                <switch
                  :checked="settings.autoTypeset"
                  @change="updateSetting('autoTypeset', $event.detail.value)"
                />
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">显示行号</text>
              <view class="setting-control">
                <switch
                  :checked="settings.showLineNumbers"
                  @change="updateSetting('showLineNumbers', $event.detail.value)"
                />
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">自动换行</text>
              <view class="setting-control">
                <switch
                  :checked="settings.wordWrap"
                  @change="updateSetting('wordWrap', $event.detail.value)"
                />
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">同步滚动</text>
              <view class="setting-control">
                <switch
                  :checked="settings.syncScroll"
                  @change="updateSetting('syncScroll', $event.detail.value)"
                />
              </view>
            </view>

            <view class="setting-item">
              <text class="setting-label">自动保存</text>
              <view class="setting-control">
                <switch
                  :checked="settings.autoSave"
                  @change="updateSetting('autoSave', $event.detail.value)"
                />
              </view>
            </view>
          </view>
        </scroll-view>

        <view class="settings-footer">
          <button class="btn btn-secondary" @click="resetSettings">
            <text class="btn-text">重置默认</text>
          </button>
          <button class="btn btn-primary" @click="toggleSettings">
            <text class="btn-text">完成</text>
          </button>
        </view>
      </view>
    </view>

    <!-- 导出对话框 -->
    <view class="dialog-overlay" v-if="showExportDialog" @click="showExportDialog = false">
      <view class="dialog" @click.stop>
        <view class="dialog-header">
          <text class="dialog-title">导出排版结果</text>
          <button class="close-btn" @click="showExportDialog = false">
            <text class="icon">✕</text>
          </button>
        </view>
        
        <view class="dialog-content">
          <view class="export-options">
            <button class="export-btn" @click="exportResult('txt')">
              <text class="export-icon">📄</text>
              <text class="export-text">TXT 文本</text>
            </button>
            <button class="export-btn" @click="exportResult('md')">
              <text class="export-icon">📝</text>
              <text class="export-text">Markdown</text>
            </button>
            <button class="export-btn" @click="exportResult('html')">
              <text class="export-icon">🌐</text>
              <text class="export-text">HTML</text>
            </button>
          </view>
        </view>
      </view>
    </view>

    <!-- 导入对话框 -->
    <view class="dialog-overlay" v-if="showImportDialog" @click="showImportDialog = false">
      <view class="dialog" @click.stop>
        <view class="dialog-header">
          <text class="dialog-title">导入文本</text>
          <button class="close-btn" @click="showImportDialog = false">
            <text class="icon">✕</text>
          </button>
        </view>
        
        <view class="dialog-content">
          <view class="import-options">
            <button class="import-btn" @click="importFromClipboard">
              <text class="import-icon">📋</text>
              <text class="import-text">从剪贴板导入</text>
            </button>
            <button class="import-btn" @click="importFromFile">
              <text class="import-icon">📂</text>
              <text class="import-text">从文件导入</text>
            </button>
          </view>
        </view>
      </view>
    </view>

    <!-- 关于对话框 -->
    <view class="dialog-overlay" v-if="showAboutDialog" @click="showAboutDialog = false">
      <view class="dialog" @click.stop>
        <view class="dialog-header">
          <text class="dialog-title">关于小排版</text>
          <button class="close-btn" @click="showAboutDialog = false">
            <text class="icon">✕</text>
          </button>
        </view>
        
        <view class="dialog-content">
          <view class="about-content">
            <text class="app-logo">📖</text>
            <text class="app-name">小排版</text>
            <text class="app-version">版本 2.0.1</text>
            <text class="app-description">一款简洁好用的文本排版工具</text>
            <text class="app-copyright">© 2024-2026 互联网互助联盟</text>
            
            <view class="about-links">
              <button class="link-btn" @click="openWebsite">
                <text class="link-text">官方网站</text>
              </button>
              <button class="link-btn" @click="openGithub">
                <text class="link-text">开源地址</text>
              </button>
              <button class="link-btn" @click="showPrivacy">
                <text class="link-text">隐私政策</text>
              </button>
              <button class="link-btn" @click="showTerms">
                <text class="link-text">服务条款</text>
              </button>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 加载提示 -->
    <view class="loading-overlay" v-if="isLoading">
      <view class="loading-spinner">
        <text class="loading-text">排版中...</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useAppStore } from '@/store'
import { copyToClipboard, showToast, showConfirm } from '@/utils'
import type { AppSettings, Preset } from '@/types'

// 使用状态管理
const store = useAppStore()

// 响应式数据
const inputText = ref('')
const outputText = ref('')
const showSettings = ref(false)
const showExportDialog = ref(false)
const showImportDialog = ref(false)
const showAboutDialog = ref(false)

// 计算属性
const settings = computed(() => store.settings)
const isLoading = computed(() => store.isLoading)
const hasText = computed(() => inputText.value.trim().length > 0)
const hasResult = computed(() => outputText.value.trim().length > 0)
const charCount = computed(() => inputText.value.length)
const resultCharCount = computed(() => outputText.value.length)
const lineCount = computed(() => {
  if (!inputText.value) return 0
  return inputText.value.split('\n').length
})
const paragraphCount = computed(() => {
  if (!inputText.value) return 0
  return inputText.value.split(/\n\s*\n/).filter(p => p.trim().length > 0).length
})

const currentPreset = computed(() => store.currentPreset)
const currentPresetName = computed(() => {
  const preset = store.presetsList.find(p => p.id === currentPreset.value)
  return preset ? preset.name : '自定义'
})

const themeClass = computed(() => {
  if (settings.value.theme === 'auto') {
    return 'auto-theme'
  }
  return settings.value.theme === 'dark' ? 'dark-theme' : ''
})

const themeIcon = computed(() => {
  switch (settings.value.theme) {
    case 'light': return '☀️'
    case 'dark': return '🌙'
    case 'auto': return '🔄'
    default: return '☀️'
  }
})

const themeName = computed(() => {
  switch (settings.value.theme) {
    case 'light': return '亮色'
    case 'dark': return '暗色'
    case 'auto': return '自动'
    default: return '亮色'
  }
})

const themeIndex = computed(() => {
  switch (settings.value.theme) {
    case 'light': return 0
    case 'dark': return 1
    case 'auto': return 2
    default: return 0
  }
})

const presetsList = computed(() => store.presetsList)

// 选项数据
const fullHalfOptions = [
  { label: '不转换', value: 0 },
  { label: '数字', value: 1 },
  { label: '字母', value: 2 },
  { label: '标点', value: 3 },
  { label: '空格', value: 4 },
  { label: '全部', value: 5 }
]

const punctuationOptions = [
  { label: '不转换', value: 0 },
  { label: '，。→，。', value: 1 },
  { label: '，.→，。', value: 2 },
  { label: '，。→,.', value: 3 },
  { label: ',.→,.', value: 4 }
]

const waveOptions = [
  { label: '不转换', value: 0 },
  { label: '～→~', value: 1 },
  { label: '～→—', value: 2 },
  { label: '~→～', value: 3 },
  { label: '~→—', value: 4 }
]

const themeOptions = [
  { label: '亮色', value: 'light' },
  { label: '暗色', value: 'dark' },
  { label: '自动', value: 'auto' }
]

// 方法
function typesetText() {
  if (!inputText.value.trim()) {
    showToast('请输入要排版的文本')
    return
  }
  
  store.setText(inputText.value)
  store.typeset()
  outputText.value = store.result
}

function copyResult() {
  if (!outputText.value) {
    showToast('没有可复制的内容')
    return
  }
  
  copyToClipboard(outputText.value)
}

function clearText() {
  inputText.value = ''
  outputText.value = ''
  store.clearText()
}

function pasteText() {
  uni.getClipboardData({
    success: (res) => {
      if (res.data) {
        inputText.value = res.data
        showToast('已粘贴文本')
      }
    }
  })
}

function exportResult(format: string) {
  store.exportResult(format)
  showExportDialog.value = false
}

function importFromClipboard() {
  uni.getClipboardData({
    success: (res) => {
      if (res.data) {
        inputText.value = res.data
        store.importText(res.data)
        showToast('已导入文本')
      }
    }
  })
  showImportDialog.value = false
}

function importFromFile() {
  // #ifdef H5
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = '.txt,.md,.html'
  input.onchange = (e) => {
    const file = (e.target as HTMLInputElement).files?.[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (event) => {
        const content = event.target?.result as string
        inputText.value = content
        store.importText(content)
        showToast('已导入文件')
      }
      reader.readAsText(file)
    }
  }
  input.click()
  // #endif
  
  // #ifndef H5
  uni.showToast({
    title: '文件导入仅支持H5端',
    icon: 'none'
  })
  // #endif
  
  showImportDialog.value = false
}

function toggleSettings() {
  showSettings.value = !showSettings.value
}

function toggleTheme() {
  store.toggleTheme()
}

function updateSetting(key: keyof AppSettings, value: any) {
  store.updateSettings({ [key]: value })
}

function updateTheme(index: number) {
  const theme = themeOptions[index].value as 'light' | 'dark' | 'auto'
  store.updateSettings({ theme })
}

function resetSettings() {
  store.resetSettings()
  showToast('已重置为默认设置')
}

function showAbout() {
  showAboutDialog.value = true
}

function openWebsite() {
  // #ifdef H5
  window.open('https://hulian.pro', '_blank')
  // #endif
}

function openGithub() {
  // #ifdef H5
  window.open('https://github.com/qhzhq/xiaopaiban', '_blank')
  // #endif
}

function showPrivacy() {
  // #ifdef H5
  window.open('https://hulian.pro/privacy', '_blank')
  // #endif
}

function showTerms() {
  // #ifdef H5
  window.open('https://hulian.pro/terms', '_blank')
  // #endif
}

function onInputChange(e: any) {
  // 输入变化时的处理
}

function onInputBlur() {
  // 输入框失焦时的处理
}

// 监听store变化
watch(() => store.result, (newResult) => {
  outputText.value = newResult
})

// 生命周期
onMounted(() => {
  store.init()
  
  // 加载保存的设置
  if (store.settings.lastPreset) {
    store.applyPreset(store.settings.lastPreset)
  }
})
</script>

<style scoped>
/* 容器样式 */
.container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: var(--mac-bg);
  color: var(--mac-text-primary);
  font-family: var(--mac-font);
}

/* 标题栏 */
.titlebar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 38px;
  padding: 0 12px;
  background-color: var(--mac-titlebar-bg);
  border-bottom: 1px solid var(--mac-border);
  -webkit-app-region: drag;
}

.titlebar-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.app-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--mac-text-primary);
}

.app-version {
  font-size: 11px;
  color: var(--mac-text-secondary);
}

.titlebar-right {
  display: flex;
  align-items: center;
  gap: 4px;
  -webkit-app-region: no-drag;
}

.titlebar-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.titlebar-btn:hover {
  background-color: var(--mac-surface-secondary);
}

/* 工具栏 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 40px;
  padding: 0 12px;
  background-color: var(--mac-surface);
  border-bottom: 1px solid var(--mac-border);
}

.toolbar-left,
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.toolbar-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  background-color: transparent;
  color: var(--mac-text-primary);
  font-size: 12px;
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.toolbar-btn:hover {
  background-color: var(--mac-surface-secondary);
}

.toolbar-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-icon {
  font-size: 14px;
}

.btn-text {
  font-size: 12px;
}

/* 主内容区 */
.main-content {
  display: flex;
  flex: 1;
  gap: 12px;
  padding: 12px;
  overflow: hidden;
}

.input-panel,
.output-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  background-color: var(--mac-surface);
  border-radius: 10px;
  box-shadow: var(--mac-shadow-sm);
  overflow: hidden;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 12px;
  border-bottom: 1px solid var(--mac-border);
}

.panel-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--mac-text-primary);
}

.panel-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.char-count {
  font-size: 11px;
  color: var(--mac-text-secondary);
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border: none;
  border-radius: 4px;
  background-color: transparent;
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.action-btn:hover {
  background-color: var(--mac-surface-secondary);
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.text-input,
.text-output {
  flex: 1;
  padding: 12px;
  border: none;
  background-color: transparent;
  color: var(--mac-text-primary);
  font-size: 14px;
  line-height: 1.5;
  resize: none;
  outline: none;
}

.text-input::placeholder,
.text-output::placeholder {
  color: var(--mac-text-tertiary);
}

.text-output {
  background-color: var(--mac-surface-secondary);
}

/* 状态栏 */
.statusbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 24px;
  padding: 0 12px;
  background-color: var(--mac-surface);
  border-top: 1px solid var(--mac-border);
  font-size: 11px;
  color: var(--mac-text-secondary);
}

.status-left,
.status-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.status-item {
  font-size: 11px;
}

/* 设置面板 */
.settings-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.settings-panel {
  width: 90%;
  max-width: 400px;
  max-height: 80vh;
  background-color: var(--mac-surface);
  border-radius: 12px;
  box-shadow: var(--mac-shadow-lg);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.settings-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid var(--mac-border);
}

.settings-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--mac-text-primary);
}

.close-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  border: none;
  border-radius: 6px;
  background-color: transparent;
  cursor: pointer;
  transition: background-color 0.15s ease;
}

.close-btn:hover {
  background-color: var(--mac-surface-secondary);
}

.settings-content {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
}

.settings-section {
  margin-bottom: 20px;
}

.section-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--mac-text-secondary);
  margin-bottom: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.preset-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.preset-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 12px 8px;
  border: 1px solid var(--mac-border);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.15s ease;
}

.preset-item:hover {
  border-color: var(--mac-accent);
  background-color: var(--mac-surface-secondary);
}

.preset-item.active {
  border-color: var(--mac-accent);
  background-color: rgba(0, 122, 255, 0.1);
}

.preset-icon {
  font-size: 20px;
}

.preset-name {
  font-size: 12px;
  color: var(--mac-text-primary);
  text-align: center;
}

.setting-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid var(--mac-border);
}

.setting-label {
  font-size: 14px;
  color: var(--mac-text-primary);
}

.setting-control {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 150px;
}

.setting-value {
  font-size: 12px;
  color: var(--mac-text-secondary);
  min-width: 50px;
  text-align: right;
}

.picker-value {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 10px;
  border: 1px solid var(--mac-border);
  border-radius: 6px;
  background-color: var(--mac-surface-secondary);
  cursor: pointer;
}

.picker-arrow {
  font-size: 10px;
  color: var(--mac-text-secondary);
}

.settings-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px;
  border-top: 1px solid var(--mac-border);
}

/* 按钮样式 */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s ease;
}

.btn-primary {
  background-color: var(--mac-accent);
  color: #ffffff;
}

.btn-primary:hover {
  background-color: var(--mac-accent-hover);
}

.btn-secondary {
  background-color: var(--mac-surface-secondary);
  color: var(--mac-text-primary);
}

.btn-secondary:hover {
  background-color: var(--mac-surface-tertiary);
}

/* 对话框 */
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.dialog {
  width: 90%;
  max-width: 360px;
  background-color: var(--mac-surface);
  border-radius: 12px;
  box-shadow: var(--mac-shadow-lg);
  overflow: hidden;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid var(--mac-border);
}

.dialog-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--mac-text-primary);
}

.dialog-content {
  padding: 16px;
}

/* 导出选项 */
.export-options {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.export-btn {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  border: 1px solid var(--mac-border);
  border-radius: 8px;
  background-color: transparent;
  cursor: pointer;
  transition: all 0.15s ease;
}

.export-btn:hover {
  border-color: var(--mac-accent);
  background-color: var(--mac-surface-secondary);
}

.export-icon {
  font-size: 24px;
}

.export-text {
  font-size: 16px;
  color: var(--mac-text-primary);
}

/* 导入选项 */
.import-options {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.import-btn {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  border: 1px solid var(--mac-border);
  border-radius: 8px;
  background-color: transparent;
  cursor: pointer;
  transition: all 0.15s ease;
}

.import-btn:hover {
  border-color: var(--mac-accent);
  background-color: var(--mac-surface-secondary);
}

.import-icon {
  font-size: 24px;
}

.import-text {
  font-size: 16px;
  color: var(--mac-text-primary);
}

/* 关于内容 */
.about-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 20px 0;
}

.app-logo {
  font-size: 48px;
}

.app-name {
  font-size: 20px;
  font-weight: 600;
  color: var(--mac-text-primary);
}

.app-version {
  font-size: 14px;
  color: var(--mac-text-secondary);
}

.app-description {
  font-size: 14px;
  color: var(--mac-text-secondary);
  text-align: center;
}

.app-copyright {
  font-size: 12px;
  color: var(--mac-text-tertiary);
  margin-top: 20px;
}

.about-links {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 12px;
  margin-top: 20px;
}

.link-btn {
  padding: 8px 16px;
  border: 1px solid var(--mac-border);
  border-radius: 6px;
  background-color: transparent;
  cursor: pointer;
  transition: all 0.15s ease;
}

.link-btn:hover {
  border-color: var(--mac-accent);
  background-color: var(--mac-surface-secondary);
}

.link-text {
  font-size: 14px;
  color: var(--mac-accent);
}

/* 加载提示 */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.loading-spinner {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 24px;
  background-color: var(--mac-surface);
  border-radius: 12px;
  box-shadow: var(--mac-shadow-lg);
}

.loading-text {
  font-size: 16px;
  color: var(--mac-text-primary);
}

/* 暗色主题 */
.dark-theme {
  --mac-bg: #1c1c1e;
  --mac-surface: #2c2c2e;
  --mac-surface-secondary: #3a3a3c;
  --mac-surface-tertiary: #2c2c2e;
  --mac-border: #48484a;
  --mac-border-focus: #0a84ff;
  --mac-text-primary: #f5f5f7;
  --mac-text-secondary: #98989d;
  --mac-text-tertiary: #636366;
  --mac-accent: #0a84ff;
  --mac-accent-hover: #409cff;
  --mac-accent-pressed: #0066cc;
  --mac-titlebar-bg: #2c2c2e;
  --mac-shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.2);
  --mac-shadow-md: 0 4px 12px rgba(0, 0, 0, 0.3);
  --mac-shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.4);
}

/* 自动主题 */
@media (prefers-color-scheme: dark) {
  .auto-theme {
    --mac-bg: #1c1c1e;
    --mac-surface: #2c2c2e;
    --mac-surface-secondary: #3a3a3c;
    --mac-surface-tertiary: #2c2c2e;
    --mac-border: #48484a;
    --mac-border-focus: #0a84ff;
    --mac-text-primary: #f5f5f7;
    --mac-text-secondary: #98989d;
    --mac-text-tertiary: #636366;
    --mac-accent: #0a84ff;
    --mac-accent-hover: #409cff;
    --mac-accent-pressed: #0066cc;
    --mac-titlebar-bg: #2c2c2e;
    --mac-shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.2);
    --mac-shadow-md: 0 4px 12px rgba(0, 0, 0, 0.3);
    --mac-shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.4);
  }
}
</style>
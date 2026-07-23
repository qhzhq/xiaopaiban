import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { AppSettings, TextStats, Preset, HistoryItem } from '@/types'

// 默认设置
const defaultSettings: AppSettings = {
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

// 预设配置
const presets: Preset[] = [
  {
    id: 'novel',
    name: '小说投稿',
    icon: '📖',
    description: '适合小说投稿的排版格式',
    settings: {
      indentation: 2,
      spaces: 0,
      lineBreaks: 1,
      fullHalf: 1,
      punctuation: 1,
      wave: 1
    }
  },
  {
    id: 'paper',
    name: '论文排版',
    icon: '📝',
    description: '学术论文标准排版格式',
    settings: {
      indentation: 2,
      spaces: 1,
      lineBreaks: 1,
      fullHalf: 1,
      punctuation: 1,
      wave: 0
    }
  },
  {
    id: 'wechat',
    name: '公众号排版',
    icon: '💬',
    description: '微信公众号文章排版',
    settings: {
      indentation: 0,
      spaces: 1,
      lineBreaks: 1,
      fullHalf: 1,
      punctuation: 1,
      wave: 0
    }
  },
  {
    id: 'clean',
    name: '纯文本清理',
    icon: '✨',
    description: '清理多余空格和特殊字符',
    settings: {
      indentation: 0,
      spaces: 0,
      lineBreaks: 1,
      fullHalf: 1,
      punctuation: 0,
      wave: 0
    }
  },
  {
    id: 'code',
    name: '代码注释',
    icon: '💻',
    description: '代码注释格式化',
    settings: {
      indentation: 2,
      spaces: 0,
      lineBreaks: 1,
      fullHalf: 0,
      punctuation: 0,
      wave: 0
    }
  },
  {
    id: 'custom',
    name: '自定义',
    icon: '⚙️',
    description: '自定义排版设置',
    settings: {}
  }
]

export const useAppStore = defineStore('app', () => {
  // 状态
  const settings = ref<AppSettings>({ ...defaultSettings })
  const text = ref<string>('')
  const result = ref<string>('')
  const stats = ref<TextStats>({
    characters: 0,
    charactersNoSpace: 0,
    words: 0,
    lines: 0,
    paragraphs: 0
  })
  const isLoading = ref<boolean>(false)
  const error = ref<string | null>(null)
  const currentPreset = ref<string | null>(null)
  const showSettings = ref<boolean>(false)
  const showExportDialog = ref<boolean>(false)
  const showImportDialog = ref<boolean>(false)
  const showAboutDialog = ref<boolean>(false)
  const showHelpDialog = ref<boolean>(false)
  const history = ref<HistoryItem[]>([])

  // 计算属性
  const wordCount = computed(() => stats.value.words)
  const charCount = computed(() => stats.value.characters)
  const lineCount = computed(() => stats.value.lines)
  const paragraphCount = computed(() => stats.value.paragraphs)
  
  const hasText = computed(() => text.value.trim().length > 0)
  const hasResult = computed(() => result.value.trim().length > 0)
  
  const currentTheme = computed(() => {
    if (settings.value.theme === 'auto') {
      // #ifdef H5
      return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
      // #endif
      // #ifndef H5
      return 'light'
      // #endif
    }
    return settings.value.theme
  })

  const presetsList = computed(() => presets)

  // 方法
  function updateSettings(newSettings: Partial<AppSettings>) {
    settings.value = { ...settings.value, ...newSettings }
    saveSettings()
  }

  function resetSettings() {
    settings.value = { ...defaultSettings }
    saveSettings()
  }

  function applyPreset(presetId: string) {
    const preset = presets.find(p => p.id === presetId)
    if (preset) {
      updateSettings(preset.settings)
      currentPreset.value = presetId
    }
  }

  function setText(newText: string) {
    text.value = newText
    updateStats()
    if (settings.value.autoTypeset) {
      typeset()
    }
  }

  function clearText() {
    text.value = ''
    result.value = ''
    stats.value = {
      characters: 0,
      charactersNoSpace: 0,
      words: 0,
      lines: 0,
      paragraphs: 0
    }
  }

  function typeset() {
    if (!text.value.trim()) {
      result.value = ''
      return
    }

    isLoading.value = true
    error.value = null

    try {
      // 这里调用排版逻辑
      const typesetText = performTypeset(text.value, settings.value)
      result.value = typesetText
      
      // 保存到历史记录
      addToHistory(text.value, typesetText)
    } catch (err) {
      error.value = err instanceof Error ? err.message : '排版失败'
      console.error('排版错误:', err)
    } finally {
      isLoading.value = false
    }
  }

  function performTypeset(text: string, settings: AppSettings): string {
    // 简化的排版逻辑，实际实现会更复杂
    let result = text
    
    // 1. 全角半角转换
    if (settings.fullHalf > 0) {
      result = convertFullHalf(result, settings.fullHalf)
    }
    
    // 2. 标点符号修正
    if (settings.punctuation > 0) {
      result = fixPunctuation(result, settings.punctuation)
    }
    
    // 3. 波浪线修正
    if (settings.wave > 0) {
      result = fixWave(result, settings.wave)
    }
    
    // 4. 段落缩进
    if (settings.indentation > 0) {
      result = addIndentation(result, settings.indentation)
    }
    
    // 5. 空行处理
    if (settings.spaces > 0) {
      result = addSpaces(result, settings.spaces)
    }
    
    // 6. 换行处理
    if (settings.lineBreaks > 1) {
      result = handleLineBreaks(result, settings.lineBreaks)
    }
    
    return result
  }

  function convertFullHalf(text: string, mode: number): string {
    // 全角半角转换逻辑
    // 1: 数字，2: 字母，3: 标点，4: 空格，5: 全部
    // 这里简化处理
    return text
  }

  function fixPunctuation(text: string, mode: number): string {
    // 标点符号修正逻辑
    // 1: ，。→，。, 2: ，.→，。, 3: ，。→,，. , 4: ,.→,.
    return text
  }

  function fixWave(text: string, mode: number): string {
    // 波浪线修正逻辑
    // 1: ～→~（全角→半角）, 2: ～→—（全角→破折号）, 3: ~→～（半角→全角）, 4: ~→—（半角→破折号）
    return text
  }

  function addIndentation(text: string, spaces: number): string {
    // 段落缩进逻辑
    const lines = text.split('\n')
    return lines.map(line => {
      if (line.trim()) {
        return '　'.repeat(spaces) + line
      }
      return line
    }).join('\n')
  }

  function addSpaces(text: string, lines: number): string {
    // 段间空行逻辑
    const paragraphs = text.split(/\n\s*\n/)
    return paragraphs.join('\n'.repeat(lines + 1))
  }

  function handleLineBreaks(text: string, mode: number): string {
    // 段内换行逻辑
    return text
  }

  function updateStats() {
    const content = text.value
    if (!content) {
      stats.value = {
        characters: 0,
        charactersNoSpace: 0,
        words: 0,
        lines: 0,
        paragraphs: 0
      }
      return
    }

    stats.value = {
      characters: content.length,
      charactersNoSpace: content.replace(/\s/g, '').length,
      words: content.trim().split(/\s+/).filter(w => w.length > 0).length,
      lines: content.split('\n').length,
      paragraphs: content.split(/\n\s*\n/).filter(p => p.trim().length > 0).length
    }
  }

  function addToHistory(originalText: string, typesetText: string) {
    const historyItem: HistoryItem = {
      id: Date.now().toString(),
      text: originalText,
      result: typesetText,
      settings: { ...settings.value },
      timestamp: Date.now(),
      preview: originalText.substring(0, 100) + (originalText.length > 100 ? '...' : '')
    }
    
    history.value.unshift(historyItem)
    
    // 最多保存50条历史记录
    if (history.value.length > 50) {
      history.value = history.value.slice(0, 50)
    }
    
    // 保存到本地存储
    saveHistory()
  }

  function clearHistory() {
    history.value = []
    uni.removeStorageSync('history')
  }

  function copyResult() {
    if (result.value) {
      uni.setClipboardData({
        data: result.value,
        success: () => {
          uni.showToast({
            title: '已复制到剪贴板',
            icon: 'success'
          })
        }
      })
    }
  }

  function exportResult(format: string = 'txt') {
    // 导出逻辑
    if (!result.value) return
    
    const filename = `排版结果_${new Date().toISOString().slice(0, 10)}.${format}`
    
    // #ifdef H5
    const blob = new Blob([result.value], { type: 'text/plain' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = filename
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
    // #endif
    
    // #ifndef H5
    uni.showToast({
      title: '导出功能仅支持H5端',
      icon: 'none'
    })
    // #endif
  }

  function importText(content: string) {
    setText(content)
  }

  function toggleSettings() {
    showSettings.value = !showSettings.value
  }

  function toggleTheme() {
    const themes: Array<'light' | 'dark' | 'auto'> = ['light', 'dark', 'auto']
    const currentIndex = themes.indexOf(settings.value.theme)
    const nextIndex = (currentIndex + 1) % themes.length
    updateSettings({ theme: themes[nextIndex] })
  }

  // 持久化
  function saveSettings() {
    uni.setStorageSync('appSettings', settings.value)
  }

  function loadSettings() {
    const savedSettings = uni.getStorageSync('appSettings')
    if (savedSettings) {
      settings.value = { ...defaultSettings, ...savedSettings }
    }
  }

  function saveHistory() {
    uni.setStorageSync('history', history.value)
  }

  function loadHistory() {
    const savedHistory = uni.getStorageSync('history')
    if (savedHistory) {
      history.value = savedHistory
    }
  }

  // 初始化
  function init() {
    loadSettings()
    loadHistory()
  }

  return {
    // 状态
    settings,
    text,
    result,
    stats,
    isLoading,
    error,
    currentPreset,
    showSettings,
    showExportDialog,
    showImportDialog,
    showAboutDialog,
    showHelpDialog,
    history,
    
    // 计算属性
    wordCount,
    charCount,
    lineCount,
    paragraphCount,
    hasText,
    hasResult,
    currentTheme,
    presetsList,
    
    // 方法
    updateSettings,
    resetSettings,
    applyPreset,
    setText,
    clearText,
    typeset,
    updateStats,
    addToHistory,
    clearHistory,
    copyResult,
    exportResult,
    importText,
    toggleSettings,
    toggleTheme,
    saveSettings,
    loadSettings,
    saveHistory,
    loadHistory,
    init
  }
})
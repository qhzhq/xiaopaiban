// 应用设置接口
export interface AppSettings {
  indentation: number  // 段首缩进字符数 (0-8)
  spaces: number       // 段间空行数 (0-3)
  lineBreaks: number   // 段内换行数 (1-5)
  fullHalf: number     // 全角半角 (0-5)
  punctuation: number  // 标点符号修正 (0-4)
  wave: number         // 波浪线修正 (0-4)
  theme: 'light' | 'dark' | 'auto'  // 主题
  fontSize: number     // 字体大小 (12-20)
  autoTypeset: boolean // 自动排版
  showLineNumbers: boolean // 显示行号
  wordWrap: boolean    // 自动换行
  syncScroll: boolean  // 同步滚动
  autoSave: boolean    // 自动保存
  lastPreset: string   // 最后使用的预设
}

// 预设配置接口
export interface Preset {
  id: string
  name: string
  icon: string
  description: string
  settings: Partial<AppSettings>
}

// 排版结果接口
export interface TypesetResult {
  text: string
  stats: {
    characters: number
    charactersNoSpace: number
    words: number
    lines: number
    paragraphs: number
  }
}

// 主题类型
export type ThemeType = 'light' | 'dark' | 'auto'

// 平台类型
export type PlatformType = 'h5' | 'mp-weixin' | 'mp-alipay' | 'mp-baidu' | 'app'

// 统计信息接口
export interface TextStats {
  characters: number
  charactersNoSpace: number
  words: number
  lines: number
  paragraphs: number
}

// 快捷键配置接口
export interface ShortcutConfig {
  key: string
  ctrlKey?: boolean
  shiftKey?: boolean
  altKey?: boolean
  metaKey?: boolean
  action: string
  description: string
}

// 导出格式
export type ExportFormat = 'txt' | 'md' | 'html' | 'docx'

// 导入选项
export interface ImportOptions {
  format: 'txt' | 'md' | 'html' | 'docx'
  encoding?: string
}

// 导出选项
export interface ExportOptions {
  format: ExportFormat
  filename?: string
  includeStats?: boolean
}

// 工具栏按钮
export interface ToolbarButton {
  id: string
  icon: string
  label: string
  action: string
  disabled?: boolean
  visible?: boolean
}

// 设置面板配置
export interface SettingsPanelConfig {
  showIndentation: boolean
  showSpaces: boolean
  showLineBreaks: boolean
  showFullHalf: boolean
  showPunctuation: boolean
  showWave: boolean
  showTheme: boolean
  showFontSize: boolean
  showAutoTypeset: boolean
  showLineNumbers: boolean
  showWordWrap: boolean
  showSyncScroll: boolean
  showAutoSave: boolean
}

// 页面配置
export interface PageConfig {
  title: string
  showToolbar: boolean
  showSettings: boolean
  showStats: boolean
  showExport: boolean
  showImport: boolean
}

// 应用状态
export interface AppState {
  settings: AppSettings
  text: string
  result: string
  stats: TextStats
  isLoading: boolean
  error: string | null
  currentPreset: string | null
  showSettings: boolean
  showExportDialog: boolean
  showImportDialog: boolean
  showAboutDialog: boolean
  showHelpDialog: boolean
}

// 事件类型
export interface AppEvent {
  type: 'typeset' | 'reset' | 'copy' | 'export' | 'import' | 'settings-change' | 'theme-change'
  payload?: any
  timestamp: number
}

// 历史记录
export interface HistoryItem {
  id: string
  text: string
  result: string
  settings: AppSettings
  timestamp: number
  preview: string
}

// 用户偏好
export interface UserPreferences {
  language: string
  timezone: string
  dateFormat: string
  timeFormat: string
  notifications: boolean
  autoUpdate: boolean
  crashReporting: boolean
  analytics: boolean
}
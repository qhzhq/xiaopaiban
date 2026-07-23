import type { AppSettings, TextStats } from '@/types'

/**
 * 全角半角转换
 * @param text 原始文本
 * @param mode 转换模式 (0-5)
 * @returns 转换后的文本
 */
export function convertFullHalf(text: string, mode: number): string {
  if (!text) return ''
  
  let result = text
  
  // 数字全角转半角
  if (mode === 1 || mode === 5) {
    result = result.replace(/[０-９]/g, (char) => {
      return String.fromCharCode(char.charCodeAt(0) - 0xFEE0)
    })
  }
  
  // 字母全角转半角
  if (mode === 2 || mode === 5) {
    result = result.replace(/[Ａ-Ｚａ-ｚ]/g, (char) => {
      return String.fromCharCode(char.charCodeAt(0) - 0xFEE0)
    })
  }
  
  // 标点全角转半角
  if (mode === 3 || mode === 5) {
    result = result.replace(/[，。！？；：""''【】（）《》、]/g, (char) => {
      const map: { [key: string]: string } = {
        '，': ',',
        '。': '.',
        '！': '!',
        '？': '?',
        '；': ';',
        '：': ':',
        '"': '"',
        '"': '"',
        ''': "'",
        ''': "'",
        '【': '[',
        '】': ']',
        '（': '(',
        '）': ')',
        '《': '<',
        '》': '>',
        '、': ','
      }
      return map[char] || char
    })
  }
  
  // 空格全角转半角
  if (mode === 4 || mode === 5) {
    result = result.replace(/　/g, ' ')
  }
  
  return result
}

/**
 * 标点符号修正
 * @param text 原始文本
 * @param mode 修正模式 (0-4)
 * @returns 修正后的文本
 */
export function fixPunctuation(text: string, mode: number): string {
  if (!text) return ''
  
  let result = text
  
  switch (mode) {
    case 1: // ，。→，。
      result = result.replace(/，\./g, '。')
      result = result.replace(/,\./g, '。')
      break
    case 2: // ，.→，。
      result = result.replace(/,\./g, '。')
      result = result.replace(/，\./g, '。')
      break
    case 3: // ，。→,.
      result = result.replace(/，。/g, ',.')
      result = result.replace(/，\./g, ',.')
      break
    case 4: // ,.→,.
      // 已经是半角，不需要转换
      break
  }
  
  return result
}

/**
 * 波浪线修正
 * @param text 原始文本
 * @param mode 修正模式 (0-4)
 * @returns 修正后的文本
 */
export function fixWave(text: string, mode: number): string {
  if (!text) return ''
  
  let result = text
  
  switch (mode) {
    case 1: // ～→~（全角→半角）
      result = result.replace(/～/g, '~')
      break
    case 2: // ～→—（全角→破折号）
      result = result.replace(/～/g, '—')
      break
    case 3: // ~→～（半角→全角）
      result = result.replace(/~/g, '～')
      break
    case 4: // ~→—（半角→破折号）
      result = result.replace(/~/g, '—')
      break
  }
  
  return result
}

/**
 * 段落缩进
 * @param text 原始文本
 * @param spaces 缩进空格数 (0-8)
 * @returns 缩进后的文本
 */
export function addIndentation(text: string, spaces: number): string {
  if (!text || spaces <= 0) return text
  
  const lines = text.split('\n')
  return lines.map(line => {
    if (line.trim()) {
      return '　'.repeat(spaces) + line
    }
    return line
  }).join('\n')
}

/**
 * 段间空行处理
 * @param text 原始文本
 * @param lines 空行数 (0-3)
 * @returns 处理后的文本
 */
export function addSpaces(text: string, lines: number): string {
  if (!text || lines <= 0) return text
  
  const paragraphs = text.split(/\n\s*\n/)
  return paragraphs.join('\n'.repeat(lines + 1))
}

/**
 * 段内换行处理
 * @param text 原始文本
 * @param mode 换行模式 (1-5)
 * @returns 处理后的文本
 */
export function handleLineBreaks(text: string, mode: number): string {
  if (!text || mode <= 1) return text
  
  // 根据模式处理换行
  // 这里简化处理，实际实现会更复杂
  return text
}

/**
 * 统计文本信息
 * @param text 文本内容
 * @returns 统计信息
 */
export function getTextStats(text: string): TextStats {
  if (!text) {
    return {
      characters: 0,
      charactersNoSpace: 0,
      words: 0,
      lines: 0,
      paragraphs: 0
    }
  }
  
  return {
    characters: text.length,
    charactersNoSpace: text.replace(/\s/g, '').length,
    words: text.trim().split(/\s+/).filter(w => w.length > 0).length,
    lines: text.split('\n').length,
    paragraphs: text.split(/\n\s*\n/).filter(p => p.trim().length > 0).length
  }
}

/**
 * 格式化文件大小
 * @param bytes 字节数
 * @returns 格式化后的字符串
 */
export function formatFileSize(bytes: number): string {
  if (bytes === 0) return '0 B'
  
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

/**
 * 格式化时间
 * @param timestamp 时间戳
 * @returns 格式化后的时间字符串
 */
export function formatTime(timestamp: number): string {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  
  // 1分钟内
  if (diff < 60 * 1000) {
    return '刚刚'
  }
  
  // 1小时内
  if (diff < 60 * 60 * 1000) {
    const minutes = Math.floor(diff / (60 * 1000))
    return `${minutes}分钟前`
  }
  
  // 1天内
  if (diff < 24 * 60 * 60 * 1000) {
    const hours = Math.floor(diff / (60 * 60 * 1000))
    return `${hours}小时前`
  }
  
  // 1周内
  if (diff < 7 * 24 * 60 * 60 * 1000) {
    const days = Math.floor(diff / (24 * 60 * 60 * 1000))
    return `${days}天前`
  }
  
  // 超过1周
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

/**
 * 防抖函数
 * @param func 要防抖的函数
 * @param wait 等待时间
 * @returns 防抖后的函数
 */
export function debounce<T extends (...args: any[]) => any>(func: T, wait: number): T {
  let timeout: ReturnType<typeof setTimeout> | null = null
  
  return ((...args: any[]) => {
    if (timeout) {
      clearTimeout(timeout)
    }
    
    timeout = setTimeout(() => {
      func.apply(this, args)
      timeout = null
    }, wait)
  }) as T
}

/**
 * 节流函数
 * @param func 要节流的函数
 * @param limit 限制时间
 * @returns 节流后的函数
 */
export function throttle<T extends (...args: any[]) => any>(func: T, limit: number): T {
  let inThrottle = false
  
  return ((...args: any[]) => {
    if (!inThrottle) {
      func.apply(this, args)
      inThrottle = true
      setTimeout(() => {
        inThrottle = false
      }, limit)
    }
  }) as T
}

/**
 * 生成唯一ID
 * @returns 唯一ID字符串
 */
export function generateId(): string {
  return Date.now().toString(36) + Math.random().toString(36).substr(2)
}

/**
 * 深拷贝对象
 * @param obj 要拷贝的对象
 * @returns 拷贝后的对象
 */
export function deepClone<T>(obj: T): T {
  if (obj === null || typeof obj !== 'object') {
    return obj
  }
  
  if (obj instanceof Date) {
    return new Date(obj.getTime()) as any
  }
  
  if (obj instanceof Array) {
    return obj.map(item => deepClone(item)) as any
  }
  
  if (obj instanceof Object) {
    const copy = {} as any
    Object.keys(obj).forEach(key => {
      copy[key] = deepClone((obj as any)[key])
    })
    return copy
  }
  
  return obj
}

/**
 * 检查是否为移动设备
 * @returns 是否为移动设备
 */
export function isMobile(): boolean {
  // #ifdef H5
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
  // #endif
  // #ifndef H5
  return false
  // #endif
}

/**
 * 获取系统信息
 * @returns 系统信息
 */
export function getSystemInfo() {
  return new Promise((resolve, reject) => {
    uni.getSystemInfo({
      success: (res) => {
        resolve(res)
      },
      fail: (err) => {
        reject(err)
      }
    })
  })
}

/**
 * 显示确认对话框
 * @param title 标题
 * @param content 内容
 * @returns Promise<boolean>
 */
export function showConfirm(title: string, content: string): Promise<boolean> {
  return new Promise((resolve) => {
    uni.showModal({
      title,
      content,
      success: (res) => {
        resolve(res.confirm)
      },
      fail: () => {
        resolve(false)
      }
    })
  })
}

/**
 * 复制文本到剪贴板
 * @param text 要复制的文本
 * @returns Promise<boolean>
 */
export function copyToClipboard(text: string): Promise<boolean> {
  return new Promise((resolve) => {
    uni.setClipboardData({
      data: text,
      success: () => {
        uni.showToast({
          title: '已复制到剪贴板',
          icon: 'success'
        })
        resolve(true)
      },
      fail: () => {
        uni.showToast({
          title: '复制失败',
          icon: 'none'
        })
        resolve(false)
      }
    })
  })
}

/**
 * 显示加载提示
 * @param title 提示文字
 */
export function showLoading(title: string = '加载中...') {
  uni.showLoading({
    title,
    mask: true
  })
}

/**
 * 隐藏加载提示
 */
export function hideLoading() {
  uni.hideLoading()
}

/**
 * 显示提示信息
 * @param title 提示文字
 * @param icon 图标类型
 */
export function showToast(title: string, icon: 'success' | 'error' | 'none' = 'none') {
  uni.showToast({
    title,
    icon,
    duration: 2000
  })
}
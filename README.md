<div align="center">
  <img src="icon.png" width="120" height="120" alt="小排版 Logo">
  <h1 align="center">小排版（一键排版）</h1>
  <p align="center">
    <strong>让文字呼吸 · 免费 · 离线 · 跨平台</strong>
  </p>
  <p align="center">
    一款专注于中文排文本版的轻量级桌面工具，强调隐私（离线）、便捷（一键操作）和跨平台支持。
  </p>
  <p align="center">
    <a href="https://pb.hulian.pro" target="_blank">🌐 产品官网</a>
    ·
    <a href="#-功能特性">📖 功能特性</a>
    ·
    <a href="#-快速上手">🚀 快速上手</a>
    ·
    <a href="#-下载安装">⬇️ 下载安装</a>
  </p>
  <p align="center">
    <img src="https://img.shields.io/badge/macOS-Intel%20%7C%20Silicon-brightgreen">
    <img src="https://img.shields.io/badge/Windows-10%2B-blue">
    <img src="https://img.shields.io/badge/Linux-x64%20%7C%20arm64-orange">
    <img src="https://img.shields.io/badge/license-MIT-green">
  </p>
</div>

---

## 📖 功能特性

### 六项精密排版能力

| 功能 | 说明 |
|------|------|
| **段落智能空行** | 自动识别自然段边界，可预设小说投稿、公众号、论文等场景的段落间距 |
| **缩进一键统一** | 支持文本缩进、全角缩进或不缩进，三种模式自由切换 |
| **全角半角转换** | 支持中文全角、英文半角或智能混排，统一标点、数字、字母规则 |
| **中英文混排优化** | 自动在中英文、数字与中文之间插入合适空格，符合 W3C 中文排版规范 |
| **全局快捷键** | macOS 按 <kbd>⌘G</kbd> / Windows 按 <kbd>Ctrl+G</kbd> 即时排版 |
| **纯离线引擎** | 100% 本地运算，文字不上传服务器，无隐私风险 |

### 更多细节

- **标点与空格**：自动处理全角/半角标点、数字、字母的混用错误；中英文之间自动插入空格
- **段落与缩进**：智能识别段落边界，提供段落间距预设；统一管理缩进格式
- **预设方案**：通用排版、论文排版、新闻排版、日常排版，一键切换
- **安全性**：永远不上传你的文字，纯本地处理
- **零学习成本**：无需注册、配置，打开即用
- **免费、无广告、无数据收集**

---

## 🚀 快速上手

1. **粘贴文本**：将文章、小说、笔记或论文粘贴到编辑区，也支持直接拖入 `.txt` 文件
2. **选择规则**：点击排版设置，选择段落模式、缩进方式和全角半角偏好，或用预设一键配置
3. **一键排版**：按 <kbd>⌘G</kbd>（macOS）/ <kbd>Ctrl+G</kbd>（Windows/Linux），或点击排版按钮，结果即刻呈现

> 💡 **小技巧**：开启「排版后直接复制」选项，排完版自动复制到剪贴板，省去手动选中步骤。

---

## ⬇️ 下载安装

桌面客户端免费、无广告、完全离线，原生比网页版更稳定。

### macOS

| 架构 | 格式 | 下载 |
|:---|:---|:---|
| Intel (x64) | DMG | [下载](https://github.com/qhzhq/xiaopaiban/releases/latest/download/小排版_1.5.2_x64.dmg) |
| Apple Silicon (M1-M4) | DMG | [下载](https://github.com/qhzhq/xiaopaiban/releases/latest/download/小排版_1.5.2_aarch64.dmg) |

### Windows

| 架构 | 格式 | 下载 |
|:---|:---|:---|
| x64 | EXE | [下载](https://github.com/qhzhq/xiaopaiban/releases/latest/download/小排版_1.5.2_x64-setup.exe) |
| x64 | MSIX | [下载](https://github.com/qhzhq/xiaopaiban/releases/latest/download/小排版_1.5.2_x64.msix) |

### Linux

| 架构 | 格式 | 下载 |
|:---|:---|:---|
| x64 | DEB | [下载](https://github.com/qhzhq/xiaopaiban/releases/latest/download/小排版_1.5.2_amd64.deb) |

> 所有安装包均通过 GitHub Actions 自动构建，也可前往 [GitHub Releases](https://github.com/qhzhq/xiaopaiban/releases) 查看全部版本。

---

## 🔧 首次使用注意事项

### macOS

```bash
# 如果提示"无法打开"，请右键点击 App → 打开
# 或在终端执行：
xattr -cr /Applications/小排版.app
```

### Linux

```bash
# 下载后赋予执行权限
chmod +x 小排版-*.AppImage
./小排版-*.AppImage
```

---

## 🏗️ 自行构建

### 环境要求

- Node.js 20+
- Rust（用于 Pake CLI）
- Pake CLI：`npm install -g pake-cli`

### 构建命令

```bash
# macOS（Intel + Apple Silicon 通用）
npm run pake:mac:universal

# 或单独构建
npm run pake:mac

# Windows
npm run pake:win

# Linux
npm run pake:linux

# 所有平台
npm run pake:all
```

---

## 🧩 技术栈

- **前端**：HTML + CSS + JavaScript（layui）
- **桌面化**：[Pake](https://github.com/tw93/Pake)（基于 Tauri）
- **CI/CD**：GitHub Actions

---

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源。

---

<div align="center">
  <sub>Made with ❤️ by 静候美好</sub>
  <br>
  <sub>产品官网：<a href="https://pb.hulian.pro">pb.hulian.pro</a></sub>
</div>

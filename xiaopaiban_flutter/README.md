# 小排版 Flutter Desktop

一款简洁好用的文本排版工具，使用 Flutter Desktop 技术栈构建。

## 功能特性

### 核心排版功能
- **一键排版** - 智能文本格式化
- **全角半角转换** - 字母、数字的全角半角互转
- **标点符号修正** - 中英文标点智能转换
- **波浪线修正** - 统一波浪线格式
- **段首缩进** - 可配置缩进字符数 (0-8)
- **段间空行** - 可配置空行数量 (0-3)
- **段内换行** - 可配置换行数量 (1-5)

### 桌面端特性
- **自定义标题栏** - 支持 macOS/Windows/Linux 原生风格
- **右键上下文菜单** - 丰富的文本操作菜单
- **键盘快捷键** - Ctrl+Enter 排版、Ctrl+Shift+C 复制等
- **多窗口适配** - 窗口大小记忆、最小尺寸限制
- **系统托盘集成** - 最小化到托盘（可选）
- **查找替换** - 支持关键词查找、文本替换、全部替换（Ctrl+F）

### 数据管理
- **历史记录** - 自动保存排版历史（最多 50 条）
- **预设系统** - 6 种内置预设 + 自定义预设
- **导入导出** - 设置和历史数据的导入导出
- **本地存储** - 所有数据本地持久化

### 界面特性
- **深色/浅色主题** - 支持跟随系统自动切换
- **响应式布局** - 输入输出面板可调整
- **实时统计** - 字数、词数、行数、段落数
- **Toast 通知** - 操作反馈提示

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Enter` | 一键排版 |
| `Ctrl+Shift+C` | 复制排版结果 |
| `Ctrl+Shift+S` | 交换输入输出 |
| `Ctrl+Shift+Delete` | 清空所有文本 |
| `Ctrl+F` | 查找替换 |
| `Ctrl+Shift+F` | 查找替换（同上） |
| `Ctrl+,` | 打开设置 |
| `Ctrl+H` | 历史记录 |
| `Ctrl+E` | 导出设置 |
| `Ctrl+I` | 导入设置 |
| `Escape` | 关闭面板 |

> macOS 用户请使用 `Cmd` 替代 `Ctrl`

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── app.dart                     # MaterialApp 配置
├── models/                      # 数据模型
│   ├── app_settings.dart        # 应用设置
│   ├── preset.dart              # 预设配置
│   ├── text_stats.dart          # 文本统计
│   ├── history_item.dart        # 历史记录项
│   └── clipboard_item.dart      # 剪贴板项
├── services/                    # 服务层
│   ├── storage_service.dart     # 本地存储服务
│   └── window_service.dart      # 窗口管理服务
├── providers/                   # 状态管理
│   └── app_state.dart           # 应用状态 (ChangeNotifier)
├── screens/                     # 页面
│   └── home_screen.dart         # 主屏幕
├── widgets/                     # 组件
│   ├── custom_title_bar.dart    # 自定义标题栏
│   ├── tool_bar.dart            # 工具栏
│   ├── text_panel.dart          # 文本面板
│   ├── settings_panel.dart      # 设置面板
│   ├── history_dialog.dart      # 历史记录对话框
│   ├── import_export_dialog.dart # 导入导出对话框
│   ├── context_menu.dart        # 右键菜单
│   ├── toast.dart               # Toast 通知
│   ├── about_dialog.dart        # 关于对话框
│   └── find_replace_panel.dart  # 查找替换面板
├── utils/                       # 工具类
│   ├── text_utils.dart          # 文本处理工具
│   ├── constants.dart           # 常量定义
│   └── keyboard_shortcuts.dart  # 快捷键定义
└── theme/                       # 主题
    └── app_theme.dart           # 应用主题
```

## 开发环境要求

- Flutter SDK >= 3.2.0
- Dart SDK >= 3.2.0

## 安装依赖

```bash
cd xiaopaiban_flutter
flutter pub get
```

## 运行项目

### macOS
```bash
flutter run -d macos
```

### Windows
```bash
flutter run -d windows
```

### Linux
```bash
flutter run -d linux
```

## 构建发布

### macOS
```bash
flutter build macos
```

### Windows
```bash
flutter build windows
```

### Linux
```bash
flutter build linux
```

## 技术栈

- **Flutter** - UI 框架
- **Provider** - 状态管理
- **window_manager** - 桌面窗口管理
- **shared_preferences** - 本地存储
- **hotkey_manager** - 键盘快捷键
- **file_picker** - 文件选择
- **url_launcher** - URL 启动

## 查找替换功能

### 功能特点
- **关键词查找** - 支持在输入或输出面板中查找文本
- **文本替换** - 替换当前匹配项或全部替换
- **高级选项** - 支持大小写敏感、全词匹配、正则表达式
- **快捷操作** - 上一个/下一个匹配项快速切换
- **实时计数** - 显示匹配数量和当前位置

### 使用方法
1. 点击工具栏的「查找」按钮或按 `Ctrl+F` 打开查找替换面板
2. 在查找框中输入关键词
3. 使用上下箭头按钮切换匹配项
4. 在替换框中输入替换文本
5. 点击「替换」替换当前项，或「全部替换」替换所有匹配项

### 高级选项
- **大小写敏感** - 区分大小写匹配
- **全词匹配** - 只匹配完整单词
- **正则表达式** - 使用正则表达式进行复杂匹配

## 从 uni-app x 迁移

本项目从 uni-app x (Vue 3 + TypeScript) 迁移而来，完整保留了所有业务逻辑：

1. **文本处理逻辑** - `text_utils.dart` 完整移植了全角半角转换、标点修正、波浪线修正等算法
2. **状态管理** - `app_state.dart` 移植了 Pinia store 的所有状态和操作
3. **UI 交互** - 所有 UI 组件和交互逻辑已适配 Flutter Desktop
4. **桌面特性** - 新增了右键菜单、键盘快捷键、窗口管理等桌面端专属功能

## 许可证

MIT License

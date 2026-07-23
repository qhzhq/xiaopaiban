# 一键排版 - Pake 到 Tauri 2 迁移记录

## 迁移概述

**迁移日期**: 2026-07-23  
**迁移版本**: v1.5.17  
**Tauri版本**: Tauri 2 (稳定版)  
**迁移原因**: Pake构建频繁出现错误，迁移到原生Tauri 2以获得更好的稳定性和控制力

## 技术栈变化

| 项目 | 原方案 | 新方案 |
|------|--------|--------|
| 框架 | Pake (基于Tauri 1封装) | Tauri 2 (原生) |
| 后端 | Node.js (Pake CLI) | Rust |
| 前端 | HTML/CSS/JS | HTML/CSS/JS (不变) |
| 构建工具 | pake-cli | @tauri-apps/cli v2 |

## 配置映射

### 窗口配置

| 原Pake配置 | Tauri 2 配置 | 说明 |
|-----------|--------------|------|
| `"width": 1024` | `"width": 1024` | 窗口宽度 |
| `"height": 768` | `"height": 768` | 窗口高度 |
| `"fullscreen": false` | `"fullscreen": false` | 不全屏 |
| `"hideTitleBar": true` | `"decorations": false` | 隐藏原生标题栏 |
| `"titleBarStyle": "hiddenInset"` | `"titleBarStyle": "Overlay"` | macOS标题栏样式 |
| `"useLocalFile": true` | `"frontendDist": "../"` | 使用本地文件 |
| `"appVersion": "1.5.17"` | `"version": "1.5.17"` | 应用版本 |

### 窗口样式

| 原Electron配置 | Tauri 2 配置 | 说明 |
|---------------|--------------|------|
| `titleBarStyle: 'hiddenInset'` | `titleBarStyle: "Overlay"` | macOS隐藏标题栏 |
| `trafficLightPosition: { x: 12, y: 12 }` | `set_traffic_light_position()` | 交通灯按钮位置 |
| `vibrancy: 'window'` | macOS私有API | 窗口背景色 |
| `minWidth: 680` | `minWidth: 680` | 最小宽度 |
| `minHeight: 500` | `minHeight: 500` | 最小高度 |

## 菜单系统实现

### Tauri 2 菜单代码

```rust
// 编辑菜单项
let undo = MenuItemBuilder::with_id("undo", "撤销")
    .accelerator("CmdOrCtrl+Z")
    .build(app)?;
let redo = MenuItemBuilder::with_id("redo", "重做")
    .accelerator("Shift+CmdOrCtrl+Z")
    .build(app)?;
let cut = MenuItemBuilder::with_id("cut", "剪切")
    .accelerator("CmdOrCtrl+X")
    .build(app)?;
let copy = MenuItemBuilder::with_id("copy", "复制")
    .accelerator("CmdOrCtrl+C")
    .build(app)?;
let paste = MenuItemBuilder::with_id("paste", "粘贴")
    .accelerator("CmdOrCtrl+V")
    .build(app)?;
let select_all = MenuItemBuilder::with_id("select_all", "全选")
    .accelerator("CmdOrCtrl+A")
    .build(app)?;
let about = MenuItemBuilder::with_id("about", "关于")
    .build(app)?;
let visit_website = MenuItemBuilder::with_id("visit_website", "访问网站")
    .build(app)?;
let quit = MenuItemBuilder::with_id("quit", "退出")
    .accelerator("CmdOrCtrl+Q")
    .build(app)?;

// 创建编辑子菜单
let edit_menu = SubmenuBuilder::with_id(app, "edit", "编辑")
    .item(&undo)
    .item(&redo)
    .separator()
    .item(&cut)
    .item(&copy)
    .item(&paste)
    .item(&select_all)
    .separator()
    .item(&about)
    .item(&visit_website)
    .separator()
    .item(&quit)
    .build()?;

// 创建主菜单
let menu = MenuBuilder::new(app)
    .item(&edit_menu)
    .build()?;

// 设置菜单
app.set_menu(menu)?;
```

## 文件结构

### Tauri 2 项目结构

```
一键排版/
├── index.html              # 前端页面
├── Images/                 # 前端资源
├── js/                     # JavaScript 文件
├── package.json            # npm 配置
├── build-tauri.sh          # Tauri 构建脚本
├── src-tauri/              # Tauri 后端
│   ├── Cargo.toml          # Rust 依赖配置
│   ├── tauri.conf.json     # Tauri 应用配置
│   ├── build.rs            # Rust 构建脚本
│   ├── capabilities/       # Tauri 2 权限配置
│   │   └── default.json
│   ├── icons/              # 应用图标
│   │   ├── 32x32.png
│   │   ├── 128x128.png
│   │   ├── 128x128@2x.png
│   │   ├── icon.icns
│   │   └── icon.ico
│   └── src/
│       ├── main.rs         # Rust 主入口
│       └── lib.rs          # Rust 库文件 (核心逻辑)
└── .github/workflows/
    └── build.yml           # GitHub Actions 构建配置
```

## 依赖配置

### package.json

```json
{
  "devDependencies": {
    "@tauri-apps/cli": "^2"
  },
  "dependencies": {
    "@tauri-apps/api": "^2",
    "@tauri-apps/plugin-shell": "^2"
  }
}
```

### Cargo.toml

```toml
[dependencies]
tauri = { version = "2", features = ["macos-private-api"] }
tauri-plugin-shell = "2"
serde = { version = "1", features = ["derive"] }
serde_json = "1"
```

## Tauri 2 新特性

### Capabilities 系统

Tauri 2 引入了 capabilities 系统来控制权限：

```json
// src-tauri/capabilities/default.json
{
  "identifier": "default",
  "description": "默认权限配置",
  "windows": ["main"],
  "permissions": [
    "core:default",
    "shell:allow-open"
  ]
}
```

### withGlobalTauri

在 `tauri.conf.json` 中启用 `withGlobalTauri`，允许在前端 JavaScript 中直接访问 Tauri API：

```json
{
  "app": {
    "withGlobalTauri": true
  }
}
```

## 构建命令

### 本地构建

```bash
# 安装依赖
npm install

# 开发模式
npm start  # 或 npx tauri dev

# 构建当前平台
npm run build

# 构建指定平台
npm run build:mac    # macOS
npm run build:win    # Windows
npm run build:linux  # Linux

# 使用构建脚本
./build-tauri.sh mac
./build-tauri.sh win
./build-tauri.sh linux
```

### GitHub Actions 构建

构建产物位置：

- **macOS**: `src-tauri/target/release/bundle/dmg/*.dmg`
- **Windows**: `src-tauri/target/release/bundle/nsis/*.exe`
- **Linux**: `src-tauri/target/release/bundle/deb/*.deb`

## UI 样式保持

### CSS 兼容性

```css
/* 标题栏拖拽区域 - Tauri 2 兼容 */
.title-bar {
    -webkit-app-region: drag;
    app-region: drag;
}

/* 按钮点击区域 - 防止拖拽 */
.btn, a, button {
    -webkit-app-region: no-drag;
    app-region: no-drag;
}
```

### 标题栏配置

```json
{
  "app": {
    "windows": [{
      "decorations": false,
      "titleBarStyle": "Overlay",
      "hiddenTitle": true
    }]
  }
}
```

## 版本号管理

所有版本号保持为 1.5.17：

| 文件 | 版本号 |
|------|--------|
| `package.json` | `"version": "1.5.17"` |
| `src-tauri/tauri.conf.json` | `"version": "1.5.17"` |
| `src-tauri/Cargo.toml` | `version = "1.5.17"` |
| `build-tauri.sh` | `APP_VERSION="1.5.17"` |
| `.github/workflows/build.yml` | `APP_VERSION: '1.5.17'` |

## 测试验证清单

### 功能验证

- [ ] macOS 窗口正常显示
- [ ] 标题栏隐藏正常
- [ ] 交通灯按钮位置正确 (x: 12, y: 12)
- [ ] 菜单功能正常
- [ ] 关于对话框正常
- [ ] 窗口尺寸限制正常 (最小 680x500)
- [ ] 编辑菜单功能正常 (撤销/重做/剪切/复制/粘贴/全选)
- [ ] 退出功能正常

### 构建验证

- [ ] macOS DMG 构建成功
- [ ] Windows EXE 构建成功
- [ ] Linux DEB 构建成功
- [ ] 版本号正确显示为 1.5.17

## 已知问题和解决方案

### 1. macOS 交通灯按钮位置

**问题**: 默认位置可能不符合设计要求  
**解决**: 使用 `set_traffic_light_position()` 方法

```rust
#[cfg(target_os = "macos")]
{
    use tauri::WebviewWindowExt;
    window.set_traffic_light_position(tauri::LogicalPosition::new(12.0, 12.0))?;
}
```

### 2. 窗口背景色

**问题**: Tauri 2 的窗口背景色设置与 Electron 的 vibrancy 不完全相同  
**解决**: 使用 macOS 私有 API

```json
{
  "app": {
    "macOSPrivateApi": true
  }
}
```

### 3. 系统托盘

**问题**: Tauri 2 的系统托盘实现与 Electron 不同  
**解决**: 需要额外开发，当前版本暂不实现

## 后续优化建议

1. **实现系统托盘功能** - 使用 Tauri 2 的 tray API
2. **添加自动更新功能** - 使用 tauri-plugin-updater
3. **优化构建产物大小** - 启用 LTO 和 strip
4. **添加文件拖放支持** - 配置 fileDropEnabled
5. **实现窗口状态保存** - 使用 tauri-plugin-window-state

## 回滚方案

如果需要回滚到 Pake 版本：

1. 恢复 `pake.json` 配置
2. 恢复 `package.json` 中的 Electron 依赖
3. 恢复 `.github/workflows/build.yml` 使用 Pake CLI
4. 删除 `src-tauri/` 目录

## 参考文档

- [Tauri 2 官方文档](https://v2.tauri.app/)
- [Tauri 2 迁移指南](https://v2.tauri.app/start/migrate/from-tauri-1/)
- [Tauri 2 配置参考](https://v2.tauri.app/reference/config/)
- [Tauri 2 API 参考](https://v2.tauri.app/reference/javascript/api/)
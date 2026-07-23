# Flutter Desktop Build Guide

本文档说明如何使用 GitHub Actions 自动构建和发布 Flutter 桌面应用。

## 构建目标

### macOS
- **x86_64**: 使用 `macos-14` 运行器构建
- **arm64**: 使用 `macos-latest` 运行器构建
- **输出格式**: `.dmg` 安装包

### Windows
- **x64**: 构建 `.exe` 安装包和 `.msixupload` 包
- **arm64**: 构建 `.exe` 安装包和 `.msixupload` 包
- **输出格式**: `.exe` (NSIS) + `.msixupload`

### Linux
- **x64**: 构建 `.deb` 安装包
- **arm64**: 构建 `.deb` 安装包
- **输出格式**: `.deb` + `.tar.gz`

## 触发构建

### 1. 通过标签触发（推荐）

创建以 `flutter-v` 开头的标签，例如：

```bash
git tag flutter-v2.0.1
git push origin flutter-v2.0.1
```

这将自动触发构建和发布流程。

### 2. 手动触发

在 GitHub Actions 页面手动运行工作流，可以指定版本号。

## 构建流程

### macOS 构建

1. 使用 `subosito/flutter-action` 设置 Flutter 环境
2. 安装依赖：`flutter pub get`
3. 构建应用：`flutter build macos --release`
4. 使用 `create-dmg` 创建 DMG 安装包
5. 上传构建产物

### Windows 构建

1. 使用 `subosito/flutter-action` 设置 Flutter 环境
2. 安装依赖：`flutter pub get`
3. 构建应用：`flutter build windows --release`
4. 使用 NSIS 创建 `.exe` 安装包
5. 使用 `msix` 包创建 `.msixupload` 包
6. 上传构建产物

### Linux 构建

1. 使用 `subosito/flutter-action` 设置 Flutter 环境
2. 安装依赖：`flutter pub get`
3. 构建应用：`flutter build linux --release`
4. 使用 `dpkg-deb` 创建 `.deb` 安装包
5. 创建 `.tar.gz` 压缩包
6. 上传构建产物

## 发布流程

当构建通过标签触发时，会自动创建 GitHub Release，包含所有平台的构建产物。

### Release 内容

- **macOS**: `小排版_2.0.1_macOS_x86_64.dmg` 和 `小排版_2.0.1_macOS_aarch64.dmg`
- **Windows**: `小排版_2.0.1_Windows_x64.exe` 和 `小排版_2.0.1_Windows_arm64.exe`
- **Linux**: `小排版_2.0.1_Linux_x64.deb` 和 `小排版_2.0.1_Linux_arm64.deb`

## 配置说明

### 版本号管理

版本号在以下文件中维护：

1. `xiaopaiban_flutter/pubspec.yaml` - Flutter 项目版本
2. `package.json` - 项目版本
3. `src/manifest.json` - uni-app 版本
4. `.github/workflows/flutter-build.yml` - GitHub Actions 版本

### MSIX 配置

MSIX 配置在 `xiaopaiban_flutter/pubspec.yaml` 中：

```yaml
msix_config:
  display_name: 小排版
  publisher_display_name: 小排版开发团队
  identity_name: com.xiaopaiban.app
  publisher: CN=小排版开发团队
  msix_version: 2.0.1.0
  logo_path: assets/icon/app_icon.png
  capabilities: internetClient
  languages: zh-CN
```

### NSIS 配置

NSIS 安装包配置在 `xiaopaiban_flutter/windows/installer.nsi` 中。

## 故障排除

### 构建失败

1. 检查 Flutter 版本是否正确
2. 确认依赖是否完整
3. 查看 GitHub Actions 日志

### 版本号不一致

确保所有文件中的版本号一致：

```bash
# 检查版本号
grep -r "2.0.1" . --include="*.yaml" --include="*.json" --include="*.toml"
```

### 签名问题

macOS 和 Windows 应用需要签名才能正常分发。目前工作流未包含签名步骤，需要手动处理。

## 本地构建

### macOS

```bash
cd xiaopaiban_flutter
flutter build macos --release
cd build/macos/Build/Products/Release
create-dmg --volname "小排版" --volicon "小排版.app/Contents/Resources/AppIcon.icns" \
  --window-pos 200 120 --window-size 600 300 --icon-size 100 \
  --icon "小排版.app" 175 120 --hide-extension "小排版.app" \
  --app-drop-link 425 120 "小排版.dmg" "小排版.app"
```

### Windows

```bash
cd xiaopaiban_flutter
flutter build windows --release
cd build/windows/x64/runner/Release
makensis installer.nsi
```

### Linux

```bash
cd xiaopaiban_flutter
flutter build linux --release
cd build/linux/x64/release/bundle
tar -czf 小排版.tar.gz *
```

## 更新日志

### v2.0.1
- 更新版本号到 2.0.1
- 添加 MSIX 支持
- 添加 NSIS 安装包支持
- 添加 DEB 包支持
- 优化 GitHub Actions 工作流

### v2.0.0
- 初始 Flutter Desktop 版本
- 支持 macOS、Windows、Linux
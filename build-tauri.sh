#!/bin/bash

# 一键排版 Tauri 打包脚本
# 用法: ./build-tauri.sh [平台]
# 平台: mac | win | linux | all

set -e

APP_VERSION="1.5.17"
APP_NAME="小排版"
APP_ID="pro.hulian.pb"

# 颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# 检查平台参数
PLATFORM=${1:-"mac"}

# 检查必要工具
check_tools() {
    if ! command -v cargo &> /dev/null; then
        error "未找到 cargo，请先安装 Rust: https://rustup.rs/"
    fi
    
    if ! command -v npm &> /dev/null; then
        error "未找到 npm，请先安装 Node.js: https://nodejs.org/"
    fi
}

# 安装依赖
install_deps() {
    info "安装 npm 依赖..."
    npm install
}

# 构建指定平台
build_platform() {
    local platform=$1
    
    case $platform in
        "mac")
            info "开始构建 macOS 版本..."
            npm run build:mac
            ;;
        "win")
            info "开始构建 Windows 版本..."
            npm run build:win
            ;;
        "linux")
            info "开始构建 Linux 版本..."
            npm run build:linux
            ;;
        "all")
            info "开始构建所有平台版本..."
            build_platform "mac"
            build_platform "win"
            build_platform "linux"
            ;;
        *)
            error "未知平台: $platform"
            ;;
    esac
}

# 显示构建结果
show_result() {
    local platform=$1
    
    echo ""
    info "构建完成!"
    echo ""
    
    case $platform in
        "mac")
            info "macOS 安装包位置:"
            echo "  - DMG: src-tauri/target/universal-apple-darwin/release/bundle/dmg/${APP_NAME}_${APP_VERSION}_universal.dmg"
            echo "  - APP: src-tauri/target/universal-apple-darwin/release/bundle/macos/${APP_NAME}.app"
            ;;
        "win")
            info "Windows 安装包位置:"
            echo "  - EXE: src-tauri/target/x86_64-pc-windows-msvc/release/bundle/nsis/${APP_NAME}_${APP_VERSION}_x64-setup.exe"
            echo "  - MSI: src-tauri/target/x86_64-pc-windows-msvc/release/bundle/msi/${APP_NAME}_${APP_VERSION}_x64_en-US.msi"
            ;;
        "linux")
            info "Linux 安装包位置:"
            echo "  - DEB: src-tauri/target/x86_64-unknown-linux-gnu/release/bundle/deb/${APP_NAME}_${APP_VERSION}_amd64.deb"
            echo "  - RPM: src-tauri/target/x86_64-unknown-linux-gnu/release/bundle/rpm/${APP_NAME}-${APP_VERSION}-1.x86_64.rpm"
            ;;
    esac
    
    echo ""
    info "安装包已生成完成，版本号: $APP_VERSION"
}

# 主流程
main() {
    info "一键排版 Tauri 打包工具 v$APP_VERSION"
    echo ""
    
    check_tools
    install_deps
    build_platform "$PLATFORM"
    show_result "$PLATFORM"
}

main
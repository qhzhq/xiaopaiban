#!/bin/bash

# 小排版 Pake 打包脚本
# 使用方法: ./build-pake.sh [平台] [架构]
# 示例:
#   ./build-pake.sh mac          # 构建 macOS (Universal: Intel + Apple Silicon)
#   ./build-pake.sh mac single   # 构建 macOS (仅当前架构)
#   ./build-pake.sh win          # 构建 Windows
#   ./build-pake.sh linux        # 构建 Linux
#   ./build-pake.sh all          # 构建所有平台(仅当前系统支持的)

set -e

APP_NAME="小排版"
APP_VERSION="1.5.16"
BUILD_DIR="pake-build"
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查依赖
check_dependencies() {
    if ! command -v pake &> /dev/null; then
        print_error "Pake CLI 未安装。请运行: npm install -g pake-cli"
        exit 1
    fi
    if ! command -v rustc &> /dev/null; then
        print_error "Rust 未安装。请访问 https://rustup.rs 安装"
        exit 1
    fi
}

# 获取系统架构
get_host_arch() {
    local arch
    arch=$(uname -m)
    if [ "$arch" = "x86_64" ]; then
        echo "x86_64"
    elif [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then
        echo "aarch64"
    else
        echo "$arch"
    fi
}

# 准备构建文件
prepare_build() {
    print_info "准备构建文件..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"

    cp index.html "$BUILD_DIR/"
    cp main.js "$BUILD_DIR/"
    cp favicon.ico "$BUILD_DIR/"
    cp icon.png "$BUILD_DIR/"
    cp -r Images "$BUILD_DIR/"
    cp -r js "$BUILD_DIR/"
    cp pake.json "$BUILD_DIR/"

    if [ -f "icon.icns" ]; then
        cp icon.icns "$BUILD_DIR/"
    fi

    print_info "构建文件准备完成 (使用 pake.json 配置)"
}

# 构建 macOS (Universal)
build_mac() {
    local arch_flag=$1
    print_info "构建 macOS 版本..."

    cd "$BUILD_DIR"

    local pake_args=(
        "--config" "pake.json"
        "--hide-title-bar"
        "--targets" "dmg"
    )

    if [ "$arch_flag" != "single" ]; then
        pake_args+=(--multi-arch)
        print_info "构建 Universal (Intel + Apple Silicon) 版本"
    else
        print_info "构建 $(get_host_arch) 版本"
    fi

    pake "${pake_args[@]}"

    cd "$PROJECT_ROOT"
    print_info "macOS 构建完成！"
    print_info "输出: $BUILD_DIR/target/release/bundle/dmg/"
}

# 构建 Windows
build_win() {
    print_info "构建 Windows 版本..."

    cd "$BUILD_DIR"

    pake --config pake.json --targets msi

    cd "$PROJECT_ROOT"
    print_info "Windows 构建完成！"
    print_info "输出: $BUILD_DIR/target/release/bundle/msi/"
}

# 构建 Linux
build_linux() {
    print_info "构建 Linux 版本..."

    cd "$BUILD_DIR"

    pake --config pake.json --targets deb

    cd "$PROJECT_ROOT"
    print_info "Linux 构建完成！"
    print_info "输出: $BUILD_DIR/target/release/bundle/deb/"
}

# 主函数
main() {
    local platform=${1:-"mac"}
    local arch=${2:-"universal"}

    print_info "==================================="
    print_info " $APP_NAME v$APP_VERSION Pake 打包"
    print_info " 平台: $platform"
    print_info " 系统架构: $(get_host_arch)"
    print_info "==================================="
    echo ""

    check_dependencies
    prepare_build

    case $platform in
        mac|macos)
            build_mac "$arch"
            ;;
        win|windows)
            build_win
            ;;
        linux)
            build_linux
            ;;
        all)
            build_mac "$arch"
            print_warn "Windows 和 Linux 构建需要在对应系统上执行"
            print_warn "或使用 GitHub Actions CI (参考 .github/workflows/build.yml)"
            ;;
        *)
            print_error "未知平台: $platform"
            print_info "支持的平台: mac, win, linux, all"
            exit 1
            ;;
    esac

    print_info "构建完成！"
    echo ""
    print_info "输出文件:"
    find "$BUILD_DIR/target/release/bundle" -type f 2>/dev/null | while read f; do
        echo "  - $f"
    done
}

main "$@"

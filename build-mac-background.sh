#!/bin/bash

# 后台构建 macOS Universal (Intel + Apple Silicon) 版本
# 使用方法: ./build-mac-background.sh

set -e

APP_NAME="小排版"
APP_VERSION="1.5.1"
BUILD_DIR="pake-build"
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$PROJECT_ROOT/build.log"

echo "==================================="
echo " $APP_NAME v$APP_VERSION Pake 打包"
echo " 构建 macOS Universal 版本"
echo " 日志文件: $LOG_FILE"
echo "==================================="
echo ""

echo "准备构建文件..."
rm -rf "$PROJECT_ROOT/$BUILD_DIR"
mkdir -p "$PROJECT_ROOT/$BUILD_DIR"

cp "$PROJECT_ROOT/index.html" "$PROJECT_ROOT/$BUILD_DIR/"
cp "$PROJECT_ROOT/main.js" "$PROJECT_ROOT/$BUILD_DIR/"
cp "$PROJECT_ROOT/favicon.ico" "$PROJECT_ROOT/$BUILD_DIR/"
cp "$PROJECT_ROOT/icon.png" "$PROJECT_ROOT/$BUILD_DIR/"
cp "$PROJECT_ROOT/pake.json" "$PROJECT_ROOT/$BUILD_DIR/"
cp -r "$PROJECT_ROOT/Images" "$PROJECT_ROOT/$BUILD_DIR/"
cp -r "$PROJECT_ROOT/js" "$PROJECT_ROOT/$BUILD_DIR/"

if [ -f "$PROJECT_ROOT/icon.icns" ]; then
    cp "$PROJECT_ROOT/icon.icns" "$PROJECT_ROOT/$BUILD_DIR/"
fi

echo "构建文件准备完成"
echo "开始构建（首次需下载编译依赖，约10-20分钟）..."
echo ""

cd "$PROJECT_ROOT/$BUILD_DIR"

nohup pake --config pake.json --targets dmg --multi-arch > "$LOG_FILE" 2>&1 &

BUILD_PID=$!
echo "构建进程 PID: $BUILD_PID"
echo ""
echo "查看构建进度:"
echo "  tail -f $LOG_FILE"
echo "  ps -p $BUILD_PID"
echo ""
echo "构建完成后输出位置:"
echo "  $BUILD_DIR/target/release/bundle/dmg/"

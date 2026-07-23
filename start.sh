#!/bin/bash

# uni-app x 项目启动脚本
# 用于快速启动开发环境

echo "=== 小排版 uni-app x 项目启动脚本 ==="
echo ""

# 检查Node.js版本
echo "1. 检查Node.js版本..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "   Node.js版本: $NODE_VERSION"
    
    # 检查版本是否满足要求（>=18）
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$MAJOR_VERSION" -lt 18 ]; then
        echo "   ❌ Node.js版本需要>=18，当前版本: $NODE_VERSION"
        echo "   请升级Node.js版本"
        exit 1
    fi
else
    echo "   ❌ Node.js未安装"
    echo "   请安装Node.js >= 18"
    exit 1
fi

# 检查npm版本
echo ""
echo "2. 检查npm版本..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "   npm版本: $NPM_VERSION"
else
    echo "   ❌ npm未安装"
    exit 1
fi

# 安装依赖
echo ""
echo "3. 安装项目依赖..."
if [ -f "package.json" ]; then
    npm install
    if [ $? -eq 0 ]; then
        echo "   ✅ 依赖安装成功"
    else
        echo "   ❌ 依赖安装失败"
        exit 1
    fi
else
    echo "   ❌ package.json不存在"
    exit 1
fi

# 显示启动选项
echo ""
echo "4. 选择启动平台:"
echo "   1) H5端 (浏览器)"
echo "   2) 微信小程序"
echo "   3) 支付宝小程序"
echo "   4) 百度小程序"
echo "   5) 字节跳动小程序"
echo "   6) QQ小程序"
echo "   7) 快手小程序"
echo "   8) 京东小程序"
echo "   9) 360小程序"
echo "   0) 退出"
echo ""

read -p "请选择平台 [1-9, 0]: " choice

case $choice in
    1)
        echo "启动H5端开发..."
        npm run dev:h5
        ;;
    2)
        echo "启动微信小程序开发..."
        npm run dev:mp-weixin
        ;;
    3)
        echo "启动支付宝小程序开发..."
        npm run dev:mp-alipay
        ;;
    4)
        echo "启动百度小程序开发..."
        npm run dev:mp-baidu
        ;;
    5)
        echo "启动字节跳动小程序开发..."
        npm run dev:mp-toutiao
        ;;
    6)
        echo "启动QQ小程序开发..."
        npm run dev:mp-qq
        ;;
    7)
        echo "启动快手小程序开发..."
        npm run dev:mp-kuaishou
        ;;
    8)
        echo "启动京东小程序开发..."
        npm run dev:mp-jd
        ;;
    9)
        echo "启动360小程序开发..."
        npm run dev:mp-360
        ;;
    0)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效选择，退出"
        exit 1
        ;;
esac
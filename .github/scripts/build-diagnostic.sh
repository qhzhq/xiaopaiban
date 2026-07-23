#!/bin/bash

# 构建诊断脚本
# 用于在构建失败时提供详细的诊断信息

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# 检查系统信息
check_system_info() {
    log_info "系统信息检查"
    echo "操作系统: $(uname -a)"
    echo "主机名: $(hostname)"
    echo "当前用户: $(whoami)"
    echo "当前目录: $(pwd)"
    echo "磁盘空间:"
    df -h
    echo ""
}

# 检查Node.js环境
check_nodejs() {
    log_info "Node.js环境检查"
    
    if command -v node &> /dev/null; then
        echo "Node.js版本: $(node --version)"
        echo "npm版本: $(npm --version)"
        
        # 检查package.json
        if [ -f "package.json" ]; then
            echo "项目依赖:"
            npm ls --depth=0 2>/dev/null || echo "依赖检查失败"
        fi
    else
        log_error "Node.js未安装"
    fi
    echo ""
}

# 检查Rust环境
check_rust() {
    log_info "Rust环境检查"
    
    if command -v rustc &> /dev/null; then
        echo "Rust版本: $(rustc --version)"
        echo "Cargo版本: $(cargo --version)"
        echo "已安装目标:"
        rustup target list --installed
        
        # 检查Cargo.toml
        if [ -f "src-tauri/Cargo.toml" ]; then
            echo "Cargo.toml存在"
        fi
    else
        log_error "Rust未安装"
    fi
    echo ""
}

# 检查Tauri环境
check_tauri() {
    log_info "Tauri环境检查"
    
    if [ -f "src-tauri/tauri.conf.json" ]; then
        echo "Tauri配置文件存在"
        echo "配置文件内容:"
        cat src-tauri/tauri.conf.json | head -20
    else
        log_error "Tauri配置文件不存在"
    fi
    
    # 检查Tauri CLI
    if command -v tauri &> /dev/null; then
        echo "Tauri CLI版本: $(tauri --version)"
    else
        log_warn "Tauri CLI未安装"
    fi
    echo ""
}

# 检查构建脚本
check_build_scripts() {
    log_info "构建脚本检查"
    
    local scripts=("build-tauri.sh" "build-pake.sh" "build-mac-background.sh")
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            echo "✅ $script 存在"
            if [ -x "$script" ]; then
                echo "  - 可执行"
            else
                echo "  - 不可执行"
            fi
        else
            echo "❌ $script 不存在"
        fi
    done
    echo ""
}

# 检查依赖文件
check_dependency_files() {
    log_info "依赖文件检查"
    
    local files=("package.json" "package-lock.json" "src-tauri/Cargo.toml" "src-tauri/Cargo.lock")
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "✅ $file 存在 ($(wc -l < "$file") 行)"
        else
            echo "❌ $file 不存在"
        fi
    done
    echo ""
}

# 检查网络连接
check_network() {
    log_info "网络连接检查"
    
    # 测试GitHub连接
    if curl -s --connect-timeout 5 https://github.com > /dev/null; then
        echo "✅ GitHub连接正常"
    else
        echo "❌ GitHub连接失败"
    fi
    
    # 测试npm registry
    if curl -s --connect-timeout 5 https://registry.npmjs.org > /dev/null; then
        echo "✅ npm registry连接正常"
    else
        echo "❌ npm registry连接失败"
    fi
    
    # 测试crates.io
    if curl -s --connect-timeout 5 https://crates.io > /dev/null; then
        echo "✅ crates.io连接正常"
    else
        echo "❌ crates.io连接失败"
    fi
    echo ""
}

# 检查环境变量
check_environment_variables() {
    log_info "环境变量检查"
    
    local env_vars=("TAURI_PRIVATE_KEY" "TAURI_KEY_PASSWORD" "GITHUB_TOKEN")
    
    for var in "${env_vars[@]}"; do
        if [ -n "${!var}" ]; then
            echo "✅ $var 已设置"
        else
            echo "⚠️ $var 未设置"
        fi
    done
    echo ""
}

# 检查构建历史
check_build_history() {
    log_info "构建历史检查"
    
    # 检查是否有构建日志
    if [ -d "src-tauri/target" ]; then
        echo "构建目录存在"
        echo "构建目录大小: $(du -sh src-tauri/target 2>/dev/null | cut -f1)"
        
        # 检查最近构建时间
        if [ -d "src-tauri/target/release" ]; then
            echo "最近构建时间: $(stat -f "%Sm" src-tauri/target/release 2>/dev/null || stat -c "%y" src-tauri/target/release 2>/dev/null)"
        fi
    else
        echo "构建目录不存在"
    fi
    echo ""
}

# 检查常见错误
check_common_errors() {
    log_info "常见错误检查"
    
    # 检查端口占用
    if command -v lsof &> /dev/null; then
        local ports=(1420 3000 8080)
        for port in "${ports[@]}"; do
            if lsof -i :$port > /dev/null 2>&1; then
                echo "⚠️ 端口 $port 被占用"
            fi
        done
    fi
    
    # 检查进程
    echo "相关进程:"
    ps aux | grep -E "(node|cargo|tauri)" | grep -v grep || echo "无相关进程"
    echo ""
}

# 生成诊断报告
generate_report() {
    log_info "生成诊断报告"
    
    local report_file="build-diagnostic-report.txt"
    
    {
        echo "构建诊断报告"
        echo "生成时间: $(date)"
        echo "========================================"
        echo ""
        
        check_system_info
        check_nodejs
        check_rust
        check_tauri
        check_build_scripts
        check_dependency_files
        check_network
        check_environment_variables
        check_build_history
        check_common_errors
        
        echo "========================================"
        echo "诊断完成"
        
    } > "$report_file"
    
    log_info "诊断报告已生成: $report_file"
    echo "报告内容:"
    cat "$report_file"
}

# 主函数
main() {
    echo "========================================"
    echo "构建诊断脚本"
    echo "========================================"
    echo ""
    
    check_system_info
    check_nodejs
    check_rust
    check_tauri
    check_build_scripts
    check_dependency_files
    check_network
    check_environment_variables
    check_build_history
    check_common_errors
    
    echo "========================================"
    echo "诊断完成"
    echo "========================================"
}

# 根据参数执行不同操作
case "${1:-}" in
    "report")
        generate_report
        ;;
    "system")
        check_system_info
        ;;
    "nodejs")
        check_nodejs
        ;;
    "rust")
        check_rust
        ;;
    "tauri")
        check_tauri
        ;;
    "scripts")
        check_build_scripts
        ;;
    "deps")
        check_dependency_files
        ;;
    "network")
        check_network
        ;;
    "env")
        check_environment_variables
        ;;
    "history")
        check_build_history
        ;;
    "errors")
        check_common_errors
        ;;
    *)
        main
        ;;
esac
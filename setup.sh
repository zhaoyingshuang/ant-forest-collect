#!/bin/bash
# 蚂蚁森林自动收取 - 环境检查脚本

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ok=0

check() {
    local name="$1"
    local result="$2"
    if [ "$result" = "0" ]; then
        echo -e "  ${GREEN}[OK]${NC} $name"
    else
        echo -e "  ${RED}[FAIL]${NC} $name"
        ok=1
    fi
}

echo "================================"
echo "  蚂蚁森林自动收取 - 环境检查"
echo "================================"
echo ""

# 1. Python 3
echo "检查 Python 3 ..."
if command -v python3 &>/dev/null; then
    ver=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    check "Python $ver" 0
else
    check "Python 3 未安装，请前往 https://python.org 下载" 1
fi
echo ""

# 2. pip 依赖
echo "检查 pip 依赖 ..."
missing=0
for pkg in opencv-python rapidocr-onnxruntime; do
    if python3 -c "import ${pkg//-/_}" &>/dev/null; then
        check "$pkg" 0
    else
        check "$pkg 未安装" 1
        missing=1
    fi
done

if [ "$missing" = "1" ]; then
    echo ""
    echo -e "  ${YELLOW}提示: 运行以下命令安装依赖${NC}"
    echo "  pip3 install -r requirements.txt"
    read -p "  是否现在安装? [y/N] " ans
    if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        pip3 install -r requirements.txt
    fi
fi
echo ""

# 3. HDC
echo "检查 HDC ..."
hdc_found=""

# 环境变量
if [ -n "$HDC_PATH" ] && [ -f "$(eval echo "$HDC_PATH")" ]; then
    hdc_found=$(eval echo "$HDC_PATH")
fi

# 系统 PATH
if [ -z "$hdc_found" ] && command -v hdc &>/dev/null; then
    hdc_found=$(command -v hdc)
fi

# 常见路径
if [ -z "$hdc_found" ]; then
    for p in \
        "$HOME/Downloads/command-line-tools/sdk/default/openharmony/toolchains/hdc" \
        "$HOME/Library/Huawei/sdk/default/openharmony/toolchains/hdc" \
        "$HOME/DevEcoStudio/sdk/default/openharmony/toolchains/hdc"
    do
        if [ -f "$p" ]; then
            hdc_found="$p"
            break
        fi
    done
fi

# 通配符匹配
if [ -z "$hdc_found" ]; then
    for p in "$HOME"/Downloads/command-line-tools/sdk/HarmonyOS-*/openharmony/toolchains/hdc; do
        if [ -f "$p" ]; then
            hdc_found="$p"
            break
        fi
    done
fi

if [ -n "$hdc_found" ]; then
    check "hdc: $hdc_found" 0
else
    check "hdc 未找到" 1
    echo ""
    echo -e "  ${YELLOW}请下载 Command Line Tools:${NC}"
    echo "  https://developer.huawei.com/consumer/cn/download/"
    echo ""
    echo "  下载后解压到 ~/Downloads/ 目录，或设置环境变量:"
    echo "  export HDC_PATH=/path/to/hdc"
fi
echo ""

# 4. 设备连接
echo "检查设备连接 ..."
if [ -n "$hdc_found" ]; then
    targets=$("$hdc_found" list targets 2>/dev/null)
    if echo "$targets" | grep -qv "Empty\|Error\|empty"; then
        check "设备已连接: $(echo "$targets" | head -1)" 0
    else
        check "未检测到设备，请用 USB 连接手机并开启调试" 1
    fi
else
    check "跳过（hdc 未找到）" 1
fi
echo ""

# 结果
echo "================================"
if [ "$ok" = "0" ]; then
    echo -e "${GREEN}所有检查通过! 运行以下命令启动:${NC}"
    echo "  python3 ant_forest_collect.py"
else
    echo -e "${RED}部分检查未通过，请按提示修复${NC}"
fi
echo "================================"

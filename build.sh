#!/bin/bash
# 蚂蚁森林自动收取 - 打包脚本
# 使用 PyInstaller 打包为单个可执行文件

set -e

VENV=".venv-build"

echo "创建虚拟环境 ..."
python3 -m venv "$VENV"
source "$VENV/bin/activate"

echo "安装依赖 ..."
pip install pyinstaller opencv-python rapidocr-onnxruntime

echo ""
echo "开始打包 ..."
pyinstaller --onefile \
  --name ant-forest-collect \
  --collect-all rapidocr_onnxruntime \
  --collect-data onnxruntime \
  ant_forest_collect.py

deactivate

echo ""
echo "打包完成!"
echo "可执行文件: dist/ant-forest-collect"
ls -lh dist/ant-forest-collect

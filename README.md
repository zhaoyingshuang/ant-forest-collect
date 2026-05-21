# 蚂蚁森林自动收取

基于 OCR 识别的蚂蚁森林自动收取工具，适用于鸿蒙设备（通过 HDC 控制）。

## 依赖

- Python 3.8+
- OpenCV
- RapidOCR
- HDC（HarmonyOS Device Connector）

## 安装

```bash
pip install -r requirements.txt
```

## 使用

确保 HDC 已安装并可用，然后运行：

```bash
python ant_forest_collect.py
```

如果 HDC 不在默认路径，可通过环境变量指定：

```bash
HDC_PATH=/path/to/hdc python ant_forest_collect.py
```

## 原理

1. 通过 HDC 截取设备屏幕
2. 使用 RapidOCR 识别"一键收"和"找能量"按钮位置
3. 通过 HDC 模拟点击完成自动收取

## 赞赏

如果这个项目对你有帮助，欢迎请作者喝杯咖啡 ☕

<table>
  <tr>
    <td align="center">微信赞赏</td>
    <td align="center">支付宝赞赏</td>
  </tr>
  <tr>
    <td align="center">
      <img src="docs/images/wechat_pay.jpg" width="200" alt="微信赞赏码">
    </td>
    <td align="center">
      <img src="docs/images/alipay.jpg" width="200" alt="支付宝赞赏码">
    </td>
  </tr>
</table>

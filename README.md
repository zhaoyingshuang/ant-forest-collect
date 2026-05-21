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

## 前置条件

1. **鸿蒙设备**：已开启 USB 调试，并通过 USB 连接电脑
2. **HDC 工具**：已安装 HarmonyOS Device Connector，可通过命令行调用
3. **蚂蚁森林**：打开支付宝，进入蚂蚁森林好友排行榜页面（停留在第一个好友）

## 使用

**1. 安装依赖**

```bash
pip install -r requirements.txt
```

**2. 确认设备连接**

```bash
hdc list targets
```

能看到设备序列号即表示连接成功。

**3. 运行**

确保手机停留在蚂蚁森林好友排行榜页面，然后执行：

```bash
python ant_forest_collect.py
```

**4. 自定义 HDC 路径**

如果 `hdc` 不在默认路径（`~/Downloads/command-line-tools/sdk/default/openharmony/toolchains/hdc`），可通过环境变量指定：

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

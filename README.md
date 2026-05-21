# 蚂蚁森林自动收取

基于 OCR 识别的蚂蚁森林自动收取工具，适用于鸿蒙设备（通过 HDC 控制）。

## 前置条件

1. **鸿蒙设备**：已开启 USB 调试，并通过 USB 连接电脑
2. **HDC 工具**：从[华为开发者官网](https://developer.huawei.com/consumer/cn/download/)下载 Command Line Tools 并解压
3. **蚂蚁森林**：打开支付宝，进入蚂蚁森林好友排行榜页面（停留在第一个好友）

## 快速开始

```bash
# 一键检查环境（Python、依赖、HDC、设备连接）
bash setup.sh

# 运行
python ant_forest_collect.py
```

脚本会自动从以下位置查找 HDC：
- 环境变量 `HDC_PATH`
- 系统 PATH
- `~/Downloads/command-line-tools/sdk/` 下的常见路径

如果 hdc 不在上述位置，可手动指定：

```bash
HDC_PATH=/path/to/hdc python ant_forest_collect.py
```

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

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
蚂蚁森林自动收取 - 稳定版
OCR识别按钮，稳定可靠
"""

import cv2
import subprocess
import time
import os
import logging
from rapidocr_onnxruntime import RapidOCR

# 配置
HDC_PATH = os.environ.get("HDC_PATH", "~/Downloads/command-line-tools/sdk/default/openharmony/toolchains/hdc")
HDC_PATH = os.path.expanduser(HDC_PATH)
MAX_COUNT = 100
MAX_COLLECT_FAIL = 3  # 一键收连续失败次数
OCR_SCALE = 0.5  # 缩小图像比例，减少CPU占用

# 日志配置
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S"
)
log = logging.getLogger(__name__)

ocr = RapidOCR()

def screenshot():
    """截图并返回图像"""
    try:
        subprocess.run([HDC_PATH, "shell", "snapshot_display", "-f", "/data/local/tmp/s.jpeg"],
                       capture_output=True, timeout=10, check=True)
        subprocess.run([HDC_PATH, "file", "recv", "/data/local/tmp/s.jpeg", "/tmp/s.jpeg"],
                       capture_output=True, timeout=10, check=True)
        img = cv2.imread("/tmp/s.jpeg")
        if img is None:
            log.warning("截图读取失败")
        return img
    except subprocess.TimeoutExpired:
        log.error("截图超时")
        return None
    except subprocess.CalledProcessError as e:
        log.error(f"截图命令失败: {e}")
        return None

def click(x, y):
    """模拟点击"""
    try:
        subprocess.run([HDC_PATH, "shell", "uitest", "uiInput", "click", str(x), str(y)],
                       capture_output=True, timeout=5, check=True)
    except (subprocess.TimeoutExpired, subprocess.CalledProcessError) as e:
        log.warning(f"点击失败 ({x}, {y}): {e}")

def find_buttons(img):
    """OCR找按钮"""
    if img is None:
        return None, None

    # 缩小图像减少CPU占用
    small = cv2.resize(img, None, fx=OCR_SCALE, fy=OCR_SCALE, interpolation=cv2.INTER_AREA)
    result, _ = ocr(small)
    if result is None:
        return None, None

    collect_pos = None
    next_pos = None

    for box, text, _ in result:
        x1, y1 = box[0]
        x2, y2 = box[2]
        # 坐标还原到原始尺寸
        cx = int((x1 + x2) / 2 / OCR_SCALE)
        cy = int((y1 + y2) / 2 / OCR_SCALE)

        if "一键收" in text and collect_pos is None:
            collect_pos = (cx, cy)
        elif "找能量" in text and next_pos is None:
            next_pos = (cx, cy)

    return collect_pos, next_pos

def main():
    log.info("蚂蚁森林收取 started")
    print("=" * 30)

    count = 0
    collect_fail = 0  # 一键收失败计数
    next_fail = 0     # 找能量失败计数
    times = []

    while count < MAX_COUNT and collect_fail < MAX_COLLECT_FAIL and next_fail < 3:
        t0 = time.time()

        # 截图
        img = screenshot()
        collect_pos, next_pos = find_buttons(img)

        # 点击"一键收"
        if collect_pos:
            click(collect_pos[0], collect_pos[1])
            collect_fail = 0
            time.sleep(1)
        else:
            collect_fail += 1
            log.warning(f"未找到一键收按钮 ({collect_fail}/{MAX_COLLECT_FAIL})")
            if collect_fail >= MAX_COLLECT_FAIL:
                log.info("一键收连续失败，退出")
                break

        # 点击"找能量"
        if next_pos:
            click(next_pos[0], next_pos[1])
            time.sleep(1.5)
            count += 1
            next_fail = 0
            elapsed = time.time() - t0
            times.append(elapsed)
            print(f"{count}:{elapsed:.1f}s", end=" ", flush=True)
        else:
            next_fail += 1
            print("✗", end=" ", flush=True)
            time.sleep(0.5)

    if times:
        print(f"\n完成! {count}次, 平均{sum(times)/len(times):.1f}s/次")
    log.info(f"结束: {count}次收取")

if __name__ == "__main__":
    main()

#!/bin/bash

# 移除旧 item（防止冲突）
sketchybar --remove keystroke

# 添加 item 和基本设置
sketchybar --add item keystroke right \
  --set keystroke icon=⌨ \
  icon.font="SF Pro:Bold:32.0" \
  icon.color=0xffffffff \
  icon.padding_left=5 \
  label.font="JetBrains Mono NL:Semibold:13.0" \
  label.padding_left=5 \
  label.padding_right=5 \
  script="/Users/ericxu/.config/sketchybar/plugins/keystroke_display.sh"

# 单独设置 update_freq, click_script 和 subscribe（避免加载问题）
sketchybar --set keystroke update_freq=5 \
  click_script="/Users/ericxu/.config/sketchybar/plugins/keystroke_trend.sh" \
  --subscribe keystroke mouse.clicked system_woke

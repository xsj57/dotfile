#!/bin/sh

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

# 选择图标
if [ -n "$CHARGING" ]; then
  # 充电图标
  case ${PERCENTAGE} in
  100) ICON="󰂅" ;;
  9[0-9]) ICON="󰂋" ;;
  8[0-9]) ICON="󰂊" ;;
  7[0-9]) ICON="󰢞" ;;
  6[0-9]) ICON="󰂉" ;;
  5[0-9]) ICON="󰢝" ;;
  4[0-9]) ICON="󰂈" ;;
  3[0-9]) ICON="󰂇" ;;
  2[0-9]) ICON="󰂆" ;;
  1[0-9]) ICON="󰢜" ;;
  [0-9]) ICON="󰢟" ;;
  *) ICON="󰂑" ;;
  esac
else
  # 电池图标
  case ${PERCENTAGE} in
  100) ICON="󰁹" ;;
  9[0-9]) ICON="󰂂" ;;
  8[0-9]) ICON="󰂁" ;;
  7[0-9]) ICON="󰂀" ;;
  6[0-9]) ICON="󰁿" ;;
  5[0-9]) ICON="󰁾" ;;
  4[0-9]) ICON="󰁽" ;;
  3[0-9]) ICON="󰁼" ;;
  2[0-9]) ICON="󰁻" ;;
  1[0-9]) ICON="󰁺" ;;
  [0-9]) ICON="󰂎" ;;
  *) ICON="󰂑" ;;
  esac
fi

# 设置颜色
if [ "$PERCENTAGE" -gt 50 ]; then
  COLOR=0xffffffff
elif [ "$PERCENTAGE" -gt 20 ]; then
  COLOR=0xffe6cfe6
else
  COLOR=0xfff7768e
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" \
  icon.color="$COLOR" label.color="$COLOR"

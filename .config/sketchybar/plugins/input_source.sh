#!/bin/sh

# 尝试不同的路径找到 im-select
if [ -x "/usr/local/bin/im-select" ]; then
  INPUT_SOURCE=$(/usr/local/bin/im-select)
elif command -v im-select >/dev/null 2>&1; then
  INPUT_SOURCE=$(im-select)
else
  # im-select 未找到
  sketchybar --set "$NAME" label="?" icon="⚠️"
  exit 1
fi

# 根据完整的输入法 ID 设置显示和图标
case "$INPUT_SOURCE" in
"com.apple.keylayout.ABC")
  LABEL="EN"
  ICON="🇺🇸"
  ;;
"com.apple.inputmethod.SCIM.ITABC")
  LABEL="简"
  ICON="🇨🇳"
  ;;
"com.apple.inputmethod.TCIM.Pinyin")
  LABEL="繁"
  ICON="🇹🇼"
  ;;
"com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese")
  LABEL="あ"
  ICON="🇯🇵"
  ;;
*)
  # 未知输入法
  LABEL="?"
  ICON="🌐"
  ;;
esac

# 更新 SketchyBar（同时设置图标和标签）
sketchybar --set "$NAME" label="$LABEL" icon="$ICON"

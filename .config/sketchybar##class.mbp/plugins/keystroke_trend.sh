#!/bin/bash

DATA_FILE="/Users/ericxu/.keystroke_data.json"
TODAY=$(date +"%Y-%m-%d")

# 获取过去7天日期
DATES=()
for i in {0..6}; do
  DATES+=($(date -v-${i}d +"%Y-%m-%d"))
done

# 读取数据
TREND=""
TODAY_COUNT=0
for DATE in "${DATES[@]}"; do
  COUNT=$(jq -r ".\"$DATE\"" "$DATA_FILE" 2>/dev/null)
  if [ "$COUNT" == "null" ] || [ -z "$COUNT" ]; then
    COUNT=0
  fi
  if [ "$DATE" == "$TODAY" ]; then
    TODAY_COUNT=$COUNT
  fi
  TREND="$TREND$DATE: $COUNT\n"
done

# 简单 ASCII 趋势图
MAX=$(echo "$TREND" | awk -F: '{print $2}' | sort -nr | head -1)
if [ "$MAX" -eq 0 ]; then MAX=1; fi
TREND_GRAPH=""
for DATE in "${DATES[@]}"; do
  COUNT=$(jq -r ".\"$DATE\"" "$DATA_FILE" 2>/dev/null)
  if [ "$COUNT" == "null" ]; then COUNT=0; fi
  BAR=$(printf '█%.0s' $(seq 1 $((COUNT * 10 / MAX))))
  TREND_GRAPH="$TREND_GRAPH$DATE: $BAR ($COUNT)\n"
done

# 显示弹出窗口
osascript -e "display dialog \"今天敲击: $TODAY_COUNT\n\n过去7天趋势:\n$TREND_GRAPH\" with title \"键盘敲击趋势\""

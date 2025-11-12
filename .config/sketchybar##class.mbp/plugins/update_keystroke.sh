#!/bin/bash

DATA_FILE="/Users/ericxu/.keystroke_data.json"
TODAY=$(date +"%Y-%m-%d")
LOCK_FILE="$DATA_FILE.lock"

# 使用 flock 避免并发写入问题
(
  /opt/homebrew/bin/flock -n 9 || exit 1 # 替换为你的 flock 绝对路径 (e.g., /usr/bin/flock or /opt/homebrew/bin/flock)

  # 读取当前数据
  if [ -f "$DATA_FILE" ]; then
    COUNT=$(jq -r ".\"$TODAY\"" "$DATA_FILE")
    if [ "$COUNT" == "null" ]; then
      COUNT=0
    fi
  else
    COUNT=0
    echo "{}" >"$DATA_FILE"
  fi

  # 增1并保存
  NEW_COUNT=$((COUNT + 1))
  jq ".\"$TODAY\" = $NEW_COUNT" "$DATA_FILE" >"$DATA_FILE.tmp"
  mv "$DATA_FILE.tmp" "$DATA_FILE"

) 9>"$LOCK_FILE"

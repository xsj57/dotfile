#!/bin/bash

DATA_FILE="/Users/ericxu/.keystroke_data.json"
TODAY=$(date +"%Y-%m-%d")

if [ -f "$DATA_FILE" ]; then
  COUNT=$(jq -r ".\"$TODAY\"" "$DATA_FILE")
  if [ "$COUNT" = "null" ] || [ -z "$COUNT" ]; then
    COUNT=0
  fi
else
  COUNT=0
fi

# 明确回写到 item 的 label
/opt/homebrew/bin/sketchybar --set keystroke label="$COUNT"

#!/bin/bash

OUTPUT_FILE=~/keystroke_counter_excluded.json

# 清空输出文件
>"$OUTPUT_FILE"

# 开始 JSON
echo '{' >>"$OUTPUT_FILE"
echo '  "title": "Keystroke Counter (Exclude F and Navigation Keys)",' >>"$OUTPUT_FILE"
echo '  "rules": [' >>"$OUTPUT_FILE"
echo '    {' >>"$OUTPUT_FILE"
echo '      "description": "Count keystrokes excluding F keys and navigation",' >>"$OUTPUT_FILE"
echo '      "manipulators": [' >>"$OUTPUT_FILE"

# 保留的 key_codes 列表（排除 F1-F20, arrows, page_up/down, home/end, insert 等）
KEY_CODES=(
  # 字母
  a b c d e f g h i j k l m n o p q r s t u v w x y z
  # 数字
  0 1 2 3 4 5 6 7 8 9
  # 符号和标点
  hyphen equal left_bracket right_bracket backslash semicolon quote comma period slash grave_accent
  # 控制键
  escape tab caps_lock left_shift left_control left_option left_command
  right_shift right_control right_option right_command
  space return delete forward_delete
  # 数字键盘
  keypad_0 keypad_1 keypad_2 keypad_3 keypad_4 keypad_5 keypad_6 keypad_7 keypad_8 keypad_9
  keypad_decimal keypad_plus keypad_minus keypad_multiply keypad_divide keypad_enter keypad_clear keypad_equal
  # 其他常见（保留音量等，如果你想排除，移除）
  volume_up volume_down mute
)

TOTAL_KEYS=${#KEY_CODES[@]}
INDEX=0
for KEY in "${KEY_CODES[@]}"; do
  INDEX=$((INDEX + 1))
  if [ $INDEX -lt $TOTAL_KEYS ]; then
    COMMA=","
  else
    COMMA=""
  fi
  echo '        {' >>"$OUTPUT_FILE"
  echo '          "type": "basic",' >>"$OUTPUT_FILE"
  echo '          "from": {' >>"$OUTPUT_FILE"
  echo '            "key_code": "'"$KEY"'",' >>"$OUTPUT_FILE"
  echo '            "modifiers": {' >>"$OUTPUT_FILE"
  echo '              "optional": ["any"]' >>"$OUTPUT_FILE"
  echo '            }' >>"$OUTPUT_FILE"
  echo '          },' >>"$OUTPUT_FILE"
  echo '          "to": [' >>"$OUTPUT_FILE"
  echo '            {' >>"$OUTPUT_FILE"
  echo '              "shell_command": "/bin/bash /Users/ericxu/.config/sketchybar/plugins/update_keystroke.sh"' >>"$OUTPUT_FILE"
  echo '            },' >>"$OUTPUT_FILE"
  echo '            {' >>"$OUTPUT_FILE"
  echo '              "key_code": "'"$KEY"'"' >>"$OUTPUT_FILE"
  echo '            }' >>"$OUTPUT_FILE"
  echo '          ]' >>"$OUTPUT_FILE"
  echo '        }'"$COMMA" >>"$OUTPUT_FILE"
done

# 结束 JSON
echo '      ]' >>"$OUTPUT_FILE"
echo '    }' >>"$OUTPUT_FILE"
echo '  ]' >>"$OUTPUT_FILE"
echo '}' >>"$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE"

# 验证 JSON
if jq . "$OUTPUT_FILE" >/dev/null; then
  echo "JSON is valid!"
else
  echo "JSON validation failed! Check for errors."
fi

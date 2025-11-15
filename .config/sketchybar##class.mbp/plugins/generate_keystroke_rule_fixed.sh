#!/bin/bash

OUTPUT_FILE=~/keystroke_counter_fixed.json

# 清空输出文件
>"$OUTPUT_FILE"

# 开始 JSON
echo '{' >>"$OUTPUT_FILE"
echo '  "title": "Keystroke Counter (Letters, Numbers, Symbols - No Hyperkey Conflict)",' >>"$OUTPUT_FILE"
echo '  "rules": [' >>"$OUTPUT_FILE"
echo '    {' >>"$OUTPUT_FILE"
echo '      "description": "Count letters, numbers, symbols; exclude when Caps Lock (Hyperkey) pressed",' >>"$OUTPUT_FILE"
echo '      "manipulators": [' >>"$OUTPUT_FILE"

# 正确 key_code 列表（字母、数字、标点；使用官方名称）
KEY_CODES=(
  # 字母
  a b c d e f g h i j k l m n o p q r s t u v w x y z
  # 数字
  0 1 2 3 4 5 6 7 8 9
  # 符号和标点（官方名称）
  hyphen equal_sign open_bracket close_bracket backslash semicolon single_quote comma period slash grave_accent_and_tilde
  # 数字键盘（数字 + 符号）
  keypad_0 keypad_1 keypad_2 keypad_3 keypad_4 keypad_5 keypad_6 keypad_7 keypad_8 keypad_9
  keypad_period keypad_hyphen keypad_asterisk keypad_slash keypad_equal_sign
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
  echo '          "conditions": [' >>"$OUTPUT_FILE"
  echo '            {' >>"$OUTPUT_FILE"
  echo '              "type": "modifier_flag",' >>"$OUTPUT_FILE" # 正确类型
  echo '              "name": "caps_lock",' >>"$OUTPUT_FILE"
  echo '              "value": 0' >>"$OUTPUT_FILE" # 0 表示未按下 (unless pressed)
  echo '            }' >>"$OUTPUT_FILE"
  echo '          ],' >>"$OUTPUT_FILE"
  echo '          "to": [' >>"$OUTPUT_FILE"
  echo '            {' >>"$OUTPUT_FILE"
  echo '              "shell_command": "/bin/bash /Users/ericxu/.config/sketchybar##class.mbp/plugins/update_keystroke.sh"' >>"$OUTPUT_FILE"
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

#!/bin/sh

# 获取基础电池信息
BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')
TIME_INFO=$(echo "$BATTERY_INFO" | grep -Eo "(\d+:\d+)|charged|no estimate")

# 获取系统详细信息
POWER_INFO=$(system_profiler SPPowerDataType 2>/dev/null)
CYCLE_COUNT=$(echo "$POWER_INFO" | grep "Cycle Count" | awk '{print $3}')
CONDITION=$(echo "$POWER_INFO" | grep "Condition" | awk '{print $2}')
MAX_CAPACITY=$(echo "$POWER_INFO" | grep "Maximum Capacity" | awk '{print $3}' | tr -d '%')

# 获取充电器信息
ADAPTER_INFO=$(echo "$POWER_INFO" | grep "Wattage" | awk '{print $2}')

# 设置状态文字
if [ -n "$CHARGING" ]; then
  if [ "$PERCENTAGE" -eq 100 ]; then
    STATUS="✅ 已充满"
  else
    STATUS="⚡ 正在充电"
  fi
else
  STATUS="🔋 使用电池"
fi

# 时间信息处理
if [ "$TIME_INFO" = "charged" ]; then
  TIME_TEXT="已充满"
elif [ "$TIME_INFO" = "no estimate" ]; then
  TIME_TEXT="计算中..."
elif [ -n "$TIME_INFO" ] && [ "$TIME_INFO" != "0:00" ]; then
  if [ -n "$CHARGING" ]; then
    TIME_TEXT="充满还需 $TIME_INFO"
  else
    TIME_TEXT="剩余使用 $TIME_INFO"
  fi
else
  TIME_TEXT="--"
fi

# 健康度显示
if [ -n "$MAX_CAPACITY" ]; then
  if [ "$MAX_CAPACITY" -ge 90 ]; then
    HEALTH_STATUS="🟢 优秀 ($MAX_CAPACITY%)"
  elif [ "$MAX_CAPACITY" -ge 80 ]; then
    HEALTH_STATUS="🟡 良好 ($MAX_CAPACITY%)"
  elif [ "$MAX_CAPACITY" -ge 70 ]; then
    HEALTH_STATUS="🟠 一般 ($MAX_CAPACITY%)"
  else
    HEALTH_STATUS="🔴 较差 ($MAX_CAPACITY%)"
  fi
else
  HEALTH_STATUS="未知"
fi

# 充电器信息
if [ -n "$ADAPTER_INFO" ]; then
  ADAPTER_TEXT="充电器: ${ADAPTER_INFO}W"
else
  ADAPTER_TEXT="充电器: 未连接"
fi

# 构建消息内容
MESSAGE="━━━━━━━━━━━━━━━━━━━━
   🔋 电池状态详情
━━━━━━━━━━━━━━━━━━━━

当前电量: ${PERCENTAGE}%
状态: ${STATUS}
时间: ${TIME_TEXT}

━━━ 电池健康 ━━━
健康度: ${HEALTH_STATUS}
循环次数: ${CYCLE_COUNT:-未知} 次
电池状况: ${CONDITION:-未知}

━━━ 电源信息 ━━━
${ADAPTER_TEXT}

━━━━━━━━━━━━━━━━━━━━"

# 使用 osascript 显示对话框
osascript <<EOF
display dialog "$MESSAGE" ¬
    buttons {"确定"} ¬
    default button "确定" ¬
    with title "电池信息" ¬
    with icon caution
EOF

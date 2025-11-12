#!/bin/bash

# Add event
#sketchybar --add event song_update com.apple.iTunes.playerInfo

# 启动音乐监听器（如果需要）
if ! pgrep -f music_monitor_file >/dev/null; then
  ~/.config/sketchybar/scripts/music_monitor_file >/dev/null 2>&1 &
fi

# 添加音乐项
sketchybar --add item music right \
  --set music script="~/.config/sketchybar/scripts/music" \
  click_script="osascript -e 'tell application \"Music\" to playpause'" \
  icon="􀊖" \
  label="Loading..." \
  label.font="JetBrains Mono NL:Bold:16.0" \
  label.color=0xffffffff \
  update_freq=2 \
  updates=on \
  drawing=off

# 添加事件订阅（可选）
sketchybar --add event music_change com.apple.Music.playerInfo
sketchybar --subscribe music music_change

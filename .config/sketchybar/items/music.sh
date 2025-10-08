#!/bin/bash

# Add event
sketchybar -m --add event song_update com.apple.iTunes.playerInfo

# Add Music Item
sketchybar -m --add item music right \
  --set music script="~/.config/sketchybar/scripts/music" \
  --set music labal.font="JetBrains Mono NL:28.0" \
  click_script="~/.config/sketchybar/scripts/music_click" \
  label.padding_right=10 \
  drawing=off \
  --subscribe music song_update

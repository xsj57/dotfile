#!/bin/bash

sketchybar --add item battery right \
  --set battery script="$PLUGIN_DIR/battery.sh" \
  click_script="$PLUGIN_DIR/battery_click.sh" \
  update_freq=30 \
  updates=on \
  icon.font="JetBrains Mono NL:Regular:16.0" \
  label.font="SF Pro:Semibold:13.0" \
  label.padding_right=2 \
  icon.padding_left=2 \
  icon.padding_right=2

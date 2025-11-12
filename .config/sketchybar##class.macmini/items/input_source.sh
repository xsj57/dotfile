#!/bin/bash

sketchybar --add item input_source right \
  --set input_source script="$PLUGIN_DIR/input_source.sh" \
  icon.font="SF Pro:Regular:16.0" \
  label.font="JetBrains Mono NL:Bold:13.0" \
  label.padding_left=4 \
  label.padding_right=8 \
  icon.padding_left=8 \
  icon.padding_right=2 \
  background.color=0x33ffffff \
  background.corner_radius=5 \
  background.height=22 \
  background.padding_right=5 \
  background.padding_left=5 \
  update_freq=2 \
  updates=on

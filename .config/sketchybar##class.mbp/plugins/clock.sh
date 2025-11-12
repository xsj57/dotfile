#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

# Get current day of week (0=Sunday, 6=Saturday)
DAY_OF_WEEK=$(date +%w)

# Set cat icon based on day
if [ "$DAY_OF_WEEK" -eq 0 ] || [ "$DAY_OF_WEEK" -eq 6 ]; then
  # Weekend - solid cat
  CAT_ICON="􂁿" # 实心猫（周末）
else
  # Weekday - transparent cat
  CAT_ICON="􂁾" # 空心猫（工作日）
fi

# Get date and time
DATE_TIME=$(date '+%a, %b %d %H:%M')

# Update both icon and label
sketchybar --set "$NAME" icon="$CAT_ICON" label="$DATE_TIME"

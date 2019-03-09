#!/bin/bash

# Get list of only the device identifiers
# 1 list devices
# 2 grep away the line 'list of devices'
# 3 grep away newline at the end
# 4 cut off everything but the first part (identifier)
ALL=`adb devices -l`
#LIST=`adb devices | grep -v devices | grep device | cut -f1`
LIST=`echo "$ALL" | grep -v devices | grep device | awk '{print $1}'`

# Similar, but grabbing the model and brand instead
# 4 cut off everything but the last part ('model:HTC_One_X')
# 5 take only the part after the colon ('HTC_One_X')
DEVICES=`echo "$ALL" | grep -v devices | grep device | awk '{print $5}' | cut -d':' -f2`
# 6 replace underscores with spaces 
DEVICES=`echo "${DEVICES//_/ }"`

# Count lines
COUNT=`echo "$LIST" | wc -l`

TARGET_DIR=~/Desktop

adb_capture() {
  echo "Capturing $1..."
  # Using multiple commands because the onliner doesn't universally work on OSX and Linux
  adb -s $1 shell screencap -p /sdcard/screen.png
  adb -s $1 pull /sdcard/screen.png
  adb -s $1 shell rm /sdcard/screen.png
  OUT_FILE="$TARGET_DIR/device-$(date +"%Y-%m-%d-%s")-$1.png"
  mv screen.png $OUT_FILE
  echo "Saved to $OUT_FILE"
}


if ((COUNT==0))
then
  echo "No devices connected."
  exit 1
elif ((COUNT==1))
then
  # Pick first in list
  SERIAL=${LIST[0]}
  adb_capture $SERIAL
else
  # Show chooser
  while true; do
    echo "Choose a device to execute this command on:"
    echo ""
    i=1
    while read -r line; do
      echo "  [$i] $line"
      i=$((i+1))
    done <<< "$DEVICES"
    echo "  [a] All"
    echo "  [c] Cancel"
    echo ""
  
    read -n1 -s n
    if (( n <= COUNT && n > 0 )); then
      SERIAL=`echo "$LIST" | head -n $n | tail -n 1`
      adb_capture $SERIAL
      break
    elif [[ $n == "c" ]]; then
      echo "Canceled."
      break
    elif [[ $n == "a" ]]; then
      for SERIAL in $LIST; do
        adb_capture $SERIAL
      done
      break
    else
      echo "Let's try that again."
      continue
    fi
  done
fi

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

if ((COUNT==0))
then
  echo "No devices connected."
  exit 1
elif ((COUNT==1))
then
  # execute regular command
  adb $@
else
  # Show chooser
  while true; do
    echo "Choose a device to execute this command on:"
    echo "  adb $@"
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
      echo "adb -s $SERIAL $@"
      adb -s $SERIAL $@
      break
    elif [[ $n == "c" ]]; then
      echo "Canceled."
      break
    elif [[ $n == "a" ]]; then
      for SERIAL in $LIST; do
        echo "adb -s $SERIAL $@"
        adb -s $SERIAL $@
      done
      break
    else
      echo "Let's try that again."
      continue
    fi
  done
fi

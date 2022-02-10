#!/bin/bash

COMMAND=$@

### Handle special simplified commands

# "adbplus open {url}"
# Opens a URL on the device
if [ "$1" = "open" ]; then
  if [ -z "$2" ]; then
    echo "No url supplied for `open` command."
    exit 1
  else
    COMMAND="shell am start -a android.intent.action.VIEW -d '$2'"
  fi
fi

# "adbplus apk {filename}"
# Installs an APK and open its folder in Finder
if [ "$1" = "apk" ]; then
  if [ -z "$2" ]; then
    echo "No filename of an APK provided."
    exit 1
  else
    COMMAND="install -r $2"
    OPEN_AFTER=1
  fi
fi

# "adbplus transfer {filename}"
# Upload a file to the Downloads folder on the phone
if [ "$1" = "transfer" ]; then
  if [ -z "$2" ]; then
    echo "No filename to transfer to phone provided."
    exit 1
  else
    COMMAND="push $2 /sdcard/Download/"
  fi
fi

# "adbplus input Lorem Ipsum"
# Type text
if [ "$1" = "input" ]; then
  if [ -z "$2" ]; then
    echo "No text provided to input on the device(s)."
    exit 1
  else
    # Replace each space with %s
    COMMAND="shell input text '${2// /$'%s'}'"
  fi
fi

# "adb clear {app id}"
# Clears app data
if [ "$1" = "clear" ]; then
  if [ -z "$2" ]; then
    echo "No application ID provided."
    exit 1
  else
    COMMAND="shell pm clear $2"
  fi
fi

### Get list of only the device identifiers
# 1 list devices
# 2 grep away the line 'list of devices'
# 3 grep away newline at the end
# 4 cut off everything but the first part (identifier)
ALL=`adb devices -l`
#LIST=`adb devices | grep -v devices | grep device | cut -f1`
LIST=`echo "$ALL" | grep -v devices | grep device | awk '{print $1}'`

### Similar, but grabbing the model and brand instead
# 4 cut off everything but the last part ('model:HTC_One_X')
# 5 take only the part after the colon ('HTC_One_X')
DEVICES=`echo "$ALL" | grep -v devices | grep device | awk '{print $5}' | cut -d':' -f2`
# 6 replace underscores with spaces 
DEVICES=`echo "${DEVICES//_/ }"`

### Count lines
COUNT=`echo "$LIST" | wc -l`

### Execute command
if ((COUNT==0))
then
  echo "No devices connected."
  exit 1
elif ((COUNT==1))
then
  # execute regular command
  adb $COMMAND
else
  # Show chooser
  while true; do
    echo "Choose a device to execute this command on:"
    echo "  adb $COMMAND"
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
      echo "adb -s $SERIAL $COMMAND"
      adb -s $SERIAL $COMMAND
      break
    elif [[ $n == "c" ]]; then
      echo "Canceled."
      break
    elif [[ $n == "a" ]]; then
      for SERIAL in $LIST; do
        echo "adb -s $SERIAL $COMMAND"
        adb -s $SERIAL $COMMAND
      done
      break
    else
      echo "Let's try that again."
      continue
    fi
  done
fi

### Open folder after install
if [ -z ${OPEN_AFTER+x} ]; then
  echo "Done."
else
  open "$(dirname "$2")"
  echo "Done."
fi

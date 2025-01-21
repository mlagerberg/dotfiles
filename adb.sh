#!/bin/bash

COMMAND=$@

### Handle special simplified commands

# "adbplus help"
# Shows the custom commands
if [ "$1" = "help" ]; then
  echo "Usage:
adbplus help			Show this message
adbplus open {uri} 		Opens a URI on the device
adbplus apk {file}		Installs an APK and opens its folder in Finder
adbplus transfer { file}	Transfers a file to the Downloads folder on the device
adbplus input '{text}'		Types the text on the device
adbplus clear {app id} 		Clears the data for the given app.
adbplus wifi {ip}            Connects to WiFi-debugging enabled device, on port 37000-44000
adbplus fixport [ip]            Sets a fixed port for WiFi-debugging (5555) until device reboot

Other commands are passed on to adb."
  exit 0
fi

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

# Finds the port to connect to for the given IP
if [ "$1" = "wifi" ]; then
  if [ -z "$2" ]; then
    echo "No IP address provided."
    exit 1
  else
    IP="$2"
    echo "Scanning ports..."
    PORT=$(nmap $IP -p 37000-44000 | awk "/\/tcp/" | cut -d/ -f1)
    echo "Port $PORT found for debugging"
    #adb connect $IP:$(nmap $IP -p 37000-44000 | awk "/\/tcp/" | cut -d/ -f1)
    adb connect "$IP:$PORT"
    exit 0
  fi
fi

# Fixes the port for WiFi-debugging to 5555 until next reboot
# You might need to disconnect and reconnect afterwards
if [ "$1" = "fixport" ]; then
  if [ -z "$2" ]; then 
    COMMAND="tcpip 5555"
    echo "Remember to disconnect and reconnect after this."
  else
    echo "Note: this command only works when only one device is connected."
    adb tcpip 5555
    adb disconnect
    echo "Port set to 5555, reconnecting..."
    adb connect "$2:5555"
    echo "Reconnected."
    exit 0;
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
      serial=`echo "$LIST" | head -n $i | tail -n 1`
      echo "  [$i] $line - $serial"
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

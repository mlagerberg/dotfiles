#!/bin/bash
# /home/pi/dotfiles/dotfiles/status.sh

source /home/pi/dotfiles/functions.sh
source /etc/os-release

log_ts_file="/home/pi/.status_timestamp"

function header_line {
	echo
	echo "${fclblue}$1:${fcreset} ${fcdark}$2${fcreset} $3"
}
function header {
	echo
	echo "${fclblue}$1:  ${fcdark}$2${fcreset}"
}

function failed_logins {
	fails=`cat /var/log/auth.log | grep -cim1 failure`
	if [ $fails ]; then
		header 'Failed login attempts' ''
		tput bold; tput setaf 1
		count=0
		# get modified date:
		ts=0
		if [[ -f "$log_ts_file" ]]; then
			ts=$(stat -c %Y "$log_ts_file")
		fi
		ts=$((ts - 1000))
		#cat /var/log/auth.log | grep failure | head
		while read line; do
			# format: Jan 19 06:25:21  <log message>
			timestamp=$(date +%s -d "${line:0:15}")
			# if log line more recent that $ts
			if (($timestamp > $ts)); then
				error "$line"
				count=$((count + 1))
			fi
		done < <(cat /var/log/auth.log | grep 'failure')
		if (($count == 0)); then
			echo "${fcdark}None.${fcreset}"
		fi
		tput sgr0
	else
		header 'Failed login attempts' 'None.'
	fi
}

###########################################
clear

#### Show OS version
header 'OS Version' '`cat /etc/os-release`'
echo $PRETTY_NAME


#### Show current sessions
header 'Currently logged in' '`w`'
w


### prints the same as the first line of 'w'
#header "Uptime" '`uptime`'
#uptime


### Memory usage statistics
#header "Memory usage" '`free`'
#free


### List of relevant disk space statistics
header 'Disk space' '`df -h`'
#Only show table header, important partitions and external hd:
df -h -l --total | grep -E "/dev/sda|rootfs|Filesystem"


### Security: check currently open ports (TCP and UDP)
#header 'Open ports' '`netstat -vautnp`'
# using sudo otherwise -p doesn't work
#sudo netstat -vautnp
 # | grep -v "ntpd\|btsync\|node"


### Checking for failed login attempts
failed_logins
# Check if any of the arguments is clearlog:
if [[ $@ != **-keeplog** ]]; then
	warn "Login attempts prior to this point will no longer be shown."
	touch "$log_ts_file"
fi


# Running deamons
header 'Running services' ''
is_running "BitTorrent Sync" "btsync"


# Check  if clock is on time
#header_line 'Time and date' '' "`date`"


# Motion timelapse status
#header 'Last snapshot' ''
#datestamp=`ls -l /media/hdd/motion/lastsnap.jpg | cut -c74-83`
#timestamp=`ls -l /media/hdd/motion/lastsnap.jpg | cut -c97-104`
#header_line 'Last snapshot' '' "$datestamp at $timestamp"

echo

exit 0

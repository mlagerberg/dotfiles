#!/bin/bash

# ___ CREDITS
# This script plucked from https://github.com/aweijnitz/pi_backup/blob/master/backup.sh
# which started from
#   http://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself
# which in turn started from
#   http://www.raspberrypi.org/phpBB3/viewtopic.php?p=136912
#

# Setting up directories
SUBDIR=snozbackups
DIR=/media/hdd/$SUBDIR

function log {
   echo "$1"
   echo "$(date +%Y/%m/%d_%H:%M:%S) $1" >> $DIR/backup.log
}

# Check if backup directory exists
if [ ! -d "$DIR" ];
	then
		log "Backup directory $DIR doesn't exist, creating it..."
		mkdir -p $DIR
fi

log "-----"
log "RaspberryPI backup process started."

# First check if pv package is installed, if not, install it first
if `dpkg -s pv | grep -q Status;`
	then
		log "Package 'pv' is installed."
	else
		log "Package 'pv' is NOT installed. Installing..."
		apt-get -y install pv
fi

# Create a filename with datestamp for our current backup (without .img suffix)
OFILE="$DIR/snozbackup-$(date +%Y.%m.%d)"
# Create final filename, with suffix
OFILEFINAL=$OFILE.img
# First sync disks
sync; sync

# Shut down some services before starting backup process
log "Stopping services before backup..."
service btsync stop

# Begin the backup process, should take about 2.5 hours from 4Gb SD card to HDD
log "Backing up SD card to external HDD."
echo "This will take some time depending on your SD card size and read performance. Please wait..."
SDSIZE=`sudo blockdev --getsize64 /dev/mmcblk0`;
sudo pv -tpreb /dev/mmcblk0 -s $SDSIZE | dd of=$OFILE.temp bs=1M conv=sync,noerror iflag=fullblock
#echo "testbackup" >> $OFILE
# Wait for DD to finish and catch result
RESULT=$?

# Start services again that where shutdown before backup process
log "Starting the stopped services again..."
service btsync start

# If command has completed successfully, delete previous backups and exit
if [ $RESULT = 0 ];
	then
		log "Successful backup"
		# Delete everything but the 3 newest:
		cd $DIR
		# +4 because +3 keeps the 3 newest files, but we don't count the backup.log
		ls -t $DIR | tail -n +4 | xargs -d '\n' rm
		mv $OFILE.temp $OFILEFINAL
		log "Backup process completed. Output: $OFILEFINAL"
		exit 0
	# Else remove attempted backup file
	else
		log "Backup failed! Previous backup files untouched."
		log "Please check there is sufficient space on the HDD."
		rm -f $OFILE
		log "Intermediate file $OFILE removed."
		exit 1
fi

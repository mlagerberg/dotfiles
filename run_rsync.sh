#!/bin/bash
# Runs a backup of /media/hdd/BTSync to /media/backup/,
# incremental, keeping the last 3 versions.


# Sources:
#       rsync and hard links:   http://www.mikerubel.org/computers/rsync_snapshots/#Rsync
#       rsync progress:         http://www.cyberciti.biz/faq/show-progress-during-file-transfer/
#       human readable time:    http://www.daveeddy.com/2014/06/29/human-readable-duration-in-bash/

human() {
    local seconds=$1
    if ((seconds < 0)); then
        ((seconds *= -1))
    fi
    local times=(
        $((seconds / 60 / 60 / 24 / 365)) # years
        $((seconds / 60 / 60 / 24 / 30))  # months
        $((seconds / 60 / 60 / 24 / 7))   # weeks
        $((seconds / 60 / 60 / 24))       # days
        $((seconds / 60 / 60))            # hours
        $((seconds / 60))                 # minutes
        $((seconds))                      # seconds
    )
    local names=(year month week day hour minute second)
    local i
    for ((i = 0; i < ${#names[@]}; i++)); do
        if ((${times[$i]} > 1)); then
            echo "${times[$i]} ${names[$i]}s"
            return
        elif ((${times[$i]} == 1)); then
            echo "${times[$i]} ${names[$i]}"
            return
        fi
    done
    echo '0 seconds'
}

#exec >  >(tee -a /home/pi/rsync.log)
#exec 2> >(tee -a /home/pi/rsync.log >&2)

# Remount backup partition for read-write
# (as a safety measure, its read-only for the
# rest of the time).
# Disabled, because unfortunately:
# "Remounting is not supported at present. You have to umount volume and then mount it once again."
#mount -o remount,rw /media/backup


START=$(date +%s)
echo "==="
date
echo "Starting backup script..."
cd /media/backup

# Shift old backups (looping around for performance)
echo "Shifting old backups..."
mv backup.3 backup.tmp 2>/dev/null
mv backup.2 backup.3 2>/dev/null
mv backup.1 backup.2 2>/dev/null
mv backup.0 backup.1 2>/dev/null
mv backup.tmp backup.0 2>/dev/null

# Create hard link structure (uses practically no space)
echo "Creating link structure..."
cp -al backup.1/. backup.0

# Copy only the changes over the hard link structure
echo "Copying files..."
rsync -v -a --delete /media/hdd/BTSync/ backup.0/

# Remount for read-only
#mount -o remount,ro /media/backup
# Done
echo "Backup finished."
END=$(date +%s)
DIFF=$(echo "$END - $START" | bc)
echo "Script ran for $(human $DIFF)"

# Remember this moment
date > /home/pi/rsync.log
echo "Script ran for $(human $DIFF)" > /home/pi/rsync.log

# Annnnd notify
echo "Backup finished in $(human $DIFF)" | mail -s "Backup finished" "pi@localhost"



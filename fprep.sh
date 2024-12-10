#!/bin/bash
#
# Resizes videos to a max width of 1920p,
# compresses and optimizes for Android,
# and saves the first frame of the video as
# JPEG (used in the app to show a preview).
#
#
# Usage:
# 	fprep.sh path/to/video.mp4
# Output:
#	path/to/video_compressed.mp4
# 	path/to/video.jpg
#

INPUT="$1"
OUTPUT=${INPUT%.*}

echo "==============="
echo "Compressing $INPUT to ${OUTPUT}_compressed.mp4..."

# Regular mode (1920 landscape video); Fast compression, large file
ffmpeg -i $1 -codec:v libx264 -preset fast -movflags +faststart -vf scale=1920:-1 "${OUTPUT}_compressed.mp4"

# Regular mode (1920 landscape video); Slow compression, small file
#ffmpeg -i $1 -codec:v libx264 -preset veryslow -movflags +faststart -vf scale=1920:-1 "${OUTPUT}_compressed.mp4"

# No resizing
#ffmpeg -i $1 -codec:v libx264 -preset veryslow -movflags +faststart -vf "scale=-1:1920, pad=ceil(iw/2)*2:ceil(ih/2)*2" "${OUTPUT}_compressed.mp4"

# Add this in case 'height is not diviseble by 2'
# -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"

# Make image of the first frame:
#ffmpeg -i "${OUTPUT}_compressed.mp4" -vf "select=eq(n\,0)" -q:v 3 "$OUTPUT.jpg"
echo "Done."

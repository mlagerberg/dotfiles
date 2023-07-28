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
ffmpeg -i $1 -codec:v libx264 -preset fast -movflags +faststart -vf scale=1920:-1 "${OUTPUT}_compressed.mp4"
ffmpeg -i "${OUTPUT}_compressed.mp4" -vf "select=eq(n\,0)" -q:v 3 "$OUTPUT.jpg"
echo "Done."

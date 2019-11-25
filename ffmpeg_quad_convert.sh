#!/bin/bash
#
# This script takes a 4-channel audio file, and re-saves it in a format
# that can be used by ExoPlayer on Android. The trick is to tear the file
# apart in separate channels and simple resave it to an AAC file; in the
# process the channels will be correctly labeled and registered in the meta
# data in a way that is compatible with ExoPlayer.
# Without doing this, the file may play in most players but will either
# fail to play in ExoPlayer, or succeed but fail to be processed by 
# a multichannel AudioProcessor in ExoPlayer.
#
# Requirements:
# 	The input can be a .wav or .aac file (or other multi-channel file
# 	compatible with ffmpeg)
#	It MUST have exactly 4 channels.
# 	The output will be a 4-channel AAC file
# 	FFMPEG must be compiled with AAC support (without requiring the --strict 2 flag)
#
# Usage:
# 	./convert.sh my_quad_file.wav
#

OUTPUT_FILE="$1_converted.aac"
echo "Step 1: extract 4 channels"
ffmpeg -i $1 -map_channel 0.0.0 channel1.tmp.wav -map_channel 0.0.1 channel2.tmp.wav -map_channel 0.0.2 channel3.tmp.wav -map_channel 0.0.3 channel4.tmp.wav

echo "Step 2: combine channels into 1 file"
ffmpeg -i channel1.tmp.wav -i channel2.tmp.wav -i channel3.tmp.wav -i channel4.tmp.wav -codec:a aac -filter_complex "[0:a][1:a][2:a][3:a] amerge=inputs=4" -ac 4 $OUTPUT_FILE

echo "Cleaning up"
rm channel1.tmp.wav
rm channel2.tmp.wav
rm channel3.tmp.wav
rm channel4.tmp.wav

echo "Done."

FILESIZE=$(stat -c%s "$OUTPUT_FILE")
echo "Size of $OUTPUT_FILE = $FILESIZE bytes."

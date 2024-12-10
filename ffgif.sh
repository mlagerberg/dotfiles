#!/bin/bash

# Turns a video into a gif
# Usage: ffgif input.mp4
# Output will be input.mp4.gif

ffmpeg -i $1 -filter_complex "[0:v] palettegen" $1.palette.png
ffmpeg -i $1 -i $1.palette.png -filter_complex "[0:v][1:v] paletteuse" $1.gif

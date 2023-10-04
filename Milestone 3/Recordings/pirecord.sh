#!/bin/bash

echo "Pi 1: recording start"

arecord -D plughw:0 -d 5 -c2 -r 48000 -f S32_LE -t wav -V stereo -v stereo1.wav

echo "Pi 1: recording end"

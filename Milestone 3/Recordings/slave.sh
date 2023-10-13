#!/bin/bash
# This is pi 2
# slave.sh
echo "pi 2 login"

#sleep 0.01
while [ ! -e /tmp/trigger ]; do
  sleep 0.0001
done

pulseaudio -k

# no timestamp, ssh method
arecord -D plughw:0 -c2 -d 10 -r 48000 -f S32_LE -t wav -V stereo -v stereo2.wav

# timestamp recording method
#timestamp=$(date +'%Y-%m-%d_%H-%M-%S.%3N')
#arecord -d 10 -f S32_LE -t wav -V stereo -v "audio2-$timestamp.wav"

#arecord -c 2 -r 44100 -f S32_LE -t wav -d 10 -v stereo2.wav

sleep 0.1

echo "pi 2 recording done"
rm -f /tmp/trigger

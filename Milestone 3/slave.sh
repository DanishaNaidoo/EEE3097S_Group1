#!/bin/bash
# This is pi 2
# slave.sh

echo "Pi 2 login"

# wait for trigger from master Pu
while [ ! -e /tmp/trigger ]; do
  sleep 0.0001
done

# kill potetential PulseAudio process
pulseaudio -k

# no timestamp, final version
arecord -D plughw:0 -c2 -d 10 -r 48000 -f S32_LE -t wav -V stereo -v stereo2.wav

# timestamp recording method
#timestamp=$(date +'%Y-%m-%d_%H-%M-%S.%3N')
#arecord -d 10 -f S32_LE -t wav -V stereo -v "audio2-$timestamp.wav"

sleep 0.1

echo "Pi 2 recording done"

# remove trigger file if still there
rm -f /tmp/trigger

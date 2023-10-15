#!/bin/bash
# This is pi 1
# master.sh

echo "Pi 1 login"
remote_user2="raspberrypi2"
remote_host2="192.168.43.89"
trigger_path="/tmp/trigger"

# send trigger signal to slave Pi
ssh "$remote_user2@$remote_host2" "touch $trigger_path"

# wait for its trigger signal from controller
while [ ! -e /tmp/trigger ]; do
  sleep 0.0001
done

# timestamp recording method
#timestamp=$(date +'%Y-%m-%d_%H-%M-%S.%3N')
#arecord -c 2 -r 48000 -f S32_LE -t wav -d 10 -v stereo1.wav

# no timestamp, final version
arecord -D plughw:0 -c2 -d 10 -r 48000 -f S32_LE -t wav -V stereo -v stereo1.wav

sleep 0.1

echo "Pi 1 recording done"

# remove trigger file
rm -f /tmp/trigger

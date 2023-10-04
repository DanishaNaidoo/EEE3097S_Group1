#!/bin/bash
# This is pi 1
rm -f /tmp/master_start_recording
echo "pi 1 waiting for pi 2 to be ready..."

# Wait for a signal from the slave Pi that it's ready
while [ ! -f /tmp/slave_ready ]; do
    sleep 1
done

# Signal the slave Pi to start recording
touch /tmp/start_recording

echo "pi 1 recording start"

# Start recording on the master Pi
arecord -D plughw:0 -c2 -r 48000 -d 10 -f S32_LE -t wav -V stereo -v stereo1.wav

# Create a "completion" file to signal that recording is finished
touch /tmp/recording_1_complete

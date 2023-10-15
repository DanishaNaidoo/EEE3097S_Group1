#!/bin/bash
# This is pi 2
rm -f /tmp/slave_ready
echo "pi 2 waiting for the signal from pi 1..."

# Wait for a signal from the master Pi to start recording
while [ ! -f /tmp/start_recording ]; do
    sleep 1
done

# Signal the master Pi that the slave is ready
touch /tmp/slave_ready

echo "pi 2 recording start"

# Start recording when the signal is received
arecord -D plughw:0 -c2 -r 48000 -d 10 -f S32_LE -t wav -V stereo -v stereo2.wav

# Create a "completion" file to signal that recording is finished
touch /tmp/recording_2_complete

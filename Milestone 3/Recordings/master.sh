#!/bin/bash
#this is pi 1
slave_ip = "192.168.43.19" #pi 2
# Calculate the start time with millisecond precision
start_time=$(date +%s.%3N)

# Calculate the duration for which recording should occur (e.g., 10 seconds)
duration=10

# Calculate the end time based on start time and duration
end_time=$(echo "$start_time + $duration" | bc)

# SSH into the slave Raspberry Pi and send the start time
ssh pi@slave_ip "echo $start_time > /tmp/start_time"

# Start recording if the current time is within the desired start and end time range
current_time=$(date +%s.%3N)
if (( $(echo "$current_time >= $start_time && $current_time < $end_time" | bc -l) )); then
    arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -v stereo1.wav
fi

# Create a "completion" file to signal that recording is finished
touch /tmp/recording_1_complete

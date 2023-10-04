#!/bin/bash
#this is pi 2
start_time_file="/tmp/start_time"

# Wait until the start time is received from the master
while [ ! -f $start_time_file ]; do
    sleep 1
done

# Read the start time from the file
start_time=$(cat $start_time_file)

# Calculate the duration for which recording should occur (e.g., 10 seconds)
duration=10

# Calculate the end time based on start time and duration
end_time=$(echo "$start_time + $duration" | bc)

# Start recording if the current time is within the desired start and end time range
current_time=$(date +%s.%3N)
if (( $(echo "$current_time >= $start_time && $current_time < $end_time" | bc -l) )); then
    arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -v stereo2.wav
fi

# Create a "completion" file to signal that recording is finished
touch /tmp/recording_2_complete

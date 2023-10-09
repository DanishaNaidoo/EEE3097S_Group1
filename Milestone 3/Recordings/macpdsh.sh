#!/bin/bash

echo "Starting script!"
# ssh raspberrypi1@192.168.43.41
# ssh raspberrypi2@192.168.43.89

# megan's mac 192.168.43.238
# Define variables
remote_user1="raspberrypi1"
#danisha's phone:
remote_host1="192.168.43.41"
#qailah's house:
#remote_host1="192.168.0.110"
remote_file1="stereo1.wav"

remote_user2="raspberrypi2"
#danisha's phone:
remote_host2="192.168.43.89"
#qailah's house:
#remote_host2="192.168.0.111"
remote_file2="stereo2.wav"

local_dir="/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/Recordings"
remote_password="group1"
remote_script1="master.sh"
remote_script2="slave.sh"

timestamp=$(date "+%Y-%m-%d %H:%M:%S.%3N")

#synchronise the clocks
pdsh -w ^hosts.txt 'sudo service ntp restart'

#execute record commands simultaneously
pdsh -w ^hosts.txt 'arecord -D plughw:0 -c2 -d 10 -r 48000 -f S32_LE -t wav -V stereo -v stereo1.wav'

ssh "$remote_user2@$remote_host2" "mv stereo1.wav stereo2.wav"

scp "$remote_user1@$remote_host1:$remote_file1" "$local_dir"

echo "File transfer for first pi completed!"

scp "$remote_user2@$remote_host2:$remote_file2" "$local_dir"

echo "File transfer for second pi completed!"

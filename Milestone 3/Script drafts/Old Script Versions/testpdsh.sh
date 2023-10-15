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

#synchronise the clocks
pdsh -w ^hosts.txt 'sudo service ntp restart'

#execute record commands simultaneously
pdsh -w ^hosts.txt "timestamp=\$(date +'%Y-%m-%d_%H-%M-%S.%3N'); arecord -d 10 -c2 -r 48000 -f S32_LE -t wav -V stereo -v \"audio-\$timestamp.wav\""

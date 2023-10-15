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

local_dir="/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/Recordings/lite_shell/"
remote_password="group1"
remote_script1="master.sh"
remote_script2="slave.sh"

# SSH into the master Raspberry Pi and run the master script remotely
ssh "$remote_user1@$remote_host1" "bash /home/$remote_user1/$remote_script1" &

# SSH into the slave Raspberry Pi and run the slave script remotely
ssh "$remote_user2@$remote_host2" "bash /home/$remote_user2/$remote_script2"

echo "Scripts executed on Raspberry Pi devices."

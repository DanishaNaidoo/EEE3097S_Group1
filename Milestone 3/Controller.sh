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

local_dir="/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/Recordings/"
remote_password="group1"
remote_script1="master.sh"
remote_script2="slave.sh"
trigger_path="/tmp/trigger"

pdsh -w ^hosts.txt 'sudo service ntp restart'

echo "restarted ntp"

# SSH into the master Raspberry Pi and run the master script remotely
ssh "$remote_user1@$remote_host1" "~/master.sh" &

# SSH into the slave Raspberry Pi and run the slave script remotely
ssh "$remote_user2@$remote_host2" "~/slave.sh" &

# Send the trigger signal to both Raspberry Pis simultaneously
ssh "$remote_user1@$remote_host1" "touch $trigger_path"
#ssh "$remote_user2@$remote_host2" "touch $trigger_path"

sleep 15

#ssh "$remote_user1@$remote_host1" "rm $trigger_path" &
#ssh "$remote_user2@$remote_host2" "rm $trigger_path"
#wait
echo "Scripts executed on Raspberry Pi devices."

echo "sshing files"

scp "$remote_user1@$remote_host1:$remote_file1" "$local_dir" 

scp "$remote_user2@$remote_host2:$remote_file2" "$local_dir"

echo "done"

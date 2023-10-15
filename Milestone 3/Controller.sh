#!/bin/bash

echo "Starting Controller script!"

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

# restart the NTP service on both Pis
pdsh -w ^hosts.txt 'sudo service ntp restart'

echo "Restarted NTP"

# SSH into the master Raspberry Pi and run the master script remotely
ssh "$remote_user1@$remote_host1" "~/master.sh" &

# SSH into the slave Raspberry Pi and run the slave script remotely
ssh "$remote_user2@$remote_host2" "~/slave.sh" &

# Send the trigger signal to master Raspberry Pi simultaneously
ssh "$remote_user1@$remote_host1" "touch $trigger_path"

# sleep to ensure that recordings have completed.
sleep 15

echo "Scripts executed on Raspberry Pi devices."

echo "Sending files"

# Transfer audio files from Pis to local directory on laptop
scp "$remote_user1@$remote_host1:$remote_file1" "$local_dir"  &

scp "$remote_user2@$remote_host2:$remote_file2" "$local_dir"

echo "Files transferred"

python3 gcc_phat.py

echo "TDOA values calculated."

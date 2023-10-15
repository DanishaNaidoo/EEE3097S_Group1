#!/bin/bash

echo "Starting!"

# Define variables
remote_user1="raspberrypi1"
master_ip="192.168.43.59"

remote_user2="raspberrypi2"
slave_ip="192.168.43.19"

local_dir="/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/Recordings"
remote_password="group1"

# SSH into the master Raspberry Pi and run the master script remotely
ssh pi@$master_ip 'bash -s' < master.sh &

# SSH into the slave Raspberry Pi and run the slave script remotely
ssh pi@$slave_ip 'bash -s' < slave.sh &

while true; do
    if ssh pi@$master_ip '[ -f /tmp/recording_1_complete ]' && ssh pi@$slave_ip '[ -f /tmp/recording_2_complete ]'; then
        echo "Both Raspberry Pis have finished recording."
        break
    fi
    sleep 1
done

#continue with mactask.sh

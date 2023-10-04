#!/bin/bash

echo "Starting!"

# Define variables
remote_user1="raspberrypi1"
remote_host1="192.168.43.41"
remote_file1="stereo1.wav"

remote_user2="raspberrypi2"
remote_host2="192.168.43.89"
remote_file2="stereo2.wav"

local_dir="/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/Recordings"
remote_password="group1"

# Use expect to automate the password entry for first pi
expect -c "
spawn scp $remote_user1@$remote_host1:$remote_file1 \"$local_dir\"
expect {
    \"password:\" {
        send \"$remote_password\n\"
        exp_continue
    }
    eof
}
"

echo "File transfer for first pi completed!"

expect -c "
spawn scp $remote_user2@$remote_host2:$remote_file2 \"$local_dir\"
expect {
    \"password:\" {
        send \"$remote_password\n\"
        exp_continue
    }
    eof
}
"

echo "File transfer for second pi completed!"

echo "Starting MATLAB..."

/Applications/MATLAB_R2023b.app/bin/matlab -nodisplay -r "run('/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/SimMain.m'); exit; "

echo "Done with MATLAB!"

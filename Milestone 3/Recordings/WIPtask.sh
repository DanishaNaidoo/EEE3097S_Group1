#!/bin/bash

echo "Starting!"

# Define variables
remote_user="raspberrypi2"
remote_host="192.168.0.113"
remote_file="stereo.wav"
local_dir="/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/Recordings"
remote_password="group1"

# Use expect to automate the password entry
expect -c "
spawn scp $remote_user@$remote_host:$remote_file \"$local_dir\"
expect {
    \"password:\" {
        send \"$remote_password\n\"
        exp_continue
    }
    eof
}
"

echo "File transfer completed!"

echo "Starting MATLAB..."

/Applications/MATLAB_R2023b.app/bin/matlab -nodisplay -r "run('/Users/megan/Desktop/ece design:eee3097s/EEE3097S_Group1/Milestone 3/SimMain.m'); exit; "

echo "Done with MATLAB!"

#!/usr/bin/expect
set timeout 30
set host "192.168.50.160"
set username "nvidia"
set password "nvidia"
set user nvidia
spawn ssh $username@$host
expect "*password*" {send "$password\r"}	
expect $user@* {send "roslaunch realsense2_camera rs_camera.launch\r"}	

interact

#!/bin/bash

echo "=====Linux Health Check ====="



echo "Hostname:"
hostname



echo "OS:"
cat /etc/os-release | grep PRETTY_NAME



echo "Upatime:"
uptime


echo  "CPU Load"
uptime | awk -F 'load average:' '{print $2}'


echo "CPU Information:"
nproc




echo "Disk Usage:"
df -h



echo "Memory:"
free -h



echo "IP Address:"
ip addr

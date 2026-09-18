#!/bin/bash

echo "===== Linux Health Check ====="
echo

# Collect system information
HOSTNAME=$(hostname)
KERNEL=$(uname -r)
CPU_CORES=$(nproc)
CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Basic information
echo "Hostname     : $HOSTNAME"
echo "OS           : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '"')"
echo "Kernel       : $KERNEL"
echo "CPU Cores    : $CPU_CORES"
echo "IP Address   : $IP_ADDRESS"
echo "Uptime       : $(uptime -p)"
echo

# CPU health
echo "CPU Load Check:"
if awk "BEGIN {exit !($CPU_LOAD >= $CPU_CORES)}"; then
    echo "CPU: WARNING - load $CPU_LOAD on $CPU_CORES cores"
else
    echo "CPU: OK - load $CPU_LOAD on $CPU_CORES cores"
fi
echo

# Disk health
echo "Disk Usage Check:"
if [ "$DISK_USAGE" -ge 80 ]; then
    echo "DISK: WARNING - ${DISK_USAGE}% used"
else
    echo "DISK: OK - ${DISK_USAGE}% used"
fi
echo

# Memory health
echo "Memory Usage Check:"
if [ "$MEM_USAGE" -ge 80 ]; then
    echo "MEMORY: WARNING - ${MEM_USAGE}% used"
else
    echo "MEMORY: OK - ${MEM_USAGE}% used"
fi

echo
echo "===== Health Check Complete ====="

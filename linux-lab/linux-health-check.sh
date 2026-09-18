#!/bin/bash

echo "===== Linux Health Check ====="
echo

# --------------------------------------------------
# Collect basic system information
# --------------------------------------------------
HOSTNAME=$(hostname)
KERNEL=$(uname -r)
CPU_CORES=$(nproc)
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "Hostname     : $HOSTNAME"
echo "OS           : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '"')"
echo "Kernel       : $KERNEL"
echo "CPU Cores    : $CPU_CORES"
echo "IP Address   : $IP_ADDRESS"
echo "Uptime       : $(uptime -p)"
echo


# --------------------------------------------------
# CPU Health Check
# --------------------------------------------------
check_cpu() {
    CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
    CPU_CORES=$(nproc)

    if awk "BEGIN {exit !($CPU_LOAD >= $CPU_CORES)}"; then
        echo "CPU: WARNING - load $CPU_LOAD on $CPU_CORES cores"
        return 1
    else
        echo "CPU: OK - load $CPU_LOAD on $CPU_CORES cores"
        return 0
    fi
}


# --------------------------------------------------
# Disk Health Check
# --------------------------------------------------
check_disk() {
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    if [ "$DISK_USAGE" -ge 80 ]; then
        echo "DISK: WARNING - ${DISK_USAGE}% used"
        return 1
    else
        echo "DISK: OK - ${DISK_USAGE}% used"
        return 0
    fi
}


# --------------------------------------------------
# Memory Health Check
# --------------------------------------------------
check_memory() {
    MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

    if [ "$MEM_USAGE" -ge 80 ]; then
        echo "MEMORY: WARNING - ${MEM_USAGE}% used"
        return 1
    else
        echo "MEMORY: OK - ${MEM_USAGE}% used"
        return 0
    fi
}


# --------------------------------------------------
# Run Health Checks
# --------------------------------------------------
echo "CPU Load Check:"
check_cpu
CPU_STATUS=$?
echo

echo "Disk Usage Check:"
check_disk
DISK_STATUS=$?
echo

echo "Memory Usage Check:"
check_memory
MEMORY_STATUS=$?
echo


# --------------------------------------------------
# Overall Health Status
# --------------------------------------------------
echo "===== Health Check Complete ====="

if [ "$CPU_STATUS" -ne 0 ] || [ "$DISK_STATUS" -ne 0 ] || [ "$MEMORY_STATUS" -ne 0 ]; then
    echo "OVERALL STATUS: WARNING"
    exit 1
else
    echo "OVERALL STATUS: OK"
    exit 0
fi
```

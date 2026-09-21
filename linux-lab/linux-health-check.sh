#!/bin/bash


timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

log() {
    local LEVEL="$1"
    local MESSAGE="$2"

    echo "$(timestamp) [$LEVEL] $MESSAGE"
}


VERBOSE=false
MODE="all"

for arg in "$@"; do
    case "$arg" in
        --verbose)
            VERBOSE=true
            ;;
        --cpu-only)
            if [ "$MODE" != "all" ]; then
                echo "Error: only one health-check mode can be selected."
                exit 1
            fi
            MODE="cpu"
            ;;


         --disk-only)
           if [ "$MODE" != "all" ]; then
               echo "Error: only one health-check mode can be selected."
               exit 1
           fi
           MODE="disk"
           ;;


        --memory-only)
          if [ "$MODE" != "all" ]; then
              echo "Error: only one health-check mode can be selected."
              exit 1
          fi
          MODE="memory"
          ;;


        --help)
            echo "Usage: $0 [--verbose] [--cpu-only|--disk-only|--memory-only|--help]"
            exit 0
            ;;

        *)
            echo "Unknown option: $arg"
            echo "Usage: $0 [--verbose] [--cpu-only|--disk-only|--memory-only|--help]"
            exit 1
            ;;
    esac
done


if [ "$VERBOSE" = true ]; then
    echo "Verbose mode enabled"
fi


if [ "$VERBOSE" = true ]; then
    VERBOSE_MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

    echo "===== Verbose Information ====="
    echo "Load Average : $(awk '{print $1, $2, $3}' /proc/loadavg)"
    echo "Root Disk    : $(df -h / | awk 'NR==2 {print $5}')"
    echo "Memory       : ${VERBOSE_MEM_USAGE}%"
    echo
fi


# --------------------------------------------------
# CPU Health Check
# --------------------------------------------------
check_cpu() {
    CPU_LOAD=$(awk '{print $1}' /proc/loadavg)
    CPU_CORES=$(nproc)

    if awk "BEGIN {exit !($CPU_LOAD >= $CPU_CORES)}"; then
        log WARNING "CPU load $CPU_LOAD on $CPU_CORES cores"
        return 1
    else
        log OK "CPU load $CPU_LOAD on $CPU_CORES cores"
        return 0
    fi
}


# --------------------------------------------------
# Disk Health Check
# --------------------------------------------------
check_disk() {
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    if [ "$DISK_USAGE" -ge 80 ]; then
        log WARNING "Disk usage ${DISK_USAGE}%"
        return 1
    else
        log OK "Disk usage ${DISK_USAGE}%"
        return 0
    fi
}


# --------------------------------------------------
# Memory Health Check
# --------------------------------------------------
check_memory() {
    MEM_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

    if [ "$MEM_USAGE" -ge 80 ]; then
        log WARNING "Memory usage ${MEM_USAGE}%"
        return 1
    else
        log OK "Memory usage ${MEM_USAGE}%"
        return 0
    fi
}


case "$MODE" in
    cpu)
        check_cpu
        exit $?
        ;;

    disk)
        check_disk
        exit $?
        ;;

    memory)
        check_memory
        exit $?
        ;;
esac


echo "===== Linux Health Check ====="
echo

log INFO "Health check started"


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

log INFO "Health check completed"


# --------------------------------------------------
# Overall Health Status
# --------------------------------------------------


if [ "$CPU_STATUS" -ne 0 ] || [ "$DISK_STATUS" -ne 0 ] || [ "$MEMORY_STATUS" -ne 0 ]; then
    echo "OVERALL STATUS: WARNING"
    exit 1
else
    echo "OVERALL STATUS: OK"
    exit 0
fi


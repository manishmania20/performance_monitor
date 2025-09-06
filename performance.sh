#!/bin/bash
# Script to mesure the CPU, memory and disk usage of a remote server

# Location to save the report
LOG_DIR="/var/log/system_monitor"
mkdir -p $LOG_DIR

# Save report with timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$LOG_DIR/system_report_$TIMESTAMP.log"

print_header() {
    echo "=============================="
    echo "SYSTEM PERFORMANCE REPORT"
    echo "Hostname: $(hostname)"
    echo "Date: $(date)"
    echo "=============================="
    echo
}

cpu_usage () {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | awk '{print "Used: " 100 - $8 "% | Idle: " $8 "%"}'
    echo "-----------------------------------------------------"
    echo
}

memory_usage () {
    echo "Memory Usage:"
    free -h | awk '/Mem:/ {print "Used: " $3 " | Total: " $2}'
    free -h | awk '/Mem:/ {print "Utilization: " $3/$2 * 100.0 "%"}'
    echo "-----------------------------------------------------"
    echo
}

disk_usage () {
    echo "Disk Usage:"
    echo -e "Filesystem\tSize\tAvailable\tUse%"
    df -h | grep -E '^/dev/' | awk '{print $1 "\t" $2 "\t" $4 "\t" $4/$2 * 100.0 "%"}'
    echo "-----------------------------------------------------"
    echo
}

{
    print_header
    cpu_usage
    memory_usage
    disk_usage
} >> "$REPORT_FILE"
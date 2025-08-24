#!/bin/bash
# Script to mesure the CPU, memory and disk usage of a remote server

# Location to save the report
REPORT_FILE="/var/log/system_performance_report.log"

REPORT=$(cat <<EOF
--------------SYSTEM PERFORMANCE REPORT--------------

Hostname: $(hostname)
Date: $(date)
-----------------------------------------------------

CPU Usage:
$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')
-----------------------------------------------------

Memory Usage:
$(free -h | awk '/Mem:/ {print "Used: " $3 " | Total: " $2}')
$(free -h | awk '/Mem:/ {print "Utilization: " $3/$2 * 100.0 "%"}')
-----------------------------------------------------

Disk Usage:
Filesystem      Total   Free    Available
$(df -h | grep -E '^/dev/' | awk '{print $1 "\t" $2 "\t" $4 "\t" $4/$2 * 100.0 "%"}')
-----------------------------------------------------
EOF
)

# Output the report to the console
echo "$REPORT"

# Save the report to a file
echo "$REPORT" >> $REPORT_FILE
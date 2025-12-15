#!/bin/bash
echo "Morning system report:"
echo "Hostname:        $(hostname)"
echo "Kernel version:  $(uname -r)"
echo "Uptime:          $(uptime -p)"
echo "Disk space:      $(df -h | grep '/dev/sda2' | awk '{print "Total: " $2 ", Used: " $3 ", Free: " $4}')"

#!/bin/bash
echo "Hostname: " `hostname`
echo "Kernel version " `uname -r`
echo "Uptime: " `uptime`
echo "Disk space: " `df -h | grep '/dev/sda2'`

#!/bin/bash
cd /var/log || { echo "Cannot change to /var/log"; exit 1; }

if grep -qa "Failed password" auth.log; then
    echo "Unauthorized access attempts detected:"
    grep -a "Failed password" auth.log
    echo
    echo "Top 5 IP addresses with failed logins:"
    grep -a "Failed password" auth.log \
      | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
      | sort | uniq -c | sort -rn | head -n 5 \
      | awk '{print $2" - "$1" attempts"}'
else
    echo "No unauthorized access attempts found."
fi
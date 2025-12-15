#!/bin/bash
SUCCESS="/tmp/port_scan_success.log"
FAILED="/tmp/port_scan_failed.log"
: > "$SUCCESS"
: > "$FAILED"
echo "Scanning ports 22–1024 on localhost..."
SCAN_OUTPUT=$(nmap -sT -p 22-1024 -Pn localhost 2>&1)
STATUS=$?
if [ $STATUS -eq 0 ]; then
    echo "Port scan completed successfully."
else
    echo "Port scan failed."
fi
echo "$SCAN_OUTPUT" | grep "open" | tee -a "$SUCCESS"
echo "$SCAN_OUTPUT" | grep "closed\|filtered" | tee -a "$FAILED"
echo "Successful connections logged to: $SUCCESS"
echo "Failed connections logged to: $FAILED"

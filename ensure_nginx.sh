#!/bin/bash
LOGFILE="/var/log/restart_history.log"
mkdir -p "$(dirname "$LOGFILE")"
touch "$LOGFILE" 2>/dev/null || true
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOGFILE"
}
echo "Checking web server status"
if systemctl is-active --quiet nginx; then
    echo "Nginx is running."
    log "Nginx already running"
else
    echo "Nginx is not running. Starting Nginx..."
    log "Nginx not running — attempting start"
    if systemctl start nginx; then
        echo "Nginx started successfully."
        log "Nginx started successfully"
    else
        echo "Failed to start Nginx."
        log "Failed to start Nginx"
    fi
fi

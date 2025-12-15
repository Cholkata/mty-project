#!/bin/bash
set -euo pipefail
HOME_DIR="${1:-/home/user}"
BACKUP_DIR="/backup"
TIMESTAMP="$(date +%F_%H-%M-%S)"
BACKUP_FILE="$BACKUP_DIR/backup_$(basename "$HOME_DIR")_$TIMESTAMP.tar.gz"
if [[ ! -d "$HOME_DIR" ]]; then
    echo "Error: directory '$HOME_DIR' does not exist"
    exit 1
fi
mkdir -p "$BACKUP_DIR"
echo "Starting backup of $HOME_DIR..."
set +e
tar -czf "$BACKUP_FILE" -C "$(dirname "$HOME_DIR")" "$(basename "$HOME_DIR")"
TAR_STATUS=$?
set -e
if [[ $TAR_STATUS -eq 0 ]]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "Backup successful: $BACKUP_FILE ($SIZE)"
    exit 0
else
    echo "Backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi

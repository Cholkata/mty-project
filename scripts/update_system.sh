#!/bin/bash
echo "Updating system"
apt-get update && apt-get upgrade -y
if /var/run/reboot-required; then
    echo "Reboot required."
else
    echo "No reboot required."
fi
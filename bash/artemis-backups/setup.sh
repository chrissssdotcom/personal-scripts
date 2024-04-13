#!/bin/bash

# Check if script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

apt install rsync -y

# Set up cron job to run the backup script every 15 minutes
(crontab -l ; echo "*/15 * * * * /var/scripts/backup/backup_script.sh") | crontab -

echo "Cron job set up successfully."

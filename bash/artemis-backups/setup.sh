#!/bin/bash

# Check if script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

mkdir /var/scripts/backup -p
apt install rsync -y
cp ./backup_script.sh /var/scripts/backup/backup_script.sh
# Set up cron job to run the backup script every 15 minutes
(crontab -l ; echo "*/15 * * * * /var/scripts/backup/backup_script.sh") | crontab -

echo "Cron job set up successfully."

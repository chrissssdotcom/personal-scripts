#!/bin/bash

# Define paths
compose_path="/mnt/config"
config_path="/opt/configs"
dest_path_build="/opt/backups/build-config"
dest_path_app="/opt/backups/app-config"

# Create backup directories if they don't exist
mkdir -p "$dest_path_build"
mkdir -p "$dest_path_app"

# Backup /mnt/config to /opt/backups/build-config
rsync -av --delete "$compose_path/" "$dest_path_build/"

# Backup /opt/configs to /opt/backups/app-config
rsync -av --delete "$config_path/" "$dest_path_app/"

echo "Backup completed successfully."

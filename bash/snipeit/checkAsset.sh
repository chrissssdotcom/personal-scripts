#!/bin/bash

# Function to check if jq is installed
check_jq_installed() {
  if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to use this script."
    exit 1
  fi
}

# Function to get asset details by asset name
get_asset_details() {
  local asset_name="$1"
  local api_token="token"
  local base_url="base-url"
  local api_url="$base_url/api/v1/hardware"

  # Make the API request
  response=$(curl -s -G --header "Authorization: Bearer $api_token" --header "Accept: application/json" --data-urlencode "search=$asset_name" "$api_url")

  # Check if the response contains any assets
  total=$(echo "$response" | jq '.total')
  if [[ "$total" -gt 0 ]]; then
    asset=$(echo "$response" | jq '.rows[0]')
    asset_tag=$(echo "$asset" | jq -r '.asset_tag')
    mac_address=$(echo "$asset" | jq -r '.mac_address')
    location=$(echo "$asset" | jq -r '.location.name')
    location_id=$(echo "$asset" | jq -r '.location.id')
    location_url="$base_url/locations/$location_id"
    
    echo "Asset Tag: $asset_tag"
    echo "MAC Address: $mac_address"
    echo "Location: $location"
    echo "Location URL: $location_url"
  else
    echo "No asset found with the name: $asset_name"
  fi
}

# Check if asset name is provided
if [[ -z "$1" ]]; then
  echo "Usage: $0 <asset_name>"
  exit 1
fi

# Check if jq is installed
check_jq_installed

# Get the asset details
get_asset_details "$1"

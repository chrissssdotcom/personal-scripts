#!/bin/bash

# Load .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Function to get a list of host IDs and names
get_hosts() {
  curl -s -X GET "${FOG_SERVER}/fog/host" \
       -H "fog-api-token: ${API_TOKEN}" \
       -H "fog-user-token: ${USER_TOKEN}" \
       -H "Content-Type: application/json" | jq -r '.hosts[] | "\(.id) \(.name)"'
}

# Function to get a list of snapin IDs and names
get_snapins() {
  curl -s -X GET "${FOG_SERVER}/fog/snapin" \
       -H "fog-api-token: ${API_TOKEN}" \
       -H "fog-user-token: ${USER_TOKEN}" \
       -H "Content-Type: application/json" | jq -r '.snapins[] | "\(.id) \(.name)"'
}

# Function to deploy a snapin to a host
deploy_snapin() {
  local host_id=$1
  local snapin_id=$2
  local host_name=$3
  local snapin_name=$4

  # Construct JSON payload
  local payload=$(jq -n --arg host_id "$host_id" --arg snapin_id "$snapin_id" '{
    "taskTypeID": 13,
    "deploySnapins": $snapin_id
  }')

  # Send API request
  response=$(curl -s -X POST "${FOG_SERVER}/fog/host/${host_id}/task" \
       -H "fog-api-token: ${API_TOKEN}" \
       -H "fog-user-token: ${USER_TOKEN}" \
       -H "Content-Type: application/json" \
       -d "$payload")

  # Check for errors in the response
  if echo "$response" | jq -e '.error' > /dev/null; then
    printf "Installing %s to %s           [ERROR]\n" "$snapin_name" "$host_name"
  else
    printf "Installing %s to %s           [OK]\n" "$snapin_name" "$host_name"
  fi
}

# Function to list all active tasks
list_active_tasks() {
  response=$(curl -s -X GET "${FOG_SERVER}/fog/task/active" \
       -H "fog-api-token: ${API_TOKEN}" \
       -H "fog-user-token: ${USER_TOKEN}" \
       -H "Content-Type: application/json")

  # Display the response in a dialog box
  dialog --title "Active Tasks" --msgbox "$(echo "$response" | jq .)" 22 80
}

# Main menu
main_menu() {
  local choice
  choice=$(dialog --stdout --title "FOG Project Management" --menu "Select an option" 22 80 16 \
    1 "List Active Tasks" \
    2 "Deploy Snapin to Host" \
    3 "Exit")

  case $choice in
    1)
      list_active_tasks
      ;;
    2)
      deploy_snapin_menu
      ;;
    3)
      exit 0
      ;;
    *)
      exit 1
      ;;
  esac
}

# Deploy snapin menu
deploy_snapin_menu() {
  # Get lists of host IDs and names, and snapin IDs and names
  HOSTS=$(get_hosts)
  SNAPINS=$(get_snapins)

  # Prepare the lists for dialog checklist
  HOSTS_LIST=()
  while IFS= read -r host; do
    ID=$(echo $host | awk '{print $1}')
    NAME=$(echo $host | cut -d' ' -f2-)
    HOSTS_LIST+=("$ID" "$NAME" "off")
  done <<< "$HOSTS"

  SNAPINS_LIST=()
  while IFS= read -r snapin; do
    ID=$(echo $snapin | awk '{print $1}')
    NAME=$(echo $snapin | cut -d' ' -f2-)
    SNAPINS_LIST+=("$ID" "$NAME" "off")
  done <<< "$SNAPINS"

  # Display snapin selection dialog
  SNAPIN_SELECTION=$(dialog --stdout --separate-output --checklist "Select Snapins" 22 80 16 "${SNAPINS_LIST[@]}")

  # If user selects "Back", return to main menu
  if [ $? -ne 0 ]; then
    return
  fi

  # Display host selection dialog
  HOST_SELECTION=$(dialog --stdout --separate-output --checklist "Select Hosts" 22 80 16 "${HOSTS_LIST[@]}")

  # If user selects "Back", return to main menu
  if [ $? -ne 0 ]; then
    return
  fi

  # Loop through each selected host and each selected snapin to deploy
  for host in $HOST_SELECTION; do
    for snapin in $SNAPIN_SELECTION; do
      host_name=$(echo "$HOSTS" | grep "^$host " | cut -d' ' -f2-)
      snapin_name=$(echo "$SNAPINS" | grep "^$snapin " | cut -d' ' -f2-)
      printf "Installing %s to %s..." "$snapin_name" "$host_name"
      deploy_snapin "$host" "$snapin" "$host_name" "$snapin_name"
    done
  done

  echo "Deployment of snapins to selected hosts completed."
}

# Run the main menu
while true; do
  main_menu
done

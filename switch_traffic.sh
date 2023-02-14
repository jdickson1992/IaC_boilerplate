#!/bin/bash

# ANSI Color codes
BLUE='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# cd into terraform directory
TERRAFORM_DIR=$(pwd)/terraform
cd $TERRAFORM_DIR

# Extract the IP of the swarm manager 0 using terraform outputs
PROXY_IP=$(terraform output swarm_manager_public_ip | tr -d '"')

# Initialize the variables for the backends
ACTIVE="green"
BACKUP="blue"

# Initialize the variable to track the seconds
min=0

# While loop that issues a GET request at port 80 of swarm manager
while true
do
  output=$(curl -s http://$PROXY_IP/home)
  if echo "$output" | grep -q "GREEN"; then
    echo -e "${GREEN}$output${NC}"
  else
    echo -e "${BLUE}$output${NC}"
  fi

  # Increment the minute counter
  min=$((min+1))

  # Switch active backends between green / blue apps every 45s
  if [ $((min % 45)) -eq 0 ]; then
    if [ "$ACTIVE" = "green" ]; then
      ACTIVE="blue"
    else
      ACTIVE="green"
    fi
    echo -e "${YELLOW}Updating Active backend to ${ACTIVE}-app. Takes a few seconds to propogate!${NC}"
    # Update the ACTIVE/BACKUP env variables of the nginx service
    ssh -i test.pem $PROXY_IP docker service update --env-add ACTIVE_BACKEND=${ACTIVE}-app --env-add BACKUP_BACKEND=${BACKUP}-app swarm_nginx > /dev/null 2>&1  &
  fi  

  # wait 2 seconds before hitting the endpoint again
  sleep 1
done

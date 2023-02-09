#!/bin/bash

# Define ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color

ANSIBLE_DIR=$(pwd)/ansible
GROUP_VARS_DIR=$ANSIBLE_DIR/group_vars
ALL_YML_FILE=$GROUP_VARS_DIR/all.yml

# Make sure the group_vars directory exists
mkdir -p $GROUP_VARS_DIR

# Get the current user
username=$(whoami)

# Create the all.yml file and add the contents
echo "dev_user: $username" > $ALL_YML_FILE


# Define an array of options
options=(full_iac deploy_swarm delete_swarm destroy_iac)

# Introduction
echo -e "${CYAN}This script presents four options for managing your infrastructure as code (IAC) environment.${NC}\n"
echo "The options are:"
echo -e "  ${YELLOW}1) full_iac${NC}: Initialize the IAC environment from provisioning to deployment. ${CYAN}This option will create all of your cloud resources and will initialise docker swarm on this infra!${NC}\n"
echo -e "  ${YELLOW}2) deploy_swarm${NC}: Deploy a Docker Swarm cluster. ${PURPLE}This option will only work if the cloud infra has been previously deployed!${NC}\n"
echo -e "  ${YELLOW}3) delete_swarm${NC}: Deletes the Docker Swarm cluster.\n"
echo -e "  ${YELLOW}4) destroy_iac${NC}: Completely destroys the IAC environment (${CYAN}Anything created by Terraform${NC}). Run this when you have finished testing!\n"

cd $ANSIBLE_DIR

# Display the options to the user
echo "Please select one of the following options:"
for i in "${!options[@]}"; do
  echo "$((i+1))) ${options[i]}"
done

# Read the user's choice
while true; do
  read -p "Enter your choice: " choice
  if [[ $choice =~ ^[0-9]+$ ]]; then
    if [[ $choice -gt 0 && $choice -le ${#options[@]} ]]; then
      echo -e "${GREEN}You have selected ${options[$((choice-1))]}.${NC}"
      # Use a case statement to perform the selected action
      case "${options[$((choice-1))]}" in
    full_iac)
        echo "This option will initialize the infrastructure as code environment."
         ansible-playbook init_infra.yml
         sleep 10
         ansible-playbook deploy_swarm.yml
         break
        ;;
    deploy_swarm)
        echo "This option will deploy a Docker Swarm cluster."
        ansible-playbook deploy_swarm.yml
        break
        ;;
    delete_swarm)
        echo "This option will delete the Docker Swarm cluster."
        ansible-playbook delete_swarm.yml
        break
        ;;
    destroy_iac)
        echo "This option will completely destroy the infrastructure as code environment."
        ansible-playbook destroy_infra.yml
        break
        ;;
    *)
        echo -e "${RED}Invalid option.${NC}"
        ;;
      esac
    else
      echo -e "${RED}Invalid option.${NC}"
    fi
  else
    echo -e "${RED}Please enter a number.${NC}"
  fi
done
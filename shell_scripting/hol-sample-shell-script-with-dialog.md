1. **Script to set username, password, and hostname using user interface**
```bash
#!/bin/bash

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Please install 'dialog' before running this script."
    exit 1
fi

# Function to display an input dialog and get user input
get_input() {
    local result
    result=$(dialog --stdout --inputbox "$1" 0 0 "$2")
    echo "$result"
}

# Function to display a password dialog and get user input
get_password() {
    local result
    result=$(dialog --stdout --passwordbox "$1" 0 0)
    echo "$result"
}

# Main script

# Get username, password, and hostname
username=$(get_input "Enter the new username:" "")
password=$(get_password "Enter the password for the user:" "")
hostname=$(get_input "Enter the new hostname:" "")

# Check if the username, password, and hostname are not empty
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$hostname" ]; then
    dialog --msgbox "Username, password, and hostname cannot be empty. Exiting." 0 0
    exit 1
fi

# Check if the user already exists
if id "$username" &>/dev/null; then
    dialog --msgbox "User '$username' already exists." 0 0
else
    # If the user doesn't exist, create the user
    sudo useradd -m -p "$(openssl passwd -1 "$password")" "$username"
    
    if [ $? -eq 0 ]; then
        dialog --msgbox "User '$username' created successfully." 0 0
    else
        dialog --msgbox "Failed to create user '$username'. Exiting." 0 0
        exit 1
    fi
fi

# Set the hostname
sudo hostnamectl set-hostname "$hostname"

# Display the new hostname
dialog --msgbox "Hostname has been set to: $hostname" 0 0

# Notify user to restart for changes to take effect
dialog --msgbox "Please restart your system for the changes to take effect." 0 0
```
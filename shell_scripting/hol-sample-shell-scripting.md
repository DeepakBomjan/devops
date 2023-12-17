1. Shell Script to set hostname of server
```bash
#!/bin/bash

# Prompt user for new hostname
echo "Enter the new hostname:"
read new_hostname

# Validate if the input is not empty
if [ -z "$new_hostname" ]; then
    echo "Hostname cannot be empty. Exiting."
    exit 1
fi

# Set the new hostname
sudo hostnamectl set-hostname "$new_hostname"

# Display the new hostname
echo "Hostname has been set to: $new_hostname"

# Notify user to restart for changes to take effect
echo "Please restart your system for the changes to take effect."

```
2. Creating User if not exist
```bash
#!/bin/bash

# Prompt user for username
echo "Enter the username:"
read username

# Check if the username is not empty
if [ -z "$username" ]; then
    echo "Username cannot be empty. Exiting."
    exit 1
fi

# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "User '$username' already exists."
else
    # If the user doesn't exist, create the user
    sudo useradd -m "$username"
    
    if [ $? -eq 0 ]; then
        echo "User '$username' created successfully."

        # Set the password for the new user
        sudo passwd "$username"
        
        if [ $? -eq 0 ]; then
            echo "Password set successfully for user '$username'."
        else
            echo "Failed to set password for user '$username'."
        fi
    else
        echo "Failed to create user '$username'."
        exit 1
    fi
fi

```

1. **Shell Script to set hostname of server**
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
2. **Creating User if not exist**
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
3. **Display System Information with menu**
```bash
#!/bin/bash

# while-menu: a menu-driven system information program

DELAY=3 # Number of seconds to display results

while true; do
  clear
  cat << _EOF_
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit

_EOF_

  read -p "Enter selection [0-3] > "

  if [[ $REPLY =~ ^[0-3]$ ]]; then
    case $REPLY in
      1)
        echo "Hostname: $HOSTNAME"
        uptime
        sleep $DELAY
        continue
        ;;
      2)
        df -h
        sleep $DELAY
        continue
        ;;
      3)
        if [[ $(id -u) -eq 0 ]]; then
          echo "Home Space Utilization (All Users)"
          du -sh /home/* 2> /dev/null
        else
          echo "Home Space Utilization ($USER)"
          du -sh $HOME 2> /dev/null
        fi
        sleep $DELAY
        continue
        ;;
      0)
        break
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
  fi
done
echo "Program terminated."
```

3. **All combination of user input switch case**
```bash
#!/bin/bash

echo "Do you like fruits? (yes/no)"
read response

case $response in
  [Yy]|[Yy][Ee][Ss])
    echo "Great! Here are some fruits for you."
    # Add more code for positive response if needed
    ;;
  [Nn]|[Nn][Oo])
    echo "Oh no! Why not give fruits a try?"
    # Add more code for negative response if needed
    ;;
  *)
    echo "Invalid response. Please enter yes or no."
    ;;
esac

```
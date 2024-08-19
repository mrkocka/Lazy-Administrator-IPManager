#!/bin/bash

greeting(){
    echo "Welcome as a user of Lazy Administrator IPManager_1.3."
}

get_active_interface(){
    # Find the active Ethernet interface
    interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^e.*')

    if [ -z "$interface" ]; then
        echo "There is no active Ethernet interface. Check the network connection."
        exit 1
    fi

    echo "Active Ethernet interface: $interface"
}

work(){
# Request the required data from the user
    read -p "Please provide the IP address (for example:192.168.0.2/24 ): " ip_cim
    read -p "Please give the IP addresses of the name server (for example: 8.8.8.8,1.1.1.1): " nameservers
    read -p "Please provide the router needed to control the route (for example: 192.168.0.1): " gateway

    # Process nameservers
    IFS=',' read -r -a nameserver_array <<< "$nameservers"

    # Fájl helye
    cel_hely="/etc/netplan"
    fajlnev="00-installer-config.yaml"
    backup_folder="/var/backups/netplan-backups"
    backup_fajlnev="00-installer-config-org.yaml"

    # Create the backup folder if it does not exist
    if [ ! -d "$backup_folder" ]; then
        mkdir -p "$backup_folder"
        if [ $? -ne 0 ]; then
            echo "Failed to create backup folder: $backup_folder"
            exit 1
        fi
    fi

   # Check if the target file exists and if so, rename it and move it to the backup folder
    if [ -f "$cel_hely/$fajlnev" ]; then
        mv "$cel_hely/$fajlnev" "$backup_folder/$backup_fajlnev"
        if [ $? -ne 0 ]; then
            echo "Failed to move file to backup folder: $backup_folder"
            exit 1
        fi
        echo "Backed up and moved: $backup_folder/$backup_fajlnev"
    fi

    # Write the data to the file
    {
    echo "# Static IP"
    echo "network:"
    echo "  ethernets:"
    echo "    $interface:"
    echo "      dhcp4: no"
    echo "      addresses:"
    echo "        - $ip_cim"
    echo "      nameservers:"
    echo "        addresses:"
    for ns in "${nameserver_array[@]}"; do
        echo "          - $ns"
    done
    echo "      routes:"
    echo "        - to: 0.0.0.0/0"
    echo "          via: $gateway"
    echo "  version: 2"
    } > "$cel_hely/$fajlnev"

    if [ $? -eq 0 ]; then
        echo "Data successfully saved to this file: $cel_hely/$fajlnev "
    else
        echo "An error occurred while saving the following file: $fajlnev "
        exit 1
    fi
}

reboot() {
    # It will offer the option to reboot
    read -p "Do you want to restart the system? (yes/no):" ujrainditas

    if [[ "$ujrainditas" =~ ^[iI]gen$ ]]; then
        echo "Restarting the system..."
        sudo reboot
    else
        echo "The system will not reboot."
    fi
}

greeting
get_active_interface
work
reboot
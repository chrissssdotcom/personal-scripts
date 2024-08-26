#!/bin/bash

# Hardcoded values
DOMAIN="hosted.chrissss.com"
REALM="HOSTED.CHRISSSS.COM"
IPA_SERVER="1syd-outpost01.hosted.chrissss.com"

# Prompt for the hostname
read -p "Enter the hostname (without domain): " HOSTNAME

# Function to install necessary packages and configure for RHEL-based systems
configure_rhel() {
    echo "Detected RHEL-based OS."
    
    # Install necessary packages
    sudo yum install -y ipa-client oddjob-mkhomedir sssd authconfig
    
    # Join the FreeIPA domain
    echo "Joining the FreeIPA domain..."
    sudo ipa-client-install --hostname=$HOSTNAME.$DOMAIN --mkhomedir --server=$IPA_SERVER --domain=$DOMAIN --realm=$REALM --principal=admin

    # Prompt for admin password
    read -sp "Enter the IPA admin password: " IPA_PASSWORD
    echo

    # Run the ipa-client-install command with the password
    echo $IPA_PASSWORD | sudo ipa-client-install --domain=$DOMAIN --realm=$REALM --server=$IPA_SERVER --mkhomedir --hostname=$HOSTNAME.$DOMAIN --principal=admin --password

    # Configure pam_mkhomedir to create local home directories
    echo "Configuring PAM to create local home directories..."
    sudo authconfig --enablemkhomedir --update

    echo "RHEL-based system configured successfully!"
}

# Function to install necessary packages and configure for Debian-based systems
configure_debian() {
    echo "Detected Debian-based OS."
    
    # Install necessary packages
    sudo apt-get update
    sudo apt-get install -y freeipa-client sssd auth-client-config libnss-sss libpam-sss oddjob-mkhomedir

    # Join the FreeIPA domain
    echo "Joining the FreeIPA domain..."
    sudo ipa-client-install --hostname=$HOSTNAME.$DOMAIN --mkhomedir --server=$IPA_SERVER --domain=$DOMAIN --realm=$REALM --principal=admin

    # Prompt for admin password
    read -sp "Enter the IPA admin password: " IPA_PASSWORD
    echo

    # Run the ipa-client-install command with the password
    echo $IPA_PASSWORD | sudo ipa-client-install --domain=$DOMAIN --realm=$REALM --server=$IPA_SERVER --mkhomedir --hostname=$HOSTNAME.$DOMAIN --principal=admin --password

    # Configure pam_mkhomedir to create local home directories
    echo "Configuring PAM to create local home directories..."
    echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0077" | sudo tee -a /etc/pam.d/common-session

    echo "Debian-based system configured successfully!"
}

# Detect the OS type and run the appropriate configuration function
if [ -f /etc/redhat-release ]; then
    configure_rhel
elif [ -f /etc/debian_version ]; then
    configure_debian
else
    echo "Unsupported OS. Exiting..."
    exit 1
fi

echo "Configuration completed."

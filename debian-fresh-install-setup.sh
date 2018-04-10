#!/bin/bash
# Setup a fresh install of Debian - Must be run as root

if (( $# != 0 )); then
    echo "Illegal number of parameters"
fi

# Trap SIGINT
trap ctrl_c INT

function ctrl_c() {
    echo "Script interrupted."
}

echo "---- Fresh install setup for Debian ----"

if [ $(id -u) -eq 0 ]; then
    # Select options for setup
    while true; do
        read -p "Do you wish to grant sudo privileges to a user? [Y/N] " yn
        case $yn in
            [Yy]* ) GRANT_SUDO=true; break;;
            [Nn]* ) GRANT_SUDO=false; break;;
            * ) echo "Type Y for yes or N for no.";;
        esac
    done
    while true; do
        read -p "Do you want to install NVIDIA GPU driver? [Y/N] " yn
        case $yn in
            [Yy]* ) NSTALL_NVIDIA_DRIVER=true; break;;
            [Nn]* ) NSTALL_NVIDIA_DRIVER=false; break;;
            * ) echo "Type Y for yes or N for no.";;
        esac
    done
    while true; do
        read -p "Do you want to install NVIDIA CUDA toolkit? [Y/N] " yn
        case $yn in
            [Yy]* ) NSTALL_NVIDIA_DRIVER=true; break;;
            [Nn]* ) NSTALL_NVIDIA_DRIVER=false; break;;
            * ) echo "Type Y for yes or N for no.";;
        esac
    done

    ## Create a new "sources.list" to enable contrib and non-free repositories
    sh ./debian-enable-contrib-and-non-free-repositories.sh

    ## Update and upgrade already installed packages
    echo "-> Updating packages cache"
    apt update
    echo "-> Upgrading packages"
    apt upgrade

    ## Install various packages
    echo "-> Installing packages"
    apt -y install $(cat packages-list)

    ## Granting sudo privileges to a specific user if necessary
    if [ "$GRANT_SUDO" = true ] ; then
        echo "-> Granting sudo privileges for a user"
        sh ./grant_sudo_privileges.sh
    fi

    ## Install NVIDIA driver/tools
    while true; do
        read -p "Do you want to install NVIDIA GPU driver? [Y/N] " yn
        case $yn in
            [Yy]* ) NSTALL_NVIDIA_DRIVER=true; break;;
            [Nn]* ) NSTALL_NVIDIA_DRIVER=false; break;;
            * ) echo "Type Y for yes or N for no.";;
        esac
    done
    if [ "$INSTALL_NVIDIA_DRIVER" = true ] ; then
        apt -y install nvidia-driver nvidia-smi
        ## Create a configuration file for Xorg server
        mkdir /etc/X11/xorg.conf.d
        echo -e 'Section "Device"\n\tIdentifier "My GPU"\n\tDriver "nvidia"\nEndSection' > /etc/X11/xorg.conf.d/20-nvidia.conf
        echo "Driver installed. Applying modifications and blacklisting Nouveau will require a reboot."
    fi

    if [ "$INSTALL_CUDA" = true ] && [ $INSTALL_NVIDIA_DRIVER = true ]; then
        echo "-> Installing CUDA"
        apt -y install nvidia-cuda-dev nvidia-cuda-toolkit
        # create a symlink for convenience
        ln -sf /usr/lib/nvidia-cuda-toolkit /usr/local/cuda
    fi

    ## Restart services
    echo "-> Restarting services to apply modifications. "
    if [ "$GRANT_SUDO" = true ] ; then
        /etc/init.d/sudo restart
    fi
    #service lightdm restart
    echo "-> Services restarted"

    echo "-> Setup finished!"
else
	echo "This script must be run as root"
	exit 2
fi

#!/bin/bash
#
# This script 'fixes' annoying issues of Gemini's default linux setup
# and installs packages to make it more usable.
#
# Usage:
# - Install debian linux for Gemini and boot to it
# - Open xterm
# - wget <url to this script>
# - bash <name of this script>
#
# Stuff it does:
# - Update system and install some useful debian packages
# - Sets up ssh server
# - Sets a shell for gemini user to allow using terminals and ssh login
# - Changes hostname to gemini (from localhost)
# - Enables avahi-daemon for discovery on LAN
# - Changes password for gemini user (for security)
# 

sudo usermod --shell /bin/bash gemini
sudo apt update
sudo apt dist-upgrade
sudo apt -y install openssh-server avahi-daemon curl htop iproute2 systemd-sysv locales

read -p "Change hostname to gemini ? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
sudo bash -c 'echo gemini > /etc/hostname'
sudo bash -c 'sed -i -e "s/localhost/localhost gemini/g" /etc/hosts' 
fi

sudo systemctl daemon-reload
sudo systemctl unmask avahi-daemon
sudo systemctl enable avahi-daemon

read -p "Change password for user gemini ? (y/n)" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
sudo passwd gemini
fi

echo 
echo Changes done.
echo Your device will be accessible as gemini.local in your network after reboot.
echo

read -p "Shutdown device now to finish changes? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
sudo poweroff
fi


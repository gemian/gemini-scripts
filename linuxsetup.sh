#!/bin/bash
#
# This script 'fixes' annoying issues of Gemini's default linux setup
# and installs packages to make it more usable.
#
# Usage:
# - Install Debian Linux for Gemini and boot to it
# - Connect Gemini with USB cable to your Linux pc
# - Connect Gemini to WiFI 
#    * With connman gui on Gemini
#    * OR with ssh console, see http://www.ev3dev.org/docs/tutorials/setting-up-wifi-using-the-command-line/
# - Execute on your pc: 
#   ssh -t gemini@10.15.19.82 "wget https://raw.githubusercontent.com/gemian/gemini-scripts/master/linuxsetup.sh ; bash linuxsetup.sh"
#
# Alternative (if you're on Windows or can't use ssh method for some other reason)
#
# - Open xterm on Gemini
# - wget goo.gl/pmVUP5          (yes, this is not recommended)
# - bash pmVUP5
#
# Stuff it does:
# - Sets a shell for gemini user to allow using terminals and ssh login
# - Resizes the linux filesystem to use full partition space (more space)
# - Update system and install some useful debian packages
# - Sets up ssh server
# - Changes hostname to gemini (from localhost)
# - Enables avahi-daemon for discovery on LAN
# - Changes password for gemini user (for security)
# 

sudo usermod --shell /bin/bash gemini
sudo resize2fs /dev/mmcblk0p29
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y install openssh-server avahi-daemon curl htop iproute2 systemd-sysv locales iputils-ping

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

read -p "Install Gnome desktop ? (y/n)" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
sudo apt install task-gnome-desktop
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


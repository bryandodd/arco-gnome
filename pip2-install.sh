#!/bin/bash

# colors
    color_nocolor='\e[0m'
    color_black='\e[0;30m'
    color_light_grey='\e[0;37m'
    color_grey='\e[1;30m'
    color_red='\e[0;31m'
    color_light_red='\e[1;31m'
    color_green='\e[0;32m'
    color_light_green='\e[1;32m'
    color_brown='\e[0;33m'
    color_yellow='\e[1;33m'
    color_other_yellow='\e[1;93m'
    color_blue='\e[0;34m'
    color_light_blue='\e[1;34m'
    color_purple='\e[0;35m'
    color_light_purple='\e[1;35m'
    color_cyan='\e[0;36m'
    color_light_cyan='\e[1;36m'
    color_white='\e[1;37m'

# indicators
    greenplus='\e[1;32m[++]\e[0m'
    greenminus='\e[1;32m[--]\e[0m'
    greenstar='\e[1;32m[**]\e[0m'
    yellowstar='\e[1;93m[**]\e[0m'
    bluestar='\e[1;34m[**]\e[0m'
    cyanstar='\e[1;36m[**]\e[0m'
    redminus='\e[1;31m[--]\e[0m'
    redexclaim='\e[1;31m[!!]\e[0m'
    redstar='\e[1;31m[**]\e[0m'
    blinkwarn='\e[1;93m[\e[5;93m**\e[0m\e[1;93m]\e[0m'
    blinkexclaim='\e[1;31m[\e[5;31m!!\e[0m\e[1;31m]\e[0m'
    fourblinkexclaim='\e[1;31m[\e[5;31m!!!!\e[0m\e[1;31m]\e[0m'

# static files
    pip2_new="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/configs/python/pip2/get-pip.py"

# helpers
    findUser=$(logname)
    userId=$(id -u $findUser)
    userGroup=$(id -g -n $findUser)
    userGroupId=$(id -g $findUser)

    sudoUser=$(whoami)
    sudoId=$(id -u $sudoUser)
    sudoGroup=$(id -g -n $sudoUser)
    sudoGroupId=$(id -g $sudoUser)

# runtime check
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\n$blinkexclaim ERR : Must run as root. Run again with 'sudo'."
    exit 1
fi

pipFile="/home/$findUser/get-pip.py"
if [[ -f "$pipFile" ]]; then
    echo -e "$yellowstar Pip2 file found. Skipping download."
else
    eval wget -q $pip2_new -O $pipFile
    echo -e "$greenplus Downloaded get-pip.py to $pipFile"
fi

echo -e "\n  $yellowstar Python2 pip : install starting"
eval python2 $pipFile
echo -e "\n  $greenplus Python2 pip : installed"
rm -f $pipFile
echo -e "\n  $yellowstar $pipFile no longer required - deleted"

echo -e "\n  $yellowstar Python3 pip : reinstall required"
paru -Sy python-pip --noconfirm
echo -e "\n  $greenplus Python3 pip : (re)installed"
fi
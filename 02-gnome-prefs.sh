#!/bin/bash

# Arcolinux | Gnome Customization - Author: Bryan Dodd
# 01-gnome-prefs.sh
#
# Disclaimer: Author assumes no liability for any damage resulting from use, misuse, or any other crazy
#             idea somebody attempts using, incorporating, deconstructing, or anything else with this tool.

# revision
    revision="0.2.1"
    baseDistro="v23.03.01"
    repoBranch="v23.03.01"

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

# helpers
    findUser=$(logname)
    userId=$(id -u $findUser)
    userGroup=$(id -g -n $findUser)
    userGroupId=$(id -g $findUser)

    sudoUser=$(whoami)
    sudoId=$(id -u $sudoUser)
    sudoGroup=$(id -g -n $sudoUser)
    sudoGroupId=$(id -g $sudoUser)


tweak_settings() {
#     || Tweak Gnome settings       ||
#     || (use dconf-editor for gui) ||
#     \\----------------------------||
    echo -e "\n${color_cyan}Setting appearance to dark mode ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark

    echo -e "\n${color_cyan}Disabling \"screen blanking\" on inactivity ...${color_nocolor}"
    gsettings set org.gnome.desktop.session idle-delay 0

    echo -e "\n${color_cyan}Disabling auto-suspend on inactivity ...${color_nocolor}"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing

    echo -e "\n${color_cyan}Adding titlebar minimize/maximize buttons ...${color_nocolor}"
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

    echo -e "\n${color_cyan}Enabling weekday on system clock ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface clock-show-weekday true

    echo -e "\n${color_cyan}Show hidden files ...${color_nocolor}"
    gsettings set org.gtk.Settings.FileChooser show-hidden true

    echo -e "\n${color_cyan}Sort directories first ...${color_nocolor}"
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true

    echo -e "\n${color_cyan}Set icon theme ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface icon-theme 'Tela-dark'

    echo -e "\n${color_cyan}Set cursor theme ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface cursor-theme 'Vimix-cursors'

    echo -e "\n${color_cyan}Set system interface font ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface font-name 'NotoSans Nerd Font 11'

    echo -e "\n${color_cyan}Set system document font ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface document-font-name 'NotoSans Nerd Font 11'

    echo -e "\n${color_cyan}Set system monospace font ...${color_nocolor}"
    gsettings set org.gnome.desktop.interface monospace-font-name 'SauceCodePro Nerd Font 10'

    echo -e "\n${color_cyan}Set legacy window title font ...${color_nocolor}"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'NotoSans Nerd Font 11'
}

set_vscode_default() {
#     || Set Default Mimetypes for VSCode ||
#     \\----------------------------------||
#      \\-- https://ask.fedoraproject.org/t/how-to-set-a-default-text-editor-in-gnome/9062/2

    echo -e "\n${color_cyan}Setting mimetypes to default to Visual Studio Code ...${color_nocolor}"
    xdg-mime default visual-studio-code.desktop application/javascript \
        application/json \
        application/x-bash \
        application/x-csh \
        application/x-httpd-eruby \
        application/x-httpd-php \
        application/x-httpd-php3 \
        application/x-httpd-php4 \
        application/x-httpd-php5 \
        application/x-ruby \
        application/x-sh \
        application/x-shellscript \
        application/x-sql \
        application/x-tcl \
        application/x-zsh \
        application/xhtml+xml \
        application/xml \
        application/xml-dtd \
        application/xslt+xml \
        inode/directory \
        text/coffeescript \
        text/css \
        text/html \
        text/plain \
        text/x-bash \
        text/x-c \
        text/x-c++ \
        text/x-c++hdr \
        text/x-c++src \
        text/x-chdr \
        text/x-csh \
        text/x-csrc \
        text/x-diff \
        text/x-dsrc \
        text/x-go \
        text/x-java \
        text/x-java-source \
        text/x-makefile \
        text/x-markdown \
        text/x-objc \
        text/x-perl \
        text/x-php \
        text/x-python \
        text/x-ruby \
        text/x-sh \
        text/x-zsh \
        text/xml \
        text/xml-dtd \
        text/yaml

    echo -e "\nThe following mimetypes were set:\n"
    echo -e "  --> ${color_other_yellow}application/javascript${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/json${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-bash${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-csh${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-httpd-eruby${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-httpd-php${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-httpd-php3${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-httpd-php4${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-httpd-php5${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-ruby${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-sh${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-shellscript${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-sql${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-tcl${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/x-zsh${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/xhtml+xml${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/xml${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/xml-dtd${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}application/xslt+xml${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}inode/directory${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/coffeescript${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/css${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/html${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/plain${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-bash${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-c${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-c++${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-c++hdr${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-c++src${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-chdr${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-csh${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-csrc${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-diff${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-dsrc${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-go${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-java${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-java-source${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-makefile${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-markdown${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-objc${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-perl${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-php${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-python${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-ruby${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-sh${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/x-zsh${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/xml${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/xml-dtd${color_nocolor}\n"
    echo -e "  --> ${color_other_yellow}text/yaml${color_nocolor}\n"
}

# runtime check
if [ "$(id -u)" -eq 0 ]; then
    echo -e "\n$blinkexclaim ERR : Must NOT run as root. Run again WITHOUT 'sudo'."
    exit 1
fi

tweak_settings
set_vscode_default

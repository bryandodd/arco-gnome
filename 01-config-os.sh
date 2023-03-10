#!/bin/bash

# Arcolinux | Gnome Customization - Author: Bryan Dodd
# 01-config-os.sh
#
# Disclaimer: Author assumes no liability for any damage resulting from use, misuse, or any other crazy
#             idea somebody attempts using, incorporating, deconstructing, or anything else with this tool.

# revision
    revision="0.2.1"
    baseDistro="v23.03.01"
    repoBranch="v0-2-1"

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
    kitty_conf="https://raw.githubusercontent.com/bryandodd/arco-gnome/$repoBranch/configs/kitty/kitty.conf"

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


## Install Config
### Kernel
##  - Linux kernel
##  * Linux lts
##  - Intel-ucode
### Drivers
##  - Xf86-video-amdgpu
### Login
##  - SDDM
##  * LightDM
### Desktop
##  - Gnome
### ArcoLinux Tools
##  * Third Party Packages / arcolinux-pamac-all
##  - Meta Packages / arcolinux-meta-sddm-themes
##  - Applications / arcolinux-tweak-tool-git
##  * Wallpapers / all
##  * SDDM Themes / all
### Communication
##  * slack-desktop
##  * teams
##  * Connect Remotely / remmina
### Development
##  * visual-studio-code-bin
### Internet
##  - firefox-ublock-origin
##  - google-chrome
##  * chromium
### Terminals
##  - kitty
### File Managers
##  - nautilus
### Utilities
##  - Installers / paru-bin
##  * Utilities / btop
##  * Utilities / duf
##  * Utilities / neofetch
##  * Utilities / hw-probe
##  * Utilities / wireshark-qt
### Applications
##  - Vmware / open-vm-tools
##  * Password Manager / keepassxc

### NOTES:
## App Icons Taskbar (https://www.omgubuntu.co.uk/2022/03/app-icons-taskbar-gnome-extension)


fix_local_permissions() {
    chown -R $findUser:$userGroup /home/$findUser/.local
    echo -e "\n  $cyanstar permissions : set$color_other_yellow $findUser $color_nocolor as owner of$color_other_yellow ~/.local $color_nocolor"
}

fix_config_permissions() {
    chown -R $findUser:$userGroup /home/$findUser/.config
    echo -e "\n  $cyanstar permissions : set$color_other_yellow $findUser $color_nocolor as owner of$color_other_yellow ~/.config $color_nocolor"
}

remove_bloat() {
#     || Remove extra software packages ||
#     \\--------------------------------||
    echo -e "\n${color_cyan}Purging bloatware (including dependencies) ...${color_nocolor}\n"
    bloatware=("gnome-tetravex" "variety" "telegram-desktop" "gnome-taquin" "tali" "swell-foop" "gnome-sudoku" "guvcview" "simplescreenrecorder" "gnome-screenshot" "gnome-robots" "four-in-a-row" "gnome-mahjongg" "iagno" "gnome-recipes" "quadrapassel" "pragha" "polari" "gnome-photos" "peek" "gnome-mines" "gnome-maps" "lightsoff" "hitori" "guake" "arcolinux-guake-autostart-git" "gnome-nibbles" "five-or-more" "evolution" "evolution-data-server" "gnome-chess" "gnome-boxes" "gnome-books" "gnome-klotski" "accerciser" "cheese" "arcolinux-conky-collection-git" "arcolinux-variety-autostart-git" "arcolinux-variety-git" "avahi" "conky-lua-archers" "geary" "gnome-games" "guvcview-common" "libgnone-games-support")
    for appName in ${bloatware[@]}; do
        pacman -Q $appName > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            pacman -Rs $appName --unneeded --noconfirm
            echo -e "  ${greenminus} $appName : removed\n"
        else
            echo -e "  ${color_other_yellow}Didn't find $appName installed.${color_nocolor}\n"
        fi
    done

    echo -e "\n${color_cyan}Purging bloatware (app only) ...${color_nocolor}\n"
    appOnlyRemoval=("gnome-builder" "endeavour")
    for appName in ${appOnlyRemoval[@]}; do
        pacman -Q $appName > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            pacman -R $appName --unneeded --noconfirm
            echo -e "  ${greenminus} $appName : removed\n"
        else
            echo -e "  ${color_other_yellow}Didn't find $appName installed.${color_nocolor}\n"
        fi
    done

    echo -e "\n${color_cyan}Removing deleted auto-start apps ...${color_nocolor}\n"
    autoStartRemoval=("am-conky-session.desktop" "guake.desktop" "variety.desktop")
    for appName in ${autoStartRemoval[@]}; do
        launcher="/home/$findUser/.config/$appName"
        rm $launcher
        if [[ ! -f "$launcher" ]]; then
            echo -e "  ${greenminus} auto-start : $appName removed\n"
        else
            echo -e "  ${color_other_yellow}Nothing to remove at path $launcher${color_nocolor}\n"
        fi
    done
}

get_prerequisites() {
#     || xmlstarlet ||
#     \\------------||
    paru -Q xmlstarlet > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/xmlstarlet --needed --noconfirm
        echo -e "\n  $greenplus xmlstarlet : installed"
    fi

#     || gnome-icon-theme ||
#     \\------------------||
    paru -Q gnome-icon-theme > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy arcolinux_repo_3party/gnome-icon-theme --needed --noconfirm
        echo -e "\n  $greenplus gnome-icon-theme : installed"
    fi

#     || gnome-icon-theme-symbolic ||
#     \\---------------------------||
    paru -Q gnome-icon-theme-symbolic > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy arcolinux_repo_3party/gnome-icon-theme-symbolic --needed --noconfirm
        echo -e "\n  $greenplus gnome-icon-theme-symbolic : installed"
    fi
}

get_visual_components() {
#     || vimix-cursors (https://github.com/vinceliuice/Vimix-cursors) ||
#     \\--------------------------------------------------------------|| 
    paru -Q vimix-cursors > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        #aurInstall="paru -Sy aur/vimix-cursors --needed --noconfirm"
        #sudo -u $findUser $aurInstall
        paru -Sy arcolinux_repo_3party/vimix-cursors --needed --noconfirm
        echo -e "\n  $greenplus vimix-cursors : installed"
    fi

#     || tela-icon-theme (https://github.com/vinceliuice/Tela-icon-theme) ||
#     \\------------------------------------------------------------------|| 
    paru -Q tela-icon-theme > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        aurInstall="paru -Sy aur/tela-icon-theme --needed --noconfirm"
        sudo -u $findUser $aurInstall
        echo -e "\n  $greenplus tela-icon-theme : installed"
    fi
}

gnome_ext_installers() {
#     || gnome-shell-extension-installer (https://github.com/brunelli/gnome-shell-extension-installer) ||
#     \\-----------------------------------------------------------------------------------------------||
    paru -Q gnome-shell-extension-installer > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        aurInstall="paru -Sy aur/gnome-shell-extension-installer --needed --noconfirm"
        sudo -u $findUser $aurInstall
        echo -e "\n  $greenplus gnome-shell-extension-installer : installed"
    fi

#     || chrome native host connector ||
#     \\------------------------------||
#      \\ https://wiki.gnome.org/action/show/Projects/GnomeShellIntegration/Installation
    paru -Q gnome-browser-connector-git > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        aurInstall="paru -Sy aur/gnome-browser-connector-git --needed --noconfirm"
        sudo -u $findUser $aurInstall
        echo -e "\n  $greenplus gnome-browser-connector-git : installed"
    fi
}

#     || extension-manager (https://github.com/mjakeman/extension-manager) ||
#     \\-------------------------------------------------------------------||
    paru -Q extension-manager > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        aurInstall="paru -Sy aur/extension-manager --needed --noconfirm"
        sudo -u $findUser $aurInstall
        echo -e "\n  $greenplus extension-manager : installed"
    fi
}

install_extensions() {
#     || Dash to Panel (https://extensions.gnome.org/extension/1160/dash-to-panel/) ||
#     \\----------------------------------------------------------------------------||
    gnome-shell-extension-installer 1160 --yes

#     || ArcMenu (https://extensions.gnome.org/extension/3628/arcmenu/) ||
#     \\----------------------------------------------------------------||
    gnome-shell-extension-installer 3628 --yes

#     || Vitals (https://extensions.gnome.org/extension/1460/vitals/) ||
#     \\--------------------------------------------------------------||
    gnome-shell-extension-installer 1460 --yes

#     || Caffeine (https://extensions.gnome.org/extension/517/caffeine/) ||
#     \\-----------------------------------------------------------------||
    gnome-shell-extension-installer 517 --yes

#     || Clipboard Indicator (https://extensions.gnome.org/extension/779/clipboard-indicator/) ||
#     \\---------------------------------------------------------------------------------------||
    gnome-shell-extension-installer 779 --yes

#     || Burn My Windows (https://extensions.gnome.org/extension/4679/burn-my-windows/) ||
#     \\---------------------------------------------------------------------------------------||
    gnome-shell-extension-installer 4679 --yes

#     || Removable Drive Menu (https://extensions.gnome.org/extension/7/removable-drive-menu/) ||
#     \\---------------------------------------------------------------------------------------||
    gnome-shell-extension-installer 7 --yes

#     || Blur My Shell (https://extensions.gnome.org/extension/3193/blur-my-shell/) ||
#     \\---------------------------------------------------------------------------------------||
    gnome-shell-extension-installer 3193 --yes

#     || Arch Linux Updates Indicator (https://extensions.gnome.org/extension/1010/archlinux-updates-indicator/) ||
#     \\---------------------------------------------------------------------------------------||
    gnome-shell-extension-installer 1010 --yes
}

revert_network_naming() {
    # See: https://wiki.archlinux.org/title/Network_configuration#Revert_to_traditional_interface_names
    ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
    echo -e "\n  $greenstar network : reverted to traditional interface naming"
}

fetch_kitty_config() {
    kittyFile="/home/$findUser/.config/kitty/kitty.conf"
    if [[ -f "$kittyFile" ]]; then
        cp $kittyFile /home/$findUser/.config/kitty/kitty.bak
    else
        mkdir -p /home/$findUser/.config/kitty
    fi

    eval wget -q $kitty_conf -O $kittyFile
    echo -e "\n  $greenplus kitty : downloaded new configuration file"
    fix_config_permissions
}

switch_to_zsh() {
    # Switch from BASH to ZSH

    chsh $findUser -s /bin/zsh
    echo -e "\n  $greenstar terminal : changed from bash to$color_light_green zsh$color_nocolor"
}

install_p10k_fonts() {
    # Install fonts necessary for Powerlevel10k theme

    #echo -e "\n  $yellowstar fonts : now attempting font install as user$color_other_yellow $findUser $color_nocolor"

    #mesloNerdFont="paru -Sy ttf-meslo-nerd-font-powerlevel10k --needed"
    #awesomeTerminalFont="paru -Sy awesome-terminal-fonts --needed"
    #powerlineGitFont="paru -Sy powerline-fonts-git --needed"
    #jetbrainsNerdFont="paru -Sy nerd-fonts-jetbrains-mono --needed"
    #notoNerdFont="paru -Sy nerd-fonts-noto-sans-regular-complete --needed"
    #cascadiaNerdFont="paru -Sy nerd-fonts-cascadia-code --needed"
    #overpassNerdFont="paru -Sy nerd-fonts-overpass --needed"
    #sourcecodeNerdFont="paru -Sy nerd-fonts-source-code-pro --needed"

    #sudo -u $findUser $mesloNerdFont
    paru -Sy arcolinux_repo_3party/ttf-meslo-nerd-font-powerlevel10k --needed --noconfirm
    echo -e "\n  $greenplus fonts : meslo nerd font powerlevel10k - installed"

    #sudo -u $findUser $awesomeTerminalFont
    paru -Sy community/awesome-terminal-fonts --needed --noconfirm
    echo -e "\n  $greenplus fonts : awesome terminal fonts - installed"

    #sudo -u $findUser $powerlineGitFont
    paru -Sy community/powerline-fonts --needed --noconfirm
    echo -e "\n  $greenplus fonts : powerline fonts - installed"
    
    #sudo -u $findUser $jetbrainsNerdFont
    paru -Sy community/ttf-jetbrains-mono-nerd --needed --noconfirm
    echo -e "\n  $greenplus fonts : jetbrains mono nerd font - installed"

    #sudo -u $findUser $notoNerdFont
    paru -Sy community/ttf-noto-nerd --needed --noconfirm
    echo -e "\n  $greenplus fonts : noto nerd font - installed"

    #sudo -u $findUser $cascadiaNerdFont
    paru -Sy community/otf-cascadia-code-nerd --needed --noconfirm
    echo -e "\n  $greenplus fonts : cascadia code nerd font - installed"

    #sudo -u $findUser $overpassNerdFont
    paru -Sy community/otf-overpass-nerd --needed --noconfirm
    echo -e "\n  $greenplus fonts : overpass nerd font - installed"
    
    #sudo -u $findUser $sourcecodeNerdFont
    paru -Sy arcolinux_repo_3party/nerd-fonts-source-code-pro --needed --noconfirm
    echo -e "\n  $greenplus fonts : source code pro nerd font - installed"

    paru -Sy community/ttf-nerd-fonts-symbols-common --needed --noconfirm
    paru -Sy community/ttf-nerd-fonts-symbols-2048-em-mono --needed --noconfirm
    paru -Sy community/ttf-nerd-fonts-symbols-2048-em --needed --noconfirm
    #paru -Sy community/ttf-nerd-fonts-symbols-1000-em-mono --needed --noconfirm
    #paru -Sy community/ttf-nerd-fonts-symbols-1000-em --needed --noconfirm
    echo -e "\n  $greenplus fonts : nerd fonts symbols packages (multiple) - installed"
}



# || BEGIN ||
# \\-------||
remove_bloat
get_prerequisites
get_visual_components
gnome_ext_installers
#install_extensions
revert_network_naming
fetch_kitty_config
switch_to_zsh
install_p10k_fonts

echo -e "\n  $blinkwarn COMPLETE : Reboot required. Proceed with any additional scripts after successful restart."
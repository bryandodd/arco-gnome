#!/bin/bash

tweak_settings() {
#     || Tweak Gnome settings ||
#     \\----------------------||
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
}

# runtime check
if [ "$(id -u)" -eq 0 ]; then
    echo -e "\n$blinkexclaim ERR : Must NOT run as root. Run again WITHOUT 'sudo'."
    exit 1
fi

tweak_settings
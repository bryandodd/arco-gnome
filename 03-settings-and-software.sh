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
    neofetch_new="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/configs/neofetch/config.conf"
    zshrc_new="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/configs/zsh/.zshrc"
    aliases_new="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/configs/zsh/.aliases"
    p10k_new="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/configs/zsh/.p10k.zsh"
    bat_new="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/configs/bat/config"
    aws_update_script="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/scripts/update-aws-cli.sh"
    aws_remove_script="https://raw.githubusercontent.com/bryandodd/arco-gnome/main/scripts/remove-aws-cli.sh"
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

# permissions fixes
fix_local_permissions() {
    chown -R $findUser:$userGroup /home/$findUser/.local
    echo -e "\n  $cyanstar permissions : set$color_other_yellow $findUser $color_nocolor as owner of$color_other_yellow ~/.local $color_nocolor"
}

fix_config_permissions() {
    chown -R $findUser:$userGroup /home/$findUser/.config
    echo -e "\n  $cyanstar permissions : set$color_other_yellow $findUser $color_nocolor as owner of$color_other_yellow ~/.config $color_nocolor"
}

config_neofetch() {
#     || neofetch ||
#     \\----------||

    neofetchFile="/home/$findUser/.config/neofetch/config.conf"
    if [[ -f "$neofetchFile" ]]; then
        cp $neofetchFile /home/$findUser/.config/neofetch/config.bak
    fi

    eval wget -q $neofetch_new -O $neofetchFile
    echo -e "\n  $greenplus neofetch : replaced config.conf with file from repo"
    fix_config_permissions
}

install_p10k() {
#     || Powerlevel10k ||
#     \\---------------||
#      \\ -- See the NerdFonts Cheat Sheet for interesting stuff: https://www.nerdfonts.com/cheat-sheet

    echo -e "\n  $yellowstar Powerlevel10k : attempting install as user$color_other_yellow $findUser $color_nocolor"
    p10kInstall="paru -Sy community/zsh-theme-powerlevel10k --noconfirm"

    paru -Q zsh-theme-powerlevel10k > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        sudo -u $findUser $p10kInstall
        echo -e "\n  $greenplus Powerlevel10k : installed"
    fi

    # replace .zshrc with copy from repo
    zshFile="/home/$findUser/.zshrc"
    if [[ -f "$zshFile" ]]; then
        cp $zshFile /home/$findUser/.zshbak
    fi

    eval wget -q $zshrc_new -O $zshFile
    echo -e "\n  $greenplus zshrc : replaced zshrc with file from repo"
    chown $findUser:$userGroup $zshFile

    # copy aliases from repo
    aliasesFile="/home/$findUser/.aliases"
    if [[ -f "$aliasesFile" ]]; then
        cp $aliasesFile /home/$findUser/.aliasesbak
    fi

    eval wget -q $aliases_new -O $aliasesFile
    echo -e "\n  $greenplus aliases : copied aliases file from repo"
    chown $findUser:$userGroup $aliasesFile

    # copy p10k.zsh from repo
    p10kFile="/home/$findUser/.p10k.zsh"
    if [[ -f "$p10kFile" ]]; then
        cp $p10kFile /home/$findUser/.p10k.bak
    fi

    eval wget -q $p10k_new -O $p10kFile
    echo -e "\n  $greenplus p10k.zsh : copied p10k config from repo"
    chown $findUser:$userGroup $p10kFile
}

install_python() {
#     || Python (v2, v3, and other core components) ||
#     \\--------------------------------------------||

    paru -Q python > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy python --needed --noconfirm
        echo -e "\n  $greenplus Python3 : installed"
    fi

    paru -Q python2 > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy python2 --needed --noconfirm
        echo -e "\n  $greenplus Python2 : installed"
    fi

    paru -Q python-setuptools > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy python-setuptools --needed --noconfirm
        echo -e "\n  $greenplus Python3 Setup Tools : installed"
    fi

    paru -Q python2-setuptools > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy python2-setuptools --needed --noconfirm
        echo -e "\n  $greenplus Python2 Setup Tools : installed"
    fi

    #paru -Q python2-pip > /dev/null 2>&1
    #if [[ $? -ne 0 ]]; then
    #    paru -Sy python2-pip --needed --noconfirm
    #    echo -e "\n  $greenplus Python2 pip : installed"
    #fi

    paru -Q python-pip > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy python-pip --needed --noconfirm
        echo -e "\n  $greenplus Python3 pip : installed"
    fi
}

manual_pip2_install() {
#     || Manual Pip2 Installation ||
#     \\--------------------------||
#      \\-- (because everybody loves to hate python2)
#       |-- package officially dropped from aur so had to resort to 'plan c'
#       |-- courtesy of https://raw.githubusercontent.com/pypa/get-pip/3843bff3a0a61da5b63ea0b7d34794c5c51a2f11/2.7/get-pip.py
#       |-- and github.com/dewalt-arch/pimpmykali

    pipFile="/home/$findUser/get-pip.py"
    if [[ -f "$pipFile" ]]; then
        echo -e "$yellowstar Pip2 install file found. Skipping download."
    else
        eval wget $pip2_new -O $pipFile
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
}

install_flameshot() {
#     || Flameshot ||
#     \\-----------||

    paru -Q flameshot > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/flameshot --needed --noconfirm
        echo -e "\n  $greenplus Flameshot : installed"
    fi
}

install_vscode() {
#     || Visual Studio Code ||
#     \\--------------------||

    paru -Q visual-studio-code-bin > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy arcolinux_repo_xlarge/visual-studio-code-bin --needed --noconfirm
        echo -e "\n  $greenplus Visual Studio Code : installed"
    fi

    # Insert aliases for VSCode
    aliasesFile="/home/$findUser/.aliases"
    sed -i '/^## End Additional H.*/i alias hosts=\"code /etc/hosts\"\nalias profile=\"code ~/.zshrc\"\nalias aliases=\"code ~/.aliases\"' $aliasesFile
    echo -e "\n  $greenstar aliases added : 'hosts', 'profile', and 'aliases' will open respective files with$color_light_green vscode$color_nocolor"
    chown $findUser:$userGroup $aliasesFile

    # Set ZSH variable for Kubernetes Editor
    zshFile="/home/$findUser/.zshrc"
    sed -i '/^export VISUAL=.*/a export KUBE_EDITOR=\"code --wait\"' $zshFile
    echo -e "\n  $greenstar zsh variable added : KUBE_EDITOR set to$color_light_green vscode$color_nocolor"
    chown $findUser:$userGroup $zshFile
}

install_msteams() {
#     || Microsoft Teams ||
#     \\-----------------||

    paru -Q teams > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy arcolinux_repo_xlarge/teams --needed --noconfirm
        echo -e "\n  $greenplus Microsoft Teams : installed"
    fi
}

install_slack() {
#     || Slack Desktop ||
#     \\---------------||

    paru -Q slack-desktop > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy arcolinux_repo_xlarge/slack-desktop --needed --noconfirm
        echo -e "\n  $greenplus Slack : installed"
    fi
}

install_remmina() {
#     || Remmina Remote Desktop ||
#     \\------------------------||

    paru -Q remmina > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/remmina --needed --noconfirm
        echo -e "\n  $greenplus Remmina : installed"
    fi
}

install_btop() {
#     || btop++ ||
#     \\--------||

    paru -Q btop > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/btop --needed --noconfirm
        echo -e "\n  $greenplus btop : installed"
    fi
}

install_stacer() {
#     || Stacer Resource Monitor ||
#     \\-------------------------||

    paru -Q stacer > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy arcolinux_repo_3party/stacer --needed --noconfirm
        echo -e "\n  $greenplus Stacer : installed"
    fi
}

install_exa() {
#     || exa (ls replacement) ||
#     \\----------------------||

    paru -Q exa > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/exa --needed --noconfirm
        echo -e "\n  $greenplus exa : installed"
    fi

    # Update aliases to call 'exa' instead of 'ls'
    aliasesFile="/home/$findUser/.aliases"
    awk -i inplace '/^alias ll=/{$0="alias ll=\"exa -lahHg --icons --group-directories-first --time-style long-iso --git --octal-permissions\""}1' $aliasesFile
    echo -e "\n  $greenstar alias updated : 'll' set to$color_light_green exa$color_nocolor"
    chown $findUser:$userGroup $aliasesFile
}

install_bat() {
#     || bat (cat replacement) ||
#     \\-----------------------||

    paru -Q bat > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/bat --needed --noconfirm
        echo -e "\n  $greenplus bat : installed"
    fi

    # Create the bat config file
    genConfigFile="bat --generate-config-file"
    sudo -u $findUser $genConfigFile
    echo -e "\n  $greenplus bat : generated default config file"

    batConfig="/home/$findUser/.config/bat/config"
    cp $batConfig /home/$findUser/.config/bat/.bakconfig

    eval wget -q $bat_new -O $batConfig
    echo -e "\n  $greenstar bat : replaced config with file from repo"
    chown $findUser:$userGroup $batConfig

    # Insert aliases to call 'bat' instead of 'cat'
    aliasesFile="/home/$findUser/.aliases"
    sed -i '/^alias l\.=.*/a \\n# see the bat config file in ~/.config/bat/config for other settings\nalias cat=\"bat -P\"\nalias cat-page=\"bat\"' $aliasesFile
    echo -e "\n  $greenstar alias added : 'cat' set to$color_light_green bat$color_nocolor"
    chown $findUser:$userGroup $aliasesFile
}

install_oathtoolkit() {
#     || oath-toolkit (totp code generator) ||
#     \\------------------------------------||

    paru -Q oath-toolkit > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/oath-toolkit --needed --noconfirm
        echo -e "\n  $greenplus oath-toolkit : installed"
    fi
}

install_aws_cli() {
#     || aws cli ||
#     \\---------||

    paru -Q aws-cli-v2-bin > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        installAwsCli="paru -Sy aur/aws-cli-v2-bin --needed --noconfirm"
        sudo -u $findUser $installAwsCli
        echo -e "\n  $greenplus AWS CLI : installed"
    fi
}

install_aws_cli_script() {
#     || aws cli - alternate install method ||
#     \\------------------------------------||

    [ -d /home/$findUser/.local/helper-scripts ] || mkdir /home/$findUser/.local/helper-scripts
    awsScriptFile="/home/$findUser/.local/helper-scripts/update-aws-cli.sh"
    eval wget -q $aws_update_script -O $awsScriptFile
    echo -e "\n  $greenplus scripts : downloaded$color_light_green update-aws-cli.sh$color_nocolor helper from repo"
    eval wget -q $aws_remove_script -O /home/$findUser/.local/helper-scripts/remove-aws-cli.sh
    echo -e "\n  $greenplus scripts : downloaded$color_light_green remove-aws-cli.sh$color_nocolor helper from repo"
    chmod +x $awsScriptFile
    bash $awsScriptFile

    echo -e "\n  $bluestar Subscript execution finished :$color_other_yellow update-aws-cli.sh $color_nocolor"
    chown -R $findUser:$userGroup /home/$findUser/.local/helper-scripts
}



install_kubectl() {
#     || kubectl ||
#     \\---------||
#      \\-- https://archlinux.org/packages/community/x86_64/kubectl/

    paru -Q kubectl > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/kubectl --needed --noconfirm
        echo -e "\n  $greenplus kubectl : installed"
    fi
}

install_kubectx() {
#     || kubectx ||
#     \\---------||
#      \\-- https://archlinux.org/packages/community/any/kubectx/

    paru -Q kubectx > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/kubectx --needed --noconfirm
        echo -e "\n  $greenplus kubectx : installed"
    fi
}

install_aws_iam_authenticator() {
#     || aws iam authenticator ||
#     \\-----------------------||
#      \\-- https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
#       |-- https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/
#       |-- https://aur.archlinux.org/packages/aws-iam-authenticator-bin
#       |-- https://github.com/kubernetes-sigs/aws-iam-authenticator

    paru -Q aws-iam-authenticator-bin > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        installAwsIamAuth="paru -Sy aur/aws-iam-authenticator-bin --needed --noconfirm"
        sudo -u $findUser $installAwsIamAuth
        echo -e "\n  $greenplus AWS IAM Authenticator : installed"
    fi
}

install_eksctl() {
#     || eksctl ||
#     \\--------||
#      \\-- https://archlinux.org/packages/community/x86_64/eksctl/

    paru -Q eksctl > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        paru -Sy community/eksctl --needed --noconfirm
        echo -e "\n  $greenplus eksctl : installed"
    fi
}

check_architecture() {
#     || vendor-specific cpu code ||
#     \\--------------------------||

    cpuVendor=$(lscpu -J | jq '.lscpu[] | select(.field=="Vendor ID:") | .data' -r)
    if [ $cpuVendor == "GenuineIntel" ]
    then
        echo -e "\n  $cyanstar CPU Detection :$color_other_yellow INTEL$color_nocolor detected. Installing Intel microcode ..."
        paru -Q intel-ucode > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            paru -Sy extra/intel-ucode --needed --noconfirm
            echo -e "\n  $greenplus Intel Microcode : installed"
        fi
    elif [ $cpuVendor == "AuthenticAMD" ]
    then
        echo -e "\n  $cyanstar CPU Detection :$color_other_yellow AMD$color_nocolor detected. Installing AMD microcode ..."
        paru -Q amd-ucode > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            paru -Sy core/amd-ucode --needed --noconfirm
            echo -e "\n  $greenplus AMD Microcode : installed"
        fi
    else
        echo -e "\n  $cyanstar CPU Detection :$color_purple COULD NOT DETERMINE CPU - skipping microcode $color_nocolor "
    fi
}


# || BEGIN ||
# \\-------||
config_neofetch
install_p10k
install_python
manual_pip2_install
install_flameshot
install_vscode
install_msteams
install_slack
install_remmina
install_btop
#install_stacer
install_exa
install_bat
install_oathtoolkit
install_aws_cli
install_kubectl
install_kubectx
install_aws_iam_authenticator
install_eksctl
check_architecture

echo -e "\n  $blinkwarn COMPLETE : Reboot required. Proceed with any additional scripts after successful restart."
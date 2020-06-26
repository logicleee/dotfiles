#!/bin/bash

macOS_host_net_complete_flag="$HOME/.macOS_host_net_complete.flag"
bash_install_complete="$HOME/.macOS_host_bash_install_complete.flag"
tex_packages_install_complete="$HOME/.macOS_host_tex_packages_insatll_complete.flag"
sudo=/user/bin/sudo

Xcode_install () { sudo /usr/sbin/softwareupdate -i Command\ Line\ Tools\ for\ Xcode-11.5 ; }

logf () {
    local _tags="$(basename ${BASH_SOURCE[2]:-undefined}):${FUNCNAME[1]:-undefined}"
    logger -t "$_tags" $1
}

logs () {
    local _tags="$(basename ${BASH_SOURCE[2]:-undefined}):${FUNCNAME[1]:-undefined}"
    logger -t "$_tags" $1
}

logs_exit () {
    local _tags="$(basename ${BASH_SOURCE[2]:-undefined}):${FUNCNAME[1]:-undefined}"
    logger -t "$_tags" $1
    exit 1
}

confirm () {
    local response
    local question=${1:-"Continue?"}
    while true ; do
        read -p "$question (y/n/q): " response
        [[ $response =~ ^[Yy]$ ]] && return 0
        [[ $response =~ ^[Nn]$ ]] && return 1
        [[ $response =~ ^[Qq]$ ]] && exit 100
        echo "  Invalid response: $response"
    done
    return 2
}

sudocfg_macOS_host_net () {
    local _action_text="Config macOS host"
    logs "BEGIN $_action_text"

    _get_host_name || logs_exit "Exiting due to non-confirm"
    _sudo_keep_alive
    _sudo_net_hostname_config && \
    _sudo_net_firewall_config && \
    touch "$macOS_host_net_complete_flag"

    echo "changes to the gui take effect on logout/reboot"
    logs "END $_action_text"
}


brewinstall_packages_PRE () {
    # add steps that go just before installing brew
    return 0
}

brewinstall_packages_POST () {
    # add steps that go just after installing base brew packages
    return 0
}

system_setup () {
    default_system_setup
}

user_setup () {
    default_user_setup
}

run_ansible_playbook_PRE () {
    # add steps that go just before running ansible playbook
    return 0
}

run_ansible_playbook () {
    ansible-playbook main.yml -i inventory
}

run_ansible_playbook_POST () {
    # add steps that go just after running ansible playbook
    _download_1password6
    return 0
}


run_dotfiles_setup () {
    "$THISDIR/../../bin/setup-dotfiles.sh"
}

brewinstall_packages () {
        _install_or_upgrade_brew
        _brew_install_base_packages
        _upgrade_pip3
        _brew_cask_install_Emacs_GUI
        _brew_cleanup
}

install_complete_notice () {
    cat <<EOF
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  Install started: $INSTALL_START_TIME
Install completed: $(date)

Review logs above for any issues. Re-run ~/.system-setup/setup.sh as needed.

Then run ./software-update-playbook.sh to update macOS and packages.
./software-update-playbook.sh:
  - updates packages
  - updates the OS
  - reboots node if required by sofwareupdate

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
EOF

}

_sudo_keep_alive () {
    sudo -v || logs_exit "Bad password.  Exiting"
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

_get_host_name () {
    cat <<EOF
Enter hostname for this device, examples:
term0: primary non-lan multi-purpose desktop-OS based node
lan1:  secondary lan-ONLY multi-purpose desktop-OS based node
cm:  config managment node
EOF
    while read -p "Enter hostname without domain: " H ; do
        export computer_name="$H"
        export host_name="$H"
        export local_host_name="$H"

        cat <<EOF
 Computer name: ${computer_name}.local
      Hostname: ${host_name}.local
Local Hostname: ${local_host_name}.local
Is this config correct?
EOF
        confirm && break
    done
}


_sudo_net_hostname_config () {
    local _action_text="Setting HOSTNAME"

    logs "BEGIN $_action_text"

    sudo scutil --set ComputerName "$computer_name"
    sudo scutil --set HostName "$host_name"
    sudo scutil --set LocalHostName "$local_host_name"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$local_host_name"

    logs "Updated HOSTNAME:"
    logs "     HostName: $(sudo scutil --get HostName)"
    logs " ComputerName: $(sudo scutil --get ComputerName)"
    logs "LocalHostName: $(sudo scutil --get LocalHostName)"

    logs "END $_action_text"

}

_sudo_net_firewall_config () {
    # ref: http://krypted.com/mac-security/command-line-firewall-management-in-os-x-10-10/

    local _action_text="Configuring Firewall"
    logs "BEGIN $_action_text"

    logs "Original Firewall State: $(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)"
    logs "Original Stealth Mode State: $(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode)"
    logs "Original logging mode: $(/usr/libexec/ApplicationFirewall/socketfilterfw --getloggingmode)"

    logs "Enabling ICMP Stealth Mode"
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

    logs "Turning on firewall with logging mode on & throttled"
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingopt throttled
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

    logs "Sanity check -- Firewall State: $(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)"

    logs "Changes to the gui may take effect on logout/reboot"

    logs "END $_action_text"

}

_install_xcode_tools () {
    xcode-select --install
    logs "let Xcode finish installing..."
    logs "Re-run ./setup.sh after"
}


_install_or_upgrade_brew () {

    local u='https://raw.githubusercontent.com/Homebrew/install/master/install.sh'
    if test ! $(which brew); then
        logs "Installing Homebrew ..."
        /bin/bash -c "$(curl -fsSL $u)" || exit 1
    else
        logs "Updating Homebrew ..."
        brew update
        brew upgrade
    fi
    brew doctor || exit 1
    export HOMEBREW_NO_AUTO_UPDATE=1
    #brew tap homebrew/dupes #depricated
}

_brew_install_base_packages () {
    local _action_text="brew install ansible nvim wget"
    logs "BEGIN $_action_text"
    brew install ansible nvim wget python3
    logs "END $_action_text; EXIT $?"
}

_brew_cask_install_Emacs_GUI () {
    local _action_text="Install Emacs"
    logs "BEGIN $_action_text"
    #wget "https://emacsformacos.com/emacs-builds/Emacs-26.3-universal.dmg"
    #open Emacs-26.3-universal.dmg
    #sudo cp -R /Volumes/Emacs/Emacs.app /Applications/
    brew cask install emacs
    logs "END $_action_text; EXIT $?"
}

_upgrade_pip3 () {
    local _action_text="Upgrade pip3"
    logs "BEGIN $_action_text"
    sudo pip3 install --upgrade pip
    logs "END $_action_text; EXIT $?"
}
_brew_cask_install_VMware_Fusion () {
    local _action_text="Install VMware Fusion"
    logs "BEGIN $_action_text"
    brew cask install vmware-fusion
    logs "END $_action_text; EXIT $?"
}

_brew_cask_install_VirtualBox () {
    local _action_text="Install VirtualBox"
    logs "BEGIN $_action_text"
    brew cask install virtualbox
    logs "END $_action_text; EXIT $?"
}

_brew_install_ruby_chruby () {
    local _action_text="brew install ruby-install chruby"
    logs "BEGIN $_action_text"
    brew install ruby-install chruby
    logs "END $_action_text; EXIT $?"
}


_ruby_install_ruby () {
    _action_text="ruby-install ruby"
    logs "BEGIN $_action_text"
    #TODO FIX! this shoud automatically handle the current verion that was just installed
    ruby-install ruby                   && \
    echo "ruby-2.3.1" > ~/.ruby-version && \
    ruby -v
    logs "END $_action_text; EXIT $?"
}

_brew_cleanup () {
    logs "Brew: Cleaning up ..."
    brew cleanup
    #brew cask cleanup
    #brew linkapps #this adds to /Applications and adds visibility for spotlight
    brew doctor
}

_install_TeX_packages () {
    logs "BEGIN ${FUNCNAME[0]}"
    "$THISDIR/../../bin/dotfiles-install-tex-packages.sh"
    logs "END ${FUNCNAME[0]}; EXIT $?"
}

_download_1password6 () {
    logs "BEGIN ${FUNCNAME[0]}"
    cd ~/Downloads
    wget https://c.1password.com/dist/1P/mac4/1Password-6.8.9.pkg
    open 1Password-6.8.9.pkg &
    cd -
    logs "END ${FUNCNAME[0]}; EXIT $?"
}

caffdisplay () {
    printf "Started %s at %s\n" "${FUNCNAME[0]}" "$(date)"
    caffeinate -d &
}

cleanup () {
    echo "Cleaning up..."
    kill $PID_CAFF
}

INSTALL_MAIN () {
    export INSTALL_START_TIME=$(date)
    cd "$THISDIR"
    caffdisplay

    PID_CAFF=$!

    if [ ! -f "$macOS_host_net_complete_flag" ]; then
        sudocfg_macOS_host_net
    fi

    # not needed anymore - homebrew handles this
    #if [ ! -f "/usr/bin/xcode-select" ] ; then
        #_install_xcode_tools
        #exit 1
    #fi

    if [ ! -f "$bash_install_complete" ] ; then
        brewinstall_packages_PRE
        brewinstall_packages
        brewinstall_packages_POST
        touch "$bash_install_complete"
    fi

    system_setup
    user_setup
    run_ansible_playbook_PRE
    run_ansible_playbook
    run_ansible_playbook_POST

    run_dotfiles_setup
    install_complete_notice

}

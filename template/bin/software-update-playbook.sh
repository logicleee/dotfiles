#!/bin/bash

export HOMEBREW_NO_AUTO_UPDATE=1
THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ~/.lib/Darwin.install.lib.sh || exit 1

if ! cd ~/.system-setup
then
    echo "ERROR: Missing ~/.system-setup -- Exiting"
    exit 1
fi

_sudo_keep_alive
brew update                                                       && \
brew upgrade                                                      && \
brew cask upgrade                                                 && \
ansible-playbook software-update-playbook.yml -i config/inventory \
   --ask-become-pass && \
sudo softwareupdate --install --all --restart

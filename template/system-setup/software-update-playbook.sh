#!/bin/bash

export HOMEBREW_NO_AUTO_UPDATE=1
source lib/Darwin.install.lib.sh || exit 1

_sudo_keep_alive
brew update                                                       && \
brew upgrade                                                      && \
brew cask upgrade                                                 && \
ansible-playbook software-update-playbook.yml -i config/inventory && \
sudo softwareupdate --install --all --restart

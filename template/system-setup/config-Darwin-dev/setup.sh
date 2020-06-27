#!/bin/bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$THISDIR/../../lib/Darwin.install.lib.sh" || exit 1
source "$THISDIR/../../lib/Darwin.setup.lib.sh" || exit 1

# ######################################## #
# FUNCTION OVERRIDES FOR SOURCED LIBRARIES #
# ######################################## #

_brewinstall_packages_POST () {
    _brew_cask_install_VMware_Fusion
    _brew_cask_install_VirtualBox
}

_run_ansible_playbook_POST () {
    # add steps that go just after running ansible playbook
    #return 0
    if [ ! -f "$tex_packages_install_complete" ] ; then
        _install_TeX_packages && \
        touch "$tex_packages_install_complete"
        return $?
    fi
}

# ############### #
# BEGIN EXECUTION #
# ############### #

trap _install_cleanup EXIT

INSTALL_MAIN

#!/bin/bash

source "$DOTFILES_PATH/lib/dotfiles-utils.lib.sh" || exit
emacsconfig_pathfile="$HOME/.VAR_EMACS_CONFIG_PATH"
EMACS_CONFIG_PATH="$(cat $emacsconfig_pathfile)" || exit
emacs_d="$EMACS_CONFIG_PATH/emacs.d"
site_lisp="$EMACS_CONFIG_PATH/emacs.d/site-lisp"
emacs_lisp_local="$emacs_d/emacs-lisp-local"

dotfiles_emacs_install_purcells_config () {
    cd "$EMACS_CONFIG_PATH/"
    git clone https://github.com/purcell/emacs.d.git
    dotfiles_emacs_link_files
    cd -
}

dotfiles_emacs_install_jade_mode () {
    cd "$site_lisp"
    git clone https://github.com/brianc/jade-mode.git
    cd -
}

dotfiles_emacs_install_theme_solarized () {
    cd "$site_lisp"
    git clone https://github.com/sellout/emacs-color-theme-solarized.git
    cd -
}

dotfiles_emacs_update_config () {
    cd "$emacs_d/"
    git pull
    cd -
}

dotfiles_emacs_link_files () {
    _dotfiles_link_item "$emacs_d" ~/.emacs.d
    _dotfiles_link_item "$DOTFILES_PATH/emacs-lisp-local" "$emacs_d/lisp-local"
    _dotfiles_link_item "$emacs_lisp_local/init-local.el" \
        "$emacs_d/lisp/init-local.el"
}

# check if setup done flag && exit
if [ -f "$EMACS_CONFIG_PATH/setup_emacs_complete.flag" ]
then 
    echo "WARNING: Skipping ${BASH_SOURCE[0]} ... already ran"
    exit
fi

if [ ! -d "$emacs_d" ]
then
    dotfiles_emacs_install_purcells_config
    dotfiles_emacs_install_jade_mode
    dotfiles_emacs_install_theme_solarized
    open /Applications/Emacs.app
else
    dotfiles_emacs_update_config
fi

echo "$(date) INFO: COMPLETED ${BASH_SOURCE[0]}"
#!/bin/bash

source "$DOTFILES_PATH/lib/dotfiles-utils.lib.sh" || exit
code_pathfile="$HOME/.VAR_CODE_PATH"
emacsconfig_pathfile="$HOME/.VAR_EMACS_CONFIG_PATH"
CODE_PATH="$(cat $code_pathfile)" || exit
EMACS_CONFIG_PATH="$(cat $emacsconfig_pathfile)" || exit
emacs_d="$EMACS_CONFIG_PATH/emacs.d"

dotfiles_emacs_clone_purcells_config () {
    cd "$EMACS_CONFIG_PATH/"
    git clone https://github.com/purcell/emacs.d.git
    dotfiles_emacs_link_files
    cd -
}

dotfiles_emacs_update_config () {
    cd "$emacs_d/"
    git pull
    cd -
}

dotfiles_emacs_link_files () {
    [ -d "$emacs_d/lisp-local" ] && rm -r "$emacs_d/lisp-local"
    _if_exists_move_but_backup_item "$emacs_d/lisp/init-local.el"

    #TODO need to put emacs-local into github and clone here

    _link_item "$CODE_PATH/emacs-lisp-local/init-local.el" \
        "$emacs_d/lisp/init-local.el"
    _link_item "$CODE_PATH/emacs-lisp-local" "$emacs_d/lisp-local"
    _link_item "$CODE_PATH/emacs-capture-templates" "$emacs_d/lisp-local/templates"
    _link_item "$CODE_PATH/emacs-jade-mode" "$emacs_d/lisp-local/jade-mode"
    _link_item "$CODE_PATH/emacs-themes" "$emacs_d/themes"
}

# check if setup done flag && exit
if [ -f "$EMACS_CONFIG_PATH/setup_emacs_complete.flag" ]
then 
    echo "WARNING: Skipping ${BASH_SOURCE[0]} ... already ran"
    exit
fi

if [ ! -d "$EMACS_CONFIG_PATH/emacs.d" ]
then
    dotfiles_emacs_clone_purcells_config
else
    dotfiles_emacs_update_config
fi

echo "$(date) INFO: COMPLETED ${BASH_SOURCE[0]}"
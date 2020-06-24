#!/bin/bash

source "$DOTFILES_PATH/lib/dotfiles-utils.lib.sh" || exit
code_pathfile="$HOME/.VAR_CODE_PATH"
emacsconfig_pathfile="$HOME/.VAR_EMACS_CONFIG_PATH"
CODE_PATH="$(cat $code_pathfile)" || exit
EMACS_CONFIG_PATH="$(cat $emacsconfig_pathfile)" || exit
emacs_d="$EMACS_CONFIG_PATH/emacs.d"

# check if setup done flag && exit
if [ -f "$EMACS_CONFIG_PATH/setup_emacs_complete.flag" ]
then 
    echo "WARNING: Skipping ${BASH_SOURCE[0]} ... already ran"
    exit
fi

# setup emacs
# clone purcell's repo

if [ ! -d "$EMACS_CONFIG_PATH/emacs.d" ]
then

    cd "$EMACS_CONFIG_PATH/"

    git clone https://github.com/purcell/emacs.d.git

    [ -d "$emacs_d/lisp-local" ] && rm -r "$emacs_d/lisp-local"
    _if_exists_move_but_backup_item "$emacs_d/lisp/init-local.el"

    ln -s "$CODE_PATH/emacs-lisp-local/init-local.el" \
        "$emacs_d/lisp/init-local.el"
    ln -s "$CODE_PATH/emacs-lisp-local" "$emacs_d/lisp-local"
    ln -s "$CODE_PATH/emacs-themes" "$emacs_d/themes"

    cd -

else

    cd "$emacs_d/"
    git pull
    cd -

fi

# clone my local-lisp
# link
cd -
echo "$(date) INFO: COMPLETED ${BASH_SOURCE[0]}"
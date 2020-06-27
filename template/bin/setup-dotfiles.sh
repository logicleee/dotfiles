#!/usr/bin/env bash
#set -e
#set -x

code_pathfile="$HOME/.VAR_CODE_PATH"
dotfiles_base_pathfile="$HOME/.VAR_DOTFILES_BASE_PATH"

_dotfiles_configure_paths () {
    if [ ! -f "$code_pathfile" ]
    then
        echo "$HOME/code" > "$code_pathfile"
    fi
    export CODE_PATH="$(cat $code_pathfile)"

    if [ ! -f "$dotfiles_base_pathfile" ]
    then
        echo "$HOME/dotfiles" > "$dotfiles_base_pathfile"
    fi
    export DOTFILES_BASE_PATH="$(cat $dotfiles_base_pathfile)"
    export DOTFILES_PATH="$DOTFILES_BASE_PATH/local"

    return 0
}

_dotfiles_check_for_repo () {
    if [ ! -d "$DOTFILES_BASE_PATH" ]
    then
        _dotfiles_setup_base
        exit $?
    fi

    return 0
}

_dotfiles_setup_base () {
    local URL='https://github.com/logicleee/dotfiles.git'

    # Prevent from re-running over and over
    local runonce_flag="$HOME/.run-once.dotfiles_setup_base"
    if [ -f  "$runonce_flag" ]
    then
        echo "ERROR: Already ran dotfiles download!"
        echo "  Flag exists: $runonce_flag"
        echo "  Halting ${BASH_SOURCE[0]}"
        exit 1
    fi

    if [ "$CODE_PATH" == "" ]
    then
        echo "ERROR: CODE_PATH not defined!"
        exit 1
    fi

    if [ "$DOTFILES_BASE_PATH" == "" ]
    then
        echo "ERROR: DOTFILES_BASE_PATH not defined!"
        exit 2
    fi

    # prevent endless loop
    touch "$runonce_flag"

    # handle $DOTFILES_BASE_PATH not in $HOME
    dotfiles_base_parent_path="$(dirname $DOTFILES_BASE_PATH)"
    if [ ! -e "$dotfiles_base_parent_path" ] 
    then
        if ! mkdir -p "$dotfiles_base_parent_path"
        then
            echo "ERROR: Unable to create $dotfiles_base_parent_path"
            exit 3
        fi
    fi

    # to make it easier to setup multiple users
    cp -v "$DOTFILES_BASE_PATH/template/bin/setup-dotfiles.sh" \
        /usr/local/share/
    echo "  ... Copied ${BASH_SOURCE[0]} to /usr/local/share, exited: $?"

    cd "$(dirname $DOTFILES_BASE_PATH)" && \
    echo "Cloning dotfiles from $URL"    && \
    git clone "$URL"                     && \
    cd "$DOTFILES_BASE_PATH"             && \
    ./template/bin/setup-dotfiles.sh

}

_dotfiles_configure_paths

_dotfiles_check_for_repo

source "$DOTFILES_BASE_PATH/template/lib/dotfiles-utils.lib.sh"

dotfiles_setup

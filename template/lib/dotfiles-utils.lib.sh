#!/bin/bash

export DOTFILES_PATH="$DOTFILES_BASE_PATH/local"
export DOTFILES_TEMPLATE_PATH="$DOTFILES_BASE_PATH/template"

code_pathfile="$HOME/.VAR_CODE_PATH"
dotfiles_base_pathfile="$HOME/.VAR_DOTFILES_BASE_PATH"

Ymd_HMS () { date +'%Y%m%d_%H%M%S' ; }
bak_suffix=".bak_$(Ymd_HMS)"

dotfiles_setup () {
    _dotfiles_configure_paths
    _dotfiles_copy_template_to_local
    _dotfiles_create_home_folders
    dotfiles_link_all
    dotfiles_git_config

    # let these scripts handle state - re-run or not:
    setup_vim="$VIMCONFIG_PATH/bin/setup_vim.sh"
    setup_emacs="$EMACSCONFIG_PATH/bin/setup_emacs.sh"
    [ -f "$setup_vim" ] && "$setup_vim" 
    [ -f "$setup_emacs" ] && "$setup_emacs" 

    dotfiles_zsh_install_or_update_ohmyzsh
}

dotfiles_zsh_install_or_update_ohmyzsh () {
    local URL='https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools'
    URL+='/install.sh'
    local zshrc="$DOTFILES_PATH/zshrc"

    if [ ! -d ~/.oh-my-zsh ]
    then
        sh -c "$(curl -fsSL $URL)"
        local xc=$?

        printf '\nsource %s\n' "$zshrc"

        return $xc
    else
        cd ~/.oh-my-zsh
        git pull && cd -
        return $?
    fi
}

dotfiles_link_all () {
    _dotfiles_link_folders
    _dotfiles_link_binfiles
    _dotfiles_link_files
    dotfiles_link_vim
    dotfiles_link_emacs
}

dotfiles_git_config () {
    git config --global core.excludesfile '~/.gitignore'
}

dotfiles_link_vim () {
    local vimconfig_pathfile="$HOME/.VAR_VIM_CONFIG_PATH"
    if [ ! -f "$vimconfig_pathfile" ]
    then
        echo "$DOTFILES_PATH" > "$vimconfig_pathfile"
    fi
    export VIMCONFIG_PATH="$(cat $vimconfig_pathfile)"
    dotfiles_files=(
        "vimrc"
        "vim"
    )

    for f in ${dotfiles_files[@]}
    do
        src="$VIMCONFIG_PATH/${f}"
        l="$HOME/.${f}"
        _dotfiles_link_item "$src" "$l"
    done
}

dotfiles_link_emacs () {
    local emacsconfig_pathfile="$HOME/.VAR_EMACS_CONFIG_PATH"
    if [ ! -f "$emacsconfig_pathfile" ]
    then
        echo "$DOTFILES_PATH" > "$emacsconfig_pathfile"
    fi
    export EMACSCONFIG_PATH="$(cat $emacsconfig_pathfile)"

    dotfiles_files=(
        "emacs.d"
        "emacs"
    )

    for f in ${dotfiles_files[@]}
    do
        src="$EMACSCONFIG_PATH/${f}"
        l="$HOME/.${f}"

        if [ -e "$src" ]
        then
            _dotfiles_link_item "$src" "$l"
        fi
    done
}

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
    export DOTFILES_TEMPLATE_PATH="$DOTFILES_BASE_PATH/template"

    return 0
}

_dotfiles_link_folders () {
    dotfiles_folders=(
        "config"
    )

    for d in ${dotfiles_folders[@]}
    do
        src="$DOTFILES_PATH/${d}"
        dest="$HOME/.${d}"

        _dotfiles_link_item "$src" "$dest"
    done
}

_dotfiles_link_binfiles () {
    bin_files=(
        "bin/dotfiles-add-module.sh"
        "bin/setup-dotfiles.sh"
        "bin/setup-dotfiles-emacs.sh"
        "bin/setup-dotfiles-vim.sh"
    )

    for d in ${bin_files[@]}
    do
        src="$DOTFILES_PATH/${d}"
        dest="$HOME/${d/.sh/}"

        _dotfiles_link_item "$src" "$dest"
    done
}

_dotfiles_link_files () {
    dotfiles_files=(
        "aspell.en.prepl"
        "aspell.en.pws"
        "bash_aliases"
        "bash_prompt"
        "bashrc"
        "exports"
        "gitconfig"
        "gitignore_global"
        "inputrc"
        "ispell_english"
        "lib/common-bash.lib.sh"
        "lib/common-zsh.lib.sh"
        "lib/common.lib.sh"
        "lib/Darwin.install.lib.sh"
        "lib/Darwin.lib.sh"
        "lib/Darwin.setup.lib.sh"
        "lib/dotfiles-utils.lib.sh"
        "lib/Linux.lib.sh"
        "ssh/config"
        "vscode"
        "wgetrc"
        "zsh_prompt"
        "zshrc"
    )

    for f in ${dotfiles_files[@]}
    do
        src="$DOTFILES_PATH/${f}"
        dest="$HOME/.${f}"

        _dotfiles_link_item "$src" "$dest"
    done
}

_dotfiles_copy_template_to_local () {
    [ -d  "$DOTFILES_PATH" ] || \
        cp -rv "$DOTFILES_TEMPLATE_PATH" "$DOTFILES_PATH"
}

_dotfiles_create_home_folders () {
    dotfiles_folders=(
        "bin"
        "code"
        ".lib"
        ".ssh"
    )

    for d in ${dotfiles_folders[@]}
    do
        dir="$HOME/${d}"
        mkdir -p "$dir"
    done

}

_dotfiles_link_item () {
    if [ "$#" -ne 2 ]; then
        echo "ERROR: ${FUNCNAME[0]} expected 2 arguments but received $#"
        return 1
    fi
    local src="$1"
    local dest="$2"

    # test arg 1 exists or skip
    if [ ! -e "$src" ] 
    then
        echo "WARNING: Missing source file, skipping: $src"
        return 0
    fi

    # test arg 2 is link - remove
    _if_link_exists_remove_it "$dest"

    # test arg 2 exists - append name .bak_Ymd_HMS
    _if_exists_move_but_backup_item "$dest"

    # link to local file
    ln -s "$src" "$dest"

}

_if_link_exists_remove_it () {
    if [ "$#" -ne 1 ]; then
        echo "ERROR: ${FUNCNAME[0]} expected 1 arguments but received $#"
        return 1
    fi
    [ -L "$1" ] && rm -v "$1"
}

_if_exists_move_but_backup_item () {
    if [ "$#" -ne 1 ]; then
        echo "ERROR: ${FUNCNAME[0]} expected 1 arguments but received $#"
        return 1
    fi

    local src="$1"
    local dest="${1}${bak_suffix:-.bak}"

    if [ -e "$src" ]; then
        mv "$src" "$dest"
        return $?
    fi
    return 0
}
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
    setup_vim="$VIMCONFIG_PATH/bin/setup-dotfiles-vim.sh"
    setup_emacs="$EMACSCONFIG_PATH/bin/setup-dotfiles-emacs.sh"
    [ -f "$setup_vim" ] && "$setup_vim" 
    [ -f "$setup_emacs" ] && "$setup_emacs" 

    dotfiles_zsh_install_or_update_ohmyzsh
    _dotfiles_ssh_key_github_hints
    dotfiles_post_setup_message
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

dotfiles_zsh_install_or_update_ohmyzsh () {
    local URL='https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools'
    URL+='/install.sh'
    local zshrc="$DOTFILES_PATH/zshrc"

    if [ ! -d ~/.oh-my-zsh ]
    then
        sh -c "$(curl -fsSL $URL)"
        local xc=$?

        printf '\nsource %s\n' "$zshrc"

        upgrade_oh_my_zsh
        git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
        ZSH_THEME="powerlevel9k/powerlevel9k"
        cd "$DOTFILES_PATH/config"
        git clone https://github.com/powerline/fonts.git
        cd -
        cd "$DOTFILES_PATH/config/fonts/"
        ./install.sh
        cd -
        _dotfiles_ohmyzsh_set_theme
        printf 'ZSH_DISABLE_COMPFIX=true\n\n%s' "$(cat ~/.zshrc)" > ~/.zshrc

        return $xc
    else
        cd ~/.oh-my-zsh
        git pull && cd -
        return $?
    fi
}

dotfiles_post_setup_message () {
    cat <<EOF

######################################################################
#          DOTFILES SETUP COMPLETE $(date)
######################################################################

Review the output above for any errors or warnings.

For zsh/powerline and themes:
    iTerm2 > Preferences > Profiles > Text > Change Font
    OR import the Default.json from:
    ~/dotfiles/local/iTerm/

You can also now run the following commands to set user defaults 
for $(whoami):
    source $DOTFILES_PATH/lib/$(uname).setup.lib.sh
    default_user_setup

######################################################################

EOF
}

_dotfiles_ohmyzsh_set_theme () {
    local theme="${1:-powerlevel9k}"
    local regex='s/^#?(ZSH_THEME=).*/\1\"'
    regex+="$theme\/$theme"
    regex+='\"/'
    sed -E -e $regex  -i .oldtheme.bak ~/.zshrc
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
        "lib/Linux.setup.lib.sh"
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
        cp -r "$DOTFILES_TEMPLATE_PATH" "$DOTFILES_PATH"
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

_dotfiles_ssh_key_github_hints () {
    cat <<EOF

######################################################################
# SSH KEY SETUP
######################################################################

# generate your key
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Open GitHub and sign in:
  open https://github.com/settings/keys

# use this to copy to clipboard for GitHub
  pbcopy < ~/.ssh/id_rsa.pub

# Start ssh-agent
  eval "\$(ssh-agent -s)"

# to add key to macOS KeyChain
  ssh-add -K ~/.ssh/id_rsa

# Update ~/.ssh/config

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa

######################################################################
######################################################################
EOF

}
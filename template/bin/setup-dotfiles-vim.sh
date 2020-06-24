#!/bin/bash

source "$DOTFILES_PATH/lib/dotfiles-utils.lib.sh"
vimconfig_pathfile="$HOME/.VAR_VIM_CONFIG_PATH"
VIM_CONFIG_PATH="$(cat $vimconfig_pathfile)"

# does this even matter?
#which nvim > /dev/null
#nvim_is_installed=$?

# check if setup done flag && exit
if [ -f "$VIM_CONFIG_PATH/setup_vim_complete.flag" ]
then
    echo "WARNING: Skipping ${BASH_SOURCE[0]} ... already ran"
    exit
fi


# setup vim
[ -d "$VIM_CONFIG_PATH/vim" ] || mkdir -p "$VIM_CONFIG_PATH/vim"
dotfiles_link_vim

# setup nvim
[ -d "$HOME/code/nvim" ] || mkdir -p "$HOME/code/nvim"
touch "$HOME/code/nvim/init.vim"

echo "$(date) INFO: COMPLETED ${BASH_SOURCE[0]}"
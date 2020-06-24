#!/usr/bin/env bash
set -e

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
code_pathfile="$HOME/.VAR_CODE_PATH"
dotfiles_pathfile="$HOME/.VAR_DOTFILES_PATH"

# This is a template showing ways to extend
# METHOD 1: overwrite/update specific variables or functions using files:
#   For Modules: ~/.dotfile_config_module
#   For local add-on configs: ~/.dotfile_config_local

# METHOD 2: change dotfiles_pathfile
#   This will just replace the pointer used by ~/.bashrc or ~/.zshrc
#   You could also re-link the rc files to replace them
#echo "$HOME/new/path/to/libraries" > "$code_pathfile"
#export DOTFILES_PATH="$(cat $dotfiles_pathfile)"
#source "$DOTFILES_PATH/bashrc"

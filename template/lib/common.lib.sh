# COMMON LIBRARY: platform and shell independent

##################################################
# VARIABLES
##################################################

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LSCOLORS=ExGxFxdxCxDxDxxbaDecac
export CLICOLOR_FORCE=1
export HISTSIZE=5000
export HISTFILESIZE=10000
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export TRASH_PATH="$HOME/.Trash/"

alias :w="echo this aint vim, dumbass"
alias ll="ls -Ghal"
alias l="ls -G"
alias h="history | less -R"
alias less="less -R"
# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
#alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
# Shortcuts
alias d="cd ~/Dropbox"
alias doc="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias E="Emacs"
alias g="git"

# Get week number
alias week='date +%V'

YmdHMSnum () { printf "%s" "$(date '+%Y%m%d%H%M%S')" ; }
YmdHMSpretty () { printf "%s" "$(date '+%Y-%m-%d_%H-%M-%S')" ; }
timestamp_line (){ printf '%s\n' "$(date +' ==> %Y-%m-%d %H:%M:%S ')$1"; }
header='######################################################################'
title_box () { line; echo $header; echo "## ${1}"; echo $header; line; }
title_TS_box () { local msg="$(timestamp_line ${1})"; title_box "${msg}"; }
line () { printf '\n\n' ''; }

swlist_node_globals () { npm list -g --depth 0; }

swlist_pip3 () { pip3 list; }

swlist_all_other_packages () {
    title_TS_box 'node modules'
    swlist_node_globals
    line

    title_TS_box 'pip3 modules'
    swlist_pip3
    line
}
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
##################################################
# OUTPUT FORMATTING
##################################################
bold=$(tput bold)
normal=$(tput sgr0)
boldstr () { printf "%s" "${bold}${1}${normal}" ; }

##################################################
# STORAGE
##################################################
dfh () {
    date
    df -H | grep "^\/\|F" | awk '{printf( "%-9s%-9s%-9s%-9s%-20s\n", $5, $2, $3, $4, $9)}'
}

dfhloop () { while true; do dfh ; sleep 120 ; done ; }

##################################################
# DATE/TIME STUFF
##################################################

utc () { date -u ; }

world_clock () {
    echo "$(boldstr 'AMS:') $(TZ=Europe/Amsterdam date)"
    echo "$(boldstr 'UTC:') $(TZ=Etc/UTC date)"
    echo "$(boldstr 'NYC:') $(TZ=America/New_York date)"
    echo "$(boldstr 'AUS:') $(TZ=America/Chicago date)"
    echo "$(boldstr 'LAX:') $(TZ=America/Los_Angeles date)"
    echo "$(boldstr 'HNL:') $(TZ=Pacific/Honolulu date)"
    echo "$(boldstr 'NRT:') $(TZ=Asia/Tokyo date)"
}

date_date_week_DOY () { date '+%F | %U | %j' ; }

ssh_agent_add () {
    cat <<EOF
REMINDER:
    eval "\$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa
EOF
}

##################################################
# MEDIA
##################################################

find_videos () {
    find . -type f | grep -E "\.webm$|\.flv$|\.vob$|\.ogg$|\.ogv$|\.drc$|\.gifv$|\.mng$|\.avi$|\.mov$|\.qt$|\.wmv$|\.yuv$|\.rm$|\.rmvb$|/.asf$|\.amv$|\.mp4$|\.m4v$|\.mp*$|\.m?v$|\.svi$|\.3gp$|\.flv$|\.f4v$"
}

##################################################
# FILES
##################################################

dotfiles_overwrite_local_from_template () {
    diff ~/dotfiles/{local,template}/lib
    diff ~/dotfiles/{local,template}/bin
    diff ~/dotfiles/{local,template}/system-setup
    confirm "OK to overwrite ~/dotfiles/local/{lib,bin,system-steup}?" || exit 0
    echo "Overwriting..."
    cp -vR ~/dotfiles/template/lib ~/dotfiles/local/
    cp -vR ~/dotfiles/template/bin ~/dotfiles/local/
    cp -vR ~/dotfiles/template/system-setup ~/dotfiles/local/
}

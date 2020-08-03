##############################################
# Add tab completion for many Bash commands
##############################################
if which brew &> /dev/null && \
        [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]
then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
fi

##############################################
# AUDIO
##############################################
vol_mute () { osascript -e 'set volume output muted true' ; }
vol_10 () { osascript -e 'set volume output volume 10' ; }
vol () { osascript -e "set volume output volume ${1:-30}" ; }
vol_100 () { osascript -e 'set volume output volume 100' ; }

##############################################
# SESSION
##############################################
# Lock the screen (when going AFK)
afk () {
    local cmd='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents'
    cmd+='/Resources/CGSession -suspend'
    $cmd
}



##############################################
# GUI APPS
##############################################
# show OS color picker
colors_picker () { open /Applications/Utilities/Digital\ Color\ Meter.app ; }

Emacs () {
    Emacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
    open -a "$Emacs" "$@"
}

Finder () { open -R . ; }

##############################################
# DOCUMENT UTILITES
##############################################
convert_doc_to_HTML () {
    #https://github.com/herrbischoff/awesome-macos-command-line
    # convert txt, rtf, docx to HTML

    [ ! -f "$1" ] && echo "Missing file $1" && return 1
    textutil -convert html $1
}

##############################################
# CLI APPS
##############################################

airport () {
    local cmd='/System/Library/PrivateFrameworks/Apple80211.framework/Versions'
    cmd+='/Current/Resources/airport'
    $cmd "$@"
}


caffdisplay () {
    printf "Started %s at %s\n" "${FUNCNAME[0]}" "$(date)"
    caffeinate -d &
}

##############################################
# FILES
##############################################
whatsnewhere () { echo "Run time: $(date)" && find . -mtime -${1:-1} ; }

backup_file () {
    local f=${1}; local fBak="${f}$(date +'.%Y%m%d%H%M%S.bak')"
    cp -pv ${f} ${fBak}
}

backup_file_sudo () {
    local f=${1}
    local fBak="${f}$(date +'.%Y%m%d%H%M%S.bak')"
    sudo cp -pv ${f} ${fBak}
}


##############################################
# DOWNLOADS
##############################################
downloads_view_history () {
    local querystr='select LSQuarantineDataURLString from LSQuarantineEvent'
    sqlite3 \
        ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* \
        $querystr
}

downloads_delete_history () {
    local querystr='delete from LSQuarantineEvent'
    sqlite3 \
        ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* \
        $querystr
}

##############################################
# HTTP HELPERS
##############################################
download_file () {
    local _f="${1:-index.html}"
    wget http://127.0.0.1:8080/$_f && mv "$_f".1 "$_f"
}

##############################################
# NETWORK
##############################################
dns_flush () { dscacheutil -flushcache && killall -HUP mDNSResponder ; }


##############################################
# SYSTEM UTILITIES
##############################################

swlist_all_software () {
    swlist_all_other_packages

    title_TS_box 'Registered macOS Software'
    system_profiler -detailLevel full SPApplicationsDataType | grep "^    [A-Za-z0-9]\|Location:\|Version:"
    line
}

spotlight_sudo_stop_indexing_dir () {
    if [ ! -d "$1" ]
    then
        echo "Missing path $1"
        return 1
    fi
    sudo mdutil -i off "$1"
}

spotlight_restart () { killall mds ; }

vnc () { open vnc://"$1" ; }

vmware_vmnet_clear () {
	mv -v /Library/Preferences/VMware\ Fusion/vmnet8/nat.conf \
		~/.Trash/nat.conf.$(date +%Y%m%d%H%M%S)
	mv -v /Library/Preferences/VMware\ Fusion/networking \
		~/.Trash/networking.$(date +%Y%m%d%H%M%S)
}

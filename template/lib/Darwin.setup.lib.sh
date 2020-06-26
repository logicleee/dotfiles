#!/bin/bash

# RESOURCES:
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# https://www.defaults-write.com/

default_system_setup () {
    _sys_tmutil_disable_local
    _sys_swupdate_check_daily
    _sys_login_and_fastuserswitching_enable
    _sys_afp_guest_disabled
    _sys_apps_unhide_utilities
    _sys_app_PDF_Join_py
}

default_server_setup_addons () {
    _sys_pmset_sleep_disabled
    _sys_autorestart_on_freeze
    _user_finder_show_hidden
}

default_user_setup () {
    _user_app_activity_monitor_tweaks
    _user_app_chrome_show_system_print_menu
    _user_app_mail_copy_address_only
    _user_app_safari_autofill_off
    _user_app_safari_bookmarksbar_show
    _user_app_safari_devmode
    _user_app_safari_homepage
    _user_app_safari_open_safe_downloads_disabled
    _user_app_safari_privacy_on
    _user_app_safari_upate_thumbnails_disabled
    _user_desktop_icons_disable
    _user_dock_icons_default_size
    _user_dock_show_lights
    _user_dock_tweaks
    _user_finder_recents_disabled
    _user_finder_DStore_net_off
    _user_finder_default_location
    _user_finder_desktop_icons
    _user_finder_fileextension_warning_disabled
    _user_finder_icons_media
    _user_finder_icons_net_remote
    _user_finder_list_view
    _user_finder_pathbar_show
    _user_finder_toobar_hide
    _user_finder_sidebar_hide
    _user_finder_seach_scope_current
    _user_finder_show_Library
    _user_finder_show_extensions
    _user_finder_showinfo_expand_most
    _user_finder_statusbar_show
    _user_keyboard_disable_smart_quotes
    _user_login_reopen_apps_disable
    _user_menubar_battery_percentage_on
    _user_menubar_icons
    _user_prefs_UI_dark_theme
    _user_prefs_ctrl_scroll_zoom_enabled
    _user_prefs_print_shows_expanded_panel
    _user_prefs_save_shows_expanded_panel
    _user_prefs_save_to_local_disk_preferred
    _user_prefs_security_req_password
    _user_screenshots
    _user_trackpad_three_finger_drag_enable

    # restart finder, etc.
    _user_restart_apps
    _user_python_virtualenv_install
}

# ===================================== #
# ==========  USER  SETTINGS  ========= #
# ===================================== #

_user_python_virtualenv_install () {
   pip3 install --user virtualenv PyYAML
}

_user_screenshots () {
    # Set screenshot save location
    mkdir ~/Desktop/Screenshots
    defaults write com.apple.screencapture location -string "~/Desktop/screenshots"
    defaults write com.apple.screencapture include-date -bool true
}


_user_login_reopen_apps_disable () {
    # Don't re-open apps on startup
    defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

    # Don't re-open apps when logging in
    defaults write com.apple.loginwindow TALLogoutSavesState -bool false
}

_user_dock_tweaks () {
    # Remove all dock icons
    defaults write com.apple.dock persistent-apps -array

    # Autohide
    defaults write com.apple.dock autohide -bool true

    # Hide unopen apps
    defaults write com.apple.dock static-only -bool true

    # No bounce
    defaults write com.apple.dock no-bouncing -bool true

    # show hidden as translucent
    defaults write com.apple.dock showhidden -bool true

    # Do not show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false


    # stacks
    defaults write com.apple.dock use-new-list-stack -bool YES
}

_user_dock_hide_forever () {
    ## ## # Essentially "disable" the dock
    defaults write com.apple.dock autohide-delay -float 1000
}

_user_dock_icons_default_size () {
   defaults write com.apple.dock tilesize -int 42
}

_user_keyboard_disable_smart_quotes () {
    # Disable smart quotes and smart dashes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable smart quotes in Message (Copy/Paste code!)
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
}

_user_keyboard_repeat_fast () {
    ## ## # Set a shorter Delay until key repeat
    defaults write NSGlobalDomain InitialKeyRepeat -int 12
}

_user_keyboard_repeat_fire () {
    ## ## # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 0
}

_user_trackpad_three_finger_drag_enable () {
    # three finger drag
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerSwipeGesture -int 1
}

_user_app_iterm_tweaks () {
    # Don’t display the annoying prompt when quitting iTerm
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false
}

_user_app_terminal_tweaks () {
    # Enable Secure Keyboard Entry in Terminal.app
    # See: https://security.stackexchange.com/a/47786/8918
    defaults write com.apple.terminal SecureKeyboardEntry -bool true

    # Disable the annoying line marks
    defaults write com.apple.Terminal ShowLineMarks -int 0

}

_user_app_safari_autofill_off () {
    # no Autofill
    defaults write com.apple.Safari AutoFillFromAddressBook -bool false
    defaults write com.apple.Safari AutoFillPasswords -bool false
    defaults write com.apple.Safari AutoFillCreditCardData -bool false
    defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
}

_user_app_safari_bookmarksbar_show () {
    # Show Safari's bookmark bar.
    defaults write com.apple.Safari ShowFavoritesBar -bool true
}

_user_app_safari_devmode () {
    # Set up Safari for development.
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true
    defaults write -g WebKitDeveloperExtras -bool true
}

_user_app_safari_privacy_on () {
    # Privacy: dont send search queries to Apple
    defaults write com.apple.Safari UniversalSearchEnabled -bool false
    defaults write com.apple.Safari SuppressSearchSuggestions -bool true
}

_user_app_safari_open_safe_downloads_disabled () {
    # Prevent Safari from opening safe files automatically after downloading
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
}

_user_app_safari_upate_thumbnails_disabled () {
    defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
}

_user_app_safari_homepage () {
    # Set Safari homepage to about:blank for faster loading
    defaults write com.apple.Safari HomePage -string "about:blank"
}


_user_app_activity_monitor_tweaks () {
    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5

    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0
}

_user_app_chrome_show_system_print_menu () {
   defaults write com.google.Chrome DisablePrintPreview -bool true
}

_user_app_mail_copy_address_only () {
    defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
}

_user_prefs_save_to_local_disk_preferred () {
   defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
}

_user_prefs_ctrl_scroll_zoom_enabled () {
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
    defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
}

_user_prefs_autocorrect_disable () {
   defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
}

_user_prefs_security_req_password () {
    # Require password 5 secs after sleep or screen saver.
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 5
}

_user_prefs_save_shows_expanded_panel () {
    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

}

_user_prefs_print_shows_expanded_panel () {
    # Expand save panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
}

_user_prefs_UI_dark_theme () {
    # Enable Dark theme for UI, Menu bar, and Spotlight
    defaults write NSGlobalDomain AppleInterfaceTheme -string 'Dark'
    defaults write NSGlobalDomain NSFullScreenDarkMenu -bool true
    defaults write com.apple.Spotlight AppleInterfaceStyle -string 'Dark'
}

_user_prefs_scrollbars_show () {
    defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
}

_user_menubar_icons () {
    defaults write com.apple.systemuiserver menuExtras -array            \
        "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"        \
        "/System/Library/CoreServices/Menu Extras/User.menu"             \
        "/System/Library/CoreServices/Menu Extras/Clock.menu"            \
        "/System/Library/CoreServices/Menu Extras/Battery.menu"          \
        "/System/Library/CoreServices/Menu Extras/AirPort.menu"          \
        "/System/Library/CoreServices/Menu Extras/Displays.menu"         \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"      \
        "/System/Library/CoreServices/Menu Extras/Volume.menu"
}

_user_menubar_battery_percentage_on () {
    # show battery percent
    defaults write com.apple.menuextra.battery ShowPercent YES
}

_user_menubar_darkmode_inverted () {
   defaults write -g NSRequiresAquaSystemAppearance -bool true
}

_user_desktop_icons_disable () {
    defaults write com.apple.finder CreateDesktop -bool false
}

_user_finder_recents_disabled () {
    defaults write -g NSNavRecentPlacesLimit -int 0
    defaults delete .GlobalPreferences NSNavRecentPlaces
}

_user_finder_fileextension_warning_disabled () {
   defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
}

_user_finder_showinfo_expand_most () {
   defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true                                   \
        OpenWith -bool true                                  \
        Preview -bool false                                  \
        Privileges -bool true

}

_user_finder_default_location () {
    # Set default Finder location to home folder (~/)
    defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
}

_user_single_application_mode_enabled () {
    defaults write com.apple.dock single-app -bool true
}

_user_single_application_mode_disabled () {
    defaults write com.apple.dock single-app -bool true
}

_user_finder_seach_scope_current () {
    # Use current directory as default search scope in Finder
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
}

_user_finder_pathbar_show () {
    defaults write com.apple.finder ShowPathbar -bool true
}

_user_finder_toobar_hide () {
    defaults write com.apple.finder ShowToolbar -bool false
}

_user_finder_sidebar_hide () {
    defaults write com.apple.finder ShowSidebar -bool false
}

_user_finder_statusbar_show () {
    defaults write com.apple.finder ShowStatusBar -bool true
}

_user_finder_DStore_net_off () {
    # Avoid creating .DS_Store files on network volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
}


_user_finder_show_Library () {
    # Show the ~/Library folder
    chflags nohidden ~/Library
}

_user_finder_show_abs_Path () {
    # Show absolute path in finder's title bar.
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
}

_user_finder_column_view () {
    #defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'
    #defaults write com.apple.finder FXPreferredSearchViewStyle -string 'Nlsv'
    defaults write com.apple.Finder FXPreferredViewStyle clmv
    defaults write com.apple.finder FXPreferredSearchViewStyle clmv
    defaults write com.apple.Finder FXPreferredViewStyle clmv
}

_user_finder_list_view () {
    defaults write com.apple.Finder FXPreferredViewStyle Nlsv
    defaults write com.apple.finder FXPreferredSearchViewStyle Nlsv
    defaults write com.apple.Finder FXPreferredViewStyle Nlsv
}

_user_finder_coverflow_view () {
    defaults write com.apple.Finder FXPreferredViewStyle Flwv
    defaults write com.apple.finder FXPreferredSearchViewStyle Flwv
    defaults write com.apple.Finder FXPreferredViewStyle Flwv
}

_user_finder_icon_view () {
    defaults write com.apple.Finder FXPreferredViewStyle icnv
    defaults write com.apple.finder FXPreferredSearchViewStyle icnv
    defaults write com.apple.Finder FXPreferredViewStyle icnv
}


_user_finder_icons_net_remote () {
    # Custom icons for remote volumes
    defaults write com.apple.finder ShowCustomIconsForRemoteVolumes -bool true
}

_user_finder_icons_media () {
    # Custom icons for removable volumes
    defaults write com.apple.finder ShowCustomIconsForRemovableVolumes -bool true
}

_user_finder_desktop_icons () {
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
}


_user_finder_show_hidden () {
    defaults write com.apple.finder AppleShowAllFiles -bool true
}

_user_finder_show_extensions () {
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
}
_user_dock_show_lights () {
    defaults write com.apple.dock show-process-indicators -bool true
}

_user_dock_add_spacers () {
    # Add several spacers
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
    defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
}

_user_restart_apps () {
    find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
    for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Messages" "Safari" "SystemUIServer"; do
    killall "${app}" > /dev/null 2>&1
    done
}

# ===================================== #
# ========== SYSTEM SETTINGS ========== #
# ===================================== #

_sys_pmset_sleep_disabled () {
     sudo pmset -a sleep 0
}

_sys_pmset_lidwake_disabled () {
    # Enable lid wakeup
    sudo pmset -a lidwake 0
}

_sys_autorestart_on_freeze () {
     systemsetup -setrestartfreeze on
}

_sys_remove_system_sleep_image () {
    # Remove the sleep image file to save disk space
    sudo rm /private/var/vm/sleepimage
    # Create a zero-byte file instead…
    sudo touch /private/var/vm/sleepimage
    # …and make sure it can’t be rewritten
    sudo chflags uchg /private/var/vm/sleepimage
}

_sys_disable_sudden_motion_sensor () {
   # Disable the sudden motion sensor as it’s not useful for SSDs
    sudo pmset -a sms 0
}

_sys_tmutil_disable_local () {
    # Disable local time machine backups
    #sudo tmutil disablelocal
    echo '`disablelocal` verb no longer exists: `sudo tmutil disablelocal`'
    return 0
}

_sys_swupdate_check_daily () {
    # Enable the automatic update check
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

    # Check for software updates daily, not just once per week
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1
}

_sys_login_and_fastuserswitching_enable () {
    # Disable automatic login
    sudo defaults write /Library/Preferences/com.apple.loginwindow com.apple.login.mcx.DisableAutoLoginClient -bool true

    # Set the login window to name and password
    sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

    # Enable Fast User Switching option
    sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool 'YES'
}

_sys_afp_guest_disabled () {
    # Disable guest connect to AFP shares
    sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
}

_sys_apps_unhide_utilities () {
    ################################################################################
    # Unhide Utilities
    ################################################################################

    # Archive Utility
    sudo ln -s "/System/Library/CoreServices/Applications/Archive Utility.app" "/Applications/Utilities/Archive Utility.app"

    # Directory Utility
    sudo ln -s "/System/Library/CoreServices/Applications/Directory Utility.app" "/Applications/Utilities/Directory Utility.app"

    # Screen Sharing
    sudo ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"

    # Ticket Viewer
    sudo ln -s "/System/Library/CoreServices/Ticket Viewer.app" "/Applications/Utilities/Ticket Viewer.app"

    # Network Diagnostics
    sudo ln -s "/System/Library/CoreServices/Network Diagnostics.app" "/Applications/Utilities/Network Diagnostics.app"

    # Network Utility
    sudo ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"

    # Wireless Diagnostics
    sudo ln -s "/System/Library/CoreServices/Applications/Wireless Diagnostics.app" "/Applications/Utilities/Wireless Diagnostics.app"

    # Feedback Assistant
    sudo ln -s "/System/Library/CoreServices/Applications/Feedback Assistant.app" "/Applications/Utilities/Feedback Assistant.app"

    # RAID Utility
    sudo ln -s "/System/Library/CoreServices/Applications/RAID Utility.app" "/Applications/Utilities/RAID Utility.app"

    # System Image Utilitys
    sudo ln -s "/System/Library/CoreServices/Applications/System Image Utility.app" "/Applications/Utilities/System Image Utility.app"

    # iOS Simulator
    sudo ln -s "/Applications/Xcode.app/Contents/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"
}

_sys_app_PDF_join_py () {
    # PDF Join utility
    # http://gotofritz.net/blog/howto/joining-pdf-files-in-os-x-from-the-command-line/
    # PDF_join.py -o PATH/TO/YOUR/MERGED/FILE.pdf /PATH/TO/ORIGINAL/1.pdf /PATH/TO/ANOTHER/2.pdf /PATH/TO/A/WHOLE/DIR/*.pdf
    # You can even pass a 'shuffle' argument to make the script take one page per document in turn instead:
    # PDF_join.py -s -o PATH/TO/YOUR/MERGED/FILE.pdf  /PATH/TO/DIR/*.pdf
    sudo ln -s "/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" "/Applications/PDF_join.py"
}

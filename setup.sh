#!/bin/bash
set -o nounset
cd ~ || { echo "Could not go to home"; exit 1; }
sudo -v # Ask for the administrator password upfront



if [[ $(uname) = 'Linux' ]]; then
  if [[ -n $GITPOD_WORKSPACE_ID ]] || [[ -n $CODESPACES  ]]; then
    echo "Running in an unsupported env (not Gitpod or Codespaces), exiting..."
    exit 1
  fi
fi

if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew update
brew upgrade



if [[ $(uname) = 'Darwin' ]]; then
  
  # Use TouchID for sudo
  curl -sL https://gist.githubusercontent.com/RichardBronosky/31660eb4b0f0ba5e673b9bc3c9148a70/raw/touchid_sudo.sh | bash

  # Force brew install paths to be global
  #  see https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md#options
  export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

  brew tap homebrew/cask-versions
  brew tap homebrew/cask-fonts
  brew tap homebrew/cask-drivers

  # Install stuff from AppStore
  sudo softwareupdate --install --all
  brew install mas
  mas signin --dialog $MY_APPLE_ID_EMAIL
  mas upgrade
  mas install 409203825  # Numbers
  mas install 409201541  # Pages
  mas install 409183694  # Keynote
  mas install 497799835  # Xcode
  mas install 462062816  # Microsoft PowerPoint
  mas install 1295203466 # Microsoft Remote Desktop
  mas install 462058435  # Microsoft Excel
  mas install 462054704  # Microsoft Word
  mas install 904280696  # Things3
  mas install 1272768911 # Keep It
  mas install 1142051783 # LG Screen Manager
  mas install 425424353  # Unarchiver
  mas install 1320666476 # Safari Extension: Wipr
  mas install 1462114288 # Safari Extension: Grammarly
  mas install 1459809092 # Safari Extension: Accelerate
  mas install 1473726602 # Safari Extension: Tab Space

  xcode-select --install
  while :
  do
    xcode-select -p >/dev/null 2>&1
    if [ $? == 0 ]; then
      echo "Sccessfully ran xcode-select --install"
      sleep 60
      break
    fi

    sleep 30
  done
fi



brew install coreutils git hub gh tree curl wget pre-commit
brew install zsh zsh-completions zsh-history-substring-search zsh-syntax-highlighting terminal-notifier
chsh -s /usr/local/bin/zsh
brew install htop watch nano unzip p7zip
brew install jq bat

brew install python3 pipenv golang node yarn rbenv php
npm update -g

brew install awscli aws-shell awslogs aws-cdk
npm install -g awsp

brew install tfenv tflint graphviz terraform-docs liamg/tfsec/tfsec cdktf
tfenv install latest
tfenv use latest

brew install serverless aws/tap/aws-sam-cli

brew install kubectl kubectx kubernetes-helm kube-ps1 aws-iam-authenticator octant dive
brew install johanhaleby/kubetail/kubetail stern


if [[ $(uname) = 'Darwin' ]]; then
  brew install --cask font-anonymous-pro font-humor-sans font-gilbert font-recursive

  brew install --cask dotnet-sdk
  brew install --cask docker

  brew install --cask iterm2 alfred lunar swish grammarly ngrok

  brew install --cask 1password
  brew install --cask flux
  brew install --cask slack zulip zoom amazon-chime whatsapp
  brew install --cask firefox-developer-edition safari-technology-preview
  brew install --cask notion
  brew install --cask omnigraffle

  brew install mpv
  brew install --cask iina
  brew install ranger exiftool ffmpeg media-info
  brew install youtube-dl subliminal

  brew install --cask transmission
  mkdir ~/Downloads/Torrents
  # Transmission: Automatically size window to fit all transfers
  defaults write org.m0k.transmission AutoSize -bool true
  # Transmission: Download and Upload Badges
  defaults write org.m0k.transmission BadgeDownloadRate -bool false
  defaults write org.m0k.transmission BadgeUploadRate   -bool false
  # Transmission: Prompt user for removal of active transfers only when downloading
  defaults write org.m0k.transmission CheckRemoveDownloading -bool true
  # Transmission: Never prompt for quit
  defaults write org.m0k.transmission CheckQuitDownloading -bool false
  defaults write org.m0k.transmission CheckQuit -bool false
  # Transmission: Default download location
  defaults write org.m0k.transmission DownloadLocationConstant -bool true
  defaults write org.m0k.transmission DownloadChoice -string "Constant"
  defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/Torrents"
  # Transmission: Set incomplete downloads location
  defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool false
  defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Torrents"
  # Transmission: Don’t prompt for confirmation before downloading
  defaults write org.m0k.transmission DownloadAsk -bool false
  defaults write org.m0k.transmission MagnetOpenAsk -bool false
  # Transmission: Trash original torrent files
  defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
  # Transmission: Display window when opening a torrent file
  defaults write org.m0k.transmission DownloadAskMulti -bool true
  defaults write org.m0k.transmission DownloadAskManual -bool true
  # Transmission: Automatic Import
  defaults write org.m0k.transmission AutoImport -bool true
  defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"
  # Transmission: Use specific port on launch
  defaults write org.m0k.transmission RandomPort -bool false
  defaults write org.m0k.transmission PeerPort 59137
  # Transmission: do not limit download speed
  defaults write org.m0k.transmission SpeedLimit -bool false
  # Transmission: No donate message
  defaults write org.m0k.transmission WarningDonate -bool false
  # Transmission: No legal disclaimer
  defaults write org.m0k.transmission WarningLegal -bool false
  # Transmission: Status bar
  defaults write org.m0k.transmission StatusBar -bool true
  # Transmission: Small view
  defaults write org.m0k.transmission SmallView -bool true
  # Transmission: Pieces bar
  defaults write org.m0k.transmission PiecesBar -bool false
  # Transmission: Pieces bar
  defaults write org.m0k.transmission FilterBar -bool true
  # Transmission: Availability
  defaults write org.m0k.transmission DisplayProgressBarAvailable -bool false

  brew install --cask visual-studio-code
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  code --install-extension alefragnani.project-manager
  code --install-extension amazonwebservices.aws-toolkit-vscode
  code --install-extension anotherglitchinthematrix.monochrome
  code --install-extension bungcip.better-toml
  code --install-extension fcrespo82.markdown-table-formatter
  code --install-extension fernandoescolar.vscode-solution-explorer
  code --install-extension golang.go
  code --install-extension hashicorp.terraform
  code --install-extension JamesBirtles.svelte-vscode
  code --install-extension lextudio.restructuredtext
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension ms-dotnettools.csharp
  code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
  code --install-extension ms-python.python
  code --install-extension rebornix.ruby
  code --install-extension redhat.vscode-commons
  code --install-extension redhat.vscode-yaml
  code --install-extension RobbOwen.synthwave-vscode
  code --install-extension shardulm94.trailing-spaces
  code --install-extension stevensona.character-count
  code --install-extension streetsidesoftware.code-spell-checker
  code --install-extension technosophos.vscode-helm
  code --install-extension tomphilbin.gruvbox-themes
  code --install-extension VisualStudioExptTeam.vscodeintellicode
  code --install-extension wayou.vscode-todo-highlight
  code --install-extension wingrunr21.vscode-ruby

  brew install elgato-control-center
  brew install audient-evo
  brew install --cask krisp
  brew install logitech-camera-settings

  mkdir ~/.ssh
  mkdir ~/.config

  osascript -e 'tell application "System Preferences" to quit'

  # Restore all settings and configs with mackup
  #  NOTE: I am unhappy with mackup backups
  #         so I moved back to defaults
  #         but still keeping it for a couple programs
  #         will be run manually
  # brew install mackup
  # mackup restore



  # Screenshots: save screenshots to specific folder
  mkdir ~/Screenshots
  defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
  # Screenshots: save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"
  # Screenshots: disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true

  # AppStore: Check for software updates daily, not just once per week
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
  defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
  # AppStore:Download newly available updates in background
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
  # AppStore: Install System data files & security updates
  defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
  # AppStore: Automatically download apps purchased on other Macs
  defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
  # AppStore: Turn on app auto-update
  defaults write com.apple.commerce AutoUpdate -bool true
  # AppStore: Allow the App Store to reboot machine on macOS updates
  defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

  # Notifications: banner on screen time for 2 seconds instead of default 5
  defaults write com.apple.notificationcenterui bannerTime 2

  # Mail: Disable send and reply animations
  defaults write com.apple.mail DisableReplyAnimations -bool true
  defaults write com.apple.mail DisableSendAnimations -bool true
  # Mail: Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
  # Mail: Disable inline attachments (just show the icons)
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
  # Mail: View conversations - Show most recent messages at the top
  defaults write com.apple.mail ConversationViewSortDescending -bool true
  # Mail: Show To/Cc label in message list
  defaults write com.apple.mail EnableToCcInMessageList -bool true

  # Activity Monitor: Show the main window when launching
  defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
  # Activity Monitor: Show All Processes
  # 100: All Processes
  # 101: All Processes, Hierarchally
  # 102: My Processes
  # 103: System Processes
  # 104: Other User Processes
  # 105: Active Processes
  # 106: Inactive Processes
  # 106: Inactive Processes
  # 107: Windowed Processes
  defaults write com.apple.ActivityMonitor ShowCategory -int 100
  # Activity Monitor: Sort results by CPU usage
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
  defaults write com.apple.ActivityMonitor SortDirection -int 0
  # Activity Monitor: Show Data in the Disk graph (instead of IO)
  defaults write com.apple.ActivityMonitor DiskGraphType -int 1
  # Activity Monitor: Show Data in the Network graph (instead of packets)
  defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

  # Graphics: Increase window resize speed for Cocoa applications
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
  # Graphics: Disabled window resize animation.
  defaults write -g NSWindowResizeTime -float 0.003

  # Finder: Disable window animations and Get Info animations.
  defaults write com.apple.finder DisableAllAnimations -bool true
  # Finder: Icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop     -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool true
  # Finder: Visibility of hidden files
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # Finder: Filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # Finder: Status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Finder: Path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # Finder: Full POSIX path as window title
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool false
  # Finder: File extension change warning
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true
  # Finder: Arrange by: Kind, Name, Application, Date Last Opened, Date Added, Date Modified, Date Created, Size, Tags, None
  defaults write com.apple.finder FXPreferredGroupBy -string "Date Modified"
  # Finder: Writing of .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  # Finder: Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool false
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false
  defaults write com.apple.finder OpenWindowForNewRemovableDisk    -bool false
  # Finder: Preferred view style
  #          Icon View   : `icnv`
  #          List View   : `Nlsv`
  #          Column View : `clmv`
  #          Cover Flow  : `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
  # Finder: Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true
  # Finder: View Options
  #          ColumnShowIcons    : Show preview column
  #          ShowPreview        : Show icons
  #          ShowIconThumbnails : Show icon preview
  #          ArrangeBy          : Sort by
  #            dnam : Name
  #            kipl : Kind
  #            ludt : Date Last Opened
  #            pAdd : Date Added
  #            modd : Date Modified
  #            ascd : Date Created
  #            logs : Size
  #            labl : Tags
  /usr/libexec/PlistBuddy \
      -c "Set :StandardViewOptions:ColumnViewOptions:ColumnShowIcons bool    false" \
      -c "Set :StandardViewOptions:ColumnViewOptions:FontSize        integer 11"    \
      -c "Set :StandardViewOptions:ColumnViewOptions:ShowPreview     bool    true"  \
      -c "Set :StandardViewOptions:ColumnViewOptions:ArrangeBy       string  modd"  \
      ~/Library/Preferences/com.apple.finder.plist



  # Safari: don't send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.SafariTechnologyPreview UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true
  defaults write com.apple.SafariTechnologyPreview SuppressSearchSuggestions -bool true
  defaults write com.apple.Safari WebsiteSpecificSearchEnabled -bool true
  defaults write com.apple.SafariTechnologyPreview WebsiteSpecificSearchEnabled -bool true
  # Safari: Start with all windows from last session
  defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true
  defaults write com.apple.SafariTechnologyPreview AlwaysRestoreSessionAtLaunch -bool true
  # Safari: Set home page
  defaults write com.apple.Safari HomePage -string "https://start.vladionescu.me"
  defaults write com.apple.SafariTechnologyPreview HomePage -string "https://start.vladionescu.me"
  # Safari: Setup new window and tab behvior
  #          0: Homepage
  #          1: Empty Page
  #          2: Same Page
  #          3: Bookmarks
  #          4: Top Sites
  defaults write com.apple.Safari NewTabBehavior -int 0
  defaults write com.apple.SafariTechnologyPreview NewTabBehavior -int 0
  defaults write com.apple.Safari NewWindowBehavior -int 0
  defaults write com.apple.SafariTechnologyPreview NewWindowBehavior -int 0
  # Safari: Save downloded files to
  defaults write com.apple.Safari DownloadsPath -string '~/Downloads'
  defaults write com.apple.SafariTechnologyPreview DownloadsPath -string '~/Downloads'
  # Safari: Remove downloads list items
  #          0: Manually
  #          1: When Safari Quits
  #          2: Upon Successful Download
  defaults write com.apple.Safari DownloadsClearingPolicy -int 2
  defaults write com.apple.SafariTechnologyPreview DownloadsClearingPolicy -int 2
  # Safari: open "safe" files automatically after downloading
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool true
  defaults write com.apple.SafariTechnologyPreview AutoOpenSafeDownloads -bool true
  # Safari: Set AutoFill
  defaults write com.apple.Safari AutoFillFromAddressBook -bool false
  defaults write com.apple.Safari AutoFillPasswords -bool false
  defaults write com.apple.Safari AutoFillCreditCardData -bool false
  defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
  defaults write com.apple.SafariTechnologyPreview AutoFillFromAddressBook -bool false
  defaults write com.apple.SafariTechnologyPreview AutoFillPasswords -bool false
  defaults write com.apple.SafariTechnologyPreview AutoFillCreditCardData -bool false
  defaults write com.apple.SafariTechnologyPreview AutoFillMiscellaneousForms -bool false
  # Safari: Website use of location services:
  #          0: Deny without prompting
  #          1: Prompt for each website once each day
  #          2: Prompt for each website one time only
  defaults write com.apple.Safari SafariGeolocationPermissionPolicy -int 1
  defaults write com.apple.SafariTechnologyPreview SafariGeolocationPermissionPolicy -int 1
  # Safari: Ask websites not to track me
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
  defaults write com.apple.SafariTechnologyPreview SendDoNotTrackHTTPHeader -bool true
  # Safari: Save article for offline reading automatically
  defaults write com.apple.Safari ReadingListSaveArticlesOfflineAutomatically -bool true
  # Safari: Search with Contains instead of Starts With
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
  defaults write com.apple.SafariTechnologyPreview FindOnPageMatchesWordStartsOnly -bool false
  # Safari: Show some bars
  defaults write com.apple.Safari AlwaysShowTabBar -bool false
  defaults write com.apple.SafariTechnologyPreview AlwaysShowTabBar -bool false
  defaults write com.apple.Safari ShowStatusBar -bool true
  defaults write com.apple.SafariTechnologyPreview ShowStatusBar -bool true
  defaults write com.apple.Safari ShowFavoritesBar -bool false
  defaults write com.apple.SafariTechnologyPreview ShowFavoritesBar -bool false
  # Safari: Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
  defaults write com.apple.SafariTechnologyPreview IncludeInternalDebugMenu -bool true
  # Safari: Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
  # Safari: Enabling the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.SafariTechnologyPreview IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.SafariTechnologyPreview WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
  defaults write com.apple.SafariTechnologyPreview "com.apple.SafariTechnologyPreview.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
  # Safari: Command-clicking a link creates tabs
  defaults write com.apple.Safari CommandClickMakesTabs -bool true
  defaults write com.apple.SafariTechnologyPreview CommandClickMakesTabs -bool true
  # Safari: Update extensions automatically
  defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
  defaults write com.apple.SafariTechnologyPreview InstallExtensionUpdatesAutomatically -bool true
  # Safari: Don't even ask about the push notifications
  defaults write com.apple.Safari CanPromptForPushNotifications -bool false
  defaults write com.apple.SafariTechnologyPreview CanPromptForPushNotifications -bool false

  # System Preferences, Users & Groups: Display login window as: Name and password
  sudo defaults write /Library/Preferences/com.apple.loginwindow "SHOWFULLNAME" -bool true
  # System Preferences, Users & Groups: Disable automatic login
  sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser 2>/dev/null
  # System Preferences, Users & Groups: Allow guests to login to this computer
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
  # System Preferences, Users & Groups: Show password hints after count (0 to disable)
  defaults write NSGlobalDomain RetriesUntilHint -int 0

  # System Preferences, Trackpad
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
  defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -int 0
  defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1
  defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0
  defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 2
  defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 2
  defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.875
  defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
  defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0
  defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

  # System Preferences, Sound: Play user interface sound effects
  defaults write com.apple.systemsound com.apple.sound.uiaudio.enabled -bool true
  # System Preferences, Sound: Play feedback when volume is changed
  defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool false

  # System Preferences, Siri:
  defaults write com.apple.assistant.support "Assistant Enabled" -bool true
  defaults write com.apple.assistant.backedup "Session Language" -string "en-GB"
  defaults write com.apple.Siri HotkeyTag -int 0
  defaults write com.apple.Siri StatusMenuVisible -bool true

  # System Preferences, Security & Privacy: Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -bool true
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  # System Preferences, Security & Privacy: Turn on Firewall
  sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
  # System Preferences, Security & Privacy: Allow signed apps
  sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool true
  # System Preferences, Security & Privacy: Firewall logging
  sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool false
  # System Preferences, Security & Privacy: Stealth mode
  sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool false
  # System Preferences, Security & Privacy: Disable Infared Remote
  sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false
  # System Preferences, Security & Privacy: Enable FileVault (if not already enabled)
  if [[ $(sudo fdesetup status | head -1) == "FileVault is Off." ]]; then
    sudo fdesetup enable -user `whoami`
  fi

  # System Preferences, Printers & Scanners: Expand save and print panels by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
  # System Preferences, Printers & Scanners: Automatically quit printer app once the print jobs complete
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # System Preferences,Keyboard: Use smart quotes
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  # System Preferences, Keyboard: Use smart dashes
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true
  # System Preferences, Keyboard: Enable full access for all controls e.g. enable Tab in modal dialogs
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
  # System Preferences, Keyboard: Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 3
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  # System Preferences, Keyboard: Adjust keyboard brightness in low light
  defaults write com.apple.BezelServices kDim -bool false
  sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool false
  # System Preferences, Keyboard: Dim keyboard after idle time (in seconds)
  defaults write com.apple.BezelServices kDimTime -int 300
  sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Keyboard Dim Time" -int 300

  # System Preferences, Mission Control: animation duration
  defaults write com.apple.dock expose-animation-duration -float 0.1
  # System Preferences, Mission Control: Automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false
  # System Preferences, Mission Control: When switching to an application, switch to a Space with open windows for the application
  defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true
  # System Preferences, Mission Control: Group windows by application in Mission Control
  defaults write com.apple.dock expose-group-by-app -bool false
  # System Preferences, Mission Control: Displays have seperate Spaces
  defaults write com.apple.spaces spans-displays -bool true
  # System Preferences, Mission Control: Hot corners
  #                                       Possible values:
  #                                         0: no-op
  #                                         2: Mission Control
  #                                         3: Show application windows
  #                                         4: Desktop
  #                                         5: Start screen saver
  #                                         6: Disable screen saver
  #                                         7: Dashboard
  #                                         10: Put display to sleep
  #                                         11: Launchpad
  #                                         12: Notification Center
  # System Preferences, Mission Control: Top left screen corner → Nothing
  defaults write com.apple.dock wvous-tl-corner -int 0
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # System Preferences, Mission Control: Top right screen corner → Nothing
  defaults write com.apple.dock wvous-tr-corner -int 0
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # System Preferences, Mission Control: Bottom left screen corner → Nothing
  defaults write com.apple.dock wvous-bl-corner -int 0
  defaults write com.apple.dock wvous-bl-modifier -int 0

  # System Preferences, Dock: show indicator lights for open application
  defaults write com.apple.dock show-process-indicators -bool true
  # System Preferences, Dock: speed up Mission Control animations
  defaults write com.apple.dock expose-animation-duration -float 0.1
  # System Preferences, Dock: automatically hide and show
  defaults write com.apple.dock autohide -bool true
  # System Preferences, Dock: Icon size of magnified Dock items
  defaults write com.apple.dock largesize -int 128
  # System Preferences, Dock: Dock orientation: 'left', 'bottom', 'right'
  System Preferences, Dock: defaults write com.apple.dock 'orientation' -string 'left'
  # System Preferences, Dock: Double-click a window's title bar to:
  # System Preferences, Dock: None
  # System Preferences, Dock: Mimimize
  # System Preferences, Dock: Maximize (zoom)
  defaults write NSGlobalDomain AppleActionOnDoubleClick -string "None"
  # System Preferences, Dock: Animate opening applications
  defaults write com.apple.dock launchanim -bool false
  # System Preferences, Dock: Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true
  # System Preferences, Dock: Auto-hide delay
  defaults write com.apple.dock autohide-delay -float 0
  # System Preferences, Dock: Auto-hide animation duration
  System Preferences, Dock: defaults write com.apple.dock autohide-time-modifier -float 0.1
  # System Preferences, Dock: Show indicators for open applications
  defaults write com.apple.dock show-process-indicators -bool true
  # System Preferences, Dock: Show recent applications in Dock
  defaults write com.apple.dock show-recents -bool false
  # System Preferences, Dock: Remove all (default) app icons from the Dock
  defaults write com.apple.dock persistent-apps -array

  # System Preferences, Language & Region
  defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
  defaults write NSGlobalDomain AppleMetricUnits -bool true
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"

  #  System Preferences, iCloud: Save to iCloud by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool true

  # System Preferences, Displays: Automatically adjust brightness
  defaults write com.apple.BezelServices dAuto -bool false
  sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false

  # System Preferences, Date & Time: Menu bar clock format
  #                                   "h:mm" Default
  #                                   "HH"   Use a 24-hour clock
  #                                   "a"    Show AM/PM
  #                                   "ss"   Display the time with seconds
  defaults write com.apple.menuextra.clock DateFormat -string "HH:mm:ss"
  # System Preferences, Date & Time: Flash the time separators
  defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
  # System Preferences, Date & Time: Analog menu bar clock
  defaults write com.apple.menuextra.clock IsAnalog -bool false

  # System Preferences, General
  defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -int 1
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
  # System Preferences, General: Allow Handoff between this Mac and your iCloud devices
  defaults write ~/Library/Preferences/ByHost/com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool true
  defaults write ~/Library/Preferences/ByHost/com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool true

  # TODO, manually:
  #  - install VPN profile & set Network order
  #  - install Ecamm Live: https://www.ecamm.com/mac/ecammlive/
  #  - install custom fonts from iCloud Drive
  #  - install custom apps from NAS

fi

brew cleanup

git config --global user.email "Vlaaaaaaad@users.noreply.github.com"
git config --global user.name  "Vlad Ionescu"

mkdir ~/Developer
mkdir ~/Developer/demos
mkdir ~/Developer/GitHub
mkdir ~/Developer/vlaaaaaaad
mkdir ~/Developer/Castravete

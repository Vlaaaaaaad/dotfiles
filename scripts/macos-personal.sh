#!/bin/bash

if [[ $(uname) != 'Darwin' ]]; then
  echo "Trying to run a macOS-only script on another OS. Exiting ..."
  exit 1
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

brew install --cask philips-hue-sync

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

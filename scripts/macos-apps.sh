#!/bin/bash

if [[ $(uname) != 'Darwin' ]]; then
  echo "Trying to run a macOS-only script on another OS. Exiting..."
  exit 1
fi

sudo -v # Ask for the administrator password upfront

if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew update
brew upgrade

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
read -rp "AppleID email? " mail
mas signin --dialog $mail
mas upgrade
mas install 409203825  # Numbers
mas install 409201541  # Pages
mas install 409183694  # Keynote
mas install 497799835  # Xcode
mas install 462062816  # Microsoft PowerPoint
mas install 462058435  # Microsoft Excel
mas install 462054704  # Microsoft Word
mas install 904280696  # Things3
mas install 1272768911 # Keep It
mas install 1482527526 # Lire
mas install 1142051783 # LG Screen Manager
mas install 425424353  # Unarchiver
mas install 483124549  # Let It Snow
mas install 1320666476 # Safari Extension: Wipr
mas install 1459809092 # Safari Extension: Accelerate
mas install 1397180934 # Safari Extension: Dark Mode
mas install 1569813296 # Safari Extension: 1Password
mas install 1472715727 # Safari Extension: Page Screenshot

brew install zsh zsh-completions zsh-history-substring-search zsh-syntax-highlighting terminal-notifier
chsh -s /usr/local/bin/zsh
brew install curl wget nano

brew install --cask font-anonymous-pro font-humor-sans font-gilbert font-recursive font-ibm-plex

brew install --cask arq cyberduck kaleidoscope
brew install --cask alfred lunar swish tailscale 1password
# brew install --cask nova bbedit
brew install --cask sublime-text
brew install --cask firefox-developer-edition safari-technology-preview google-chrome polypane
brew install --cask omnigraffle

brew install --cask slack zoom amazon-chime whatsapp discord
# brew install --cask audio-hijack
# brew install --cask tg-pro
brew install --cask audient-evo elgato-control-center logitech-camera-settings
# brew install --cask ecamm-live

brew install --cask movist-pro
brew install --cask freetube
brew install exiftool media-info unzip p7zip coreutils
brew install yt-dlp

brew cleanup

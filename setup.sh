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
  mas install 408981434  # iMovie
  mas install 462062816  # Microsoft PowerPoint
  mas install 1295203466 # Microsoft Remote Desktop
  mas install 462058435  # Microsoft Excel
  mas install 462054704  # Microsoft Word
  mas install 904280696  # Things3
  mas install 1142051783 # LG Screen Manager
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

brew install python3 pipenv golang node yarn rbenv
npm update -g

brew install awscli aws-shell awslogs aws-cdk
npm install -g awsp

brew install tfenv tflint graphviz terraform-docs liamg/tfsec/tfsec
tfenv install latest
tfenv use latest

brew install serverless aws/tap/aws-sam-cli

brew install kubectl kubectx kubernetes-helm kube-ps1 aws-iam-authenticator octant dive
brew install johanhaleby/kubetail/kubetail stern


if [[ $(uname) = 'Darwin' ]]; then
  brew install --cask font-anonymous-pro font-humor-sans font-gilbert

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
  defaults write org.m0k.transmission DownloadAsk -bool false
  defaults write org.m0k.transmission MagnetOpenAsk -bool false
  defaults write org.m0k.transmission CheckQuit -bool false
  defaults write org.m0k.transmission CheckRemove -bool false
  defaults write org.m0k.transmission AutoImport -bool true
  defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"
  defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
  defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool false
  defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Torrents"
  defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/Torrents"
  defaults write org.m0k.transmission SpeedLimit -bool false
  defaults write org.m0k.transmission RandomPort -bool false
  defaults write org.m0k.transmission PeerPort 59137
  defaults write org.m0k.transmission WarningDonate -bool false
  defaults write org.m0k.transmission WarningLegal -bool false

  brew install --cask visual-studio-code
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  code --install-extension alefragnani.project-manager
  code --install-extension amazonwebservices.aws-toolkit-vscode
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
  #  TODO: unhappy with mackup backups
  brew install mackup
  mackup restore


  # TODO, manually:
  #  - install Ecamm Live: https://www.ecamm.com/mac/ecammlive/
  #  - install custom fonts from iCloud Drive


fi

brew cleanup

git config --global user.email "Vlaaaaaaad@users.noreply.github.com"
git config --global user.name  "Vlad Ionescu"

mkdir ~/Repos
mkdir ~/Repos/demos
mkdir ~/Repos/GitHub
mkdir ~/Repos/vlaaaaaaad
mkdir ~/Repos/Castravete

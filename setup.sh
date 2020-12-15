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
  # TODO: delete this when moving to Apple Silicon?
  export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

  brew tap homebrew/cask-versions
  brew tap homebrew/cask-fonts

  # Install stuff from AppStore
  sudo softwareupdate -iva
  brew install mas
  mas signin --dialog
  mas upgrade
  mas install 409203825  # Numbers
  mas install 409201541  # Pages
  mas install 409183694  # Keynote
  mas install 497799835  # Xcode
  mas install 462062816  # Microsoft PowerPoint
  mas install 1295203466 # Microsoft Remote Desktop
  mas install 462058435  # Microsoft Excel
  mas install 904280696  # Things3
  mas install 462054704  # Microsoft Word
  mas install 1142051783 # LG Screen Manager
  mas install 1320666476 # Safari Extension: Wipr
  mas install 1462114288 # Safari Extension: Grammarly

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



brew install coreutils git hub github/gh/gh tree curl wget pre-commit
brew install zsh zsh-completions zsh-history-substring-search zsh-syntax-highlighting terminal-notifier
chsh -s /usr/local/bin/zsh
brew install htop watch nano unzip unrar p7zip
brew install jq bat

brew install python3 pipenv golang node yarn rbenv
npm update -g

brew install awscli aws-shell awslogs aws-cdk
npm install -g awsp

brew install tfenv tflint graphviz terraform-docs liamg/tfsec/tfsec
tfenv install latest

brew install serverless aws/tap/aws-sam-cli

brew install kubectl kubectx kubernetes-helm kube-ps1 aws-iam-authenticator octant
brew install johanhaleby/kubetail/kubetail stern


if [[ $(uname) = 'Darwin' ]]; then
  brew cask install font-anonymous-pro font-humor-sans font-gilbert

  brew cask install dotnet-sdk
  brew cask install docker

  brew cask install iterm2 alfred lunar amethyst

  brew cask install 1password
  brew cask install flux
  brew cask install slack zulip zoom amazon-chime whatsapp
  brew cask install firefox-developer-edition
  brew cask install notion
  brew cask install omnigraffle

  brew install mpv
  brew cask install iina
  brew install ranger exiftool ffmpeg media-info
  brew install youtube-dl subliminal

  brew cask install transmission
  mkdir ~/Downloads/Torrents

  brew cask install visual-studio-code
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

  # Restore all settings and configs with mackup
  #  NOTE: this replaced all the `defaults` commands
  mackup restore
fi

brew cleanup

git config --global user.email "Vlaaaaaaad@users.noreply.github.com"
git config --global user.name  "Vlad Ionescu"

mkdir ~/Repos
mkdir ~/Repos/GitHub
mkdir ~/Repos/vlaaaaaaad
mkdir ~/Repos/Castravete

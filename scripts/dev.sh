#!/bin/bash

if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [[ $(uname) != 'Darwin' ]]; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"

  brew install --cask visual-studio-code
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  code --install-extension alefragnani.project-manager
  code --install-extension amazonwebservices.aws-toolkit-vscode
  code --install-extension bungcip.better-toml
  code --install-extension fcrespo82.markdown-table-formatter
  code --install-extension fernandoescolar.vscode-solution-explorer
  code --install-extension golang.go
  code --install-extension hashicorp.terraform
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
  code --install-extension VisualStudioExptTeam.vscodeintellicode
  code --install-extension wayou.vscode-todo-highlight
  code --install-extension wingrunr21.vscode-ruby
  
  # brew install --cask dash
  brew install --cask visual-studio docker
fi

brew install git gh pre-commit
brew install zsh zsh-completions zsh-history-substring-search zsh-syntax-highlighting
chsh -s /usr/local/bin/zsh
brew install htop watch
brew install jq bat tree

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

git config --global user.email "Vlaaaaaaad@users.noreply.github.com"
git config --global user.name  "Vlad Ionescu"

mkdir ~/Developer
mkdir ~/Developer/demos
mkdir ~/Developer/GitHub
mkdir ~/Developer/vlaaaaaaad
mkdir ~/Developer/Castravete

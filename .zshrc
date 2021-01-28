# zmodload zsh/zprof

# if in a script or non-zsh, exit
[ -z "$PS1" ] && return
[ ! -n "$ZSH_VERSION" ] && return

if [ -f ${HOME}/.zshrc.local ]; then
  # File full of secrets, API keys, and so on
  # Managed by mackup
  source ${HOME}/.zshrc.local
fi

if [[ $(uname) = 'Linux' ]]; then
  IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
  IS_MAC=1
fi

if [[ -x `which brew` ]]; then
  HAS_BREW=1
fi



######## ##     ## ##    ##  ######  ######## ####  #######  ##    ##  ######
##       ##     ## ###   ## ##    ##    ##     ##  ##     ## ###   ## ##    ##
##       ##     ## ####  ## ##          ##     ##  ##     ## ####  ## ##
######   ##     ## ## ## ## ##          ##     ##  ##     ## ## ## ##  ######
##       ##     ## ##  #### ##          ##     ##  ##     ## ##  ####       ##
##       ##     ## ##   ### ##    ##    ##     ##  ##     ## ##   ### ##    ##
##        #######  ##    ##  ######     ##    ####  #######  ##    ##  ######

# compressed file expander - https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh
extract() {
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2) tar xvjf $1;;
      *.tar.gz) tar xvzf $1;;
      *.tar.xz) tar xvJf $1;;
      *.tar.lzma) tar --lzma xvf $1;;
      *.bz2) bunzip $1;;
      *.rar) unrar x $1;;
      *.gz) gunzip $1;;
      *.tar) tar xvf $1;;
      *.tbz2) tar xvjf $1;;
      *.tgz) tar xvzf $1;;
      *.zip) unzip $1;;
      *.Z) uncompress $1;;
      *.7z) 7z x $1;;
      *.dmg) hdiutul mount $1;; # mount macOS disk images
      *) echo "'$1' cannot be extracted via >extract()<";;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# notify function - http://hints.macworld.com/article.php?story=20120831112030251
notify() {
  if [ -z "$SSH_CLIENT" -o -z "$SSH_TTY" ]; then
    if [[ $IS_MAC -eq 1 ]]; then
      if [ -z $1 ]; then
        echo "Check how to use notify!"
      elif [ -z $2 ]; then
        terminal-notifier -message "$1" -sound purr
      elif [ -z $3 ]; then
        terminal-notifier -title "$1" -message "$2" -sound purr
      else
        terminal-notifier -title "$1" -subtitle "$2" -message "$3" -sound purr
      fi
    elif [[ $IS_LINUX -eq 1 ]]; then
      notify-send -u low 'Command finished' '\"'$CMD_NAME'\" has finished.'
    else
       echo "Fancy OS you're running. Define it!"
    fi
  else
    # TODO: we are in ssh, do fancy stuff (ssh to host, display alert)
    :
  fi
}

# Run the command given by "$@" in the background
silent_background() {
  if [[ -n $ZSH_VERSION ]]; then # zsh: https://superuser.com/a/1285272/365890
      setopt local_options no_notify no_monitor
      # We'd use &| to background and disown, but incompatible with bash, so:
      "$@" &
  elif [[ -n $BASH_VERSION ]]; then # bash: https://stackoverflow.com/a/27340076/5353461
    { 2>&3 "$@"& } 3>&2 2>/dev/null
  else  # Unknownness - just background it
    "$@" &
  fi
  disown &>/dev/null  # Close STD{OUT,ERR} to prevent whine if job has already completed
}



########  ######## ########   ######   #######  ##    ##    ###    ##       #### ######## ##    ##
##     ## ##       ##     ## ##    ## ##     ## ###   ##   ## ##   ##        ##     ##     ##  ##
##     ## ##       ##     ## ##       ##     ## ####  ##  ##   ##  ##        ##     ##      ####
########  ######   ########   ######  ##     ## ## ## ## ##     ## ##        ##     ##       ##
##        ##       ##   ##         ## ##     ## ##  #### ######### ##        ##     ##       ##
##        ##       ##    ##  ##    ## ##     ## ##   ### ##     ## ##        ##     ##       ##
##        ######## ##     ##  ######   #######  ##    ## ##     ## ######## ####    ##       ##

autoload -Uz colors; colors
autoload -Uz bashcompinit
autoload -Uz compinit
autoload -Uz vcs_info
zmodload -i zsh/complist

# Performance hack stolen from https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
_comp_path="${XDG_CACHE_HOME:-$HOME/.cache}/zshcompdump"
# #q expands globs in conditional expressions
if [[ $_comp_path(#qNmh-20) ]]; then
  # -C (skip function check) implies -i (skip security check).
  compinit -C -d "$_comp_path"
  bashcompinit
else
  mkdir -p "$_comp_path:h"
  compinit -i -d "$_comp_path"
  bashcompinit
fi
unset _comp_path

setopt auto_cd # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt multios # perform implicit tees or cats when multiple redirections are attempted.zsh
setopt complete_in_word # Allow completion from within a word/phrase
setopt correct # spelling correction for commands
setopt correctall # spelling correction for arguments

zstyle ':vcs_info:*' enable git #svn cvs
# Enable completion caching, use rehash to clear
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zshcompdump"
# Fallback to built in ls colors
zstyle ':completion:*' list-colors ''
# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
# Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle '*' single-ignored show
# git
zstyle ':vcs_info:*' stagedstr '%F{green}•'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}•'
zstyle ':vcs_info:*' check-for-changes true

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HISTCONTROL=ignorespace # ignore commands that start with a space
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt inc_append_history # Add commands as they are typed, don't wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history



########     ###    ######## ##     ##
##     ##   ## ##      ##    ##     ##
##     ##  ##   ##     ##    ##     ##
########  ##     ##    ##    #########
##        #########    ##    ##     ##
##        ##     ##    ##    ##     ##
##        ##     ##    ##    ##     ##

export TERM=xterm-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nano
export AWS_DEFAULT_REGION=eu-west-1
export PATH=$PATH:~/bin:/usr/local/bin:/usr/local/sbin:~/bin:~/.cabal/bin

if [[ $IS_MAC -eq 1 ]]; then
  # PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  # hard-coded brew output for startup performance
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

  # export HOMEBREW_GITHUB_API_TOKEN=0000000000000000000000000 # Moved to zshrc.local
  export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

  # eval "$(rbenv init -)"
elif [[ $IS_LINUX -eq 1 ]]; then
  # export PATH="$HOME/.rbenv/bin:$PATH"
  # eval "$(rbenv init -)"
  :
fi




if [ -f /usr/local/opt/kube-ps1/share/kube-ps1.sh ]; then
  source /usr/local/opt/kube-ps1/share/kube-ps1.sh
  export KUBE_PS1_SYMBOL_ENABLE=false
  export KUBE_PS1_SYMBOL_COLOR=''
  export KUBE_PS1_CTX_COLOR=''
  export KUBE_PS1_NS_COLOR=''
  export KUBE_PS1_BG_COLOR=''
  export KUBE_PS1_PREFIX=''
  export KUBE_PS1_DIVIDER=' @ '
  export KUBE_PS1_SUFFIX=''
fi

preexec () {
  # Note the date when the command started, in unix time.
  CMD_START_DATE=$(date +%s)

  # Store the command that we're running.
  CMD_NAME=$1
}

precmd () {
  # START LONG COMMAND NOTIFICATION

  # Proceed only if we've ran a command in the current shell.
  if ! [[ -z $CMD_START_DATE ]]; then
    # Note current date in unix time
    CMD_END_DATE=$(date +%s)

    # Store the difference between the last command start date vs. current date.
    CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))

    # Store an arbitrary threshold, in seconds.
    CMD_NOTIFY_THRESHOLD=11

    if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
      # Beep or visual bell if the elapsed time (in seconds) is greater than threshold
      print -n '\a'

      # Send a notification
      if ! [[ "$CMD_NAME" == "htop" ||  "$CMD_NAME" == "top" || "$CMD_NAME" == "vim" || "$CMD_NAME" == "vi" || "$CMD_NAME" == "nano" || "$CMD_NAME" == "ranger" ]]; then
        notify "$CMD_NAME has finised" "$CMD_ELAPSED_TIME s"
      fi
    fi
  fi

  # END LONG COMMAND NOTIFICATION

  print ""

  # START GIT STATUS

  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    zstyle ':vcs_info:*' formats '[%b] %c%u%f'
  else
    zstyle ':vcs_info:*' formats '[%b] %F{red}•%c%u%f'
  fi

  vcs_info

  # END GIT STATUS
}

_newline=$'\n'

user_prompt() {
  if [[ $IS_MAC -eq 1 ]]; then
    echo "%n @ %m: ${vcs_info_msg_0_} ${_newline}│"
  elif [[ -n $GITPOD_WORKSPACE_ID ]]; then
    echo "%n @ ☁️ : ${_newline}│"
  elif [[ -n $CODESPACES  ]]; then
    echo "%n @ 🐙 : ${_newline}│"
  fi
}

kubernetes_prompt() {
  if (( $+functions[kube_ps1] )); then
    current_context=$(kube_ps1 config current-context)

    if [[ -n $current_context ]]; then
      echo "    ${current_context} ${_newline}│"

      if [ $commands[kubectl] ]; then
        silent_background source <(kubectl completion zsh)
        complete -F __start_kubectl k
      fi
      if [ $commands[helm] ]; then
          silent_background source <(helm completion zsh)
      fi
    fi
  fi
}

aws_prompt() {
  if [ $commands[aws] ]; then
    if [[ -n $AWS_PROFILE ]]; then
      echo "    ${AWS_PROFILE} ${_newline}│"

      if [ -f /usr/local/bin/aws_complete ]; then
        complete -C '/usr/local/bin/aws_completer' aws
      fi
    fi
  fi
}

directory_prompt() {
  echo "   %~/ ${_newline}└ "
}

PROMPT='┌─── $(user_prompt) $(kubernetes_prompt) $(aws_prompt) $(directory_prompt)'




if [[ $IS_MAC -eq 1 ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ $IS_MAC -eq 1 ]]; then
  source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
else
  source /home/linuxbrew/.linuxbrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

bindkey "^A"      beginning-of-line
bindkey '^[[A'    history-substring-search-up
bindkey '^[[B'    history-substring-search-down



   ###    ##       ####    ###     ######  ########  ######
  ## ##   ##        ##    ## ##   ##    ## ##       ##    ##
 ##   ##  ##        ##   ##   ##  ##       ##       ##
##     ## ##        ##  ##     ##  ######  ######    ######
######### ##        ##  #########       ## ##             ##
##     ## ##        ##  ##     ## ##    ## ##       ##    ##
##     ## ######## #### ##     ##  ######  ########  ######

if [[ $IS_MAC -eq 1 ]]; then
  alias ls='ls -Alh --group-directories-first --color=auto -F'
elif [[ $IS_LINUX -eq 1 ]]; then
  alias ls='ls -Alh --group-directories-first --color=auto -F'
fi

function cd {
  [ -z "$PS1" ] && return
  builtin cd "$@" && ls
}

alias grep="grep --color=auto "

# Moving
alias ..="cd .."
alias bk="cd $OLDPWD" # Go back to old directory

# Git
alias gcl="git clone "
alias ga="git add "
alias gcm="git commit -m "
alias gst="git status"
alias gpu="git pull "
alias gp="git push "
alias gpo="git push origin "
alias gpom="git push origin main"
alias gb="git branch "
alias gc="git checkout "
alias gcb="git checkout -b "

# YouTube-dl
alias youtube-dl-with-sub="youtube-dl -o '~/Downloads/%(title)s.%(ext)s' --write-auto-sub --sub-lang en "

# VSCode
alias vsc='code .'
alias vsca='code --add '

# AWS
alias awsp="source _awsp"
alias awsctx="source _awsp"

# Terraform
alias tf="terraform "

# Helm
alias helm2="/usr/local/opt/helm@2/bin/helm "

# Kubernetes
alias k="kubectl "
alias kgpo="kubectl get pods "
alias ka="kubectl --all-namespaces "
alias kgpoa="kubectl get pods --all-namespaces "
alias ksys="kubectl --namespace=kube-system "
alias kaf='kubectl apply -f '
alias keti='kubectl exec -ti '
alias kgp='kubectl get pods '
alias kep='kubectl edit pods '
alias kdp='kubectl describe pods '
alias kdelp='kubectl delete pods '
alias kgs='kubectl get svc '
alias kes='kubectl edit svc '
alias kds='kubectl describe svc '
alias kdels='kubectl delete svc '
alias kgi='kubectl get ingress '
alias kei='kubectl edit ingress '
alias kdi='kubectl describe ingress '
alias kgsec='kubectl get secret '
alias kdsec='kubectl describe secret '
alias kdelsec='kubectl delete secret '
alias kgd='kubectl get deployment '
alias ked='kubectl edit deployment '
alias kdd='kubectl describe deployment '
alias kdeld='kubectl delete deployment '
alias krsd='kubectl rollout status deployment '
alias kgrs='kubectl get rs '
alias krh='kubectl rollout history '
alias kpf="kubectl port-forward "
alias kl='kubectl logs '
alias klf='kubectl logs -f '
alias kgno='kubectl get nodes '
alias kdno='kubectl describe node '

# if [[ $IS_MAC -eq 1 ]]; then
#   test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# fi

# zprof

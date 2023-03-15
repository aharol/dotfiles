# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each

# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
# ZSH_THEME="intheloop"
# ZSH_THEME="agnoster"
# ZSH_THEME="agnoster-nix"
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="powerlevel10k/powerlevel10k"

export DISPLAY=:0
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
# export TERM=rxvt-256color

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
    # COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(osx, docker, virtualenv, python, git, vscode) #zsh-syntax-highlighting nix-shell nix-zsh-completions docker)

# User configuration

# Source nix
# if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
#     source $HOME/.nix-profile/etc/profile.d/nix.sh;
# fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="$HOME/.ssh"
eval $(ssh-add -K $SSH_KEY_PATH/id_rsa &> /dev/null)

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
source $HOME/.zsh_aliaces
#source /usr/local/bin/aws_zsh_completer.sh

export EDITOR="/usr/local/bin/nvim"
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# function prompt_nix_shell_precmd {
#   if [[ ${IN_NIX_SHELL} -eq 1 ]] then
#     if [[ -n ${IN_WHICH_NIX_SHELL} ]] then
#       NIX_SHELL_NAME=": ${IN_WHICH_NIX_SHELL}"
#     fi
#     NIX_PROMPT="%F{8}[%F{3}nix-shell${NIX_SHELL_NAME}%F{8}]%f"
#     if [[ $PROMPT != *"$NIX_PROMPT"* ]] then
#       PROMPT="$NIX_PROMPT $PROMPT"
#     fi
#   fi
# }

# function prompt_nix_shell_setup {
#   autoload -Uz add-zsh-hook
#   add-zsh-hook precmd prompt_nix_shell_precmd
# }
#
# prompt_nix_shell_setup "$@"


source $ZSH/oh-my-zsh.sh

plugins=(virtualenv)


# ORDER IS IMPORTANT!
# Enable highlighters
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
#
# ZSH_HIGHLIGHT_STYLES[default]=none
# ZSH_HIGHLIGHT_STYLES[path]=none
# ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# ZSH_HIGHLIGHT_STYLES[assign]=none
# ZSH_HIGHLIGHT_STYLES[globbing]=none

# ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
# ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold

# ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
# ZSH_HIGHLIGHT_STYLES[commandseparator]=none
# ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=white

# ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
#
# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
#
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
# ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# [[ -f ~/.p9k.zsh ]] && source ~/.p9k.zsh

# See following for more information: http://www.infinitered.com/blog/?p=19

# Path ------------------------------------------------------------
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:$PATH  # OS-X Specific, with MacPorts installed
export PATH=$HOME/.local/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH

export NVM_DIR=$HOME/.nvm
[ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh  # This loads nvm

# source /Users/aharol/.nix-profile/etc/profile.d/nix.sh

export PATH="$HOME/.cargo/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"


export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
export WORKSPACE=$ICLOUD/Workspace

source ~/.zshrc

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#export PS1='($(pyenv version-name)) '$PS1

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export BASE_PROMPT=$PS1
function updatePrompt {
    if [[ "$(pyenv version-name)" != "system" ]]; then
        # the next line should be double quote; single quote would not work for me
        export PS1="($(pyenv version-name)) "$BASE_PROMPT
    else
        export PS1=$BASE_PROMPT
    fi
}
export PROMPT_COMMAND='updatePrompt'
precmd() { eval '$PROMPT_COMMAND' } # this line is necessary for zsh

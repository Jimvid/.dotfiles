# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jimvid/.oh-my-zsh"

# Themes
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true

# Plugins
plugins=(
    git
    npm
    node
    brew
)

source $ZSH/oh-my-zsh.sh

# Aliases
# TODO

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Intel Platform
alias intel="arch -x86_64"

# Init Starship
eval "$(starship init zsh)"

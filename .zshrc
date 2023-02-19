# Path to your oh-my-zsh installation.
export ZSH="/Users/jimvid/.oh-my-zsh"

# Themes
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true

# Plugins
plugins=(
    git
	zsh-autosuggestions
    web-search
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# General Aliases
alias vim="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Intel Platform
alias intel="arch -x86_64"

# Init Starship
eval "$(starship init zsh)"

#FZF setup
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--reverse --preview "cat {}"'

# find files/dirs and exclude node_modules and .git directories
alias ff='vim $(rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}" | fzf)'
alias fd='cd $(find . -type d \( -name node_modules -o -name .git \) -prune -o -name "*" | fzf)'

# Search from 
alias fdh='cd ~ && cd \$(find * -type d | fzf)'

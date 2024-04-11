# Path to your oh-my-zsh installation.
export ZSH="/home/jimvid/.oh-my-zsh"

# Themes
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

# Plugins
plugins=(
    git
	zsh-autosuggestions
    zsh-syntax-highlighting
)

# General Aliases
alias vim="nvim"
alias lg="lazygit"
alias ls="lsd"
alias ff='vim $(rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}" | fzf)'
alias fd='cd $(find . -type d \( -name node_modules -o -name .git \) -prune -o -name "*" | fzf)'

#FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--reverse --preview "cat {}"'


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Zoxide
eval "$(zoxide init zsh)"

# zsh
source $ZSH/oh-my-zsh.sh

# Path to your oh-my-zsh installation.
export ZSH="/home/jimvid/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Themes
ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true

# Plugins
plugins=(
    git
	zsh-autosuggestions
    web-search
)

# General Aliases
alias vim="nvim"
alias lg="lazygit"
alias ls="lsd"
alias ff='vim $(rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}" | fzf)'
alias fd='cd $(find . -type d \( -name node_modules -o -name .git \) -prune -o -name "*" | fzf)'
alias cd="z"

#FZF setup
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--reverse --preview "cat {}"'


# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Starship
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# Cargo
source "$HOME/.cargo/env"

# zsh-syntax-highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

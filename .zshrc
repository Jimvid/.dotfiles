# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Themes
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

# Plugins
plugins=(
    git
	zsh-autosuggestions
    fzf-tab
    zsh-syntax-highlighting
    command-not-found
)

# General Aliases
alias vim="nvim"
alias lg="lazygit"
alias ff='vim $(rg --files --hidden --follow --no-ignore-vcs -g "!{node_modules,.git}" | fzf)'
alias fd='cd $(find . -type d \( -name node_modules -o -name .git \) -prune -o -name "*" | fzf)'

# Reload waybar on hypr
alias waybar-reload='pkill waybar && hyprctl dispatch exec waybar'

#FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_DEFAULT_OPTS='--reverse --preview "cat {}"'

# Zoxide
eval "$(zoxide init zsh)"

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# source cargo
[ -f ~/.cargo/env ] && source $HOME/.cargo/env

# zsh
source $ZSH/oh-my-zsh.sh

# nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Go
export PATH=$PATH:/usr/local/go/bin

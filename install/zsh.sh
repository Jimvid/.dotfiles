#!/bin/bash
# zsh itself comes from packages.sh
set -e

[[ $SHELL == */zsh ]] || chsh -s "$(which zsh)"

[ -d ~/.oh-my-zsh ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
clone() { [ -d "$ZSH_CUSTOM/plugins/$2" ] || git clone "$1" "$ZSH_CUSTOM/plugins/$2"; }
clone https://github.com/Aloxaf/fzf-tab fzf-tab
clone https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
clone https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting

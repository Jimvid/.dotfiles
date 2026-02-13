#!/bin/zsh
set -e

if [ ! -d "$HOME/.config/nvm" ]; then
  mkdir -p ~/.config/nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi

source ~/.zshrc
nvm install --lts
nvm use --lts

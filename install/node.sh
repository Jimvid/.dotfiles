#!/bin/bash
# PROFILE=/dev/null keeps the nvm installer from appending to the linked ~/.zshrc
set -e

export NVM_DIR="$HOME/.config/nvm"

if [ ! -d "$NVM_DIR" ]; then
  mkdir -p "$NVM_DIR"
  PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh)"
fi

. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

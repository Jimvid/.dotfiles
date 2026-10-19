#!/bin/bash
# Not in the Arch repos. Re-running never updates; use each tool's own updater.
set -e

mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"   # installers below land here; arch does not add it by default

# -> ~/.local/bin/herdr
command -v herdr >/dev/null || curl -fsSL https://herdr.dev/install.sh | sh

# -> ~/.local/bin/claude; the integration gives herdr the agent-state hook
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
herdr integration status | grep -q '^claude: current' || herdr integration install claude

# arch's rustup package ships without a default toolchain
rustup show active-toolchain >/dev/null 2>&1 || rustup default stable

# -> ~/fvm/bin; `fvm global` creates ~/fvm/default, which .zshrc puts on PATH
[ -x ~/fvm/bin/fvm ] || curl -fsSL https://fvm.app/install.sh | bash

#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

# First, install fnm
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir $HOME/.local/bin

# Create/update zsh completions for fnm
$HOME/.local/bin/fnm completions --shell zsh > ${DIR}/zsh/completions/_fnm

# Use fnm to install the latest LTS version of node
$HOME/.local/bin/fnm install --lts

# Install tree-sitter-cli for use with nvim-treesitter
npm install -g tree-sitter-cli

# Install cspell for spellchecking via null-ls
npm install -g cspell@latest

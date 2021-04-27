#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

# Install useful apt packages
PACKAGES='curl htop jq openssh-server php ripgrep tmux tree zsh'
sudo apt install --assume-yes ${PACKAGES}

# Install node as a snap (includes npm and yarn)
sudo snap install node

# Install bat - a cat clone with syntax highlighting and git integration
${DIR}/install_bat.sh

# Install composer
${DIR}/install_composer.sh

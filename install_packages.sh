#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

# Install useful apt packages
PACKAGES='curl htop jq network-manager-openvpn openssh-server python-pip tmux tree zsh'
sudo apt install --assume-yes ${PACKAGES}

# Install joe - a .gitignore generator
pip install joe

# Install ripgrep (rg) - a much faster alternative to grep, ag, etc
${DIR}/install_ripgrep.sh

# Install bat - a cat clone with syntax highlighting and git integration
${DIR}/install_bat.sh

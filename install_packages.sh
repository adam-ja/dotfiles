#!/bin/bash

# Install useful apt packages
PACKAGES='curl htop jq network-manager-openvpn openssh-server python-pip tmux tree zsh'
sudo apt install --assume-yes ${PACKAGES}

# Install joe - a .gitignore generator
pip install joe

# Install ripgrep (rg) - a much faster alternative to grep, ag, etc
source install_ripgrep.sh

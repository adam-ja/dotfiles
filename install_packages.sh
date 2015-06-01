#!/bin/bash

# Install useful apt packages
for i in \
    curl \
    gsettings \
    htop \
    network-manager-openvpn \
    openssh-server \
    python-pip \
    tmux \
    tree \
    zsh \
; do
    sudo apt-get install --assume-yes $i
done

# Install joe - a .gitignore generator
pip install joe

#!/bin/bash

# Install useful apt packages
sudo apt-get install --assume-yes \
    curl \
    gsettings \
    htop \
    network-manager-openvpn \
    openssh-server \
    python-pip \
    tmux \
    tree \
    zsh \

# Install joe - a .gitignore generator
pip install joe

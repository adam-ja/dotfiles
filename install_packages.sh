#!/bin/bash

# Install useful apt packages
sudo apt-get install --assume-yes \
    curl \
    tree \
    htop \
    python-pip \
    openssh-server \
    network-manager-openvpn \
    zsh \
    tmux \

# Install joe - a .gitignore generator
pip install joe

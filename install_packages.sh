#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

case "$(uname -s)" in
    Linux)
        # Get the latest version of php rather than the default for the current Ubuntu version
        sudo add-apt-repository ppa:ondrej/php

        PACKAGES='bat curl fzf jq openssh-server php php-curl php-mbstring php-xml tmux tree wget xclip xtail zsh'
        sudo apt install --assume-yes ${PACKAGES}

        # bat clashes with another package so the executable is installed as batcat. Alias this to bat.
        mkdir -p ~/.local/bin
        ln -s /usr/bin/batcat ~/.local/bin/bat

        # Workaround for a bug with the ripgrep package
        # https://bugs.launchpad.net/ubuntu/+source/rust-bat/+bug/1868517/comments/32
        apt download ripgrep
        sudo dpkg --force-overwrite -i ripgrep*.deb
        rm ripgrep*.deb

        sudo snap install --edge nvim --classic

        ${DIR}/install_delta.sh
        ;;
    Darwin)
        brew install bat fzf git-delta jq php ripgrep tmux tree wget

        brew install --HEAD luajit neovim

        brew tap homebrew/cask-fonts
        brew install --cask font-hack-nerd-font
        ;;
    *)
        echo 'Unknown OS'
        ;;
esac

${DIR}/install_composer.sh
${DIR}/install_node.sh

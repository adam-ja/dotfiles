#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

case "$(uname -s)" in
    Linux)
        # Get the latest version of php rather than the default for the current Ubuntu version
        sudo add-apt-repository ppa:ondrej/php

        # Add neovim nightly ppa
        sudo add-apt-repository ppa:neovim-ppa/unstable

        PACKAGES='bat curl fd-find fzf jq nala neovim openssh-server php php-curl php-mbstring php-xml python3-neovim tmux tree wget xclip xtail zsh'
        sudo apt install --assume-yes ${PACKAGES}

        mkdir -p ~/.local/bin
        # bat clashes with another package so the executable is installed as batcat. Alias this to bat.
        ln -s /usr/bin/batcat ~/.local/bin/bat
        # fd clashes with another package so the executable is installed as fdfind. Alias this to fd.
        ln -s $(which fdfind) ~/.local/bin/fd

        # Workaround for a bug with the ripgrep package
        # https://bugs.launchpad.net/ubuntu/+source/rust-bat/+bug/1868517/comments/32
        apt download ripgrep
        sudo dpkg --force-overwrite -i ripgrep*.deb
        rm ripgrep*.deb

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

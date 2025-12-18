#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

case "$(uname -s)" in
    Linux)
        # Get the latest version of php rather than the default for the current Ubuntu version
        sudo add-apt-repository ppa:ondrej/php -y

        PACKAGES='bat build-essential curl fd-find fzf git-extras imagemagick jq nala openssh-server php php-curl php-mbstring php-xml tmux tree wget xclip xtail zsh'
        sudo apt install --assume-yes ${PACKAGES}

        # Install neovim (the stable version in the PPAs is way out of date)
        sudo snap install nvim --classic

        # Install golang
        sudo snap install go --classic

        mkdir -p ~/.local/bin
        # fd clashes with another package so the executable is installed as fdfind. Alias this to fd.
        ln -s $(which fdfind) ~/.local/bin/fd

        ${DIR}/install_delta.sh
        ${DIR}/install_font.sh
        ;;
    Darwin)
        brew install bat fzf git-delta jq php tmux tree wget

        brew install --HEAD luajit neovim

        brew tap homebrew/cask-fonts
        brew install --cask font-hack-nerd-font
        ;;
    *)
        echo 'Unknown OS'
        ;;
esac

${DIR}/install_ubi.sh
${DIR}/install_kitty.sh
${DIR}/install_composer.sh
${DIR}/install_node.sh
${DIR}/install_rust.sh

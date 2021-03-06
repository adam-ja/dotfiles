#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"

case "$(uname -s)" in
    Linux)
        PACKAGES='bat curl fzf jq openssh-server php ripgrep tmux tree wget zsh'
        sudo apt install --assume-yes ${PACKAGES}

        # bat clashes with another package so the executable is installed as batcat. Alias this to bat.
        mkdir -p ~/.local/bin
        ln -s /usr/bin/batcat ~/.local/bin/bat

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
${DIR}/install_nvm.sh

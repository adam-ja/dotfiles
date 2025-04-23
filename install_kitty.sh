#!/bin/bash

# Based on install instructions from https://sw.kovidgoyal.net/kitty/binary
# Note symlinks are set up in `install.conf.yaml` so excluded here.

# Download and install latest binary
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Desktop integration on linux
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

#!/bin/bash

if ! command -v gsettings &> /dev/null
then
    exit
fi

# Map caps lock to escape
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

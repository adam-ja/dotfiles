#!/bin/bash

DOWNLOAD_URL='https://github.com/sharkdp/bat/releases/download/'
TAG=$(curl -sSL 'https://api.github.com/repos/sharkdp/bat/releases/latest' | jq --raw-output .tag_name)
VERSION=${TAG/v}

if type 'bat' &> /dev/null && [[ $(bat --version) == *${VERSION}* ]]; then
    echo bat is already installed at latest version ${VERSION}
    exit
fi

curl -LO ${DOWNLOAD_URL}${TAG}/bat_${VERSION}_amd64.deb

sudo dpkg -i bat_${VERSION}_amd64.deb

rm bat_${VERSION}_amd64.deb

bat cache --build

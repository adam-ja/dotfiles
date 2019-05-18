#!/bin/bash

DOWNLOAD_URL='https://github.com/BurntSushi/ripgrep/releases/download/'
VERSION=$(curl -sSL 'https://api.github.com/repos/BurntSushi/ripgrep/releases/latest' | jq --raw-output .tag_name)

if type 'rg' &> /dev/null && [[ $(rg --version) == *${VERSION}* ]]; then
    echo ripgrep is already installed at latest version ${VERSION}
    exit
fi

curl -LO ${DOWNLOAD_URL}${VERSION}/ripgrep_${VERSION}_amd64.deb

sudo dpkg -i ripgrep_${VERSION}_amd64.deb

rm ripgrep_${VERSION}_amd64.deb

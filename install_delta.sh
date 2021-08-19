#!/bin/bash

DOWNLOAD_URL='https://github.com/dandavison/delta/releases/download/'
TAG=$(curl -sSL 'https://api.github.com/repos/dandavison/delta/releases/latest' | jq --raw-output .tag_name)

if type 'delta' &> /dev/null && [[ $(delta --version) == *${TAG}* ]]; then
    echo git-delta is already installed at latest version ${TAG}
    exit
fi

curl -LO ${DOWNLOAD_URL}${TAG}/git-delta_${TAG}_amd64.deb

sudo dpkg -i git-delta_${TAG}_amd64.deb

rm git-delta_${TAG}_amd64.deb

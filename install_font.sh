#!/bin/bash

DOWNLOAD_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/'
TAG=$(curl -sSL 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' | jq --raw-output .tag_name)

curl -LO ${DOWNLOAD_URL}${TAG}/JetBrainsMono.zip

mkdir -p ${HOME}/.fonts

unzip JetBrainsMono.zip *.ttf -d ${HOME}/.fonts

rm JetBrainsMono.zip

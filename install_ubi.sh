#!/bin/bash

if command -v ubi &>/dev/null
then
    ubi --self-upgrade
else
    curl --silent --location \
        https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
        TARGET=$HOME/.local/bin sh
fi

# Install/update git-spice
ubi --project abhinav/git-spice --exe gs --rename-exe git-spice --in $HOME/.local/bin

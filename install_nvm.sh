#!/bin/bash

TAG=$(curl -sSL 'https://api.github.com/repos/nvm-sh/nvm/releases/latest' | jq --raw-output .tag_name)

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${TAG}/install.sh | bash

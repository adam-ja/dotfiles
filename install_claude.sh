#!/bin/bash

# Install Claude Code
# https://code.claude.com/docs/en/quickstart#step-1-install-claude-code
# It automatically updates itself (https://code.claude.com/docs/en/setup#auto-updates)
curl -fsSL https://claude.ai/install.sh | bash

# Install the Claude ACP adapter
# https://github.com/zed-industries/claude-code-acp
npm install -g @zed-industries/claude-code-acp

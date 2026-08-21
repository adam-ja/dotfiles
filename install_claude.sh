#!/bin/bash

# Install Claude Code
# https://code.claude.com/docs/en/quickstart#step-1-install-claude-code
# It automatically updates itself (https://code.claude.com/docs/en/setup#auto-updates)
curl -fsSL https://claude.ai/install.sh | bash

# Install the Claude ACP adapter
# https://github.com/agentclientprotocol/claude-agent-acp
npm install -g @agentclientprotocol/claude-agent-acp

# Install rtk to reduce token consumption for bash calls
cargo install --git https://github.com/rtk-ai/rtk
rtk init -g --auto-patch

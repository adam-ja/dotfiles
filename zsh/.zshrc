# Path to oh-my-zsh installation.
export ZSH=$HOME/dotfiles/oh-my-zsh

# Enable command auto-correction.
ENABLE_CORRECTION=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(bower command-not-found composer git last-working-dir sudo vagrant)

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

source $ZSH/oh-my-zsh.sh

export LANG=en_GB.UTF-8

# Make vim the default editor
export VISUAL='vim'

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias tmux='tmux -2' # Always assume terminal supports 256 colours
alias grep='grep --color=always' # Always colour highlight matching strings with grep

# Include promptline config
if [ -f ~/dotfiles/zsh/promptline-snapshot ]; then
    source ~/dotfiles/zsh/promptline-snapshot
fi

# Include extra local config if it exists
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

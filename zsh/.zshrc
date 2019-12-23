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
#
# vi-mode goes first as it can otherwise override things that break other plugins
plugins=(vi-mode command-not-found composer fzf git history-substring-search tmux fzf-git)

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

#####
# In general, all ZSH_* variables for controlling oh-my-zsh behaviour need to be set before sourcing oh-my-zsh.sh
#####

# Set location for custom themes and plugins
ZSH_CUSTOM=$HOME/dotfiles/zsh_custom

# Use spaceship prompt
SPACESHIP_TIME_SHOW=true
SPACESHIP_BATTERY_SHOW=false
ZSH_THEME="spaceship"

# Automatically start tmux when opening a new terminal window (window will also automatically close when exiting tmux)
ZSH_TMUX_AUTOSTART=true
# Don't autoconnect to previous tmux session (if one exists) when opening new terminal window. Autoconnecting prevents
# me from having multiple windows with different tmux sessions for different things and that's just annoying
ZSH_TMUX_AUTOCONNECT=false

# When searching history, ignore adjacent duplicates
setopt HIST_FIND_NO_DUPS

source $ZSH/oh-my-zsh.sh

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second, default is 40 so 0.4 seconds)
export KEYTIMEOUT=1

export LANG=en_GB.UTF-8

# Make vim the default editor
export VISUAL='vim'

# Set a global config file for ripgrep (rg)
export RIPGREP_CONFIG_PATH="$HOME/dotfiles/misc/ripgreprc"

# Set the path to the bat config file
export BAT_CONFIG_PATH="$HOME/dotfiles/misc/bat.conf"

# Set fzf installation directory path
export FZF_BASE="$HOME/.fzf"

# Use rg rather than find to respect the .ignore (but not VCS ignore)
export FZF_DEFAULT_COMMAND='rg --color=never --no-ignore-vcs --ignore-case --hidden -l ""'

# Set default FZF options
# - Reverse causes FZF to list top to bottom rather than bottom to top
export FZF_DEFAULT_OPTS="--layout=reverse"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias grep='grep --color=always' # Always colour highlight matching strings with grep
alias lesss='less -r' # Output raw control characters (maintains colours etc when piping through less)
alias sedhelp='echo "rg --files-with-matches --color=never SEARCH_TERM [PATHS] | xargs sed -i '\''s/SEARCH_TERM/REPLACEMENT/g'\''"'
alias findswp='find . -name "*.swp"'
alias rmswp='findswp -print0 | xargs -0 rm'
alias fzfp="fzf --preview '(bat --color=always {} || cat {})'"
alias fgco='gco $(git_branches)'
alias fgbd='gbd $(git_branches)'
alias fgbD='gbD $(git_branches)'

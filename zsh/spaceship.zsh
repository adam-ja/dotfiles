# Don't add a blank lines before each prompt
SPACESHIP_PROMPT_ADD_NEWLINE=false

SPACESHIP_TIME_SHOW=true
SPACESHIP_BATTERY_SHOW=false

SPACESHIP_CHAR_SYMBOL=""
SPACESHIP_CHAR_SUFFIX=" "

SPACESHIP_VI_MODE_INSERT="󰰃"
SPACESHIP_VI_MODE_NORMAL="󰰒"

# Async makes the prompt faster but is all kinds of broken
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
SPACESHIP_PROMPT_ASYNC=false

# Add sections to the default prompt order
spaceship add --after node react
spaceship add --before char vi_mode

# Fix vi-mode indicator not updating
eval spaceship_vi_mode_enable

# Dotfiles

This repo contains all of my dotfiles and a script to bootstrap them using [Dotbot][dotbot]. It is forked from [dotfiles_template][fork].

## Installation

- Run the following commands
```bash
cd ~
git clone https://github.com/adam-ja/dotfiles.git --recurse-submodules
cd dotfiles
./install
chsh -s `which zsh`
```
- Edit your terminal profile and change the font to a Powerline font to see fancy symbols in the tmux and vim status lines.
- Logout and log back in. ZSH will now be your default shell.
- When first opening a terminal, you will be prompted to follow the ZSH new user setup. Follow the instructions to create a blank `.zshrc` file and put the following content in it:
```bash
source $HOME/dotfiles/zsh/.zshrc
```
- This will pull in all the config from dotfiles and allow you to set local overrides below this line for the specific machine you're installing on.
- The next new terminal you open will be using the fully configured zsh.
- You're done.

## License

This software is hereby released into the public domain. That means you can do
whatever you want with it without restriction. See `LICENSE.md` for details.

If you like what you see, feel free to fork it (or just copy any bits you like) but these are my personal configs so I won't be accepting any pull requests unless there's a suggestion I really like and can see being useful for myself.

[dotbot]: https://github.com/anishathalye/dotbot
[fork]: https://github.com/anishathalye/dotfiles_template/fork

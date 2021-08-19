# Dotfiles

This repo contains all of my dotfiles and a script to bootstrap them using [Dotbot][dotbot]. It is forked from [dotfiles_template][fork].

## Installation

- Run the following commands
```sh
cd ~
git clone https://github.com/adam-ja/dotfiles.git --recurse-submodules
cd dotfiles
./install
```
- Edit your terminal profile and change the font to a [Nerd Font][nerdfonts] font to see fancy symbols in the tmux and vim status lines.
- If ZSH is not already your default shell, you can make it so with:
```sh
chsh -s `which zsh`
```
- You may need to log out and back in for this to take effect.
- If you do not already have a `~/.zshrc` file, create one and add the following to it:
```sh
source $HOME/dotfiles/zsh/zshrc
```
- This will pull in all the config from dotfiles and allow you to set local overrides below this line for the specific machine you're installing on.
- The next new terminal you open will be using the fully configured zsh.
- The onedark theme used for neovim and tmux also provides matching themes for various terminal emulators. Just import them into your terminal profile from `nvim/plugged/onedark.vim/term`. If using GNOME Terminal, which doesn't support theme/colour scheme imports, use [One for GNOME Terminal][one-gnome-terminal] instead.
- You're done.

## License

This software is hereby released into the public domain. That means you can do
whatever you want with it without restriction. See `LICENSE.md` for details.

If you like what you see, feel free to fork it (or just copy any bits you like) but these are my personal configs so I won't be accepting any pull requests unless there's a suggestion I really like and can see being useful for myself.

[dotbot]: https://github.com/anishathalye/dotbot
[fork]: https://github.com/anishathalye/dotfiles_template/fork
[nerdfonts]: https://github.com/ryanoasis/nerd-fonts
[one-gnome-terminal]: https://github.com/denysdovhan/one-gnome-terminal

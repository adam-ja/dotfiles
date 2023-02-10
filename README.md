# Dotfiles

This repo contains all of my dotfiles and a script to bootstrap them using [Dotbot][dotbot]. It is forked from [dotfiles_template][fork].

## Installation

- Run the following commands
```sh
cd ~
git clone https://github.com/adam-ja/dotfiles.git --recurse-submodules
cd dotfiles
./install.sh
```
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

### Extras

- A [Nerd Font][nerdfonts] is required to see fancy symbols. The popular JetBrains Mono Nerd Font is installed as part of the process above, and this also includes ligatures where supported.
- The kitty terminal emulator is also installed and configured to use the JetBrains font (kitty supports ligatures) and the matching theme from the onedarkpro neovim theme. If using kitty, it's worth changing the default terminal app in the OS to this, and updating any keyboard shortcuts (e.g. Ctrl-Alt-T in Ubuntu).
- If not using kitty, you'll need to set the font and theme in your terminal emulator of choice.
    - Some themes are provided by the onedarkpro.nvim plugin (use the commands `:OnedarkproExportTo[Kitty|Alacritty|WindowsTerminal]`). GNOME Terminal doesn't support theme imports, but you can use [One for GNOME Terminal][one-gnome-terminal] instead.
    - Not all terminal emulators support ligatures (including GNOME Terminal).

## License

This software is hereby released into the public domain. That means you can do
whatever you want with it without restriction. See `LICENSE.md` for details.

If you like what you see, feel free to fork it (or just copy any bits you like) but these are my personal configs so I won't be accepting any pull requests unless there's a suggestion I really like and can see being useful for myself.

[dotbot]: https://github.com/anishathalye/dotbot
[fork]: https://github.com/anishathalye/dotfiles_template/fork
[nerdfonts]: https://github.com/ryanoasis/nerd-fonts
[one-gnome-terminal]: https://github.com/denysdovhan/one-gnome-terminal

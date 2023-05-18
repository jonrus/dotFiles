# dotFiles
My config files for various apps.

## Apps
   - [Kitty](https://sw.kovidgoyal.net/kitty/)
   - Bash helpers/functions/aliases
   - [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)
   - [Starship](https://github.com/starship/starship)
   - [asdf](https://asdf-vm.com/)

## Full Install
   - Install Kitty (if using...)
   - Install Starship
   - Install Hack Nerd Font
   - Install asdf
   - Install neovim
   - Clone this repo
   - Add `source .../dotFiles/bash/.source_all` to `.bashrc`
   - Create symlink of `.../dotFiles/starship/pure-preset.toml` to `~/.config/starship.toml`

## No asdf Install
   - Install Hack Nerd Font
   - Clone this repo
   - Add `source .../dotFiles/bash/.source_no_asdf` to `.bashrc`
   - Create symlink of `.../dotFiles/starship/pure-preset.toml` to `~/.config/starship.toml`

## Minimum Install (On [Kinoite](https://kinoite.fedoraproject.org/) for example)
   - Install Hack Nerd Font
   - Manually Install Starship
     - Place binary in PATH 
   - Clone this repo
   - Add `source .../dotFiles/bash/.source_minimum` to `.bashrc`

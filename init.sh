#!/bin/bash
#
# Sets up .dotfiles on new machine
#
# Usage:
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/init.sh)

# set up local .dotfiles repo
mkdir -p $HOME/github
git clone --bare git@github.com:hootio/.dotfiles.git $HOME/github/.dotfiles
config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
$config config --local status.showUntrackedFiles no
$config checkout
curl -fsSL https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf > $HOME/github/.dotfiles/.config/tmux/tmux.conf

# brew
## install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## install brew packages
brew bundle --file $HOME/Brewfile --no-lock
brew bundle check

# reload zsh
exec zsh

#!/bin/bash
#
# Sets up .dotfiles on new machine
#
# Usage:
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/.init.sh)

mkdir -p $HOME/github
git clone --bare git@github.com:hootio/.dotfiles.git $HOME/github/.dotfiles
config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
$config config --local status.showUntrackedFiles no
$config checkout
exec zsh

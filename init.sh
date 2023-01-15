#!/bin/bash
mkdir -p $HOME/github
git clone --bare git@github.com:hootio/.dotfiles.git $HOME/github/.dotfiles
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
config config --local status.showUntrackedFiles no
config checkout

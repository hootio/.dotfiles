#!/bin/bash
#
# Sets up .dotfiles on new machine
#
# Usage:
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/init.sh)

# set up local .dotfiles repo
REPO_DIR="$HOME/github/.dotfiles"
mkdir -p $REPO_DIR
config="git --git-dir=$REPO_DIR --work-tree=$HOME"
if [ ! -d "$REPO_DIR" ]; then
    echo "Directory does not exist. Cloning repository..."
    git clone --bare git@github.com:hootio/.dotfiles.git $REPO_DIR
    $config config --local status.showUntrackedFiles no
    $config checkout
else
    echo "Directory exists. Pulling latest changes..."
    $config pull || { echo "Failed to pull latest changes."; exit 1; }
fi

mkdir -p $HOME/.config/tmux
curl -fsSL https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf > $HOME/.config/tmux/tmux.conf

# brew
## install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## install brew packages
brew bundle --file $HOME/Brewfile --no-lock
brew bundle check
brew update
brew upgrade

# reload zsh
exec zsh

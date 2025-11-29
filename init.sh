#!/bin/bash
set -euo pipefail
#
# Sets up .dotfiles on new machine
#
# Usage:
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/init.sh)

REPO_DIR="$HOME/github/.dotfiles"
config="git --git-dir=$REPO_DIR --work-tree=$HOME"
cleanup() {
  echo "An error occurred. Cleaning up..."
  $config ls-tree -z --name-only -r HEAD | xargs -0 -I{} sh -c 'echo "Deleting $HOME/{}"; rm -f "$HOME/{}"'
  echo "Deleting $REPO_DIR"
  rm -rf $REPO_DIR
}
trap cleanup ERR

# ensure github ssh key exists
SSH_KEY_PATH="$HOME/.ssh/github_ed25519"
if [ -f $SSH_KEY_PATH ]; then
  chmod 600 $SSH_KEY_PATH
  ssh-add $SSH_KEY_PATH
else
  echo "$SSH_KEY_PATH not found. Please add your Github SSH key."; exit 1;
fi

# set up local .dotfiles repo
mkdir -p $HOME/github
if [ ! -d $REPO_DIR ]; then
    echo "Directory does not exist. Cloning repository..."
    git clone --bare git@github.com:hootio/.dotfiles.git $REPO_DIR
    $config config --local status.showUntrackedFiles no
    $config checkout
else
    echo "Directory exists. Pulling latest changes..."
    $config pull || { echo "Failed to pull latest changes."; exit 1; }
fi
curl -fsSL https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf > $HOME/.config/tmux/tmux.conf

# brew
## install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
## install brew packages
brew bundle --file $HOME/Brewfile
brew bundle check
brew update
brew upgrade

# rust
## install rustc and cargo
rustup-init -y

# reload zsh as login shell to run .zprofile
exec zsh -l

#!/bin/bash
set -euo pipefail
#
# Sets up .dotfiles on new machine
#
# Usage:
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/init.sh)
# Clean up mode:
#   ./init.sh cleanup
#

OS_TYPE=$(uname -s)
if [[ "$OS_TYPE" != "Darwin" ]]; then
  echo "Error: Unsupported OS type '$OS_TYPE'. Must be Darwin"
  exit 1
fi

# consts
SSH_KEY_PATH="$HOME/.ssh/github_ed25519"
REPO_DIR="$HOME/github/.dotfiles"
config="git --git-dir=$REPO_DIR --work-tree=$HOME"

cleanup() {
  echo "Cleaning up..."
  echo "Deleting $HOME/.gitconfig"
  rm -f .gitconfig
  $config ls-tree -z --name-only -r HEAD | xargs -0 -I{} sh -c 'echo "Deleting $HOME/{}"; rm -f "$HOME/{}"'
  echo "Deleting $REPO_DIR"
  rm -rf $REPO_DIR
  exit 0
}

# run cleanup mode
if [[ "${1:-}" == "cleanup" ]]; then
  cleanup
  exit 0
fi

# ensure github ssh key exists
if [ -f $SSH_KEY_PATH ]; then
  chmod 600 $SSH_KEY_PATH
  eval "$(ssh-agent -s)"
  ssh-add $SSH_KEY_PATH
else
  echo "$SSH_KEY_PATH not found. Please add your Github SSH key."
  exit 1
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

# install tmux config
curl -fsSL https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf > $HOME/.config/tmux/tmux.conf

# install brew
BREWFILE=$HOME/Brewfile
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
BREW_PREFIX=$(brew --prefix)
eval "$($BREW_PREFIX/bin/brew shellenv)"

# install brew packages
brew bundle --file $BREWFILE --verbose
brew bundle check --file $BREWFILE
brew update
brew upgrade

# install rustc and cargo
rustup-init -y

# reload zsh as login shell to run .zprofile
exec zsh -l


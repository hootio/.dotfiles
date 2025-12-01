#!/bin/bash
set -euo pipefail
#
# Sets up .dotfiles on new machine
#
# Usage:
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/init.sh) mac
#   bash <(curl https://raw.githubusercontent.com/hootio/.dotfiles/main/init.sh) linux

if [ $# -eq 0 ]; then
  echo "Usage: $0 <mac|linux>"
  exit 1
fi

PLATFORM="$1"
if [[ "$PLATFORM" != "mac" && "$PLATFORM" != "linux" ]]; then
  echo "Error: Invalid platform '$PLATFORM'. Must be 'mac' or 'linux'"
  exit 1
fi

echo "Setting up dotfiles for platform: $PLATFORM"

# consts
SSH_KEY_PATH="$HOME/.ssh/github_ed25519"
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
if [ -f $SSH_KEY_PATH ]; then
  chmod 600 $SSH_KEY_PATH
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

# set up .gitconfig
cat .gitconfig.template >> $HOME/.gitconfig

# install tmux config
curl -fsSL https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf > $HOME/.config/tmux/tmux.conf

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
BREW_PREFIX=$(brew --prefix)
eval "$($BREW_PREFIX/bin/brew shellenv)"

if [ "$PLATFORM" = "mac" ]; then
  # install brew packages
  brew bundle --file $HOME/Brewfile.mac
  brew bundle check --file $HOME/Brewfile.mac
  brew update
  brew upgrade
  
  # install rustc and cargo
  rustup-init -y
  
elif [ "$PLATFORM" = "linux" ]; then
  # install brew packages
  brew bundle --file $HOME/Brewfile.linux
  brew bundle check --file $HOME/Brewfile.linux
  brew update
  brew upgrade

  # sync everything
  ## .dotfiles repo
  dotsync2 paths add "$HOME/github/.dotfiles"
  TRACKED_FILES=$($config ls-tree --full-tree -r --name-only HEAD)
  for file in $TRACKED_FILES; do
    if [ -f "$HOME/$file" ]; then
      dotsync2 paths add "$HOME/$file"
    fi
  done
  ## brew and packages
  dotsync2 paths add "$BREW_PREFIX"
  ## push
  dotsync2 push
fi

# reload zsh as login shell to run .zprofile
exec zsh -l

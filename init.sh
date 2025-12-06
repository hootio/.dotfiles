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
if [[ "$OS_TYPE" == "Darwin" ]]; then
  PLATFORM="mac"
elif [[ "$OS_TYPE" == "Linux" ]]; then
  PLATFORM="linux"
else
  echo "Error: Unsupported OS type '$OS_TYPE'. Must be Darwin or Linux"
  exit 1
fi

# consts
BREW_LINUX_PATH="$HOME/.brew"
SSH_KEY_PATH="$HOME/.ssh/github_ed25519"
REPO_DIR="$HOME/github/.dotfiles"
config="git --git-dir=$REPO_DIR --work-tree=$HOME"

cleanup() {
  echo "An error occurred. Cleaning up..."
  echo "Deleting $HOME/.gitconfig"
  rm -f .gitconfig
  echo "Deleting $BREW_LINUX_PATH"
  rm -rf $BREW_LINUX_PATH
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

echo "Setting up dotfiles for platform: $PLATFORM"

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

# set up .gitconfig
cat .gitconfig.template >> $HOME/.gitconfig

# install tmux config
curl -fsSL https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf > $HOME/.config/tmux/tmux.conf

# install brew
if [ "$PLATFORM" = "mac" ]; then
  BREWFILE=$HOME/Brewfile.mac
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW_PREFIX=$(brew --prefix)
elif [ "$PLATFORM" = "linux" ]; then
  BREWFILE=$HOME/Brewfile.linux
  BREW_PREFIX="$BREW_LINUX_PATH"
  mkdir -p "$BREW_PREFIX"
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_PREFIX"
fi
eval "$($BREW_PREFIX/bin/brew shellenv)"

# install brew packages
brew bundle --file $BREWFILE --verbose
brew bundle check --file $BREWFILE
brew update
brew upgrade

if [ "$PLATFORM" = "mac" ]; then
  # install rustc and cargo
  rustup-init -y
elif [ "$PLATFORM" = "linux" ]; then
  # sync everything across servers
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

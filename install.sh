#!/usr/bin/env bash

set -e

IS_OSX=false
[[ $OSTYPE == 'darwin'* ]] && IS_OSX=true

if type brew &> /dev/null; then
  brew update
else
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ "$IS_OSX" = false ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

if [ "$IS_OSX" = true ]; then
  . ./iterm2/install.sh
fi

if ! type fzf &> /dev/null; then
  echo "Installing fzf"
  brew install fzf
fi

if ! type zplug &> /dev/null; then
  echo "Installing ZPlug"
  brew install zplug
fi

if ! type tmux &> /dev/null; then
  echo "Installing tmux"
  brew install tmux tmuxinator
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if ! type nvim &> /dev/null; then
  echo "Installing Neovim"
  brew install neovim
  git clone https://github.com/p-m-p/nvim-config.git "$HOME/.config/nvim"
fi

if ! brew --prefix --installed sdkman-cli &> /dev/null; then
  echo "Installing SDKMAN"
  brew tap sdkman/tap
  brew install sdkman-cli
fi

if ! type podman &> /dev/null; then
  echo "Installing Podman"
  brew install podman podman-compose

  if [ "$IS_OSX" = true ]; then
    podman machine init
    podman machine start
    brew install --cask podman-desktop
  fi
fi

for dotfile in ./dotfiles/*
do
  FILE_NAME=$(basename "$dotfile")
  FILE_PATH="$HOME/.$FILE_NAME"

  if [ -f "$FILE_PATH" ]; then
    echo "$FILE_PATH exists: backing up to $FILE_PATH.bak"
    mv "$FILE_PATH" "$FILE_PATH.bak"
  fi

   cp "$dotfile" "$FILE_PATH"
done

echo "Install complete, now 'source ~/.zshrc' and run 'setup.sh'"

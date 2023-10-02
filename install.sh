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
  echo "Installing iTerm2"
  . ./iterm2/install.sh
fi

if ! type starship &> /dev/null; then
  echo "Installing Starship"
  brew install starship
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

if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

if [ ! -d "$(brew --prefix sdkman-cli)" ]; then
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

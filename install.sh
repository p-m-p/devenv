#!/bin/bash

set -e

[ -z "$HOME_DIR" ] && HOME_DIR=~

for config in ./dotfiles/*
do
  cp "$config" "$HOME_DIR/.$(basename config)"
done

if ! command -v brew 2>&1 /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

if [[ $OSTYPE == 'darwin'* ]]; then
  brew tap homebrew/cask-fonts
  brew install --cask iterm2 font-hack-nerd-font
  cp ./iterm2/profiles.json "$HOME_DIR/Library/Application\ Support/iTerm2/DynamicProfiles"
  AUTO_LAUNCH_DIR="$HOME_DIR/Library/Application\ Support/iTerm2/Scripts/AutoLaunch"
  mkdir -p "$AUTO_LAUNCH_DIR"
  cp ./iterm2/setprofile  "$AUTO_LAUNCH_DIR"
fi

brew install starship tmux neovim

if [ ! -d "$HOME_DIR/.tmux" ]; then
  echo "Installing tmux plugin config"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d "$HOME_DIR/.config/nvim" ]; then
  echo "Installing Neovim configs"
  git clone https://github.com/p-m-p/nvim-config.git "$HOME_DIR/.config/nvim"
fi

if [ ! -d "$HOME_DIR/.nvm" ]; then
  echo "Installing nvm"
  git clone https://github.com/nvm-sh/nvm.git "$HOME_DIR/.nvm"
  . "$HOME_DIR/.nvm/nvm.sh" && nvm install --lts
  echo "lts/*" > "$HOME_DIR/.nvmrc"
  corepack enable pnpm
  pnpm install -g commitizen cz-conventional-changelog-coauthors
fi

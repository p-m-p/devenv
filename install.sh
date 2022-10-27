#!/usr/bin/env bash

set -e

[ -z "$HOME_DIR" ] && HOME_DIR=~

for config in $( ls ./dot-files )
do
  echo "Installing .$config"
  cp ./dot-files/$config $HOME_DIR/.$config
done

if [ ! -d "$HOME_DIR/.tmux-themepack" ]; then
  echo "Installing TMUX theme"
  git clone --depth=1 https://github.com/jimeh/tmux-themepack.git $HOME_DIR/.tmux-themepack
fi

if [ ! -d "$HOME_DIR/.config/nvim" ]; then
  echo "Installing Neovim configs and bootstrapping"
  git clone https://github.com/p-m-p/nvim-config.git $HOME_DIR/.config/nvim
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi

if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh"
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $HOME_DIR/.oh-my-zsh
fi

if [ ! -d "$HOME_DIR/.nvm" ]; then
  echo "Installing Node with nvm"
  git clone https://github.com/nvm-sh/nvm.git $HOME_DIR/.nvm
  zsh -c "source $HOME_DIR/.nvm/nvm.sh && nvm install --lts"
  echo "lts/*" > $HOME_DIR/.nvmrc
fi

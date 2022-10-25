#!/usr/bin/env bash

set -e

[ -z "$HOME_DIR" ] && HOME_DIR=~

for config in $( ls ./dot-files )
do
  echo "Installing .$config"
  cp ./dot-files/$config $HOME_DIR/.$config
done

if [ ! -d "$HOME_DIR/.tmux-themepack" ]; then 
  echo "Installing TMUX theme at $HOME_DIR/.tmux-themepack"
  git clone --depth=1 https://github.com/jimeh/tmux-themepack.git $HOME_DIR/.tmux-themepack
fi

if [ ! -d "$HOME_DIR/.config/nvim" ]; then
  echo "Installing Neovim configs"
  git clone https://github.com/p-m-p/nvim-config.git $HOME_DIR/.config/nvim
fi

#!/usr/bin/env bash

set -e

[ -z "$HOME_DIR" ] && HOME_DIR=~

for config in $( ls ./dot-files )
do
  echo "Installing .$config"
  cp ./dot-files/$config $HOME_DIR/.$config
done

if [ ! -d "$HOME_DIR/.tmux" ]; then
  echo "Installing tmux plugin config"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d "$HOME_DIR/.config/nvim" ]; then
  echo "Installing Neovim configs and bootstrapping"
  git clone https://github.com/p-m-p/nvim-config.git $HOME_DIR/.config/nvim
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi

if [ ! -d "$HOME_DIR/.nvm" ]; then
  echo "Installing Node with nvm"
  git clone https://github.com/nvm-sh/nvm.git $HOME_DIR/.nvm
  zsh -c "source $HOME_DIR/.nvm/nvm.sh && nvm install --lts"
  echo "lts/*" > $HOME_DIR/.nvmrc
fi

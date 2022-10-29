#!/usr/bin/env zsh

set -e

[ -z "$HOME_DIR" ] && HOME_DIR=~

for config in $( ls ./dot-files )
do
  cp ./dot-files/$config $HOME_DIR/.$config
  echo "Added $HOME_DIR/.$config"
done

if [ ! -d "$HOME_DIR/.tmux" ]; then
  echo "Installing tmux plugin config"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -d "$HOME_DIR/.config/nvim" ]; then
  echo "Installing Neovim configs"
  git clone https://github.com/p-m-p/nvim-config.git $HOME_DIR/.config/nvim
fi

if [ ! -d "$HOME_DIR/.nvm" ]; then
  echo "Installing nvm"
  git clone https://github.com/nvm-sh/nvm.git $HOME_DIR/.nvm
  source $HOME_DIR/.nvm/nvm.sh && nvm install --lts
  echo "lts/*" > $HOME_DIR/.nvmrc
fi

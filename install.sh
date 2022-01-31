#!/usr/bin/env bash

[ -z "$HOME_DIR" ] && HOME_DIR=~
VIM_DIR="$HOME_DIR/.vim"

vim_plugins=(
  "https://github.com/kien/ctrlp.vim.git"
  "https://github.com/pangloss/vim-javascript.git"
  "https://github.com/tpope/vim-fugitive.git"
  "https://github.com/bling/vim-airline.git"
  "https://github.com/vim-airline/vim-airline-themes.git"
  "https://github.com/vim-ruby/vim-ruby.git"
  "https://github.com/plasticboy/vim-markdown.git"
  "https://github.com/leafgarland/typescript-vim.git"
)

# Copy config scripts
for config in $( ls ./dot-files )
do
  cp ./dot-files/$config $HOME_DIR/.$config
done

# TMUX session start up
if [ -d ~/development ]; then
  cp ./tmux-launch $HOME_DIR/development
else
  cp ./tmux-launch $HOME_DIR
fi

if [ ! -d $VIM_DIR ]; then
  echo 'Unable to locate .vim directory for current user'
  exit 1
fi

# Setup vim
for fldr in $( ls ./vim )
do
  if [ ! -d $VIM_DIR/$fldr ]; then
    echo "Setting up vim directory: $fldr"
    mkdir $VIM_DIR/$fldr
  fi

  if [ -d ./vim/$fldr ]; then
    for vim_file in $( ls ./vim/$fldr )
    do
      cp -r ./vim/$fldr/$vim_file $VIM_DIR/$fldr/$vim_file
    done
  fi
done

# Install Vim plugins
for plugin in ${vim_plugins[@]}
do
  plugin_name=$( echo $plugin | sed -E 's;^.*/(.*).git$;\1;' )
  plugin_dir=$VIM_DIR/bundle/$plugin_name

  if [ ! -d $plugin_dir ]; then
    echo
    echo "Installing vim plugin: $plugin_name"
    git clone $plugin $plugin_dir
  fi
done

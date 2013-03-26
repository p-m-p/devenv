#!/usr/bin/env bash

# Copy config scripts
config_files="vimrc tmux.conf gitignore gitconfig"
for config in $config_files
do
  cp ./$config ~/.$config
done

# TMUX session start up
cp ./tmux-launch ~/development

# Setup vim and plugins
vim_dirs="autoload bundle colors"
for vim_dir in $vim_dirs
do
  if [ ! -d ~/.vim/$vim_dir ]; then
    mkdir ~/.vim/$vim_dir
  fi

  if [ -d ./vim/$vim_dir ]; then
    for vim_file in $( ls ./vim/$vim_dir )
    do
      cp ./vim/$vim_dir/$vim_file ~/.vim/$vim_dir/$vim_file
    done
  fi
done

declare -A vim_plugins
vim_plugins["vim-haml"]="git@github.com:tpope/vim-haml.git"
vim_plugins["vim-handlebars"]="git@github.com:nono/vim-handlebars.git"
vim_plugins["vim-javascript"]="git@github.com:pangloss/vim-javascript.git"

for plugin in ${!vim_plugins[@]}
do
  if [ ! -d ~/.vim/bundle/$plugin ]; then
    git clone ${vim_plugins[$plugin]} ~/.vim/bundle/$plugin
  fi
done

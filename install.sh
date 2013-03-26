#!/usr/bin/env bash

# config scripts
config_files="vimrc tmux.conf"
for config in $config_files
do
  cp ./config "~/.$(config)"
done

# Setup vim and plugins
cp -r vim ~/.vim
git clone git@github.com:tpope/vim-haml.git ~/.vim/bundle/vim-haml
git clone git@github.com:nono/vim-handlebars.git ~/.vim/bundle/vim-handlebars
git clone git@github.com:pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript

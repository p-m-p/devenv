#!/usr/bin/env bash

vim_plugins=(
  "git@github.com:tpope/vim-haml.git"
  "git@github.com:nono/vim-handlebars.git"
  "git@github.com:pangloss/vim-javascript.git"
  "git@github.com:p-m-p/snipmate.vim.git"
  "git@github.com:p-m-p/vim-airline.git"
)

# Copy config scripts
for config in $( ls ./dot-files )
do
  cp ./dot-files/$config ~/.$config
done

# TMUX session start up
if [ -d ~/development ]; then
  cp ./tmux-launch ~/development
else
  cp ./tmux-launch ~
fi

if [ ! -d ~/.vim ]; then
  echo 'Unable to locate ~/.vim directory for current user'
  exit $?
fi

# Setup vim
for vim_dir in $( ls ./vim )
do
  if [ ! -d ~/.vim/$vim_dir ]; then
    echo "Setting up vim directory: $vim_dir"
    mkdir ~/.vim/$vim_dir
  fi

  if [ -d ./vim/$vim_dir ]; then
    for vim_file in $( ls ./vim/$vim_dir )
    do
      cp -r ./vim/$vim_dir/$vim_file ~/.vim/$vim_dir/$vim_file
    done
  fi
done

# Install Vim plugins
for plugin in ${vim_plugins[@]}
do
  plugin_name=$( echo $plugin | sed -E 's;^.*/(.*).git$;\1;' )
  plugin_dir=~/.vim/bundle/$plugin_name

  if [ ! -d $plugin_dir ]; then
    echo
    echo "Installing vim plugin: $plugin_name"
    git clone $plugin $plugin_dir
  fi
done

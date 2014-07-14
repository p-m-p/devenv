#!/usr/bin/env bash

[ -z "$HOME_DIR" ] && HOME_DIR=~
VIM_DIR="$HOME_DIR/.vim"

vim_plugins=(
  "git@github.com:kien/ctrlp.vim.git"
  "git@github.com:tpope/vim-haml.git"
  "git@github.com:nono/vim-handlebars.git"
  "git@github.com:pangloss/vim-javascript.git"
  "git@github.com:p-m-p/snipmate.vim.git"
  "git@github.com:tpope/vim-fugitive.git"
  "git@github.com:bling/vim-airline.git"
  "git@github.com:wavded/vim-stylus.git"
  "git@github.com:vim-ruby/vim-ruby.git"
  "git@github.com:vim-scripts/VimClojure.git"
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

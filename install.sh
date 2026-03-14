#!/usr/bin/env zsh

set -e

# Dotfiles
# -------------------------------------------------------------------------------
for dotfile in ./dotfiles/*
do
  FILE_NAME=$(basename "$dotfile")
  FILE_PATH="$HOME/.$FILE_NAME"

  if [ -f "$FILE_PATH" ]; then
    echo "⚠️ $FILE_PATH exists: backing up to $FILE_PATH.bak"
    mv "$FILE_PATH" "$FILE_PATH.bak"
  fi

   cp "$dotfile" "$FILE_PATH"
done


# Xcode tools (git, gcc)
# -------------------------------------------------------------------------------
if ! type git &> /dev/null; then
  echo "🛠️ Installing Xcode developer tools..."
  xcode-select --install
fi


# Homebrew setup and bundle installation
# -------------------------------------------------------------------------------
if type brew &> /dev/null; then
  brew update
else
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_FILE="$HOME/Brewfile"

if [ ! -f "$BREW_FILE" ]; then
  echo "📦 Copying brew bundle to $BREW_FILE"
  cp ./Brewfile "$BREW_FILE"
fi

brew bundle --file="$BREW_FILE"


# Configs
# -------------------------------------------------------------------------------
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"

VIM_PLUG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$VIM_PLUG_FILE" ]; then
  echo "📦 Installing vim-plug"
  curl -fLo "$VIM_PLUG_FILE" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
  git clone https://github.com/p-m-p/nvim-config.git "$NVIM_CONFIG_DIR"
fi

VALE_DIR="$HOME/Library/Application\ Support/vale"
if [ ! -d "$TPM_DIR" ]; then
  cp -R ./vale "$VALE_DIR"
fi


# Update iTerm2 settings for Catppuccin theme and default profile
# -------------------------------------------------------------------------------
AUTO_LAUNCH_DIR="$HOME/Library/Application\ Support/iTerm2/Scripts/AutoLaunch"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application\ Support/iTerm2/DynamicProfiles"

if [ ! -d "$DYNAMIC_PROFILES_DIR" ]; then
  mkdir -p "$DYNAMIC_PROFILES_DIR"
fi
cp "./iterm2/profiles.json" "$DYNAMIC_PROFILES_DIR"

if [ ! -d "$AUTO_LAUNCH_DIR" ]; then
  mkdir -p "$AUTO_LAUNCH_DIR"
fi
cp "./iterm2/setprofile.py" "$AUTO_LAUNCH_DIR"

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

brew bundle --file=./Brewfile
echo "📦 Copying brew bundle to $HOME/Brewfile"
cp ./Brewfile "$HOME/Brewfile"


# Configs
# -------------------------------------------------------------------------------
if ! type tmux &> /dev/null; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if ! type nvim &> /dev/null; then
  git clone https://github.com/p-m-p/nvim-config.git "$HOME/.config/nvim"
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

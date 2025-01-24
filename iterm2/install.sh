#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
AUTO_LAUNCH_DIR="$HOME/Library/Application\ Support/iTerm2/Scripts/AutoLaunch"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application\ Support/iTerm2/DynamicProfiles"
ITERM_APP_DIR="/Applications/iTerm.app"

brew install --cask font-hack-nerd-font

if [ ! -d "$ITERM_APP_DIR" ]; then
  echo "Installing iTerm2"
  brew install --cask iterm2
fi

if [ ! -d "$DYNAMIC_PROFILES_DIR" ]; then
  mkdir -p "$DYNAMIC_PROFILES_DIR"
fi

cp "$SCRIPT_DIR/profiles.json" "$DYNAMIC_PROFILES_DIR"

if [ ! -d "$AUTO_LAUNCH_DIR" ]; then
  mkdir -p "$AUTO_LAUNCH_DIR"
fi

cp "$SCRIPT_DIR/setprofile.py" "$AUTO_LAUNCH_DIR"


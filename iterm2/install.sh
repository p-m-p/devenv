#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
AUTO_LAUNCH_DIR="$HOME/Library/Application\ Support/iTerm2/Scripts/AutoLaunch"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application\ Support/iTerm2/DynamicProfiles"

brew tap homebrew/cask-fonts
brew install --cask iterm2 font-hack-nerd-font

if [ ! -d "$DYNAMIC_PROFILES_DIR" ]; then
  mkdir -p "$DYNAMIC_PROFILES_DIR"
fi

cp "$SCRIPT_DIR/profiles.json" "$DYNAMIC_PROFILES_DIR"

if [ ! -d "$AUTO_LAUNCH_DIR" ]; then
  mkdir -p "$AUTO_LAUNCH_DIR"
fi

cp "$SCRIPT_DIR/setprofile" "$AUTO_LAUNCH_DIR"


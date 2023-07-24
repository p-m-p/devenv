#!/usr/bin/env zsh

source "$HOME/.zshrc"

nvm install --lts
corepack enable pnpm
SHELL=zsh pnpm setup
source "$HOME/.zshrc"
pnpm install -g commitizen cz-conventional-changelog-coauthors

sdk install java
sdk install gradle

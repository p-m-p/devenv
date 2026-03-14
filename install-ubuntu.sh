#!/usr/bin/env bash

set -e

echo "Installing development environment for Ubuntu..."

# Update package lists
sudo apt update

# Essential build tools
sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  unzip \
  software-properties-common

# Shell & Terminal
sudo apt install -y \
  zsh \
  tmux \
  lynx \
  direnv \
  fzf

# Modern CLI tools (available in apt)
sudo apt install -y \
  bat \
  ripgrep \
  jq

# Create bat symlink (Ubuntu installs as batcat)
if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
  mkdir -p ~/.local/bin
  ln -sf "$(which batcat)" ~/.local/bin/bat
fi

# Languages
sudo apt install -y \
  lua5.4 \
  liblua5.4-dev \
  luarocks \
  default-jdk \
  gradle \
  python3-pip

# Linting & Quality
sudo apt install -y \
  yamllint \
  codespell

# Containers
sudo apt install -y \
  podman \
  podman-compose

# GitHub CLI
if ! command -v gh &> /dev/null; then
  echo "Installing GitHub CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install -y gh
fi

# Neovim (latest stable)
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim..."
  sudo add-apt-repository -y ppa:neovim-ppa/stable
  sudo apt update
  sudo apt install -y neovim
fi

# eza (modern ls)
if ! command -v eza &> /dev/null; then
  echo "Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza
fi

# zoxide
if ! command -v zoxide &> /dev/null; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# lazygit
if ! command -v lazygit &> /dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
fi

# vale
if ! command -v vale &> /dev/null; then
  echo "Installing vale..."
  curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh | sh -s -- -b ~/.local/bin
fi

# selene (Lua linter)
if ! command -v selene &> /dev/null; then
  echo "Installing selene..."
  SELENE_VERSION=$(curl -s "https://api.github.com/repos/Kampfkarren/selene/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo selene.zip "https://github.com/Kampfkarren/selene/releases/latest/download/selene-${SELENE_VERSION}-linux.zip"
  unzip -o selene.zip -d ~/.local/bin
  rm selene.zip
fi

# stylua (Lua formatter)
if ! command -v stylua &> /dev/null; then
  echo "Installing stylua..."
  STYLUA_VERSION=$(curl -s "https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo stylua.zip "https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip"
  unzip -o stylua.zip -d ~/.local/bin
  rm stylua.zip
fi

# nvm (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# pnpm
if ! command -v pnpm &> /dev/null; then
  echo "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# zplug
if [ ! -d "$HOME/.zplug" ]; then
  echo "Installing zplug..."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# tmuxinator
if ! command -v tmuxinator &> /dev/null; then
  echo "Installing tmuxinator..."
  sudo gem install tmuxinator
fi

# Hack Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/HackNerdFont-Regular.ttf" ]; then
  echo "Installing Hack Nerd Font..."
  mkdir -p "$FONT_DIR"
  curl -Lo /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
  unzip -o /tmp/Hack.zip -d "$FONT_DIR"
  rm /tmp/Hack.zip
  fc-cache -fv
fi

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

echo ""
echo "Ubuntu installation complete!"
echo ""
echo "Next steps:"
echo "  1. Log out and back in for shell change to take effect"
echo "  2. Run the main install.sh to set up dotfiles and configs"
echo "  3. Install Node.js: nvm install --lts"

#!/usr/bin/env bash

set -e

# Detect OS
# -------------------------------------------------------------------------------
OS="$(uname -s)"
case "$OS" in
  Darwin)
    PLATFORM="macos"
    ;;
  Linux)
    if [ -f /etc/debian_version ]; then
      PLATFORM="debian"
    else
      echo "Unsupported Linux distribution. This script supports Debian/Ubuntu."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported operating system: $OS"
    exit 1
    ;;
esac

echo "Detected platform: $PLATFORM"
echo ""

# Dotfiles
# -------------------------------------------------------------------------------
echo "Setting up dotfiles..."
BACKUP_DIR=""

for dotfile in ./dotfiles/*; do
  FILE_NAME=$(basename "$dotfile")
  FILE_PATH="$HOME/.$FILE_NAME"

  if [ -f "$FILE_PATH" ]; then
    if [ -z "$BACKUP_DIR" ]; then
      BACKUP_DIR="./backups/$(date +%Y-%m-%d_%H-%M-%S)"
      mkdir -p "$BACKUP_DIR"
      echo "  Backing up existing dotfiles to $BACKUP_DIR"
    fi
    mv "$FILE_PATH" "$BACKUP_DIR/.$FILE_NAME"
  fi

  cp "$dotfile" "$FILE_PATH"
done
echo ""

# Platform-specific package installation
# -------------------------------------------------------------------------------
if [ "$PLATFORM" = "macos" ]; then
  # Xcode tools (git, gcc)
  if ! command -v git &> /dev/null; then
    echo "Installing Xcode developer tools..."
    xcode-select --install
  fi

  # Homebrew setup and bundle installation
  if command -v brew &> /dev/null; then
    brew update
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  BREW_FILE="$HOME/Brewfile"
  if [ ! -f "$BREW_FILE" ]; then
    echo "Copying brew bundle to $BREW_FILE"
    cp ./Brewfile "$BREW_FILE"
  fi

  brew bundle --file="$BREW_FILE"

elif [ "$PLATFORM" = "debian" ]; then
  echo "Installing packages via apt..."

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
    python3-pip \
    ruby-full \
    golang-go

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

  # Rust (needed for cargo installs)
  if ! command -v cargo &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi

  # Rust tools via cargo
  echo "Installing Rust tools via cargo..."
  command -v eza &> /dev/null || cargo install eza
  command -v zoxide &> /dev/null || cargo install zoxide
  command -v selene &> /dev/null || cargo install selene
  command -v stylua &> /dev/null || cargo install stylua
  command -v bob &> /dev/null || cargo install bob-nvim

  # Neovim (via bob for latest stable)
  export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
  if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim..."
    bob install stable
    bob use stable
  fi

  # Go tools via go install
  export PATH="$HOME/go/bin:$PATH"
  command -v lazygit &> /dev/null || go install github.com/jesseduffield/lazygit@latest
  command -v vale &> /dev/null || go install github.com/errata-ai/vale/v3/cmd/vale@latest

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
    git clone https://github.com/zplug/zplug "$HOME/.zplug"
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

  # Kiro CLI
  if ! command -v kiro &> /dev/null; then
    echo "Installing Kiro CLI..."
    curl -fsSL https://cli.kiro.dev/install | bash
  fi

  # Kiro CLI config
  if [ ! -d "$HOME/.kiro" ]; then
    echo "Setting up Kiro config..."
    mkdir -p "$HOME/.kiro/steering" "$HOME/.kiro/settings" "$HOME/.kiro/agents"
    cp ./kiro/steering/*.md "$HOME/.kiro/steering/"
    cp ./kiro/settings/*.json "$HOME/.kiro/settings/"
    cp ./kiro/agents/*.json "$HOME/.kiro/agents/"
    kiro-cli agent set-default default
  fi

  # Set zsh as default shell
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as default shell..."
    sudo chsh -s "$(which zsh)" "$(whoami)"
  fi
fi

echo ""

# Shared configs
# -------------------------------------------------------------------------------
echo "Setting up shared configs..."

# Tmux Plugin Manager
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"

# Neovim config (vim-plug and plugins auto-install on first run)
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
  echo "Cloning Neovim config..."
  git clone https://github.com/p-m-p/nvim-config.git "$NVIM_CONFIG_DIR"
fi

# Vale config (platform-specific location)
if [ "$PLATFORM" = "macos" ]; then
  VALE_DIR="$HOME/Library/Application Support/vale"
else
  VALE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/vale"
fi
if [ ! -d "$VALE_DIR" ]; then
  echo "Setting up Vale config..."
  cp -R ./vale "$VALE_DIR"
fi

# macOS-specific: iTerm2 setup
# -------------------------------------------------------------------------------
if [ "$PLATFORM" = "macos" ]; then
  echo ""
  echo "Setting up iTerm2..."

  AUTO_LAUNCH_DIR="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"
  DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

  if [ ! -d "$DYNAMIC_PROFILES_DIR" ]; then
    mkdir -p "$DYNAMIC_PROFILES_DIR"
  fi
  cp "./iterm2/profiles.json" "$DYNAMIC_PROFILES_DIR"

  if [ ! -d "$AUTO_LAUNCH_DIR" ]; then
    mkdir -p "$AUTO_LAUNCH_DIR"
  fi
  cp "./iterm2/setprofile.py" "$AUTO_LAUNCH_DIR"
fi

# Done
# -------------------------------------------------------------------------------
echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal to load the new shell config"
if [ "$PLATFORM" = "macos" ]; then
  echo "  2. Enable iTerm2 Python runtime: iTerm2 > Scripts > Manage > Install Python Runtime"
fi

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

# Backup directory for this run
BACKUP_DIR=""

backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    if [ -z "$BACKUP_DIR" ]; then
      BACKUP_DIR="./backups/$(date +%Y-%m-%d_%H-%M-%S)"
      mkdir -p "$BACKUP_DIR"
      echo "  Backing up existing files to $BACKUP_DIR"
    fi
    cp "$file" "$BACKUP_DIR/$(basename "$file")"
  fi
}

backup_dir() {
  local dir="$1"
  if [ -d "$dir" ]; then
    if [ -z "$BACKUP_DIR" ]; then
      BACKUP_DIR="./backups/$(date +%Y-%m-%d_%H-%M-%S)"
      mkdir -p "$BACKUP_DIR"
      echo "  Backing up existing files to $BACKUP_DIR"
    fi
    cp -R "$dir" "$BACKUP_DIR/"
  fi
}

# Dotfiles
# -------------------------------------------------------------------------------
echo "Setting up dotfiles..."
for dotfile in ./dotfiles/*; do
  FILE_NAME=$(basename "$dotfile")
  FILE_PATH="$HOME/.$FILE_NAME"
  backup_file "$FILE_PATH"
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

  # Brewfile
  echo "Syncing Brewfile..."
  backup_file "$HOME/Brewfile"
  cp ./Brewfile "$HOME/Brewfile"
  brew bundle --file="$HOME/Brewfile"

  # Claude Code config
  echo "Setting up Claude Code config..."
  mkdir -p "$HOME/.claude"
  backup_file "$HOME/.claude/settings.json"
  backup_file "$HOME/.claude/CLAUDE.md"
  backup_file "$HOME/.claude.json"
  cp ./claude-code/settings.json "$HOME/.claude/settings.json"
  cp ./claude-code/CLAUDE.md "$HOME/.claude/CLAUDE.md"
  cp ./claude-code/mcp.json "$HOME/.claude.json"

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
  if ! command -v kiro-cli &> /dev/null; then
    echo "Installing Kiro CLI..."
    curl -fsSL https://cli.kiro.dev/install | bash
    export PATH="$HOME/.local/bin:$PATH"
  fi

  # Kiro CLI config
  echo "Setting up Kiro config..."
  backup_dir "$HOME/.kiro/steering"
  backup_dir "$HOME/.kiro/settings"
  backup_dir "$HOME/.kiro/agents"
  mkdir -p "$HOME/.kiro/steering" "$HOME/.kiro/settings" "$HOME/.kiro/agents"
  cp ./kiro/steering/*.md "$HOME/.kiro/steering/"
  cp ./kiro/settings/*.json "$HOME/.kiro/settings/"
  cp ./kiro/agents/*.json "$HOME/.kiro/agents/"

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
echo "Setting up Vale config..."
backup_dir "$VALE_DIR"
cp -R ./vale "$VALE_DIR"

# Bat config (Catppuccin theme)
# On Ubuntu, bat is installed as batcat - use symlink or batcat directly
if command -v bat &> /dev/null; then
  BAT_CMD="bat"
elif [ -x "$HOME/.local/bin/bat" ]; then
  BAT_CMD="$HOME/.local/bin/bat"
elif command -v batcat &> /dev/null; then
  BAT_CMD="batcat"
else
  BAT_CMD=""
fi

if [ -n "$BAT_CMD" ]; then
  BAT_CONFIG_DIR="$($BAT_CMD --config-dir 2>/dev/null || echo "$HOME/.config/bat")"
  echo "Setting up bat config..."
  backup_file "$BAT_CONFIG_DIR/config"
  backup_dir "$BAT_CONFIG_DIR/themes"
  mkdir -p "$BAT_CONFIG_DIR/themes"
  cp ./bat/config "$BAT_CONFIG_DIR/config"
  cp ./bat/themes/*.tmTheme "$BAT_CONFIG_DIR/themes/"
  $BAT_CMD cache --build
fi

# macOS-specific: iTerm2 setup
# -------------------------------------------------------------------------------
if [ "$PLATFORM" = "macos" ]; then
  echo ""
  echo "Setting up iTerm2..."

  AUTO_LAUNCH_DIR="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"
  DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

  mkdir -p "$DYNAMIC_PROFILES_DIR" "$AUTO_LAUNCH_DIR"
  backup_file "$DYNAMIC_PROFILES_DIR/profiles.json"
  backup_file "$AUTO_LAUNCH_DIR/setprofile.py"
  cp "./iterm2/profiles.json" "$DYNAMIC_PROFILES_DIR"
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

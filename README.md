# devenv

Personal development environment setup. One script to bootstrap a fresh machine with all tools, configs, and themes.

## Quick Start

### macOS

```bash
git clone https://github.com/p-m-p/devenv.git
cd devenv
./install.sh
```

### Ubuntu

```bash
git clone https://github.com/p-m-p/devenv.git
cd devenv
./install-ubuntu.sh  # Install packages
./install.sh         # Set up dotfiles and configs
```

## What's Included

### Applications

| App | Description |
|-----|-------------|
| iTerm2 | Terminal emulator with Catppuccin Mocha theme |
| Podman Desktop | Container management |
| 1Password | Password manager + CLI |
| Google Chrome | Browser |

### CLI Tools

| Tool | Description |
|------|-------------|
| `bat` | Syntax-highlighted `cat` replacement |
| `eza` | Modern `ls` with icons |
| `ripgrep` | Fast text search |
| `fzf` | Fuzzy finder |
| `zoxide` | Smarter `cd` that learns your habits |
| `lazygit` | Git TUI |
| `jq` | JSON processor |
| `direnv` | Directory-specific environment variables |

### Development

| Tool | Description |
|------|-------------|
| Neovim | Editor ([my config](https://github.com/p-m-p/nvim-config)) |
| Node.js | Via nvm with pnpm |
| Java + Gradle | JDK and build tool |
| Lua | With luarocks, selene, stylua |
| Podman | Container runtime (aliased to `docker`) |

### Shell

- **Zsh** with zplug plugin manager
- **Pure** prompt with Catppuccin Mocha colors
- Plugins: autosuggestions, syntax highlighting, vi-mode, history substring search

### Tmux

- Prefix: `Ctrl-A`
- Vi-mode navigation (`hjkl`)
- Mouse enabled
- Catppuccin theme with CPU and battery status
- Plugins auto-install on setup

## Dotfiles

The installer copies these to your home directory:

| File | Purpose |
|------|---------|
| `.zshrc` | Shell config, aliases, plugins |
| `.gitconfig` | Git settings and aliases |
| `.tmux.conf` | Tmux configuration |
| `.editorconfig` | Editor formatting rules |
| `.nvmrc` | Node.js LTS version |
| `.gitignore` | Global git ignores |
| `.czrc` | Commitizen config |

## Shell Aliases

```bash
docker → podman
mux    → tmuxinator
pc     → podman-compose
cat    → bat
ls     → eza
ll     → eza -la
tree   → eza --tree
```

## iTerm2 Setup (macOS)

After installation, enable the Python runtime in iTerm2 for the auto-profile script:

**iTerm2 → Scripts → Manage → Install Python Runtime**

This automatically sets Catppuccin Mocha as the default profile.

## Post-Install

1. Restart your terminal to load the new shell config
2. Run `zplug install` if prompted to install zsh plugins
3. Open Neovim and run `:PlugInstall` for editor plugins

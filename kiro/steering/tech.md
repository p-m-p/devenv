# Tech Stack

## Languages & Runtimes
- Node.js (via nvm, package manager: pnpm)
- Lua 5.4 (with luarocks, selene for linting, stylua for formatting)
- Go (tools via go install)
- Rust (tools via cargo)
- Java (default-jdk with Gradle)

## Editor & Tools
- Neovim with vim-plug (auto-installs plugins)
- Tmux with TPM plugin manager
- Zsh with zplug

## CLI Replacements
- `bat` instead of cat (with Catppuccin theme)
- `eza` instead of ls
- `zoxide` replaces cd
- `ripgrep` for search
- `delta` for git diffs
- `glow` for rendering markdown
- `fzf` for fuzzy finding

## Containers
- Podman (not Docker) - use `podman` and `podman-compose`
- Alias: `docker` → `podman`, `pc` → `podman-compose`

## Linting & Quality
- vale for prose
- selene for Lua
- stylua for Lua formatting
- yamllint, codespell

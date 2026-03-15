# LSP Servers

## TypeScript / JavaScript
- Server: `typescript-language-server`
- Install: `npm install -g typescript-language-server typescript`
- Config: Uses tsconfig.json / jsconfig.json

## Lua
- Server: `lua-language-server`
- Linting: `selene` (installed via cargo)
- Formatting: `stylua` (installed via cargo)
- Config: .luarc.json, selene.toml, stylua.toml

## Go
- Server: `gopls`
- Install: `go install golang.org/x/tools/gopls@latest`
- Formatting: `gofmt` / `goimports`

## Python
- Server: `pyright` or `pylsp`
- Install: `npm install -g pyright` or `pip install python-lsp-server`
- Formatting: `black`, `ruff`
- Linting: `ruff`, `pylint`

## Ruby
- Server: `solargraph`
- Install: `gem install solargraph`
- Config: .solargraph.yml

## Java
- Server: `jdtls` (Eclipse JDT Language Server)
- Build: Gradle (preferred), Maven
- Config: build.gradle, settings.gradle

## JSON / YAML
- JSON: `vscode-json-languageserver`
- YAML: `yaml-language-server`
- Install: `npm install -g vscode-langservers-extracted yaml-language-server`

## Bash
- Server: `bash-language-server`
- Install: `npm install -g bash-language-server`
- Linting: `shellcheck`

## General
- Use Mason in Neovim to manage LSP server installations
- Format on save when available
- Prefer project-local configs over global

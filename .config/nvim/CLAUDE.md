# CLAUDE.md - Neovim Config

## Overview

Barebones Neovim config using **lazy.nvim** as the plugin manager (not the LazyVim distro). Every line is intentional.

## Architecture

```
init.lua              → Entry point: leaders, options, lazy bootstrap
lua/config/
  options.lua         → All vim options, devserver detection, OSC 52 clipboard
  lazy.lua            → lazy.nvim bootstrap + VeryLazy loader for keymaps/autocmds
  keymaps.lua         → All keymaps (loaded on VeryLazy)
  autocmds.lua        → Autocmds, diagnostics config, LSP keymaps (loaded on VeryLazy)
lua/plugins/
  colorscheme.lua     → Catppuccin Mocha
  ui.lua              → lualine, which-key, bufferline, mini.icons
  treesitter.lua      → nvim-treesitter + textobjects (keymaps set manually)
  editor.lua          → gitsigns, mini.pairs, mini.ai, conform.nvim
  lsp.lua             → nvim-lspconfig + lazydev (disabled on devserver)
  completion.lua      → blink.cmp
  meta.lua            → meta.nvim (devserver only)
```

## Key Design Decisions

### Devserver detection
`vim.g.is_devserver` is set in `options.lua` by checking for `/usr/share/fb-editor-support/nvim`. Used throughout config to conditionally load plugins.

### LSP split
- **Mac**: `nvim-lspconfig` + `vim.lsp.config()` / `vim.lsp.enable()` (Neovim 0.11 native API). Servers installed manually via brew/pip/npm.
- **Devserver**: `nvim-lspconfig` disabled entirely. `meta.nvim` provides LSP via `require("meta.lsp")`.
- **Shared**: LSP keymaps (`gd`, `gr`, `K`, etc.) live in `autocmds.lua` via `LspAttach`, so they work on both platforms.

### Formatting
- **Mac**: conform.nvim with `stylua`, `shfmt`.
- **Devserver**: conform.nvim's `formatters_by_ft` is empty; `<leader>cf` falls back to LSP format (linttool@meta).

### Treesitter
Uses nvim-treesitter v1.x (new API). Highlighting/indent are native Neovim features. The plugin handles parser installation only (`:TSInstall`). Textobjects keymaps are set up manually in `treesitter.lua` using the new `nvim-treesitter-textobjects` API.

## Adding an LSP server

```lua
-- In lua/plugins/lsp.lua, inside the config function:
vim.lsp.config("server_name", { settings = { ... } })
vim.lsp.enable("server_name")
```

## Adding a plugin

Create a new file in `lua/plugins/` or add to an existing one. Return a lazy.nvim plugin spec table.

## Important keybindings

- `<leader>l` → Lazy plugin manager
- `<leader>cf` → Format file
- `<leader>ca` → Code action
- `gd` / `gr` / `K` → LSP goto def / references / hover
- `]f` / `[f` → Next/prev function
- `]h` / `[h` → Next/prev git hunk

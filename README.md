# Dotfiles

Personal configuration files for a terminal-centric development workflow.

## Philosophy

### Terminal-First

Use a terminal for everything. IDEs come and go - investing in terminal-based tools provides longevity and consistency. Zed is kept as a lightweight backup for quick notes and clipboard space, but the primary workflow lives in the terminal.

### Terminal Emulator Agnostic

Tmux and Neovim are the core tools, not the terminal emulator. Today it's Ghostty, tomorrow it may be WezTerm, iTerm2, or something else entirely. The terminal emulator is just a window - the real environment lives in tmux.

### Consistent Environment

Muscle memory matters. The environment is designed for predictable, shortcut-driven navigation:

- **OS level**: Tiling layouts defined in Raycast config
- **Terminal level**: Tmux sessions, windows, and panes with consistent naming
- **Editor level**: Neovim with predictable keybindings

The goal is to reach any context quickly without conscious thought.

### Remote Work Persistence

Tmux on remote servers preserves work even when connections drop. The `devmain` command connects via `et` (Eternal Terminal) and attaches to a persistent tmux session. Tmux plugins (resurrect, continuum) preserve state across restarts.

### Minimal Plugins, Manual Setup

Prefer understanding over convenience:

- **Zsh**: Hand-rolled config with only what's needed. No Oh My Zsh bloat.
- **Tmux**: Using Oh My Tmux while learning, with plans to minimize once comfortable.
- **Neovim**: Using LazyVim as a starting point while getting familiar with Neovim.

The goal is to eventually understand and own every line of configuration.

### Keyboard-Optimized, Mouse-Allowed

Optimized for hands on keyboard, but mouse actions remain enabled to maintain productivity while learning. Example: tmux allows mouse dragging to resize panes. As muscle memory develops, mouse usage naturally decreases.

## Setup

### Local Machine

```bash
./init.sh
```

This script is ephemeral and runs only on the local machine. It bootstraps the initial setup.

### Remote/Dev Servers

Configs are **not** automatically synced to dev servers. Instead:

1. Manually copy relevant configs to the dev server
2. Adjust as needed for the server environment
3. Use `dotsync2` to sync dotfiles across other internal servers and on-demands

This separation keeps work and personal configs distinct and allows for environment-specific adjustments.

## Structure

```
~/.config/
  ghostty/config     # Terminal emulator
  tmux/              # Tmux (via Oh My Tmux)
  nvim/              # Neovim (via LazyVim)

~/.zshrc             # Shell config
~/.starship.toml     # Prompt
```

## Theme

Catppuccin Mocha across all tools for visual consistency.

# Dotfiles

> A terminal-centric development environment built for speed, consistency, and longevity.

## Why Terminal-First?

IDEs come and go. Atom, Sublime, VS Code - the landscape shifts every few years, and rebuilding muscle memory is expensive.

Terminal tools stick around. Vim has been here since 1991. Tmux since 2007. By investing in terminal-based tools, this setup prioritizes **longevity over novelty**.

That said, pragmatism wins. Zed lives on the machine as a lightweight escape hatch - useful for quick notes, scratch space, or when a GUI is just easier.

## The Stack

### Ghostty (for now)

The terminal emulator is deliberately treated as disposable. Today it's Ghostty. Tomorrow it might be Warp, WezTerm, or something else.

The real environment lives *inside* tmux - the emulator is just a viewport.

### Tmux

Tmux is the backbone. It provides:

- **Persistence**: SSH drops? The session lives on.
- **Portability**: Same workflow on a MacBook, Linux workstation, or remote server.
- **Organization**: Sessions for projects, windows for contexts, panes for tasks.

The `devmain` command connects to remote dev servers via `et` (Eternal Terminal) and attaches to a persistent tmux session. Work survives network hiccups, VPN reconnects, and laptop lid closes.

Plugins: `tmux-resurrect` and `tmux-continuum` handle state persistence across restarts.

### Neovim

Neovim for everything. Currently running LazyVim as a starting point while building fluency. The goal is to eventually understand every line and strip it down to essentials.

### Zsh

Hand-rolled `.zshrc` with only what's needed. No Oh My Zsh, no bloated frameworks. Just:

- Syntax highlighting
- Autosuggestions
- History substring search
- fzf integration
- Starship prompt

Every line exists for a reason.

## Philosophy

### Consistency is Velocity

The environment is designed for predictable, shortcut-driven navigation:

| Layer | Tool | Purpose |
|-------|------|---------|
| OS | Raycast | Window tiling, app launching, snippets |
| Terminal | Tmux | Session/window/pane management |
| Editor | Neovim | Code editing, file navigation |

Same keybindings. Same layouts. Same mental model - whether at home or SSH'd into a remote server. Muscle memory compounds.

### Keyboard-First, Mouse-Allowed

Optimized for hands on keyboard, but the mouse isn't disabled. Dragging tmux pane borders? Sure. Clicking a link? Go for it.

Productivity today matters. As keyboard fluency grows, mouse usage naturally fades.

### Learn by Owning

Prefer understanding over convenience:

- **Zsh**: No frameworks. Just raw config.
- **Tmux**: Using Oh My Tmux as scaffolding while learning. Will minimize once fluent.
- **Neovim**: LazyVim as a starting point. Gradual customization as understanding deepens.

The goal is to eventually own every line of configuration.

## The Bare Repo Trick

These dotfiles use the **bare git repository** pattern - no symlinks, no stow, no complex tooling.

The idea: create a bare git repo and set the work tree to `$HOME`. This lets you version control files exactly where they live, without polluting your home directory with a `.git` folder.

```bash
# The alias
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"

# Use it like normal git
config add ~/.zshrc
config commit -m "Update shell config"
config push
```

### Why Bare Repo?

- **No symlinks**: Files live in their real locations. No `~/.zshrc -> ~/.dotfiles/.zshrc` indirection.
- **No dependencies**: Just git. No stow, no chezmoi, no dotbot.
- **Selective tracking**: Only track what you want. The rest of `$HOME` is ignored.
- **Familiar workflow**: It's just git with different flags.

### Setup on a New Machine

```bash
git clone --bare <repo-url> $HOME/github/.dotfiles
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
config checkout
config config --local status.showUntrackedFiles no
```

The last line tells git to stop showing the thousands of untracked files in your home directory.

## Setup

### Local Machine

```bash
./init.sh
```

This script is ephemeral. Run it once on a fresh machine to bootstrap Homebrew, clone repos, and set up initial state. Designed to run locally, not on servers.

### Remote/Dev Servers

Configs are **intentionally not auto-synced** to dev servers. The workflow:

1. Manually copy the configs that make sense for server environments
2. Adjust as needed (servers have different needs than laptops)
3. Use `dotsync2` to propagate across other internal servers and on-demands

This keeps personal and work configs appropriately separated.

## Theme

**Catppuccin Mocha** everywhere - terminal, tmux, Neovim. One palette, zero context-switching friction.

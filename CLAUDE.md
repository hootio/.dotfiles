# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a **dotfiles repository** using the bare git repo pattern. The primary purpose of Claude here is to help maintain and improve the dotfiles configuration. The working directory is `$HOME`, but only specific files are tracked.

## Important: File Modification Policy

**Tracked files** (listed below): Modify freely as requested.

**Untracked files**: Always ask for confirmation before creating or modifying. Since the working directory is `$HOME`, most files are untracked and unrelated to dotfiles work.

## Tracked Files

```
.config/ghostty/config
.config/karabiner/karabiner.json
.config/nvim/.gitignore
.config/nvim/.neoconf.json
.config/nvim/init.lua
.config/nvim/lazyvim.json
.config/nvim/lua/config/autocmds.lua
.config/nvim/lua/config/keymaps.lua
.config/nvim/lua/config/lazy.lua
.config/nvim/lua/config/options.lua
.config/nvim/lua/plugins/example.lua
.config/nvim/stylua.toml
.config/tmux/tmux.conf.local
.config/weechat/irc.conf
.starship.toml
.zprofile
.zshenv
.zshrc
Brewfile
README.md
init.sh
keychron_k11_max_ansi_rgb_knob.layout.json
raycast.rayconfig
```

## Dotfiles Commands

The `config` alias manages the bare git repo:

```bash
config status                    # Check dotfiles status
config diff                      # See changes
config add <file>                # Stage a file
config commit -m "message"       # Commit
config push                      # Push to origin
config ls-files                  # List all tracked files
```

## Philosophy (Respect These)

1. **Terminal-first**: Tmux and Neovim are the core tools. The terminal emulator is just a viewport.

2. **Minimal, understood config**: Every line should exist for a reason. No bloated frameworks. Currently using Oh My Tmux and LazyVim as scaffolding while learning—goal is to eventually own every line.

3. **No symlinks**: Files live in their real locations via bare git repo. No stow, no dotbot.

4. **Catppuccin Mocha**: Consistent theme across all tools.

5. **Keyboard-first, mouse-allowed**: Optimize for keyboard, but don't disable mouse functionality.

## Key Configuration Notes

### Zsh (`~/.zshrc`)
- Emacs keybindings (`bindkey -e`)
- `KEYTIMEOUT=1` for responsive escape handling
- Plugins via Homebrew: fzf, zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search
- Starship prompt

### Ghostty (`~/.config/ghostty/config`)
- `macos-option-as-alt = true`
- `cmd+enter` and `shift+enter` send newline
- Shift+Cmd+Click to open links (bypasses tmux mouse capture)

### Tmux (`~/.config/tmux/tmux.conf.local`)
- Uses Oh My Tmux (base config at `~/.config/tmux/tmux.conf`)
- Mouse enabled
- Vi mode for copy
- Extended keys enabled for Ghostty: `terminal-features 'xterm-ghostty:clipboard:bracketed-paste:extkeys'`
- Plugins: tmux-resurrect, tmux-continuum

### Neovim (`~/.config/nvim/`)
- LazyVim-based
- Add plugins in `lua/plugins/` directory
- Colorscheme: Catppuccin Mocha (in `lua/plugins/colorscheme.lua`)

## Setup Commands

```bash
./init.sh              # Bootstrap new machine (macOS only)
./init.sh cleanup      # Remove all dotfiles (destructive)
```

## Remote Connection

```bash
devmain <YUBIKEY_OTP>  # Connect to hooti.sb with persistent tmux session
sesh                   # Local tmux session (rakhsh)
```

# plugins #
source <(fzf --zsh)
BREW_PREFIX="$(brew --prefix)"
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh


# configs #
export EDITOR="nvim"
bindkey -e    # use emacs keybindings (override zsh auto-vi-mode from EDITOR=nvim)
KEYTIMEOUT=1  # reduce escape sequence timeout (10ms) for responsive arrow keys after Esc
bindkey '^[' send-break  # make standalone Escape cancel instead of waiting for meta-sequence
# Re-bound below (after the tmux pane-state block defines _tps_ack) so Escape
# also acknowledges a finished command. Kept here so the plain binding still
# applies outside tmux, where _tps_ack is never defined.
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# turn on default zsh completions (refreshes cache weekly for speed)
autoload -Uz compinit
if [[ ! -f ~/.zcompdump ]] || [[ -n ~/.zcompdump(#qN.mw+1) ]]; then
  compinit
else
  compinit -C
fi
# use case-insensitive if case-sensitive result not found. ex: ls desk<tab>
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# immediately launches select menu without asking for confirmation. ex: rsync -<tab>
zstyle ':completion:*' menu yes select
# behave like bash for word style, affecting option+arrow navigation
autoload -Uz select-word-style && select-word-style bash

ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# --- tmux pane state ----------------------------------------------------------
# Pushes real command lifecycle into the tmux status dot. This is the generic
# layer: any command, no timeouts, and the exit code is the actual $?.
#
# tmux cannot do this itself -- it only sees the exit status of a pane's OWN
# process, so `sh -c "exit 1"` (a child of this shell) is invisible to it.
#
# No acknowledgement logic here on purpose: agent-state.sh clears ok/fail on the
# pane you are looking at, which keeps this hook free of a per-prompt tmux call.
if [[ -n "$TMUX" ]]; then
  _tps_ran=0
  _tps_preexec() { _tps_ran=1; ~/.tmux/pane-state.sh working }
  _tps_precmd() {
    local rc=$?
    (( _tps_ran )) || return
    _tps_ran=0
    (( rc == 0 )) && ~/.tmux/pane-state.sh ok || ~/.tmux/pane-state.sh fail
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _tps_preexec
  add-zsh-hook precmd  _tps_precmd

  # Escape acknowledges a finished result, clearing the tab back to gray.
  # Deliberate beats automatic here: clearing on view would wipe the dot the
  # instant you glance at a window, even when you looked, decided to come back
  # later, and still want the reminder. This only fires when you actively
  # dismiss the prompt in that pane.
  # Wraps the existing `bindkey '^[' send-break` rather than replacing it.
  _tps_ack() { ~/.tmux/pane-state.sh idle; zle send-break }
  zle -N _tps_ack
  bindkey '^[' _tps_ack
fi


# prompt #
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/.starship.toml


# aliases #
alias l="ls -al --color"
alias ll=l
alias v=nvim
alias vi=nvim
alias vim=nvim
alias grep=rg
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gl="git log"
alias gp="git push"
alias gs="git status"
alias config="git --git-dir=$HOME/github/.dotfiles/ --work-tree=$HOME"
compdef config=git
# glow only reads its config from ~/Library/Preferences on macOS and ignores
# --config when rendering, so pass the theme and pager as flags instead
alias glow='glow -ps ~/.config/glow/catppuccin-mocha.json'
# tmux can leave a stale socket behind when a server dies, after which every new
# session fails with "server exited unexpectedly". Remove it, but only when no
# tmux process is running at all -- unlinking a live server's socket orphans it.
TMUX_RMSTALE='s="${TMUX_TMPDIR:-/tmp}/tmux-$(id -u)/default"; [ -S "$s" ] && ! pgrep -u "$(id -u)" tmux >/dev/null 2>&1 && rm -f "$s"; true'
tmux_rmstale() { sh -c "$TMUX_RMSTALE" }
devmain() {
  if [ -z "$1" ]; then
    echo "Usage: devmain <YUBIKEY_OTP>"
    return 1
  fi
  dev connect -n hooti.sb -y "$1" -- sh -c "$TMUX_RMSTALE; exec tmux new-session -A -s hooti-sb"
  stty sane
}
odmain() {
  if [ -z "$1" ]; then
    echo "Usage: odmain <YUBIKEY_OTP>"
    return 1
  fi
  dev connect -t www_fbsource_configerator -y "$1" -- sh -c "sudo ondemand-idle-checks disable; $TMUX_RMSTALE; TERM=xterm-256color SHELL=/bin/zsh exec tmux new-session -A -s hooti-od"
  stty sane
}
sesh() { tmux_rmstale; tmux new-session -A -s rakhsh }

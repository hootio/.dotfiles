#!/bin/bash
# pane-state.sh — set one pane's state. The single writer used by every producer:
# zsh preexec/precmd (generic commands) and Claude/Codex hooks (agent turns).
#
#   working   something is running                        -> peach
#   waiting   agent finished its turn / wants input       -> green
#   ok        last command exited 0, not yet seen         -> green
#   fail      last command exited non-zero, not yet seen  -> red
#   idle      shell prompt, nothing pending               -> blank
#
# waiting/ok/fail are ACKNOWLEDGEABLE: they describe something that already
# happened and you have not looked at yet, so viewing the pane clears them
# (pane-focus-in hook in tmux.conf). working/idle are live state and are never
# cleared by looking -- that distinction is what stops "click on, click off"
# from changing anything real.
#
# Usage: pane-state.sh <state> [pane]
# Pane defaults to $TMUX_PANE, which is exported into agent hook subprocesses.

[ -z "${TMUX:-}" ] && exit 0
state="${1:-}"
pane="${2:-${TMUX_PANE:-}}"
[ -z "$state" ] || [ -z "$pane" ] && exit 0

case "$state" in
  working|waiting|ok|fail|idle) ;;
  *) exit 0 ;;
esac

tmux set-option -p -q -t "$pane" @pstate "$state" 2>/dev/null
exit 0

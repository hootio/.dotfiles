#!/bin/bash
# agent-state.sh — reduce per-pane @pstate into a per-window @state for the
# status bar. Runs once per status-interval from status-right.
#
# THIS NO LONGER GUESSES. The first version inferred state from output silence,
# which was wrong twice: `focus-events on` makes an app repaint when you leave a
# window, resetting the silence clock so a stale window looked busy for 60s; and
# silence cannot distinguish "thinking" from "blocked on input" anyway. State is
# now pushed by the things that actually know -- zsh preexec/precmd for commands
# (real exit codes, no timeout) and Claude/Codex hooks for agent turns.
#
# WHY EXIT CODES NEED THE SHELL, NOT TMUX. tmux only knows the exit status of a
# pane's OWN process. `sh -c "exit 1"` is a child of your shell; the shell
# survives, the pane never dies, and pane_dead stays 0. So `remain-on-exit
# failed` can only catch you exiting the shell itself -- it cannot see the build
# you just ran. precmd can, because it reads $?.
#
# PRECEDENCE, most consequential first: fail > ok|waiting > working > idle.
# A window is red if any pane failed, green if any pane is done or wants input,
# peach only when everything running is still running.
#
# Panes with no @pstate (spawned before this was installed, or never ran a
# command) fall back to a coarse guess so the bar is never blank by accident.
#
# NOTHING IS CLEARED BY LOOKING. A completed result stays on the tab until the
# next command in that pane replaces it -- ok/fail persist through you visiting
# the window, leaving it, and coming back. Viewing a pane changes no state at
# all, which is the whole point.
#
# The tradeoff, accepted deliberately: a pane that finished an hour ago still
# shows green, so in a multi-pane window a stale success can outrank a sibling
# that is still working. Run anything in that pane and it clears.
#
# THE REDUCE IS IN AWK, NOT BASH. The original used `declare -A`, which needs
# bash 4+. macOS ships bash 3.2 at /bin/bash and has no newer one unless you
# install it, so the associative arrays would have failed here -- and failed
# quietly, since this runs inside #() where stderr is discarded and the only
# symptom is a status bar whose dots never change. awk has associative arrays
# natively, so one implementation now works on both machines.

set -u

# '|' separated: pane_dead_status is EMPTY on a live pane, so a space-separated
# read silently shifts every later field and misclassifies everything.
tmux list-panes -a -F '#{session_name}:#{window_index}|#{@pstate}|#{pane_dead}|#{pane_dead_status}|#{pane_current_command}' 2>/dev/null |
awk -F'|' '
  function rank(s) {
    if (s == "fail")                 return 3
    if (s == "ok" || s == "waiting") return 2
    if (s == "working")              return 1
    return 0
  }
  {
    win = $1; pstate = $2; dead = $3; deadstatus = $4; cmd = $5
    if (win == "") next
    if (pstate == "") {
      if (dead == "1" && deadstatus != "" && deadstatus != "0") {
        pstate = "fail"
      } else if (cmd == "sh" || cmd == "bash" || cmd == "zsh" || \
                 cmd == "fish" || cmd == "tmux" || cmd == "") {
        pstate = "idle"
      } else {
        pstate = "working"
      }
    }
    r = rank(pstate)
    if (!(win in bestrank) || r > bestrank[win]) {
      bestrank[win] = r
      best[win] = pstate
    }
  }
  END { for (w in best) print w "|" best[w] }
' |
while IFS='|' read -r win state; do
  [ -z "$win" ] && continue
  # ok and waiting have different causes but the same meaning to you -- "this
  # one wants attention" -- so they collapse to one colour.
  case "$state" in
    ok|waiting) state=ready ;;
  esac
  prev=$(tmux show-options -wqv -t "$win" @state 2>/dev/null)
  # Only write on change: every set-option triggers a status redraw.
  [ "$prev" = "$state" ] || tmux set-option -w -q -t "$win" @state "$state" 2>/dev/null
done

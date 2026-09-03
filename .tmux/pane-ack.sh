#!/bin/bash
# pane-ack.sh — intentional no-op, kept only as a 127 guard.
#
# Acknowledgement moved into agent-state.sh (pane-focus-in is pane-scoped, so a
# global set-hook silently does nothing and per-pane registration misses panes
# created later). A stale `pane-focus-in` hook registered during that debugging
# survived both deleting this file and editing tmux.conf -- live hooks live in
# the tmux server, and `source-file` only adds, never removes -- so every focus
# change ran a missing script, returned 127, and broke status rendering until a
# redraw. Cheaper to keep an empty file than to hunt a hook that may be
# registered somewhere not visible to show-hooks.
exit 0

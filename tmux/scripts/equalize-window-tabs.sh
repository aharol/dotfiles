#!/bin/sh
# Pads/truncates every window tab to the length of the longest window name
# currently open in the session, so tabs line up instead of each being sized
# to its own name. Re-run via hooks (window-linked/window-renamed/
# window-unlinked) whenever the window list changes, so the reference width
# stays current.

session="$1"

width=$(tmux list-windows -t "$session" -F '#{window_name}' | awk '{ if (length($0) > m) m = length($0) } END { print m + 0 }')
[ "$width" -lt 1 ] 2>/dev/null && width=1

# These are window options: targeting only a session changes its current
# window, not every tab. Set both formats explicitly on each window.
tmux list-windows -t "$session" -F '#{window_id}' | while IFS= read -r window; do
    tmux set-option -w -t "$window" window-status-format "#[fg=#11111b,bg=#{@thm_overlay_2}] #I #[fg=#cdd6f4,bg=#{@thm_surface_0}] #{p${width}:#{=${width}:#{window_name}}} "
    tmux set-option -w -t "$window" window-status-current-format "#[fg=#11111b,bg=#{@thm_mauve}] #I #[fg=#cdd6f4,bg=#{@thm_surface_1}] #{p${width}:#{=${width}:#{window_name}}} "
done

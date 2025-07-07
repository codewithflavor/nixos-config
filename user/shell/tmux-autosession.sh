#!/usr/bin/env bash

SESSION="dashboard"

# Check if session exists
tmux has-session -t "$SESSION" 2>/dev/null

if [ $? != 0 ]; then
    # Create session and split panes
    tmux new-session -d -s "$SESSION" 'btop'      # Left column: btop
    tmux split-window -h -t "$SESSION"            # Right column
    tmux split-window -v -t "$SESSION:0.1"        # Split bottom half of right column
fi

# Attach to the session
tmux attach -t "$SESSION"

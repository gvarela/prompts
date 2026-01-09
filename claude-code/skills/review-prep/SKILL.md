---
name: review-prep
description: Interactive code review walkthrough using tmux and nvim for pair programming style review. Use when reviewing changes, preparing for PR review, or walking through a diff with the user.
---

# Code Review Prep

Interactive walkthrough of changes as pair programming. Opens files in nvim pane, highlights code, waits for questions.

## Setup

1. Check for nvim pane in tmux, create vertical split if needed
2. Get diff (default: last commit, or accept commit range as argument)
3. Parse into logical changes with file:line

## Start Review

State the problem(s) being solved (1-2 max, more is a code smell).
Map each change to which problem it addresses.

## For Each Change

1. Open file at line in nvim pane
2. Highlight the changed code using visual mode
3. Focus nvim pane so user can inspect
4. Give ONE line context: "Change X/N - Problem Y. [brief description]"
5. Wait for questions

## Navigation

- `next` / `back` - move between changes
- `done` - wrap up review
- Ask to see related code - opens it

## Conversation Style

- Short, pithy responses - one or two lines max
- Wait for questions, don't front-load explanation
- Answer directly, then offer: "want to see X?"
- Bounce up/down abstraction layers on request

## Tmux Helpers

```bash
# Find or create nvim pane
NVIM_PANE=$(tmux list-panes -F "#{pane_id} #{pane_current_command}" | grep nvim | awk '{print $1}')
if [ -z "$NVIM_PANE" ]; then
  tmux split-window -h "nvim"
  sleep 0.5
  NVIM_PANE=$(tmux list-panes -F "#{pane_id} #{pane_current_command}" | grep nvim | awk '{print $1}')
fi

# Open file at line
tmux send-keys -t $NVIM_PANE Escape ":e +LINE FILE" Enter

# Focus pane
tmux select-pane -t $NVIM_PANE
```

## Code Smell Flags

- More than 2-3 problems per diff
- Change doesn't map to stated problem
- Same pattern repeated without extraction (discuss, don't mandate)

if command -v tmux &> /dev/null; then
  if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    tmux new-session -A -s ssh
  fi
fi

# .bashrc
TMUX_CMD="tmux -f $HOME/.config/tmux/tmux.conf"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load bash completion if available
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Initialize starship prompt
eval "$(starship init bash)"  # Use fancy prompt

# Enable fzf (fuzzy finder) if installed
if command -v fzf >/dev/null 2>&1; then
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

# Enable zoxide (smart cd replacement)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# Display system info at shell start
if command -v neofetch >/dev/null 2>&1; then
  neofetch
fi

# Aliases for common commands
alias ls='exa -alh --icons'         # Better ls
alias ll='exa -lah --icons'         # Long list
alias cat='bat --paging=never'      # Colorful cat
alias grep='rg'                     # Use ripgrep
alias cd='z'                        # Use zoxide
alias ..='cd ..'
alias ...='cd ../..'
alias tmux='tmux -2u'               # UTF-8 and 256 color
alias update='sudo xbps-install -Su'  # System update
alias upgrade='sudo xbps-install -u'  # Upgrade all packages
alias tms='tmuxterm -s'
alias tmu='tmuxterm --new'

# Git aliases
alias gp='git pull'
alias gf='git fetch'
alias gs='git status'
alias gh='git push'
alias gl='git log'
alias gc='git commit'

# Set editor
export EDITOR=nvim
export VISUAL=nvim

# Starship config (optional, can be separate file)
export STARSHIP_CONFIG=~/.config/starship.toml


PS1='[\u@\h \W]\$ '

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/1password/agent.sock"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
PATH=$PATH:~/.local/bin

# --- Auto-attach or create tmux session uniquely ---
if command -v tmux >/dev/null && [ -z "$TMUX" ] && [ -n "$TERM" ] && [ -z "$INSIDE_TMUX_AUTO" ]; then
  export INSIDE_TMUX_AUTO=1

  # Сначала ищем существующую session_N без флага attached
  SESSION=$(tmux list-sessions 2>/dev/null | awk '!/\(attached\)$/ && $1 ~ /^session_[0-9]+:/ { gsub(":", "", $1); print $1; exit }')

  # Если не нашли — создаём новую уникальную session
  if [[ -z "$SESSION" ]]; then
    i=1
    while tmux has-session -t "session_$i" 2>/dev/null; do
      ((i++))
    done
    SESSION="session_$i"
    tmux new-session -d -s "$SESSION"
  fi

  exec tmux attach -t "$SESSION"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

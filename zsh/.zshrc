setopt INTERACTIVE_COMMENTS

# %1~ shows the last dir, %~ will show the full one.
export PS1="[%D{%Y-%m-%d}] %n@%~$ "
if [[ "$TERM" =~ 256color ]]; then
  export PS1="%F{green}[%D{%Y-%m-%d}]%f %n@%F{purple}%~%f$ "
  export PS1="%{$(tput setaf 2)%}[%D{%Y-%m-%d}]%{$(tput sgr0)%} %n@%{$(tput setaf 5)%}%~%{$(tput sgr0)%}$ "
fi

alias python='python3'
alias c='clear'
alias rb='source ~/.zshrc'
alias ob='vim ~/.zshrc'
alias of='vim ~/.zsh_functions.sh'

# TODO(afro): Make sure this is doing something?
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

###
# Setup history.
###

# Function to log commands
function log_command {
    local log_dir="$HOME/.logs"
    local log_file="${log_dir}/$(date +%Y-%m-%d).log"
    local current_dir=$(pwd)
    local tmux_session=""

    # Check if inside a tmux session
    if [ -n "$TMUX" ]; then
        tmux_session=$(tmux display-message -p '#S')
        tmux_session="(tmux: $tmux_session)"
    fi

    # Create log directory if it doesn't exist
    [[ ! -d "$log_dir" ]] && mkdir -p "$log_dir"

    # Append the command to the log file
    # echo "$(date +%H:%M:%S) $USER : $tmux_session : $current_dir : $1" >> "$log_file"
    echo "$(date +%H:%M:%S) $USER $tmux_session: $current_dir : $1" >> "$log_file"
}

# Hook to execute the log_command function before each command
autoload -Uz add-zsh-hook
add-zsh-hook preexec log_command

# Extra functions written.
source ~/.zsh_functions.sh

##########
# HISTORY
##########

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Immediately append to history file:
setopt INC_APPEND_HISTORY

# Record timestamp in history:
setopt EXTENDED_HISTORY

# Expire duplicate entries first when trimming history:
setopt HIST_EXPIRE_DUPS_FIRST

# Dont record an entry that was just recorded again:
setopt HIST_IGNORE_DUPS

# Delete old recorded entry if new entry is a duplicate:
setopt HIST_IGNORE_ALL_DUPS

# Do not display a line previously found:
setopt HIST_FIND_NO_DUPS

# Dont record an entry starting with a space:
setopt HIST_IGNORE_SPACE

# Dont write duplicate entries in the history file:
setopt HIST_SAVE_NO_DUPS

# Share history between all sessions:
setopt SHARE_HISTORY

# Execute commands using history (e.g.: using !$) immediatel:
unsetopt HIST_VERIFY

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

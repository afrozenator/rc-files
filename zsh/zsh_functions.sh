# Delete daily command logs older than an age such as 2y, 6m, or 30d.
# Months and years use macOS calendar adjustments. The cutoff day is kept.
# Only regular YYYY-MM-DD.log files directly inside ~/.logs are considered.
# Preview first with: prune_logs 6m --dry-run
prune_logs() {
    emulate -L zsh

    local age="${1:-}" mode="${2:-}"
    # Bound the numeric input to avoid overflow in macOS date.
    if (( $# < 1 || $# > 2 || ${#age} > 7 )) ||
        [[ "$age" != <1->[ymd] ]] ||
        { (( $# == 2 )) && [[ "$mode" != --dry-run ]]; }; then
        print -u2 -r -- 'Usage: prune_logs <age> [--dry-run]'
        print -u2 -r -- 'Age: a positive integer (up to six digits) followed by y, m, or d.'
        return 2
    fi

    local log_dir="$HOME/.logs"
    local cutoff today
    today=$(/bin/date '+%Y-%m-%d') || return 1
    cutoff=$(/bin/date "-v-$age" '+%Y-%m-%d') || return 2
    if [[ "$cutoff" != [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ||
          ! "$cutoff" < "$today" ]]; then
        print -u2 -r -- "Age is outside the supported date range: $age"
        return 2
    fi

    local log_file
    local -a old_logs=()
    for log_file in "$log_dir"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].log(N.); do
        [[ "${log_file:t:r}" < "$cutoff" ]] && old_logs+=("$log_file")
    done

    if (( ${#old_logs} == 0 )); then
        print -r -- "No daily logs older than $cutoff."
        return 0
    fi

    if [[ "$mode" == --dry-run ]]; then
        print -r -- "Would delete ${#old_logs} daily log(s) dated before $cutoff:"
        printf '%s\n' "${old_logs[@]}"
        return 0
    fi

    command rm -- "${old_logs[@]}" || return 1
    print -r -- "Deleted ${#old_logs} daily log(s) dated before $cutoff."
}

# Move up one directory by default, or N directories with: .. N
function .. {
    emulate -L zsh
    local levels="${1-1}"
    if (( $# > 1 )) || [[ "$levels" != <1-> ]]; then
        print -u2 -r -- 'Usage: .. [positive number of levels]'
        return 2
    fi

    local target=''
    local -i i
    for (( i = 0; i < levels; i++ )); do
        target+='../'
    done
    builtin cd -- "$target"
}

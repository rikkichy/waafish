function fish_prompt
    set -l last_status $status
    set -l grey (set_color brblack)
    set -l reset (set_color normal)

    # Git branch
    set -l git_info ""
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (command git branch --show-current 2>/dev/null)
        if test -z "$branch"
            set branch (command git rev-parse --short HEAD 2>/dev/null)
        end
        set git_info " ($branch)"
    end

    set -l arrow ">"
    if test $last_status -ne 0
        set arrow "!"
    end

    echo -n -s $grey (prompt_pwd) $git_info " $arrow " $reset
end

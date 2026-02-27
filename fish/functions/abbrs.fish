function abbrs -d "Display abbreviations with descriptions"
    set_color --bold cyan
    echo "Fish Abbreviations"
    set_color normal
    echo

    set_color --bold
    printf "  %-12s %s\n" "Shortcut" "Expands to"
    set_color normal
    printf "  %-12s %s\n" "--------" "----------"

    set -l section ""

    while read -l line
        # Skip empty lines
        test -z (string trim "$line"); and continue

        # Section comments
        if string match -qr '^#\s*(.+)' -- "$line"
            set section (string match -r '^#\s*(.+)' -- "$line")[2]
            echo
            set_color --bold yellow
            echo "  $section"
            set_color normal
            continue
        end

        # Abbreviation lines
        if string match -qr '^abbr\s' -- "$line"
            set -l name (string match -r 'abbr\s+-a\s+(\S+)' -- "$line")[2]
            set -l expansion (string match -r 'abbr\s+-a\s+\S+\s+(.+)' -- "$line")[2]
            # Strip surrounding quotes
            set expansion (string trim -c '"' "$expansion")
            set expansion (string trim -c "'" "$expansion")

            set_color green
            printf "  %-12s" "$name"
            set_color normal
            printf " %s\n" "$expansion"
        end
    end < (status dirname)/../conf.d/abbreviations.fish
end

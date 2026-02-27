function fish_greeting
    # --- Gather info (single date call) ---
    set -l user $USER
    set -l _d (date '+%H%n%A%n%H:%M%n%Y-%m-%d')
    set -l hour $_d[1]
    set -l day $_d[2]
    set -l time_str $_d[3]
    set -l today $_d[4]

    # --- Session counter ---
    set -l session_file "$HOME/.cache/fish_session_count"
    set -l session_count 1
    if test -f $session_file
        set -l stored (cat $session_file)
        if test (count $stored) -ge 2; and test "$stored[1]" = "$today"
            set session_count (math $stored[2] + 1)
        end
    end
    printf '%s\n%d\n' $today $session_count >$session_file

    # --- Time-of-day theme ---
    set -l border_color
    set -l period
    set -l time_icon
    if test $hour -lt 6
        set border_color blue
        set period night
        set time_icon ""
    else if test $hour -lt 12
        set border_color yellow
        set period morning
        set time_icon ""
    else if test $hour -lt 17
        set border_color green
        set period afternoon
        set time_icon ""
    else if test $hour -lt 21
        set border_color magenta
        set period evening
        set time_icon ""
    else
        set border_color cyan
        set period night
        set time_icon ""
    end

    # --- Narrative: greeting ---
    set -l greeting
    switch $period
        case night
            set greeting (random choice \
                "Burning the midnight oil, $user?" \
                "Night owl mode, $user." \
                "The world sleeps, but not $user." \
                "Late night session, $user.")
        case morning
            set greeting (random choice \
                "Good morning, $user." \
                "Morning, $user." \
                "Rise and shine, $user." \
                "Top of the morning, $user.")
        case afternoon
            set greeting (random choice \
                "Good afternoon, $user." \
                "Hey there, $user." \
                "Afternoon, $user." \
                "What's cooking, $user?")
        case evening
            set greeting (random choice \
                "Good evening, $user." \
                "Evening, $user." \
                "Welcome back, $user." \
                "Hey $user, winding down?")
    end

    # --- Narrative: day ---
    set -l day_msg
    switch $day
        case Monday
            set day_msg (random choice \
                "Monday. Coffee first, questions later." \
                "Monday again. Deep breaths." \
                "Ah, Monday. Good luck out there." \
                "Monday. Let's get through this.")
        case Tuesday
            set day_msg (random choice \
                "Tuesday. The sequel nobody asked for." \
                "Tuesday. At least it's not Monday." \
                "Tuesday. You survived Monday." \
                "Tuesday. One down, four to go.")
        case Wednesday
            set day_msg (random choice \
                "Wednesday. Halfway there." \
                "Happy hump day." \
                "Wednesday. All downhill from here." \
                "Mid-week. Doing alright?")
        case Thursday
            set day_msg (random choice \
                "Thursday. Almost Friday." \
                "Thursday. The weekend is close." \
                "Thursday. One more day." \
                "Thursday. The Friday trailer.")
        case Friday
            set day_msg (random choice \
                "Happy Friday." \
                "It's Friday. You made it." \
                "FRIDAY. The vibes are immaculate." \
                "Friday. Go easy, you earned it.")
        case Saturday
            set day_msg (random choice \
                "Saturday. Why are you in a terminal?" \
                "Saturday coding? Respect." \
                "Saturday. No deadlines..right?" \
                "Weekend mode. Take it easy.")
        case Sunday
            set day_msg (random choice \
                "Sunday. Recharging for the week?" \
                "Sunday vibes. Nice and chill." \
                "Sunday. The calm before Monday." \
                "Sunday. Monday doesn't exist yet.")
    end

    # --- Build content lines ---
    set -l line1 "$time_icon $greeting"
    set -l line2 " $day_msg"

    # --- Compute box width ---
    set -l header " $session_count · $period · $time_str"
    set -l max_len 0
    for line in $line1 $line2 $header
        set -l len (printf '%s' "$line" | wc -m | string trim)
        test $len -gt $max_len; and set max_len $len
    end
    set -l W (math "$max_len + 6")

    # --- Render ---
    set -l bc (set_color $border_color)
    set -l tx (set_color normal)
    set -l rs (set_color normal)

    # Top border
    set -l hpad (math "$W - "(printf '%s' "$header" | wc -m | string trim)" - 4")
    test $hpad -lt 1; and set hpad 1
    echo -s $bc "╭── " $tx $header $bc " " (string repeat -n $hpad "─") "╮" $rs

    # Blank
    echo -s $bc "│" (string repeat -n $W " ") "│" $rs

    # Content (pad with spaces for reliable right border)
    set -l len1 (printf '%s' "$line1" | wc -m | string trim)
    set -l pad1 (math "$W - 2 - $len1")
    test $pad1 -lt 0; and set pad1 0
    echo -s $bc "│" $tx "  " $line1 (string repeat -n $pad1 " ") $bc "│" $rs

    set -l len2 (printf '%s' "$line2" | wc -m | string trim)
    set -l pad2 (math "$W - 2 - $len2")
    test $pad2 -lt 0; and set pad2 0
    echo -s $bc "│" $tx "  " $line2 (string repeat -n $pad2 " ") $bc "│" $rs

    # Blank
    echo -s $bc "│" (string repeat -n $W " ") "│" $rs

    # Bottom border
    echo -s $bc "╰" (string repeat -n $W "─") "╯" $rs

end

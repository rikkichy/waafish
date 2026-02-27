# Commentary event handlers — snarky remarks on directory changes,
# long commands, error streaks, idle returns, and sudo usage.

function _directory_commentary --on-variable PWD
    set -l msgs

    switch $PWD
        case "$HOME/.config" "$HOME/.config/*"
            set msgs \
                "About to break something again?" \
                "Here we go again.." \
                "Tinkering with configs, huh?" \
                "One wrong edit and it all falls apart." \
                "Ah yes, the danger zone." \
                "Careful..these files bite."

        case "$HOME"
            set msgs \
                "Home sweet home." \
                "Back to base." \
                "There's no place like ~" \
                "Welcome home, wanderer."

        case "$HOME/Desktop"
            set msgs \
                "The digital junk drawer." \
                "How many screenshots live here?" \
                "Desktop..where files go to be forgotten." \
                "Let me guess..it's a mess."

        case "$HOME/Downloads"
            set msgs \
                "The graveyard of forgotten ZIPs." \
                "How many 'installer (3).dmg' files are in here?" \
                "Downloads..the land of no return." \
                "Brave soul, entering Downloads."

        case "$HOME/Documents" "$HOME/Documents/*"
            set msgs \
                "Oh, fancy. Actual documents." \
                "Who still uses Documents?" \
                "Organized? In this economy?"

        case "*/.git"
            set msgs \
                "Peeking behind the curtain.." \
                "Here be dragons." \
                "You probably shouldn't be in here." \
                "The forbidden zone."

        case "*/node_modules" "*/node_modules/*"
            set msgs \
                "You're going IN there??" \
                "Abandon all hope, ye who enter here." \
                "That's heavier than a black hole." \
                "Brave. Very brave." \
                "Why would you do this to yourself?"

        case "/tmp" "/tmp/*"
            set msgs \
                "Living on borrowed time in here." \
                "Nothing here is permanent. Just like life." \
                "Temp files, temp vibes." \
                "Here today, gone on reboot."

        case "/" "/usr" "/usr/*" "/etc" "/etc/*" "/var" "/var/*"
            set msgs \
                "System territory. Tread lightly." \
                "You better know what you're doing." \
                "Root-level adventure. Exciting and terrifying." \
                "Don't touch anything."

        case '*'
            # Small chance of a random comment in any other directory
            if test (random 1 8) -eq 1
                set msgs \
                    "New place, who dis?" \
                    "Exploring, are we?" \
                    "I wonder what's in here.." \
                    "Ooh, somewhere new."
            end
    end

    if test (count $msgs) -gt 0
        set_color brblack
        echo (random choice $msgs)
        set_color normal
    end
end

function _command_duration_commentary --on-event fish_postexec
    set -l ms $CMD_DURATION
    set -l msgs

    if test $ms -gt 60000
        set -l mins (math --scale=1 $ms / 60000)
        set msgs \
            "That took "$mins" minutes. You could've made coffee." \
            "$mins minutes..did you fall asleep?" \
            "Wow, "$mins" min. That command needs therapy." \
            "$mins minutes of your life you'll never get back." \
            "That was "$mins" min. I almost gave up on you." \
            "$mins min. Have you considered a faster machine?"
    else if test $ms -gt 30000
        set -l secs (math --scale=0 $ms / 1000)
        set msgs \
            "$secs seconds. Go grab a snack next time." \
            "That took "$secs"s. Patience level: expert." \
            "$secs seconds..felt like forever." \
            "Only "$secs"s? Felt longer honestly." \
            "$secs seconds of pure suspense."
    else if test $ms -gt 10000
        set -l secs (math --scale=0 $ms / 1000)
        set msgs \
            "$secs seconds. Not bad, not great." \
            "That was "$secs"s. I've seen faster." \
            "$secs seconds. Could be worse." \
            "Took "$secs"s. I was starting to worry."
    end

    if test (count $msgs) -gt 0
        set_color brblack
        echo (random choice $msgs)
        set_color normal
    end
end

function _error_streak_commentary --on-event fish_postexec
    set -l last_status $status

    if not set -q __error_streak_count
        set -g __error_streak_count 0
    end

    if test $last_status -ne 0
        set -g __error_streak_count (math $__error_streak_count + 1)
        set -l streak $__error_streak_count
        set -l msgs

        if test $streak -eq 2
            set msgs \
                "That's 2 in a row..you good?" \
                "Two fails. Coincidence? Maybe." \
                "0 for 2. Don't worry, I'm not counting. Wait." \
                "Miss #2. Just warming up, right?"

        else if test $streak -eq 3
            set msgs \
                "3 fails. Maybe read the error message?" \
                "Three in a row. That's a pattern now." \
                "Strike three. In baseball you'd be out." \
                "Hat trick of errors. Impressive, honestly."

        else if test $streak -eq 4
            set msgs \
                "4 consecutive fails. This is becoming a lifestyle." \
                "Four. I'm starting to worry about you." \
                "Fail number 4. Have you tried..not failing?" \
                "4 in a row. Are you doing this on purpose?"

        else if test $streak -eq 5
            set msgs \
                "5 in a row. I'm starting to question everything." \
                "Five fails. This is a cry for help, isn't it?" \
                "That's 5. Maybe step away from the keyboard?" \
                "5 consecutive errors. New personal best?"

        else if test $streak -ge 6; and test $streak -lt 10
            set msgs \
                "$streak fails. At this point I respect the commitment." \
                "$streak in a row. Are you stress-testing me?" \
                "$streak consecutive fails. This is modern art." \
                "Fail #$streak. You're in uncharted territory."

        else if test $streak -ge 10
            set msgs \
                "$streak fails. I have no words. Actually I do: stop." \
                "$streak in a row. This has to be a record." \
                "Fail #$streak. I'm not mad, I'm just disappointed." \
                "$streak consecutive errors. Legend."
        end

        if test (count $msgs) -gt 0
            set_color brblack
            echo (random choice $msgs)
            set_color normal
        end

    else
        if test $__error_streak_count -ge 3
            set -l recovery_msgs \
                "You did it! Only took $__error_streak_count tries." \
                "Finally! I was losing hope after $__error_streak_count fails." \
                "Success! The $__error_streak_count-fail streak is over!" \
                "Back from the dead after $__error_streak_count misses!"

            set_color brblack
            echo (random choice $recovery_msgs)
            set_color normal
        end

        set -g __error_streak_count 0
    end
end

function _idle_return_commentary --on-event fish_preexec
    set -l now (date +%s)

    if not set -q __last_command_finished_at
        set -g __last_command_finished_at $now
        return
    end

    set -l idle_secs (math $now - $__last_command_finished_at)
    set -l idle_mins (math --scale=0 $idle_secs / 60)
    set -l msgs

    if test $idle_secs -ge 3600
        set msgs \
            "I thought you'd never come back." \
            "Over an hour. I was about to file a missing persons report." \
            "You were gone so long I started contemplating existence." \
            "Back after $idle_mins minutes? I aged." \
            "I was just about to give up on you. $idle_mins minutes!"

    else if test $idle_secs -ge 1800
        set msgs \
            "I was getting lonely in here." \
            "Half an hour? I almost fell asleep." \
            "Back from your adventure? That was $idle_mins minutes." \
            "Oh, you remembered me! It's been a while." \
            "I started talking to /dev/null while you were gone."

    else if test $idle_secs -ge 900
        set msgs \
            "Back from a meeting?" \
            "Was that a coffee break or a nap?" \
            "$idle_mins minutes. Productive break, I hope?" \
            "Oh hey, welcome back. Miss me?" \
            "Gone for a bit. Everything okay out there?"

    else if test $idle_secs -ge 300
        if test (random 1 10) -le 3
            set msgs \
                "Quick break?" \
                "Back already?" \
                "Short absence noted." \
                "Little break? No judgment." \
                "Stretching your legs? Good call."
        end
    end

    if test (count $msgs) -gt 0
        set_color brblack
        echo (random choice $msgs)
        set_color normal
    end
end

function _idle_return_timestamp_update --on-event fish_postexec
    set -g __last_command_finished_at (date +%s)
end

function _sudo_commentary --on-event fish_preexec
    set -l cmd $argv[1]

    if not string match -qr '^\s*sudo\b' $cmd
        return
    end

    set -l msgs \
        "Power trip, huh?" \
        "With great power comes great responsibility.." \
        "Root access requested. Are you sure about this?" \
        "Oh, pulling rank now?" \
        "Sudo? Bold move." \
        "The nuclear option. I respect it." \
        "You must be desperate if you're asking sudo." \
        "Escalating privileges..this better be worth it." \
        "Going full admin mode. Don't break anything." \
        "Sudo says: I hope you know what you're doing." \
        "Look at you, acting all important with sudo." \
        "Permission granted..but at what cost?"

    set_color red
    echo (random choice $msgs)
    set_color normal
end

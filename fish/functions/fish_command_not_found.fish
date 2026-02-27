function fish_command_not_found
    set -l cmd $argv[1]
    set -l msgs \
        "I dunno what's $cmd..is that a spell?" \
        "$cmd? Never heard of her." \
        "$cmd..did you just make that up?" \
        "Hmm..$cmd? That's not a thing." \
        "$cmd? Are you okay?" \
        "I looked everywhere. No $cmd here." \
        "$cmd sounds cool but..it doesn't exist." \
        "Typo? $cmd doesn't ring a bell." \
        "$cmd..bless you?" \
        "Nice try, but $cmd isn't real."
    echo (random choice $msgs)
end

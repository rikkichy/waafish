# PATH
switch (uname)
    case Darwin
        fish_add_path /opt/homebrew/bin
    case Linux
        test -d /home/linuxbrew/.linuxbrew/bin; and fish_add_path /home/linuxbrew/.linuxbrew/bin
end

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"


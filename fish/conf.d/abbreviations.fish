abbr -a ff fastfetch
abbr -a ls "eza --icons --group-directories-first -1"
abbr -a ll "eza --icons --group-directories-first -la"
abbr -a lt "eza --icons --group-directories-first --tree --level=2"

# Convert: cov input.mkv output.mp4 | coi input.png output.webp | cod input.docx output.pdf
abbr -a cov "ffmpeg -i"
abbr -a coi magick

# Download: dlv url | dla url
abbr -a dlv yt-dlp
abbr -a dla "yt-dlp -x --audio-format mp3"

# Archives
abbr -a untar "tar -xvf"
abbr -a mktar "tar -cvf"
abbr -a ungz "gunzip"
abbr -a mkgz "gzip"
abbr -a unzip "unzip"
abbr -a mkzip "zip -r"

# Network
switch (uname)
    case Darwin
        abbr -a localip "ifconfig | grep 'inet ' | grep -v '127.' | awk '{print \$2}'"
        abbr -a ports "lsof -iTCP -sTCP:LISTEN -nP"
    case Linux
        abbr -a localip "ip -4 addr show | grep 'inet ' | grep -v '127.' | awk '{print \$2}' | cut -d/ -f1"
        abbr -a ports "ss -tlnp"
end
abbr -a publicip "curl -s ifconfig.me"

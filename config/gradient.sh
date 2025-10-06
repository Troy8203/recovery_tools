#!/bin/bash

# Define your ASCII art lines (each line as a string)
ascii_lines=(
''
'           ▒█░░▒█ █▀▀ █░░ █▀▀ █▀▀█ █▀▄▀█ █▀▀    　 ▒█▀▀█ █▀▀█ █░░█   '
'           ▒█▒█▒█ █▀▀ █░░ █░░ █░░█ █░▀░█ █▀▀    　 ▒█▄▄▀ █░░█ █▄▄█   '
'           ▒█▄▀▄█ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀▀ ▀░░░▀ ▀▀▀    　 ▒█░▒█ ▀▀▀▀ ▄▄▄█   '
''
'                    ㄒ卄🝗 丂丫丂〸🝗爪 讠丂 𝓝ㄖ山 尺🝗闩ᗪ丫'
'                    ﾁㄖ尺 丫ㄖㄩ尺 讠𝓝丂七尺ㄩ⼕セ讠ㄖ𝓝丂.'
)

# Set gradient colors (from: Red, to: Blue)
start_r=63; start_g=198; start_b=211     # Starting color
end_r=173; end_g=70; end_b=255           # Ending color

# Print each line with gradient applied character by character
for line in "${ascii_lines[@]}"; do
    length=${#line}
    for ((i=0; i<length; i++)); do
        char="${line:$i:1}"

        # Calculate RGB for this character based on its position
        r=$((start_r + (end_r - start_r) * i / length))
        g=$((start_g + (end_g - start_g) * i / length))
        b=$((start_b + (end_b - start_b) * i / length))

        # Print character with calculated RGB color
        printf "\033[38;2;%d;%d;%dm%s" $r $g $b "$char"
    done
    echo -e "\033[0m"  # Newline + reset color
done
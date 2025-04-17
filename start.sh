#!/bin/bash

cd "$(dirname "$0")"

# Function to check if required fonts are installed
check_fonts() {
    local fonts=("ChopinScript" "DejaVu Serif" "zekton")
    local missing_fonts=()

    for font in "${fonts[@]}"; do
        if ! fc-list | grep -q "$font"; then
            echo "Font '$font' not installed"
            missing_fonts+=("$font")
        fi
    done

    if [ ${#missing_fonts[@]} -gt 0 ]; then
        echo "Warning: Some required fonts are missing. Install them for proper display."
        return 1
    else
        echo "All required fonts are installed."
        return 0
    fi
}

# Check if Conky is already running and stop it
if pidof conky > /dev/null; then
    killall conky
fi

# Check fonts before starting Conky
check_fonts

# Start Conky with the specified configuration and log errors
conky -c ./conky.conf &

exit 0
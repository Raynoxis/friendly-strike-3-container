#!/bin/bash
set -e

# Check DISPLAY
if [ -z "$DISPLAY" ]; then
    echo "Error: DISPLAY not set. An X11 server is required."
    echo "Example: -e DISPLAY=192.168.0.20:0.0"
    exit 1
fi

# Configure PulseAudio (if socket available)
if [ -n "$PULSE_SERVER" ]; then
    echo "PulseAudio configured: $PULSE_SERVER"
elif [ -S "/run/user/1000/pulse/native" ]; then
    export PULSE_SERVER=unix:/run/user/1000/pulse/native
fi

case "$1" in
    game)
        echo "Starting Friendly-Strike 3..."
        cd /game
        wine Friendly-Strike3.exe
        ;;
    hoster)
        echo "Starting FS3 Hoster server..."
        cd /game/FS3hoster
        wine FrStr3Hoster.exe
        ;;
    chat)
        echo "Starting FS3 Chat Authent..."
        cd /game/FS3hoster
        wine FS3_ChatAuthent.exe
        ;;
    bash)
        exec /bin/bash
        ;;
    *)
        echo "Usage: $0 {game|hoster|chat|bash}"
        echo "  game   - Start the Friendly-Strike 3 game"
        echo "  hoster - Start the hosting server"
        echo "  chat   - Start the chat authentication server"
        echo "  bash   - Open a shell"
        exit 1
        ;;
esac

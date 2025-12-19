#!/bin/bash
set -e

# Vérification du DISPLAY
if [ -z "$DISPLAY" ]; then
    echo "Erreur: DISPLAY non défini. Un serveur X11 est requis."
    echo "Exemple: -e DISPLAY=192.168.0.20:0.0"
    exit 1
fi

# Configuration PulseAudio (si socket disponible)
if [ -n "$PULSE_SERVER" ]; then
    echo "PulseAudio configuré: $PULSE_SERVER"
elif [ -S "/run/user/1000/pulse/native" ]; then
    export PULSE_SERVER=unix:/run/user/1000/pulse/native
fi

case "$1" in
    game)
        echo "Lancement de Friendly-Strike 3..."
        cd /game
        wine Friendly-Strike3.exe
        ;;
    hoster)
        echo "Lancement du serveur FS3 Hoster..."
        cd /game/FS3hoster
        wine FrStr3Hoster.exe
        ;;
    chat)
        echo "Lancement de FS3 Chat Authent..."
        cd /game/FS3hoster
        wine FS3_ChatAuthent.exe
        ;;
    bash)
        exec /bin/bash
        ;;
    *)
        echo "Usage: $0 {game|hoster|chat|bash}"
        echo "  game   - Lance le jeu Friendly-Strike 3"
        echo "  hoster - Lance le serveur d'hébergement"
        echo "  chat   - Lance le serveur d'authentification chat"
        echo "  bash   - Ouvre un shell"
        exit 1
        ;;
esac

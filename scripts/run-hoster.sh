#!/bin/bash
# Script de lancement du serveur FS3 Hoster en conteneur

# Détection du DISPLAY
DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"

# Port du serveur (par défaut 1206, modifiable)
SERVER_PORT="${1:-1206}"

echo "Lancement de FS3 Hoster..."
echo "DISPLAY: $DISPLAY_VAR"
echo "Ports exposés: 1203, $SERVER_PORT"

podman run --rm -it \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    -p 1203:1203/udp \
    -p $SERVER_PORT:$SERVER_PORT/udp \
    friendly-strike3:latest hoster

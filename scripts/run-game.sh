#!/bin/bash
# =============================================================================
# run-game.sh - Lancement de Friendly-Strike 3 en conteneur
# =============================================================================

set -e

# Configuration par défaut
DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"
IMAGE_NAME="friendly-strike3:latest"

# Passer /dev/snd si disponible (audio non garanti en rootless)
AUDIO_OPTS=""
if [ -d "/dev/snd" ]; then
    AUDIO_OPTS="--device /dev/snd"
fi

echo "=== Friendly-Strike 3 ==="
echo "DISPLAY: $DISPLAY_VAR"
echo "========================="
echo ""

exec podman run --rm -it \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    $AUDIO_OPTS \
    "$IMAGE_NAME" game

#!/bin/bash
# =============================================================================
# run-game.sh - Lancement de Friendly-Strike 3 en conteneur
# =============================================================================

set -e

# Configuration par défaut
DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"
IMAGE_NAME="friendly-strike3:latest"

# =============================================================================
# Détection audio automatique
# =============================================================================
AUDIO_OPTS=""

# Chercher le socket PulseAudio de l'utilisateur courant
PULSE_SOCKET="/run/user/$(id -u)/pulse/native"

# Si on est root, essayer de trouver le socket d'un autre utilisateur
if [ "$(id -u)" -eq 0 ]; then
    for uid_dir in /run/user/*; do
        if [ -S "$uid_dir/pulse/native" ]; then
            PULSE_SOCKET="$uid_dir/pulse/native"
            break
        fi
    done
fi

# Configurer PulseAudio si le socket existe
if [ -S "$PULSE_SOCKET" ]; then
    AUDIO_OPTS="-v $PULSE_SOCKET:$PULSE_SOCKET -e PULSE_SERVER=unix:$PULSE_SOCKET"
    AUDIO_STATUS="PulseAudio ($PULSE_SOCKET)"
else
    AUDIO_STATUS="Désactivé (socket non trouvé)"
fi

# Ajouter les devices ALSA si disponibles (fallback)
if [ -d "/dev/snd" ]; then
    AUDIO_OPTS="$AUDIO_OPTS --device /dev/snd"
fi

# =============================================================================
# Affichage de la configuration
# =============================================================================
echo "=== Friendly-Strike 3 ==="
echo "DISPLAY: $DISPLAY_VAR"
echo "Audio:   $AUDIO_STATUS"
echo "========================="
echo ""

# =============================================================================
# Lancement du conteneur
# =============================================================================
exec podman run --rm -it \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    $AUDIO_OPTS \
    "$IMAGE_NAME" game

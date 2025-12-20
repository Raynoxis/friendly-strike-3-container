#!/bin/bash
# =============================================================================
# run-game-hdmi.sh - Lancer le jeu avec audio HDMI (ALSA)
# =============================================================================
#
# Usage: sudo ./scripts/run-game-hdmi.sh [hw:0,3]
#
# Par defaut, utilise hw:0,3. Voir /proc/asound/pcm pour les sorties HDMI.
# =============================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit etre lance en root (sudo)."
    echo "Exemple: sudo $0 [hw:0,3]"
    exit 1
fi

DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"
IMAGE_NAME="friendly-strike3:latest"
ALSA_DEVICE="${1:-${FS3_ALSA_DEVICE:-hw:0,3}}"
ASOUND_TMP="/tmp/fs3.asoundrc"

trap 'rm -f "$ASOUND_TMP"' EXIT

cat > "$ASOUND_TMP" <<EOF
pcm.!default {
  type plug
  slave.pcm "$ALSA_DEVICE"
}
ctl.!default {
  type hw
  card 0
}
EOF

echo "=== Friendly-Strike 3 (HDMI) ==="
echo "DISPLAY: $DISPLAY_VAR"
echo "ALSA:    $ALSA_DEVICE"
echo "==============================="
echo ""

exec podman --cgroup-manager=cgroupfs run --rm -it \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    -v "$ASOUND_TMP:/root/.asoundrc:ro" \
    --device /dev/snd \
    "$IMAGE_NAME" game

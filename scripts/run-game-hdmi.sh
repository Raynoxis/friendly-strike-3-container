#!/bin/bash
# =============================================================================
# run-game-hdmi.sh - Run the game with HDMI audio (ALSA)
# =============================================================================
#
# Usage: sudo ./scripts/run-game-hdmi.sh [hw:0,3]
#
# Defaults to hw:0,3. See /proc/asound/pcm for HDMI outputs.
# =============================================================================

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root (sudo)."
    echo "Example: sudo $0 [hw:0,3]"
    exit 1
fi

DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"
CONTAINER_BIN="${FS3_CONTAINER_BIN:-podman}"
IMAGE_NAME="${FS3_IMAGE:-docker.io/raynoxis/friendly-strike-3:latest}"
PULL_POLICY="${FS3_PULL_POLICY:-missing}"
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

exec "$CONTAINER_BIN" --cgroup-manager=cgroupfs run --rm -it \
    --pull="$PULL_POLICY" \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    -v "$ASOUND_TMP:/root/.asoundrc:ro" \
    --device /dev/snd \
    "$IMAGE_NAME" game

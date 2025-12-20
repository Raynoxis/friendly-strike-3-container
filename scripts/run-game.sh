#!/bin/bash
# =============================================================================
# run-game.sh - Run Friendly-Strike 3 in a container
# =============================================================================

set -e

# Default configuration
DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"
CONTAINER_BIN="${FS3_CONTAINER_BIN:-podman}"
IMAGE_NAME="${FS3_IMAGE:-docker.io/raynoxis/friendly-strike-3:latest}"
PULL_POLICY="${FS3_PULL_POLICY:-missing}"

# Pass /dev/snd if available (audio not guaranteed rootless)
AUDIO_OPTS=""
if [ -d "/dev/snd" ]; then
    AUDIO_OPTS="--device /dev/snd"
fi

echo "=== Friendly-Strike 3 ==="
echo "DISPLAY: $DISPLAY_VAR"
echo "========================="
echo ""

exec "$CONTAINER_BIN" run --rm -it \
    --pull="$PULL_POLICY" \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    $AUDIO_OPTS \
    "$IMAGE_NAME" game

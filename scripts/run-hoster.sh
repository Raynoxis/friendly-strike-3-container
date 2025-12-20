#!/bin/bash
# Run the FS3 Hoster server in a container

# DISPLAY detection
DISPLAY_VAR="${DISPLAY:-192.168.0.20:0.0}"
CONTAINER_BIN="${FS3_CONTAINER_BIN:-podman}"
IMAGE_NAME="${FS3_IMAGE:-docker.io/raynoxis/friendly-strike-3:latest}"
PULL_POLICY="${FS3_PULL_POLICY:-missing}"

# Server port (default 1206, overridable)
SERVER_PORT="${1:-1206}"

echo "Starting FS3 Hoster..."
echo "DISPLAY: $DISPLAY_VAR"
echo "Exposed ports: 1203, $SERVER_PORT"

"$CONTAINER_BIN" run --rm -it \
    --pull="$PULL_POLICY" \
    --network=host \
    -e DISPLAY="$DISPLAY_VAR" \
    -p 1203:1203/udp \
    -p $SERVER_PORT:$SERVER_PORT/udp \
    "$IMAGE_NAME" hoster

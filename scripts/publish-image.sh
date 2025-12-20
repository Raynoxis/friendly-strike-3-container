#!/bin/bash
# =============================================================================
# publish-image.sh - Build and publish the image to Docker Hub
# =============================================================================

set -euo pipefail

CONTAINER_BIN="${FS3_CONTAINER_BIN:-podman}"
BUILD_CONTEXT="${FS3_BUILD_CONTEXT:-./build}"
IMAGE_NAME="${FS3_IMAGE:-docker.io/raynoxis/friendly-strike-3:latest}"
DOCKERHUB_USER="${DOCKERHUB_USER:-raynoxis}"

if ! command -v "$CONTAINER_BIN" >/dev/null 2>&1; then
    echo "Error: runtime not found: $CONTAINER_BIN"
    exit 1
fi

DOCKERHUB_TOKEN="${DOCKERHUB_TOKEN:-}"

if [ -z "$DOCKERHUB_TOKEN" ] && [ -f "$HOME/.bashrc" ]; then
    # Reload aliases to reuse dockerpass.
    set +u
    shopt -s expand_aliases
    # shellcheck disable=SC1090
    . "$HOME/.bashrc"
    set -u
    if alias dockerpass >/dev/null 2>&1; then
        DOCKERHUB_TOKEN="$(dockerpass)"
    fi
fi

if [ -z "$DOCKERHUB_TOKEN" ]; then
    echo "Error: missing Docker Hub token."
    echo "Set DOCKERHUB_TOKEN or add the dockerpass alias in ~/.bashrc."
    exit 1
fi

echo "Building image: $IMAGE_NAME"
"$CONTAINER_BIN" build -t "$IMAGE_NAME" "$BUILD_CONTEXT"

echo "Docker Hub login: $DOCKERHUB_USER"
echo "$DOCKERHUB_TOKEN" | "$CONTAINER_BIN" login -u "$DOCKERHUB_USER" --password-stdin docker.io

echo "Pushing image: $IMAGE_NAME"
"$CONTAINER_BIN" push "$IMAGE_NAME"

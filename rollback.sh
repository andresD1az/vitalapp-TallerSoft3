#!/usr/bin/env bash
set -euo pipefail

STATE_DIR=$(pwd)
CUR_FILE="$STATE_DIR/.current_tag"
PREV_FILE="$STATE_DIR/.prev_tag"

TARGET_TAG="${1:-}"
if [ -z "$TARGET_TAG" ]; then
  if [ -f "$PREV_FILE" ]; then
    TARGET_TAG="$(cat "$PREV_FILE")"
  else
    echo "No existe $PREV_FILE y no se proporcionó TAG. Abortando." >&2
    exit 1
  fi
fi

if [ -z "${IMAGE:-}" ]; then
  echo "La variable IMAGE no está definida. Exporta IMAGE=ghcr.io/andresd1az/vitalapp-tallersoft3 (u otra)." >&2
  exit 1
fi

export TAG="$TARGET_TAG"
echo "Rollback a TAG=$TAG"

# Trae la imagen objetivo y relanza
docker pull "${IMAGE}:${TAG}"
docker compose pull
docker compose up -d --remove-orphans

echo -n "$TAG" > "$CUR_FILE"

docker ps

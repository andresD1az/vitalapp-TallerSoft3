#!/usr/bin/env bash
set -euo pipefail
export TAG=${TAG:-${1:-latest}}
echo "Deploy TAG=$TAG"
echo "Using IMAGE=${IMAGE:-"(not set)"}"
# track previous/current tag for rollback
STATE_DIR=$(pwd)
CUR_FILE="$STATE_DIR/.current_tag"
PREV_FILE="$STATE_DIR/.prev_tag"
if [ -f "$CUR_FILE" ]; then
  cp -f "$CUR_FILE" "$PREV_FILE" || true
fi
echo -n "$TAG" > "$CUR_FILE"
if [ -n "${IMAGE:-}" ]; then
  docker pull "${IMAGE}:${TAG}"
fi
docker compose pull
docker compose up -d --remove-orphans
docker image prune -f
docker ps

#!/usr/bin/env bash
set -euo pipefail
export TAG=${TAG:-${1:-latest}}
echo "Deploy TAG=$TAG"
echo "Using IMAGE=${IMAGE:-"(not set)"}"
if [ -n "${IMAGE:-}" ]; then
  docker pull "${IMAGE}:${TAG}"
fi
docker compose pull
docker compose up -d --remove-orphans
docker image prune -f
docker ps

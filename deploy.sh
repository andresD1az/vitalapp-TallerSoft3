
#!/usr/bin/env bash
set -euo pipefail
export TAG=${1:-latest}
echo "Deploy TAG=$TAG"
docker compose pull
docker compose up -d --remove-orphans
docker image prune -f
docker ps

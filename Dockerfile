
# ---- Build base (instala deps) ----
FROM node:20-alpine AS base
WORKDIR /app
# cache-bust ARG to avoid stale package.json cache
ARG BUILD_ID
COPY package*.json ./
# sanitize any leftover overrides/cross-spawn and install
RUN npm pkg delete overrides || true \
 && npm pkg delete dependencies.cross-spawn || true \
 && echo "--- package.json after sanitize ---" \
 && cat package.json \
 && (npm ci --omit=dev || npm install --omit=dev)
COPY . .

# ---- Runtime ----
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
RUN apk add --no-cache curl
COPY --from=base /app /app
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD curl -fsS http://localhost:3000/health || exit 1
CMD ["node", "src/index.js"]

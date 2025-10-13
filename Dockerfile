
# ---- Build base (instala deps) ----
FROM node:20-alpine AS base
WORKDIR /app
# cache-bust ARG to avoid stale package.json cache
ARG BUILD_ID
COPY package*.json ./
# install deps (honor overrides in package.json)
RUN cat package.json && (npm ci --omit=dev || npm install --omit=dev)
# diagnostics: verify cross-spawn version inside image build
RUN npm ls cross-spawn || true
RUN node -e "console.log('cross-spawn version in image:', require('cross-spawn/package.json').version)"
COPY . .
# remove devDependencies from package.json for production footprint
RUN node -e "const fs=require('fs');const p=JSON.parse(fs.readFileSync('package.json','utf8'));if(p.devDependencies){delete p.devDependencies;}fs.writeFileSync('package.json',JSON.stringify(p,null,2)+'\n')"
RUN rm -f package-lock.json

# ---- Runtime ----
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
RUN apk add --no-cache curl
# copy only runtime assets to reduce attack surface
COPY --from=base /app/node_modules /app/node_modules
COPY --from=base /app/src /app/src
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD curl -fsS http://localhost:3000/health || exit 1
CMD ["node", "src/index.js"]


# VitalApp — DevOps MVP Starter

Este repo es una **plantilla mínima viable** para practicar DevOps con una app Node.js + Express,
CI/CD con GitHub Actions, análisis de calidad (Sonar), empaquetado Docker y despliegue a Staging con Docker Compose vía SSH.

## Estructura
```
vitalapp/
├─ src/
│  ├─ app.js
│  ├─ index.js
│  └─ routes/health.js
├─ tests/
│  └─ health.test.js
├─ Dockerfile
├─ docker-compose.yml
├─ package.json
├─ .dockerignore
├─ .gitignore
├─ sonar-project.properties
├─ deploy.sh
└─ .github/workflows/ci-cd.yml
```

## Uso rápido (local)
```bash
npm ci
npm test
docker build -t vitalapp:dev .
docker run -p 3000:3000 vitalapp:dev
# http://localhost:3000/health
```

## Configuración de CI/CD
1. Sube esto a un repo en GitHub.
2. Crea **Secrets** en `Settings → Secrets and variables → Actions`:
   - `STAGING_HOST`, `STAGING_USER`, `STAGING_SSH_KEY`
   - `PROD_HOST`, `PROD_USER`, `PROD_SSH_KEY` (opcional si harás prod)
   - `SONAR_TOKEN` y `SONAR_HOST_URL` (si usas SonarQube on-prem; para SonarCloud usualmente basta token)
3. En la VM de *staging* (Linux con Docker + Docker Compose):
   ```bash
   sudo mkdir -p /opt/vitalapp && cd /opt/vitalapp
   # Copia docker-compose.yml y deploy.sh o deja que el pipeline los maneje si clonas el repo
   chmod +x deploy.sh
   ./deploy.sh
   ```

## Flujo de pipeline
- **CI:** Install deps → Tests (Jest) → Sonar scan
- **Build:** Construye y publica imagen Docker en GHCR
- **Deploy Staging:** SSH a VM y ejecuta `docker compose pull && up -d`
- **Deploy Prod (opcional):** Igual que staging, con environment protegido

## Notas
- Ajusta `ghcr.io/TU_ORG/vitalapp` en `docker-compose.yml` con tu organización/repositorio.
- Para SonarCloud, elimina `SONAR_HOST_URL` si no lo usas (o déjalo vía secrets).
- La app se separa en `src/app.js` (instancia Express exportada para tests) y `src/index.js` (arranque del servidor). Esto evita procesos colgados en Jest.
- Healthchecks usan `curl` dentro del contenedor (Dockerfile instala `curl`).

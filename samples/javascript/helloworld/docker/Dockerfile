# syntax=docker/dockerfile:1

# Pin to a specific minor version + digest-friendly slim base for small, reproducible images.
FROM node:lts-bookworm-slim AS base
ENV NODE_ENV=production
WORKDIR /opt/app

# Update the package lists and upgrade libgnutls to the patched version
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnutls-bin libgnutls30 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Update package lists and upgrade the OS and Perl packages
RUN apt-get update && apt-get upgrade -y perl

npm update brace-expansion

# --- Dependencies stage -------------------------------------------------------
# Installed separately so this layer is cached unless package*.json changes.
FROM base AS deps
COPY package.json package-lock.json* ./
# Use npm ci when a lockfile exists for deterministic installs; fall back to
# install otherwise. Only production deps are installed.
RUN if [ -f package-lock.json ]; then \
      npm ci --omit=dev; \
    else \
      npm install --omit=dev; \
    fi \
    && mkdir -p node_modules

# --- Runtime stage ------------------------------------------------------------
FROM base AS runtime

# Copy installed modules and application source (including brand assets).
COPY --from=deps /opt/app/node_modules ./node_modules
COPY package.json server.js ./
COPY assets ./assets

# Run as the built-in unprivileged "node" user, never as root.
USER node

EXPOSE 3000
ENV PORT=3000

# No Docker HEALTHCHECK: liveness/readiness are handled by Kubernetes probes
# hitting the /healthz endpoint (see k8s probe example in README).

# Use the exec form so the process gets PID 1 and receives signals directly.
CMD ["node", "server.js"]

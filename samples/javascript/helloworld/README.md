# Hello World (Node.js)

A minimal Node.js server that serves a page reading **"Hello World by `<name>`"**, where `<name>` comes from the `NAME` environment var.

## Routes

| Path       | Description                                                                                         |
| ---------- | -------------------------------------------------------------------------------------------------- |
| `/`        | The greeting plus an "Inspect" panel. If `NAME` is unset, shows a "Next steps" guide.              |
| `/healthz` | Health-check endpoint for Kubernetes probes (returns `200 ok`).                                     |

When `NAME` is **set**, the home page greets `Hello World by <name>` and confirms
the configuration. When `NAME` is **unset**, it shows a warning and a designed
"Next steps" walkthrough (create a new version → add the `NAME` configuration →
redeploy).

The "Inspect" panel has two tabs:

- **Headers** — every incoming HTTP request header.
- **Environment variables** — every variable in the process environment.

> ⚠️ The Environment variables tab prints the **entire** container environment,
> which in a real deployment can include secrets. It's here to illustrate how
> configuration reaches the service; add an allow-list or redaction before
> exposing anything sensitive.

## Run locally

```bash
cd javascript/helloworld
NAME="Ada" npm start
# open http://localhost:3000
```

## Environment variables

| Variable | Default      | Description                                                          |
| -------- | ------------ | ------------------------------------------------------------------- |
| `NAME`   | _(unset)_    | Name shown in the greeting. When unset, the page shows next steps.  |
| `PORT`   | `3000`       | Port the server listens on.                                         |

## Run with Docker

The Dockerfile lives in the `docker/` subfolder. Build from the project root
(`helloworld/`) so the build context includes the source files:

```bash
cd javascript/helloworld
docker build -f docker/Dockerfile -t helloworld .
docker run --rm -p 3000:3000 -e NAME="Ada" helloworld
# open http://localhost:3000
```

The container runs from `/opt/app` as the unprivileged `node` user.

## Health checks (Kubernetes)

The server exposes a lightweight `GET /healthz` endpoint (returns `200 ok`)
intended for Kubernetes liveness/readiness probes:

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /healthz
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10
```

# Hello World (Node.js)

A minimal Node.js web server that serves a page reading **"Hello World by `<name>`"**, where `<name>` comes from the `NAME` environment variable.

## Routes

| Path        | Description                                                                                     |
| ----------- | ----------------------------------------------------------------------------------------------- |
| `/`         | The greeting, with a link to the advanced page.                                                 |
| `/advanced` | The greeting plus the caller's IP and a guessed location (city/region/country) derived from it. |
| `/healthz`  | Health-check endpoint for Kubernetes probes (returns `200 ok`).                                 |

The `/advanced` page reads the client IP from the left-most `X-Forwarded-For`
entry (so it works behind a k8s ingress / load balancer), falling back to the
socket address. Location is guesstimated via the free, key-less
[ip-api.com](http://ip-api.com) service; private/loopback IPs are reported as a
local network and lookup failures degrade gracefully.

## Run locally

```bash
cd javascript/helloworld
NAME="Ada" npm start
# open http://localhost:3000
```

## Environment variables

| Variable | Default | Description                          |
| -------- | ------- | ------------------------------------ |
| `NAME`   | `World` | Name shown on the page.              |
| `PORT`   | `3000`  | Port the server listens on.          |

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

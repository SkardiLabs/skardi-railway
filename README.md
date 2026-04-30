# Skardi on Railway

One-click Railway template for [Skardi](https://github.com/SkardiLabs/skardi) v0.3.0 — an open-source data plane for AI agents that turns parameterized SQL into REST endpoints.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template)

## Features

- `skardi-server` v0.3.0 (image: `ghcr.io/skardilabs/skardi/skardi-server:0.3.0`)
- SQLite persisted on a Railway volume mounted at `/data`
- Four CRUD pipelines wired up out of the box: `list-tasks`, `create-task`, `complete-task`, `delete-task`
- Healthcheck at `/health`, dashboard at `/`

## Notes

- Source repo: <https://github.com/SkardiLabs/skardi>
- Docs: <https://skardilabs.github.io/skardi-docs/>
- Pipeline reference: [docs/pipelines.md](https://github.com/SkardiLabs/skardi/blob/main/docs/pipelines.md)

## Local check

```bash
docker build -t skardi-railway:0.3.0 .
docker run --rm -e PORT=8080 -p 8080:8080 -v skardi-data:/data skardi-railway:0.3.0
curl -s http://localhost:8080/health
```

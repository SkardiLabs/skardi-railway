# Skardi on Railway

One-click Railway template for [Skardi](https://github.com/SkardiLabs/skardi) v0.3.0 — an open-source data plane for AI agents that turns parameterized SQL into REST endpoints.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template)

## Features

- `skardi-server` v0.3.0 (image: `ghcr.io/skardilabs/skardi/skardi-server:0.3.0`)
- SQLite persisted on a Railway volume mounted at `/data`
- Four CRUD pipelines wired up out of the box: `list-tasks`, `create-task`, `complete-task`, `delete-task`
- Healthcheck at `/health`, dashboard at `/`
- Optional session auth via [better-auth](https://www.better-auth.com), with the auth DB co-located on the same volume

## Configuration

All variables are declared in the Railway service's **Variables** panel (or in the template composer when you publish the template). See [`.env.example`](./.env.example) for the canonical list with comments.

| Variable | Required | Suggested value | Description |
|---|---|---|---|
| `PORT` | auto | injected by Railway | HTTP port the server binds to. |
| `DATA_DIR` | no | `/data` | Mount path for the SQLite database. Must match the volume mount. |
| `AUTH_MODE` | no | `BETTER_AUTH_DIESEL_SQLITE` | Enables session auth. Omit to leave endpoints open. |
| `AUTH_SECRET` | if `AUTH_MODE` set | `${{ secret(48) }}` | Session signing key (≥32 chars). Use Railway's `secret()` template function so it's generated at deploy. |
| `AUTH_DB_PATH` | no | `/data/auth.db` (default) | Auth SQLite path. Entrypoint defaults this onto the volume whenever `AUTH_MODE` is set. |
| `AUTH_BASE_URL` | if `AUTH_MODE` set | `https://${{ RAILWAY_PUBLIC_DOMAIN }}` | Public origin for auth callbacks / cookies. |
| `RUST_LOG` | no | `info` | Log filter passed to `tracing-subscriber`. |

When wiring an external Railway-managed data store (e.g. Postgres) into `ctx.yaml`, reference it via the **private** network — `${{ Postgres.RAILWAY_PRIVATE_DOMAIN }}` — so traffic stays off the public internet.

## Notes

- Source repo: <https://github.com/SkardiLabs/skardi>
- Docs: <https://skardilabs.github.io/skardi-docs/>
- Pipeline reference: [docs/pipelines.md](https://github.com/SkardiLabs/skardi/blob/main/docs/pipelines.md)
- Auth guide: [docs/auth/](https://github.com/SkardiLabs/skardi/tree/main/docs/auth)

## Local check

```bash
docker build -t skardi-railway:0.3.0 .
docker run --rm -e PORT=8080 -p 8080:8080 -v skardi-data:/data skardi-railway:0.3.0
curl -s http://localhost:8080/health
```

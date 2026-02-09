# Django Docker Starter (Hello World)

A Dockerized Django starter with:
- One server-rendered page (Django Templates)
- Bootstrap styling (CDN)
- pytest test setup
- Containerized debugging via debugpy + VS Code attach

## Prereqs
- Docker + Docker Compose

## Quick start (run the server)
Build and start the Django dev server in Docker:

```bash
docker compose up --build web

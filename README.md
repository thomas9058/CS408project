# Django Demo (Docker)

## Requirements checklist

- [x] Server runs locally (Docker)
  - `docker compose up --build web`
  - Open: http://127.0.0.1:8000/

- [x] One route/page renders “Hello World”
  - Route: `/`
  - View: `pages/views.py::hello`
  - Template: `templates/hello.html`

- [x] Uses server-side templating
  - Django Templates

- [x] Uses a UI framework
  - Bootstrap 5 via CDN in `templates/hello.html`

- [x] Includes one automated test
  - `docker compose run --rm test`

- [x] Demonstrates debugging
  - Option 1: debug logs in container output (`logger.info(...)`)
  - Option 2: VS Code attach via debugpy:
    - `docker compose up --build debug`
    - VS Code: "Attach to Django (debugpy in Docker)"
    - Set breakpoint in `pages/views.py`, then request `/`
  - (Add screenshot of breakpoint or debug logs)

## Commands

Run server:
```bash
docker compose up --build web

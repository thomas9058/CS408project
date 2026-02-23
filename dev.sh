#!/usr/bin/env bash
# Django Docker dev/deploy helper
# Usage: ./dev.sh [command ...]

set -euo pipefail

load_env() {
  if [ -f .env ]; then
    set -a
    # shellcheck disable=SC1091
    . ./.env
    set +a
  fi
}

cmd_new() {
  if [ -f .env ]; then
    echo "✘ .env already exists. Refusing to overwrite."
    exit 1
  fi

  APP_NAME="$(basename "$(pwd)" | tr ' ' '-')"
  APP_VERSION="latest"

  echo "Creating a new .env for this project..."
  echo "Are you deploying to a VM with a public IP? (y/n, default: y)"
  read -r has_vm
  has_vm="${has_vm:-y}"

  if [[ "$has_vm" =~ ^[Yy]$ ]]; then
    echo "What is the VM public IP or DNS? (example: 203.0.113.10)"
    read -r vm_host
    VM_HOST="$vm_host"
    echo "What SSH key filename is in ~/.ssh/? (example: mykey.pem) (leave blank to skip ssh helpers)"
    read -r vm_key
    VM_KEY_NAME="${vm_key:-none}"
    VM_DEPLOY_DIR="/home/${USER}/${APP_NAME}"
  else
    VM_HOST="localhost"
    VM_KEY_NAME="none"
    VM_DEPLOY_DIR="$(pwd)"
  fi

  {
    echo "APP_NAME=${APP_NAME}"
    echo "APP_VERSION=${APP_VERSION}"
    echo "VM_HOST=${VM_HOST}"
    echo "VM_KEY_NAME=${VM_KEY_NAME}"
    echo "VM_DEPLOY_DIR=${VM_DEPLOY_DIR}"
  } > .env

  echo "✔ Wrote .env"
  echo "Next: ./dev.sh build install"
}

cmd_build() {
  load_env
  echo "🔨 Building Docker images..."
  docker compose build --no-cache
  echo "✔ Build complete"
}

cmd_install() {
  load_env
  echo "🚀 Starting containers..."
  docker compose up -d --remove-orphans

  echo "🗄 Running migrations..."
  docker compose exec web python manage.py migrate

  echo "✔ App is running"
  echo "Open:"
  if [ "${VM_HOST:-localhost}" = "localhost" ]; then
    echo "  http://127.0.0.1:8000/"
  else
    echo "  http://${VM_HOST}:8000/"
  fi
}

cmd_up() {
  load_env
  docker compose up --build
}

cmd_down() {
  load_env
  docker compose down
}

cmd_logs() {
  load_env
  docker compose logs -f
}

cmd_test() {
  load_env
  echo "🧪 Running tests..."
  docker compose build
  docker compose run --rm test
}

cmd_ssh() {
  load_env
  if [ "${VM_HOST:-}" = "" ] || [ "${VM_KEY_NAME:-none}" = "none" ]; then
    echo "✘ VM_HOST / VM_KEY_NAME not configured in .env. Run ./dev.sh new"
    exit 1
  fi
  chmod 600 "${HOME}/.ssh/${VM_KEY_NAME}" 2>/dev/null || true
  ssh -i "${HOME}/.ssh/${VM_KEY_NAME}" "${USER}@${VM_HOST}"
}

cmd_help() {
  cat <<'EOF'
dev.sh — Django Docker helper

Configure:
  new         Create .env interactively

Dev:
  up          Run docker compose up --build (foreground)
  down        Stop containers
  logs        Tail logs
  test        Run pytest inside container

Deploy-ish (VM):
  build       Build images (no cache)
  install     Start containers + run migrations (good on VM)
EOF
}

main() {
  if [ $# -eq 0 ]; then
    cmd_help
    exit 0
  fi

  for cmd in "$@"; do
    case "$cmd" in
      new) cmd_new ;;
      build) cmd_build ;;
      install) cmd_install ;;
      up) cmd_up ;;
      down) cmd_down ;;
      logs) cmd_logs ;;
      test) cmd_test ;;
      ssh) cmd_ssh ;;
      help|-h|--help) cmd_help ;;
      *) echo "Unknown command: $cmd"; cmd_help; exit 1 ;;
    esac
  done
}

main "$@"
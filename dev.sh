#!/usr/bin/env bash

set -e  # Exit immediately if a command fails

echo "🚀 Starting development environment..."

# Make sure Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "❌ Docker is not running. Please start Docker first."
  exit 1
fi

# Build containers
echo "🔨 Building Docker containers..."
docker compose build

# Start web service in background
echo "📦 Starting web container..."
docker compose up -d web

# Wait briefly for container to initialize
sleep 2

# Run migrations
echo "🗄 Applying database migrations..."
docker compose exec web python manage.py migrate

echo ""
echo "✅ Development server is running!"
echo "🌐 Open: http://127.0.0.1:8000/"
echo ""
echo "To view logs:"
echo "  docker compose logs -f web"
echo ""
echo "To stop:"
echo "  docker compose down"

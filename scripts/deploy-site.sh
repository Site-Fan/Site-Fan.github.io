#!/usr/bin/env bash
set -euo pipefail

# Deploy script: pulls from origin/main, builds Hugo site, and syncs to public dir
REPO_DIR="/home/sitefan/blog"
PUBLIC_DIR="/home/sitefan/blog/public"
BRANCH="main"
BASEURL="https://fanst.cc/"

cd "$REPO_DIR"

# Ensure we run on the target branch
current_branch=$(git rev-parse --abbrev-ref HEAD || echo "")
if [ "$current_branch" != "$BRANCH" ]; then
  echo "Switching to $BRANCH"
  git fetch origin "$BRANCH"
  git checkout "$BRANCH"
fi

# Pull updates (fast-forward only)
if ! git pull --ff-only origin "$BRANCH"; then
  echo "git pull failed (non-fast-forward). Exiting." >&2
  exit 1
fi

# Install node deps and build
if command -v npm >/dev/null 2>&1; then
  npm ci
else
  echo "npm not found in PATH. Skipping npm ci." >&2
fi

if command -v hugo >/dev/null 2>&1; then
  hugo --gc --minify --baseURL "$BASEURL"
else
  echo "hugo not found in PATH. Please install Hugo. Exiting." >&2
  exit 1
fi

# Sync built site to public dir (Caddy serves this)
rsync -av --delete public/ "$PUBLIC_DIR/"

# Ensure correct ownership
chown -R sitefan:sitefan "$PUBLIC_DIR"

echo "Deploy finished at $(date)"

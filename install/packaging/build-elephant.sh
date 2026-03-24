#!/bin/bash
# Install Elephant — data provider backend for the Walker app launcher
# https://github.com/abenz1267/elephant
set -eEo pipefail

if command -v elephant &>/dev/null; then
  echo "Elephant already installed"
  exit 0
fi

echo "Building Elephant from source..."

export PATH="$HOME/go/bin:/usr/local/go/bin:$PATH"

if ! command -v go &>/dev/null; then
  echo "ERROR: go not found. Ensure golang is installed."
  exit 1
fi

BUILD_DIR=$(mktemp -d)
git clone https://github.com/abenz1267/elephant.git "$BUILD_DIR/elephant"
cd "$BUILD_DIR/elephant"

go build -o elephant ./cmd/elephant.go
sudo install -Dm755 elephant /usr/local/bin/elephant

cd /
rm -rf "$BUILD_DIR"

echo "Elephant installed successfully"

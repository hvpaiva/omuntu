#!/bin/bash
# Build Walker application launcher from source

if command -v walker &>/dev/null; then
  echo "Walker already installed"
  exit 0
fi

set -e

echo "Building Walker from source..."

BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

# Walker-specific deps (golang, gtk4, layer-shell already in apt.packages/swayosd)
sudo apt-get install -y golang libgtk-4-dev libgtk4-layer-shell-dev libglib2.0-dev

git clone https://github.com/abenz1267/walker.git
cd walker

go build -o walker .
sudo install -Dm755 walker /usr/local/bin/walker

cd /
rm -rf "$BUILD_DIR"

echo "Walker installed successfully"

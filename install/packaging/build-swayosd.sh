#!/bin/bash
# Build SwayOSD from source (not available in Ubuntu repos)

if command -v swayosd-server &>/dev/null; then
  echo "SwayOSD already installed"
  exit 0
fi

set -e

echo "Building SwayOSD from source..."

BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

# All build dependencies: Rust, SASS compiler, GTK3, layer-shell, audio, input
sudo apt-get install -y \
  rustc cargo sassc \
  libgtk-3-dev libgtk-layer-shell-dev libpulse-dev \
  libevdev-dev libudev-dev libinput-dev \
  libglib2.0-dev libdbus-1-dev

git clone https://github.com/ErikReider/SwayOSD.git
cd SwayOSD

meson setup build
ninja -C build
sudo ninja -C build install

cd /
rm -rf "$BUILD_DIR"

echo "SwayOSD installed successfully"

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

# Build dependencies: SASS compiler, GTK3, layer-shell, audio, input
sudo apt-get install -y \
  sassc \
  libgtk-3-dev libgtk-layer-shell-dev libpulse-dev \
  libevdev-dev libudev-dev libinput-dev \
  libglib2.0-dev libdbus-1-dev

# Ubuntu 24.04 ships Rust 1.75 but SwayOSD needs edition2024 (Rust 1.85+)
# Install latest stable Rust via rustup if needed
if ! command -v rustc &>/dev/null || [[ $(rustc --version | grep -oP '\d+\.\d+' | head -1) < "1.85" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  source "$HOME/.cargo/env"
fi

git clone https://github.com/ErikReider/SwayOSD.git
cd SwayOSD

meson setup build
ninja -C build
sudo ninja -C build install

cd /
rm -rf "$BUILD_DIR"

echo "SwayOSD installed successfully"

#!/bin/bash
# Build SwayOSD from source (not available in Ubuntu 24.04 repos)
# Requires building gtk4-layer-shell first (not in 24.04 repos either)

if command -v swayosd-server &>/dev/null; then
  echo "SwayOSD already installed"
  exit 0
fi

set -e

echo "Building SwayOSD from source..."

# All build dependencies
sudo apt-get install -y \
  sassc \
  libgtk-4-dev libpulse-dev libinput-dev \
  libevdev-dev libudev-dev libdbus-1-dev \
  libglib2.0-dev libcairo2-dev \
  libwayland-dev wayland-protocols \
  gobject-introspection libgirepository1.0-dev \
  gtk-doc-tools valac

# Rust installed by packaging/rustup.sh — set PATH for this subshell
export PATH="$HOME/.cargo/bin:$PATH"

BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

# Step 1: Build gtk4-layer-shell (not in Ubuntu 24.04 repos, first available in 24.10)
if ! pkg-config --exists gtk4-layer-shell-0; then
  echo "Building gtk4-layer-shell from source..."
  git clone https://github.com/wmww/gtk4-layer-shell.git
  cd gtk4-layer-shell
  meson setup build --prefix=/usr
  ninja -C build
  sudo ninja -C build install
  sudo ldconfig
  cd "$BUILD_DIR"
fi

# Step 2: Build SwayOSD
git clone https://github.com/ErikReider/SwayOSD.git
cd SwayOSD
meson setup build --prefix=/usr --buildtype release
meson compile -C build
sudo meson install -C build

cd /
rm -rf "$BUILD_DIR"

echo "SwayOSD installed successfully"

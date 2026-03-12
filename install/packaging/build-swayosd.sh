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
  meson ninja-build pkg-config \
  sassc \
  libgtk-4-dev libpulse-dev libinput-dev \
  libevdev-dev libudev-dev libdbus-1-dev \
  libglib2.0-dev libcairo2-dev \
  libwayland-dev wayland-protocols \
  gobject-introspection libgirepository1.0-dev \
  gtk-doc-tools valac

# Rust installed by packaging/rustup.sh
export PATH="$HOME/.cargo/bin:$PATH"

if ! command -v rustup &>/dev/null; then
  echo "ERROR: rustup not found. Run packaging/rustup.sh first."
  exit 1
fi

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

# SwayOSD requires Rust nightly (rust-toolchain.toml)
# Install it explicitly — rustup auto-install fails under run_logged (stdin=/dev/null)
rustup toolchain install nightly

# Use the actual rustc binary, not the rustup proxy — the proxy fails
# inside meson's env-wrapped subprocesses (CARGO_HOME override confuses it)
export RUSTC="$(rustup which rustc)"
export CARGO="$(rustup which cargo)"
echo "Using rustc: $RUSTC ($($RUSTC --version))"

meson setup build --prefix=/usr --buildtype release
meson compile -C build
sudo meson install -C build

# Remove nightly — keep stable as the user's default toolchain
rustup toolchain remove nightly

cd /
rm -rf "$BUILD_DIR"

echo "SwayOSD installed successfully"

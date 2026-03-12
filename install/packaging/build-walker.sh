#!/bin/bash
# Build Walker application launcher from source (Rust-based since v1.0.8+)

if command -v walker &>/dev/null; then
  echo "Walker already installed"
  exit 0
fi

set -e

echo "Building Walker from source..."

# Build dependencies
sudo apt-get install -y \
  pkg-config \
  libgtk-4-dev libcairo2-dev libpoppler-glib-dev \
  libglib2.0-dev gobject-introspection libgirepository1.0-dev

# Rust installed by packaging/rustup.sh
export PATH="$HOME/.cargo/bin:$PATH"

if ! command -v cargo &>/dev/null; then
  echo "ERROR: cargo not found. Run packaging/rustup.sh first."
  exit 1
fi

BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR"

git clone https://github.com/abenz1267/walker.git
cd walker

cargo build --release
sudo install -Dm755 target/release/walker /usr/local/bin/walker

cd /
rm -rf "$BUILD_DIR"

echo "Walker installed successfully"

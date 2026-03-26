#!/bin/bash
# Install Elephant — data provider backend for the Walker app launcher
# https://github.com/abenz1267/elephant
# Requires Go >= 1.25; Ubuntu 24.04 apt ships Go 1.22 (too old).
# mise (installed by packaging/mise.sh) is used to provide a recent Go.
set -eEo pipefail

if command -v elephant &>/dev/null; then
  echo "Elephant already installed"
  exit 0
fi

echo "Building Elephant from source..."

# go-sqlite3 uses CGo and requires libsqlite3-dev at build time
sudo apt-get install -y libsqlite3-dev

# Activate mise shims (mise installed by packaging/mise.sh)
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# Elephant requires Go >= 1.25; install via mise if the system Go is too old
CURRENT_GO=$(go version 2>/dev/null | grep -oP 'go\K[0-9.]+' || echo "0.0")
if [ "$(printf '%s\n' "1.25" "$CURRENT_GO" | sort -V | head -1)" != "1.25" ]; then
  echo "System Go $CURRENT_GO is too old (need >= 1.25), installing via mise..."
  "$HOME/.local/bin/mise" use --global go@latest
fi

# Ensure mise-managed go is in PATH after install
export PATH="$HOME/.local/share/mise/shims:$PATH"

BUILD_DIR=$(mktemp -d)
# Expand BUILD_DIR at trap-set time (intentional) so the temp path is captured
# shellcheck disable=SC2064
trap "rm -rf $BUILD_DIR" EXIT

git clone https://github.com/abenz1267/elephant.git "$BUILD_DIR/elephant"
cd "$BUILD_DIR/elephant"

go build -o elephant ./cmd/elephant
sudo install -Dm755 elephant /usr/local/bin/elephant

echo "Elephant installed successfully"

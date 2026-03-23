#!/bin/bash
# Install Elephant — data provider backend for the Walker app launcher
# https://github.com/abenz1267/elephant
set -eEo pipefail

if command -v elephant &>/dev/null; then
  echo "Elephant already installed: $(elephant --version 2>/dev/null || true)"
  exit 0
fi

echo "Installing Elephant..."
ELEPHANT_VERSION=$(curl -s "https://api.github.com/repos/abenz1267/elephant/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -Lo /tmp/elephant.tar.gz "https://github.com/abenz1267/elephant/releases/latest/download/elephant_${ELEPHANT_VERSION}_Linux_x86_64.tar.gz"
tar xf /tmp/elephant.tar.gz -C /tmp elephant
sudo install -Dm755 /tmp/elephant /usr/local/bin/elephant
rm -f /tmp/elephant.tar.gz /tmp/elephant

echo "Elephant installed successfully"

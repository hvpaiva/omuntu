#!/bin/bash
set -eEo pipefail

if command -v lazydocker &>/dev/null; then
  echo "lazydocker already installed: $(lazydocker --version)"
  exit 0
fi

echo "Installing lazydocker..."
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -Lo /tmp/lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar xf /tmp/lazydocker.tar.gz -C /tmp lazydocker
sudo install -Dm755 /tmp/lazydocker /usr/local/bin/lazydocker
rm -f /tmp/lazydocker.tar.gz /tmp/lazydocker

echo "Installed: $(lazydocker --version)"

#!/bin/bash
# Install mise (runtime version manager) via official installer
# On Arch this comes from pacman; Ubuntu needs the curl installer

if command -v mise &>/dev/null; then
  echo "mise already installed: $(mise --version)"
  exit 0
fi

echo "Installing mise..."
curl https://mise.jdx.dev/install.sh | sh

if [[ ! -x "$HOME/.local/bin/mise" ]]; then
  echo "ERROR: mise installer completed but binary not found at ~/.local/bin/mise"
  exit 1
fi
echo "Installed: $($HOME/.local/bin/mise --version)"

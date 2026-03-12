#!/bin/bash
# Install Rust via rustup (recommended over Ubuntu's packaged rustc)
# This runs before base.sh so cargo packages and source builds use the latest stable Rust

if [[ -x "$HOME/.cargo/bin/rustc" ]]; then
  echo "Rust already installed: $($HOME/.cargo/bin/rustc --version)"
  exit 0
fi

echo "Installing Rust via rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

if [[ ! -x "$HOME/.cargo/bin/rustc" ]]; then
  echo "ERROR: rustup completed but rustc not found at ~/.cargo/bin/rustc"
  exit 1
fi
echo "Installed: $($HOME/.cargo/bin/rustc --version)"

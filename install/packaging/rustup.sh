#!/bin/bash
# Install Rust via rustup (Ubuntu 24.04's rustc 1.75 is too old for SwayOSD)
# This runs before base.sh so cargo packages and source builds use the latest Rust

if [[ -x "$HOME/.cargo/bin/rustc" ]]; then
  echo "Rust already installed: $($HOME/.cargo/bin/rustc --version)"
  exit 0
fi

echo "Installing Rust via rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
echo "Installed: $($HOME/.cargo/bin/rustc --version)"

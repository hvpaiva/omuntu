#!/bin/bash
# Install Nerd Fonts (JetBrainsMono and iAWriter)

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

install_nerd_font() {
  local font_name="$1"
  local font_dir="$FONT_DIR/$font_name"

  if [[ -d "$font_dir" ]] && ls "$font_dir"/*.ttf &>/dev/null; then
    echo "$font_name already installed"
    return 0
  fi

  echo "Installing $font_name Nerd Font..."
  local tmp_dir
  tmp_dir=$(mktemp -d)
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz"

  if curl -sL "$url" -o "$tmp_dir/${font_name}.tar.xz"; then
    mkdir -p "$font_dir"
    tar -xf "$tmp_dir/${font_name}.tar.xz" -C "$font_dir"
    rm -rf "$tmp_dir"
    echo "$font_name installed"
  else
    echo "Failed to download $font_name"
    rm -rf "$tmp_dir"
  fi
}

install_nerd_font "JetBrainsMono"
install_nerd_font "iA-Writer"

fc-cache -f

set -eEo pipefail

# Install all apt packages
mapfile -t apt_packages < <(grep -v '^#' "$OMUNTU_INSTALL/packages/apt.packages" | grep -v '^$')
omarchy-pkg-add "${apt_packages[@]}"

# Install PPA packages
mapfile -t ppa_packages < <(grep -v '^#' "$OMUNTU_INSTALL/packages/ppa.packages" | grep -v '^$')
omarchy-pkg-add "${ppa_packages[@]}"

# Setup Flathub remote (flatpak itself is in apt.packages)
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true

# Install Flatpak packages
mapfile -t flatpak_packages < <(grep -v '^#' "$OMUNTU_INSTALL/packages/flatpak.packages" | grep -v '^$')
for pkg in "${flatpak_packages[@]}"; do
  flatpak install -y flathub "$pkg" || true
done

# Install cargo packages (rustup installed by packaging/rustup.sh)
export PATH="$HOME/.cargo/bin:$PATH"
if command -v cargo &>/dev/null; then
  mapfile -t cargo_packages < <(grep -v '^#' "$OMUNTU_INSTALL/packages/cargo.packages" | grep -v '^$')
  for pkg in "${cargo_packages[@]}"; do
    cargo install "$pkg" 2>/dev/null || true
  done
fi

# Install pip packages via pipx (Ubuntu 24.04 marks system Python as externally
# managed; pipx installs CLI tools in isolated envs exposed via ~/.local/bin)
if command -v pipx &>/dev/null; then
  mapfile -t pip_packages < <(grep -v '^#' "$OMUNTU_INSTALL/packages/pip.packages" | grep -v '^$')
  for pkg in "${pip_packages[@]}"; do
    pipx install "$pkg" 2>/dev/null || true
  done
fi

# Create symlinks for differently-named binaries
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  mkdir -p ~/.local/bin
  ln -sf "$(which fdfind)" ~/.local/bin/fd
fi

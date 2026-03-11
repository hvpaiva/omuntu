# Setup Ubuntu repositories and install build tools

if [[ -n ${OMUNTU_ONLINE_INSTALL:-} ]]; then
  # Add Hyprland PPA
  sudo add-apt-repository -y ppa:cppiber/hyprland

  # Add Ghostty PPA
  sudo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu

  # Add Charm repo (gum) — may already exist from presentation.sh
  if [ ! -f /etc/apt/sources.list.d/charm.list ]; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  fi

  # Update package lists
  sudo apt-get update

  # Install build essentials
  sudo apt-get install -y build-essential cmake meson ninja-build curl wget pkg-config

  # Install Flatpak support
  sudo apt-get install -y flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
fi

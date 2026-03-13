# Setup Ubuntu repositories (PPAs and third-party repos)
# Packages are installed later in packaging/base.sh via apt.packages

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

  # Update package lists after adding all repos
  # apt-get update exits non-zero if any index file fails (e.g. AppStream
  # metadata), even when Packages lists succeed. apt-get install still
  # fails loudly if packages are unavailable.
  sudo apt-get update || true
fi

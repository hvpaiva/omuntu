NVIDIA="$(lspci | grep -i 'nvidia')"

if [[ -n $NVIDIA ]]; then
  echo "NVIDIA GPU detected, installing drivers..."

  # Install kernel headers for current kernel
  sudo apt-get install -y "linux-headers-$(uname -r)"

  # Use ubuntu-drivers to auto-install the best driver
  if command -v ubuntu-drivers &>/dev/null; then
    sudo ubuntu-drivers install
  else
    sudo apt-get install -y ubuntu-drivers-common
    sudo ubuntu-drivers install
  fi

  # Configure modprobe for early KMS
  sudo tee /etc/modprobe.d/nvidia.conf <<EOF >/dev/null
options nvidia_drm modeset=1
EOF

  # Determine GPU architecture for Hyprland env vars
  if echo "$NVIDIA" | grep -qE "GTX 16[0-9]{2}|RTX [2-5][0-9]{3}|RTX PRO [0-9]{4}|Quadro RTX|RTX A[0-9]{4}|A[1-9][0-9]{2}|H[1-9][0-9]{2}|T4|L[0-9]+"; then
    GPU_ARCH="turing_plus"
  elif echo "$NVIDIA" | grep -qE "GTX (9[0-9]{2}|10[0-9]{2})|GT 10[0-9]{2}|Quadro [PM][0-9]{3,4}|Quadro GV100|MX *[0-9]+|Titan (X|Xp|V)|Tesla V100"; then
    GPU_ARCH="maxwell_pascal_volta"
  fi

  if [[ -z ${GPU_ARCH:-} ]]; then
    echo "No specific env config for your NVIDIA GPU."
    exit 0
  fi

  # Add NVIDIA environment variables
  if [[ $GPU_ARCH = "turing_plus" ]]; then
    cat >>"$HOME/.config/hypr/envs.conf" <<'EOF'

# NVIDIA (Turing+ with GSP firmware)
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
  elif [[ $GPU_ARCH = "maxwell_pascal_volta" ]]; then
    cat >>"$HOME/.config/hypr/envs.conf" <<'EOF'

# NVIDIA (Maxwell/Pascal/Volta without GSP firmware)
env = NVD_BACKEND,egl
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
  fi
fi

# Install Vulkan drivers matching detected GPU hardware
# (NVIDIA Vulkan is handled by nvidia.sh via nvidia-utils)

PACKAGES=()

if lspci | grep -iE "(VGA|Display).*Intel" > /dev/null; then
  PACKAGES+=("mesa-vulkan-drivers")
fi

if lspci | grep -iE "(VGA|Display).*AMD" > /dev/null; then
  PACKAGES+=("mesa-vulkan-drivers")
fi

if (( ${#PACKAGES[@]} > 0 )); then
  # Remove duplicates
  mapfile -t PACKAGES < <(printf '%s\n' "${PACKAGES[@]}" | sort -u)
  omarchy-pkg-add "${PACKAGES[@]}"
fi

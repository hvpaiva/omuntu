# This installs hardware video acceleration for Intel GPUs
if INTEL_GPU=$(lspci | grep -iE 'vga|3d|display' | grep -i 'intel'); then
  if [[ ${INTEL_GPU,,} =~ (hd\ graphics|uhd\ graphics|xe|iris|arc) ]]; then
    omarchy-pkg-add intel-media-va-driver
  elif [[ ${INTEL_GPU,,} =~ "gma" ]]; then
    omarchy-pkg-add i965-va-driver
  fi
fi

abort() {
  echo -e "\e[31mOmuntu install requires: $1\e[0m"
  echo
  gum confirm "Proceed anyway on your own accord and without assistance?" || exit 1
}

# Must be Ubuntu 24.04+
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  if [[ "$ID" != "ubuntu" ]]; then
    abort "Ubuntu 24.04+"
  fi
  if [[ "${VERSION_ID%%.*}" -lt 24 ]]; then
    abort "Ubuntu 24.04+"
  fi
else
  abort "Ubuntu 24.04+"
fi

# Must not be running as root
if (( EUID == 0 )); then
  abort "Running as root (not user)"
fi

# Must be x86 only to fully work
if [[ $(uname -m) != "x86_64" ]]; then
  abort "x86_64 CPU"
fi

# Cleared all guards
echo "Guards: OK"

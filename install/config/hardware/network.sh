# Ensure NetworkManager is running (Ubuntu default)
sudo systemctl enable --now NetworkManager.service

# Prevent systemd-networkd-wait-online timeout on boot
sudo systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
sudo systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true

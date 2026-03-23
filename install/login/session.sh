# Create Hyprland session files for SDDM + UWSM
# hyprland.desktop: used by UWSM internally to resolve the compositor binary
# hyprland-uwsm.desktop: the session SDDM should launch (starts Hyprland via UWSM)
sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
NoDisplay=true
EOF

sudo tee /usr/share/wayland-sessions/hyprland-uwsm.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland (UWSM)
Comment=Hyprland managed by the Universal Wayland Session Manager
Exec=uwsm start -- hyprland.desktop
Type=Application
DesktopNames=Hyprland
EOF

# Pre-select hyprland-uwsm as the default SDDM session for the current user.
# SDDM reads state.conf to restore the last selected session on login.
sudo mkdir -p /var/lib/sddm
sudo tee /var/lib/sddm/state.conf > /dev/null <<EOF
[Last]
Session=hyprland-uwsm.desktop
User=$(whoami)
EOF

# Create environment.d for Wayland session
mkdir -p ~/.config/environment.d
cat > ~/.config/environment.d/wayland.conf <<EOF
XDG_CURRENT_DESKTOP=Hyprland
XDG_SESSION_TYPE=wayland
QT_QPA_PLATFORM=wayland
GDK_BACKEND=wayland,x11
SDL_VIDEODRIVER=wayland
EOF

# Configure XDG desktop portal
mkdir -p ~/.config/xdg-desktop-portal
cat > ~/.config/xdg-desktop-portal/hyprland-portals.conf <<EOF
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.FileChooser=gtk
EOF

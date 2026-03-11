# Create Hyprland session for the existing display manager
sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
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

# Omuntu

> **WARNING: Do not install Omuntu at this time.** The installer has known critical issues and is not mature enough for use. Running the installation now may leave your system in an inconsistent state. This project is under active development — no support will be provided for broken installs.

Omuntu is a fork of [Omarchy](https://github.com/basecamp/omarchy) adapted for **Ubuntu 24.04 LTS**.

It transforms an existing Ubuntu 24.04 installation into the Omarchy desktop experience (Hyprland + themes + tooling) via a desktop configurator/installer — not an ISO.

## Quick Start

```bash
wget -qO- https://raw.githubusercontent.com/hvpaiva/omuntu/dev/boot.sh | bash
```

After installation, log out and select **Hyprland** in your display manager (GDM or other).

## What Omuntu Does

1. Adds PPAs and repos (cppiber/hyprland, ghostty, charm/gum)
2. Installs packages via apt, Flatpak, cargo, and source builds
3. Copies configs to `~/.config/` (Hyprland, Waybar, Walker, themes, etc.)
4. Creates a Hyprland session in `/usr/share/wayland-sessions/`
5. Applies the default theme
6. Configures hardware (NVIDIA, bluetooth, audio)

## What Omuntu Does NOT Do

- Replace your display manager (GDM stays as-is)
- Plymouth / boot splash theming
- Bootloader configuration
- Autologin / SDDM theming
- Hibernation setup
- Snapshots
- Build an ISO

## Requirements

- Ubuntu 24.04 LTS (or newer)
- x86_64 architecture
- Non-root user with sudo access

## Key Differences from Omarchy

| Feature | Omarchy (Arch) | Omuntu (Ubuntu) |
|---------|---------------|-----------------|
| Package manager | pacman + yay (AUR) | apt + Flatpak |
| Display manager | SDDM (installed) | Keep existing (GDM) |
| Bootloader | Limine | Not managed |
| Network | iwd | NetworkManager |
| Snapshots | snapper + btrfs | Not managed |
| NVIDIA drivers | pacman packages | ubuntu-drivers |

## After Installation

- **Super + Return** — Terminal
- **Super + Space** — App Launcher (Walker)
- **Super + Alt + Space** — Omuntu Menu
- **Super + K** — Keybindings cheatsheet

## Updating

Run `omuntu-update` from the terminal or use the Omuntu Menu > Update > Omuntu.

## License

Omuntu is released under the [MIT License](https://opensource.org/licenses/MIT).

Based on [Omarchy](https://github.com/basecamp/omarchy) by DHH / Basecamp.

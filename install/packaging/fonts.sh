set -eEo pipefail

# Omuntu logo in a font for Waybar use
mkdir -p ~/.local/share/fonts
cp ~/.local/share/omuntu/config/omuntu.ttf ~/.local/share/fonts/
fc-cache

# Install Nerd Fonts (JetBrainsMono, iAWriter)
# shellcheck source=install/packaging/install-nerd-fonts.sh
source "$OMUNTU_INSTALL/packaging/install-nerd-fonts.sh"

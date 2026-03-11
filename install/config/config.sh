# Copy over Omuntu configs
mkdir -p ~/.config
cp -R ~/.local/share/omuntu/config/* ~/.config/

# Use default bashrc from Omuntu
cp ~/.local/share/omuntu/default/bashrc ~/.bashrc

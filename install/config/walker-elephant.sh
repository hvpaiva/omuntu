#!/bin/bash

# Ensure Walker service is started automatically on boot
mkdir -p ~/.config/autostart/
cp $OMUNTU_PATH/default/walker/walker.desktop ~/.config/autostart/

# And is restarted if it crashes or is killed
mkdir -p ~/.config/systemd/user/app-walker@autostart.service.d/
cp $OMUNTU_PATH/default/walker/restart.conf ~/.config/systemd/user/app-walker@autostart.service.d/restart.conf

# Create apt hook to restart walker after updates
sudo mkdir -p /etc/apt/apt.conf.d
sudo tee /etc/apt/apt.conf.d/99-walker-restart > /dev/null << EOF
DPkg::Post-Invoke { "if [ -x $OMUNTU_PATH/bin/omarchy-restart-walker ]; then $OMUNTU_PATH/bin/omarchy-restart-walker || true; fi"; };
EOF

# Link the visual theme menu config
mkdir -p ~/.config/elephant/menus
ln -snf $OMUNTU_PATH/default/elephant/omuntu_themes.lua ~/.config/elephant/menus/omuntu_themes.lua
ln -snf $OMUNTU_PATH/default/elephant/omuntu_background_selector.lua ~/.config/elephant/menus/omuntu_background_selector.lua

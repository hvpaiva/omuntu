# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
# Run omarchy-restart-xcompose to apply changes

# Include fast emoji access
include "%H/.local/share/omuntu/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMUNTU_USER_NAME"
<Multi_key> <space> <e> : "$OMUNTU_USER_EMAIL"
EOF

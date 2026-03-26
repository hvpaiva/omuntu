#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Omuntu locations
export OMUNTU_PATH="$HOME/.local/share/omuntu"
export OMUNTU_INSTALL="$OMUNTU_PATH/install"
export OMUNTU_INSTALL_LOG_FILE="/var/log/omuntu-install.log"
export PATH="$OMUNTU_PATH/bin:$PATH"

# Install
# shellcheck source=install/helpers/all.sh
source "$OMUNTU_INSTALL/helpers/all.sh"
# shellcheck source=install/preflight/all.sh
source "$OMUNTU_INSTALL/preflight/all.sh"
# shellcheck source=install/packaging/all.sh
source "$OMUNTU_INSTALL/packaging/all.sh"
# shellcheck source=install/config/all.sh
source "$OMUNTU_INSTALL/config/all.sh"
# shellcheck source=install/login/all.sh
source "$OMUNTU_INSTALL/login/all.sh"
# shellcheck source=install/post-install/all.sh
source "$OMUNTU_INSTALL/post-install/all.sh"

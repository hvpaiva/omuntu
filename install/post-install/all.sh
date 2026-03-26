run_logged "$OMUNTU_INSTALL/post-install/apt-cleanup.sh"
# shellcheck source=install/post-install/allow-reboot.sh
source "$OMUNTU_INSTALL/post-install/allow-reboot.sh"
# shellcheck source=install/post-install/finished.sh
source "$OMUNTU_INSTALL/post-install/finished.sh"

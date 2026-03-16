# Overwrite parts of the omuntu-menu with user-specific submenus.
# See $OMUNTU_PATH/bin/omuntu-menu for functions that can be overwritten.
#
# WARNING: Overwritten functions will obviously not be updated when Omuntu changes.
#
# Example of minimal system menu:
#
# show_system_menu() {
#   case $(menu "System" "  Lock\n󰐥  Shutdown") in
#   *Lock*) omuntu-lock-screen ;;
#   *Shutdown*) omuntu-system-shutdown ;;
#   *) back_to show_main_menu ;;
#   esac
# }
#
# Example of overriding just the about menu action: (Using zsh instead of bash (default))
#
# show_about() {
#   exec omuntu-launch-or-focus-tui "zsh -c 'fastfetch; read -k 1'"
# }

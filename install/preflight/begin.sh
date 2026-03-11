clear_logo
gum style --foreground 3 --padding "1 0 0 $PADDING_LEFT" "Installing..."
echo

# Keep sudo credentials alive throughout installation
# run_logged scripts use </dev/null so sudo can't prompt for password
sudo -v
(while true; do sudo -n true; sleep 55; done) &
SUDO_KEEPALIVE_PID=$!

start_install_log

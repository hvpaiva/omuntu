clear_logo
gum style --foreground 3 --padding "1 0 0 $PADDING_LEFT" "Installing..."
echo

# Grant passwordless sudo for the duration of the install.
# run_logged redirects stdin from /dev/null, so sudo can never prompt
# for a password inside logged scripts. This eliminates that entirely.
# The sudoers file is removed in post-install/finished.sh.
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/99-omuntu-installer >/dev/null
sudo chmod 440 /etc/sudoers.d/99-omuntu-installer

# Prevent any interactive prompts from apt/dpkg during install
export DEBIAN_FRONTEND=noninteractive

start_install_log

# shellcheck source=install/preflight/guard.sh
source "$OMUNTU_INSTALL/preflight/guard.sh"
# shellcheck source=install/preflight/begin.sh
source "$OMUNTU_INSTALL/preflight/begin.sh"
run_logged "$OMUNTU_INSTALL/preflight/show-env.sh"
run_logged "$OMUNTU_INSTALL/preflight/apt-setup.sh"
run_logged "$OMUNTU_INSTALL/preflight/migrations.sh"
run_logged "$OMUNTU_INSTALL/preflight/first-run-mode.sh"

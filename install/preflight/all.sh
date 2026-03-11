source $OMUNTU_INSTALL/preflight/guard.sh
source $OMUNTU_INSTALL/preflight/begin.sh
run_logged $OMUNTU_INSTALL/preflight/show-env.sh
run_logged $OMUNTU_INSTALL/preflight/apt-setup.sh
run_logged $OMUNTU_INSTALL/preflight/migrations.sh
run_logged $OMUNTU_INSTALL/preflight/first-run-mode.sh

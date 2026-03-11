# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(OMUNTU_CHROOT_INSTALL|OMUNTU_ONLINE_INSTALL|OMUNTU_USER_NAME|OMUNTU_USER_EMAIL|USER|HOME|OMUNTU_REPO|OMUNTU_REF|OMUNTU_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done

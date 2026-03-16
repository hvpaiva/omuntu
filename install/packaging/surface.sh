# NOTE: On Ubuntu, linux-firmware-marvell is included in the linux-firmware package.
# The linux-surface project (https://github.com/linux-surface/linux-surface) provides
# additional Surface-specific kernel and firmware support for Ubuntu.
if omuntu-hw-surface; then
  omuntu-pkg-add linux-firmware-marvell
fi

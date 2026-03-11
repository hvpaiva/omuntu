#!/bin/bash

# Set install mode to online since boot.sh is used for curl installations
export OMUNTU_ONLINE_INSTALL=true

ansi_art='
  ▄██████▄   ▄██████████████▄  ▄█   █▄   ▄██████▄   ███████████  ▄█   █▄
 ███    ███  ███   ███    ███  ███   ███  ███    ███  ███     ███  ███   ███
 ███    ███  ███   ███    ███  ███   ███  ███    ███  ███     ███  ███   ███
 ███    ███  ███   ███    ███  ███   ███  ███    ███  ███     ███  ███   ███
 ███    ███  ███   ███    ███  ███   ███  ███    ███  ███     ███  ███   ███
 ███    ███  ███   ███    ███  ███   ███  ███    ███  ███     ███  ███   ███
 ███    ███  ███   ███    ███  ███   ███  ███    ███  ███     ███  ███   ███
  ▀██████▀   ▀█   ███    █▀    ▀█████▀    ▀██████▀   ████████▀    ▀█████▀ '

clear
echo -e "\n$ansi_art\n"

# Use custom branch if instructed, otherwise default to dev
OMUNTU_REF="${OMUNTU_REF:-dev}"

sudo apt-get update && sudo apt-get install -y git curl software-properties-common

# Use custom repo if specified, otherwise default to hvpaiva/omuntu
OMUNTU_REPO="${OMUNTU_REPO:-hvpaiva/omuntu}"

echo -e "\nCloning Omuntu from: https://github.com/${OMUNTU_REPO}.git"
rm -rf ~/.local/share/omuntu/
git clone "https://github.com/${OMUNTU_REPO}.git" ~/.local/share/omuntu >/dev/null

echo -e "\e[32mUsing branch: $OMUNTU_REF\e[0m"
cd ~/.local/share/omuntu
git fetch origin "${OMUNTU_REF}" && git checkout "${OMUNTU_REF}"
cd -

echo -e "\nInstallation starting..."
source ~/.local/share/omuntu/install.sh

#!/usr/bin/env bash

# Colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
RESET_COLOR="\033[0m"

# Symbols
CHECKMARK="\xE2\x9C\x94"
GREEN_CHECK="$GREEN${CHECKMARK}$RESET_COLOR"
PARTYPOPPER="\xF0\x9F\x8E\x89"
BLUE_ARROW="$BLUE=>$RESET_COLOR"


########################################################
#
#   cfg stash/restore
#
########################################################

# List of directories to be stashed
CONFIG_BACKUP_DIRS=(
    nvim
    gh
)

########################################################
#
#   For cfg install
#
########################################################

# List of linux packages to install
APT_PACKAGES=(
    git
    curl
    wget
    python3
    # python-dev
    # python-pip
    python3-dev
    python3-pip
    zsh
    grep
    # awk
    gawk
    software-properties-common
    zsh
    fd-find
    sysstat
    iotop
)

# List of mac packages to install
HOMEBREW_PACKAGES=(
    fastfetch
    gh
    jq
    coreutils
    make
    gnu-tar
    gnu-sed
    gawk
    grep
    findutils
    wget
    httpie
    gnupg
    pinentry-mac
    tree
)

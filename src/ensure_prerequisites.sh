#!/usr/bin/env bash

ensure_prerequisites() {
    # Check if git is installed
    if [ "$OS" == "darwin" ]; then
        ensure_mac_prequisites
    elif [ "$OS" == "windows" ]; then
        ensure_windows_prequisites
    fi
}

ensure_mac_prequisites() {
    check_and_install_git
    # Check if brew is installed
    if ! [ -x "$(command -v brew)" ]; then
        echo -e "Homebrew not installed! Installing homebrew ..." >&2
        sudo echo "sudo power!"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/bryan/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}
ensure_windows_prequisites() {
    # Check if choco is installed
    if ! [ -x "$(command -v choco)" ]; then
        echo -e "Chocolatey not installed! Installing chocolatey ..." >&2
        install_choco
    fi
    check_and_install_git
}

check_and_install_git() {
    if ! [ -x "$(command -v git)" ]; then
        echo -e "Git not installed! Installing git ..." >&2
        # Install git
        if [ "$OS" == "linux" ]; then
            sudo apt-get install git
        elif [ "$OS" == "darwin" ]; then
            xcode-select --install
        elif [ "$OS" == "windows" ]; then
            choco install git
        fi
    fi
}

install_choco() {
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
}
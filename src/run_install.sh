#!/usr/bin/env bash

run_install() {
    # TODO: Implement install functionality
    echo -e "Installing packages..."

    if [ "$OS" == "linux" ]; then
        # TODO: add support for RPM, ARCH, and NIX
        if has_apt; then
            install_debian
        else
            echo -e "apt not found! Bailing out!"
            exit 1
        fi
    elif [ "$OS" == "darwin" ]; then
        install_mac
    elif [ "$OS" == "windows" ]; then
        install_windows
    fi

    # TODO: instal zsh, zsh theme, neovim, python3
    
    # TODO: install for linux dev servers: fonts, nextcloud, nvm, gh, docker, docker-compose, golang, build-essential, lolcat
    # TODO: install for linux desktops: kitty, fonts, nextcloud, vscode-insiders, nvm, gh, docker, docker-compose, golang, build-essential, lolcat
    # TODO: install for mac iterm2, fonts, nexcloud, vscode-insiders, nvm, gh, docker, docker-compose, golang, build-essential, lolcat
    # TODO: install ocaml
    # TODO: install golang
    # TODO: install nvm
    # TODO: Add seafile drive : https://help.seafile.com/drive_client/drive_client_for_linux/ 
}


has_apt() {
    if command -v apt > /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}

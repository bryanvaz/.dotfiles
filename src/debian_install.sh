#!/usr/bin/env bash

install_debian() {
    echo -e "\nUpdating APT repos before we begin..."
    sudo apt update

    echo -e "\nDo you want to upgrade all your packages before getting started? (recommended)"
    read -n 1 -p "Upgrade packages? (y/n)" res_char
    echo -e " "
    if [ "$res_char" == "y" ]; then
        sudo apt upgrade -y
        echo -e "******* upgrade complete *******\n"
    fi

    echo -e "Installing base packages..."
    echo -e "The following packages will be installed if not present: ${APT_PACKAGES[@]}"
    echo -e "Do you want to continue? (if not will skip to next step)"
    read -n 1 -p "Install base packages? (y/n)" res_char
    echo -e " "
    if [ "$res_char" == "y" ]; then
        sudo apt-get install -y "${APT_PACKAGES[@]}"
        echo -e "checking for fd-find being correctly symlinked"
        if command -v fdfind > /dev/null; then
            LINK_PATH="/usr/local/bin/fd"
            if [ -L "$LINK_PATH" ]; then
                TARGET_PATH=$(readlink "$LINK_PATH")
                if [ "$TARGET_PATH" == "$(which fdfind)" ]; then
                    echo "fd-find correctly symlinked to $LINK_PATH"
                else
                    echo "fd at '$LINK_PATH' is not linked to fdfind at $(which fdfind). It is linked to '$TARGET_PATH'"
                    echo "Do you want to relink?"
                    read -n 1 -p "Relink fd-find? (y/n)" res_char
                    echo -e " "
                    if [ "$res_char" == "y" ]; then
                        rm -f $LINK_PATH
                        sudo ln -sf $(which fdfind) $LINK_PATH
                    fi                    
                fi
            else
                echo "fd at '$LINK_PATH' is not a symlink"
                echo "Do you want to symlink?"
                read -n 1 -p "Symlink fd-find? (y/n)" res_char
                echo -e " "
                if [ "$res_char" == "y" ]; then
                    if [ -f "$LINK_PATH" ]; then
                        rm -f $LINK_PATH
                    fi
                    sudo ln -sf $(which fdfind) $LINK_PATH
                fi
            fi
        fi
        echo -e "******* base packages installed *******\n"

    fi

    if ! has_zsh; then
        echo -e "ZSH not installed, cannot configure zsh. Skipping zsh setup..."
    else
        if is_zsh_active; then
            echo -e "Zsh is already activated"
        else
            echo -e "Activating zsh..."
            chsh -s $(which zsh)
            echo -e "******* Zsh activated! *******\n"
        fi

        # Now install special stuff
        if has_oh_my_zsh; then
            echo -e "oh-my-zsh already installed! Skipping..."
        else
            echo -e "Installing oh-my-zsh..."
            rm -Rf $HOME/.oh-my-zsh
            ZSH= RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            echo -e "******* oh-my-zsh installed! *******\n"
        fi
        install_zsh_theme
    fi
    


    if has_neovim; then
        echo -e "Neovim already installed! Skipping..."
    else
        # Install neovim
        echo -e "Installing Neovim from nightly (gotta do nightly, sorry)..."
        wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
        sudo mkdir -p /usr/local/lib/neovim
        sudo mv /tmp/nvim.appimage /usr/local/lib/neovim/nvim.appimage
        sudo chmod 755 /usr/local/lib/neovim/nvim
        sudo ln -s /usr/local/lib/neovim/nvim /usr/local/bin/nvim
        echo -e "******* Neovim installed! *******\n"
    fi
    echo -e "Installing Neovim plugin dependencies..."
    if command -v rg > /dev/null; then
        echo -e "* ripgrep found."
    else
        echo -e "* Installing ripgrep for telescope..."
        wget -O /tmp/ripgrep_13.0.0_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
        sudo dpkg -i /tmp/ripgrep_13.0.0_amd64.deb
    fi


    # Install gh
    if has_gh; then
        echo -e "gh already installed! Skipping..."
    else
        echo -e "Install Github Client? (recommended)"
        read -n 1 -p "Install gh? (y/n)" res_char
        echo -e " "
        if [ "$res_char" == "y" ]; then
            echo -e "Installing gh..."
            type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo -e "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install gh -y
            echo -e "******* gh installed! *******\n"
        fi
    fi

    # Install docker
    if docker_installed; then
        echo -e "Docker already installed! Skipping..."
    else
        echo -e "Install Docker? (recommended)"
        read -n 1 -p "Install Docker? (y/n)" res_char
        echo -e " "
        if [ "$res_char" == "y" ]; then
            echo -e "Installing Docker..."

            echo -e "Setup docker group for non-root access? (recommended)"
            read -n 1 -p "Setup docker group? (y/n)" res_char
            echo -e " "
            if [ "$res_char" == "y" ]; then
                if getent group docker > /dev/null; then
                    echo -e "docker group already exists, adding user ..."
                else
                    sudo groupadd docker
                fi
                echo "adding user to docker..."
                sudo usermod -aG docker $USER
                # newgrp docker
                echo -e "******* Docker group setup complete! *******\n"
            fi
            echo -e "Cleansing any traces of previous docker installs, if present..."
            sudo apt-get remove docker docker-engine docker.io containerd runc
            echo -e "\nInstalling docker repo prereqs..."
            sudo apt-get update
            sudo apt-get -y install \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg \
                lsb-release

            echo -e "\nInstalling docker repo keyring..."
            sudo install -m 0755 -d /etc/apt/keyrings
            if [ -e /etc/apt/keyrings/docker.gpg ]; then
                sudo mv /etc/apt/keyrings/docker.gpg /etc/apt/keyrings/docker.gpg.bak
            fi
            if [ "$DISTRO" == "ubuntu" ]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            elif [ "$DISTRO" == "debian" ]; then
                curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            else
                curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            fi
            sudo chmod a+r /etc/apt/keyrings/docker.gpg

            if [ "$DISTRO" == "ubuntu" ]; then
                echo \
                    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                    "$(. /etc/os-release && echo -e "$VERSION_CODENAME")" stable" | \
                    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            elif [ "$DISTRO" == "debian" ]; then
                echo \
                    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
                    "$(. /etc/os-release && echo -e "$VERSION_CODENAME")" stable" | \
                    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null    
            else
                echo \
                    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
                    "$(. /etc/os-release && echo -e "$VERSION_CODENAME")" stable" | \
                    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            fi

            echo -e "\nRefreshing APT with docker repo data..."
            sudo apt-get update
            echo -e "\nInstalling docker..."
            sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            echo -e "******* Docker installed! *******\n"
        fi
    fi

    # Install lolcat
    if command -v lolcat > /dev/null; then
        echo -e "lolcat already installed! Skipping..."
    else
        echo -e "Install lolcat? (recommended)"
        read -n 1 -p "Install lolcat? (y/n)" res_char
        echo -e " "
        if [ "$res_char" == "y" ]; then
            echo -e "Installing lolcat..."
            wget -O /tmp/figurine_linux_v1.2.1.tar.gz https://github.com/arsham/rainbow/releases/download/v1.2.1/figurine_linux_v1.2.1.tar.gz
            mkdir -p /tmp/figurine
            tar -xzf /tmp/figurine_linux_v1.2.1.tar.gz -C /tmp/figurine
            sudo mkdir -p /usr/local/lib/figurine
            sudo mv /tmp/figurine/deploy/rainbow /usr/local/lib/figurine/rainbow
            sudo chmod 755 /usr/local/lib/figurine/rainbow
            sudo ln -s /usr/local/lib/figurine/rainbow /usr/local/bin/lolcat
            echo -e "******* lolcat installed! *******\n"
        fi
    fi

    # Install build-essential
    echo -e "Do you want to install build essentials? (recommended if not a ops server)"
    read -n 1 -p "Install build-essential? (y/n)" res_char
    echo -e " "
    if [ "$res_char" == "y" ]; then
        sudo apt-get install build-essential
    fi

    # Install nvm
    echo -e "TODO: Install nvm and node"

    if command -v go > /dev/null; then
        echo -e "go already installed! Skipping..."
    else
        echo -e "Install golang? (recommended)"
        read -n 1 -p "Install golang? (y/n)" res_char
        echo -e " "
        if [ "$res_char" == "y" ]; then
            echo -e "Installing go..."
            wget -O /tmp/go1.21.0.linux-amd64.tar.gz https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf /tmp/go1.21.0.linux-amd64.tar.gz
            echo -e "******* go installed! *******\n"
            go install -v golang.org/x/tools/cmd/goimports@latest
            go install -v honnef.co/go/tools/cmd/staticcheck@latest
            go install -v golang.org/x/tools/gopls@latest
            go install -v github.com/go-delve/delve/cmd/dlv@latest
            go install -v github.com/stamblerre/gocode@v1.0.0
        fi
    fi
    

    # Install poetry
    if command -v poetry > /dev/null; then
        echo -e "poetry already installed! Skipping..."
    else
        echo -e "Install poetry (python package manager)? (recommended)"
        read -n 1 -p "Install poetry? (y/n)" res_char
        echo -e " "
        if [ "$res_char" == "y" ]; then
            echo -e "Installing poetry..."
            curl -sSL https://install.python-poetry.org | python3 -
            echo -e "******* poetry installed! *******\n"
        fi
    fi

    echo -e "TODO: Install ocaml"

    echo -e "TODO: Install rust toolchain"

    echo -e "TODO: Install zig toolchain"

    echo -e "TODO: Install seadrive"



    # TODO: instal zsh, zsh theme, neovim, python3
    
    # TODO: install for linux dev servers: fonts, nextcloud, nvm, gh, docker, docker-compose, golang, build-essential, lolcat
    # TODO: install for linux desktops: kitty, fonts, nextcloud, vscode-insiders, nvm, gh, docker, docker-compose, golang, build-essential, lolcat
    # TODO: install for mac iterm2, fonts, nexcloud, vscode-insiders, nvm, gh, docker, docker-compose, golang, build-essential, lolcat
    # TODO: install ocaml
    # TODO: install golang
    # TODO: install nvm
    # TODO: Add seafile drive : https://help.seafile.com/drive_client/drive_client_for_linux/ 
    # TODO: brew install stats for system monitoring
}


has_zsh() {
    if command -v zsh > /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}

is_zsh_active() {
    if ! has_zsh; then
        return 1 # false
    fi
    ZSH_PATH=$(which zsh)
    CURR_SHELL=$(getent passwd $USER | cut -d: -f7)
    if [ "$CURR_SHELL" == "$ZSH_PATH" ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

has_oh_my_zsh() {
    if [ -d "${HOME}/.oh-my-zsh" ] && [ -f "${HOME}/.oh-my-zsh/oh-my-zsh.sh" ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

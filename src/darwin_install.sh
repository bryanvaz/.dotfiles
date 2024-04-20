#!/usr/bin/env bash

install_mac() {
    echo -e "$BLUE_ARROW Checking elevated privileges..."
    sudo echo -ne ""
    echo -e "$BLUE_ARROW Updating homebrew before we begin..."
    brew update

    ##############################
    # Check zsh and oh my zsh and install theme
    ##############################

    echo -e "$YELLOW***** Setting up oh-my-zsh and prefered themes *****$RESET_COLOR"
    if ! which zsh > /dev/null; then
        # If zsh is not installed, install it using brew
        echo -e "$BLUE_ARROW Zsh is not installed. Installing..."
        brew install zsh
        echo -e "$GREEN_CHECK Zsh successfully installed."
    else
        echo -e "$GREEN_CHECK Zsh is already installed."
    fi

    current_shell=$(dscl . -read ~/ UserShell | awk '{print $2}')
    if [ "$current_shell" != "$(which zsh)" ]; then
        echo "$BLUE_ARROW Current shell is not zsh. Resetting..."
        # If it's not, change the default shell to zsh
        chsh -s "$(which zsh)"
        echo -e "$GREEN_CHECK shell changed to zsh."
    fi

    # Check if .oh-my-zsh directory exists in the home directory
    if [ ! -d "$HOME/.oh-my-zsh" ] ; then
        echo -e "$BLUE_ARROW Oh My Zsh is not installed. Installing..."
        # If not, install oh-my-zsh
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo -e "$GREEN_CHECK Oh My Zsh is already installed."
    fi

    install_zsh_theme

    ##############################
    # Install homebrew packages
    ##############################

    echo -e "$YELLOW***** Installing homebrew packages *****$RESET_COLOR"
    for package in "${HOMEBREW_PACKAGES[@]}"; do
        if brew list --formula -1 | grep -q "^${package}\$"; then
            echo -e "$GREEN_CHECK $package is already installed"
        else
            echo -e "$BLUE_ARROW Installing $package..."
            brew install "$package"
            echo -e "$GREEN_CHECK $package installed"
        fi
    done

    ##############################
    # Configure GPG for mac to use pinentry-mac
    ##############################

    echo -e "$YELLOW***** Configuring GPG for mac *****$RESET_COLOR"
    if ! [ -f "$HOME/.gnupg/gpg-agent.conf" ]; then
        echo -e "$BLUE_ARROW Creating gpg-agent.conf..."
        mkdir -p "$HOME/.gnupg"
        echo "" >> "$HOME/.gnupg/gpg-agent.conf"
        echo -e "$GREEN_CHECK gpg-agent.conf created!"
    fi
    
    if grep -q "use-standard-socket" "$HOME/.gnupg/gpg-agent.conf"; then
        echo -e "$GREEN_CHECK 'use-standard-socket' found in gpg-agent.conf"
    else
        echo -e "$BLUE_ARROW 'use-standard-socket' not found in gpg-agent.conf"
        echo "use-standard-socket" >> "$HOME/.gnupg/gpg-agent.conf"
        echo -e "$GREEN_CHECK 'use-standard-socket' added to gpg-agent.conf"
    fi

    if grep -q "pinentry-program" "$HOME/.gnupg/gpg-agent.conf"; then
        echo -e "$GREEN_CHECK 'pinentry' found in gpg-agent.conf"
    else
        echo -e "$BLUE_ARROW 'pinentry-program' not found in gpg-agent.conf"
        echo -e "pinentry-program $(which pinentry-mac)" >> "$HOME/.gnupg/gpg-agent.conf"
        echo -e "$GREEN_CHECK 'pinentry-program $(which pinentry-mac)' added to gpg-agent.conf"
    fi
    

    ##############################
    # Install neovim
    ##############################

    echo -e "$YELLOW***** Installing neovim and plugin deps *****$RESET_COLOR"

    if has_neovim; then
        echo -e "$GREEN_CHECK Neovim already installed!"
    else
        echo -e "$BLUE_ARROW downloading neovim..."
        curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-macos.tar.gz -o /tmp/nvim-macos-x86_64.tar.gz
        echo -e "$BLUE_ARROW unpacking neovim..."
        tar -xzf /tmp/nvim-macos-x86_64.tar.gz -C /tmp
        echo -e "$BLUE_ARROW installing neovim..."
        sudo mkdir -p /usr/local/lib/nvim
        sudo cp -R /tmp/nvim-macos/* /usr/local/lib/nvim
        sudo ln -s /usr/local/lib/nvim/bin/nvim /usr/local/bin/nvim
        echo -e "$GREEN_CHECK Neovim installed!"
    fi

    if brew list --formula -1 | grep -q "^ripgrep\$"; then
        echo -e "$GREEN_CHECK ripgrep is already installed (for telescope)"
    else
        echo -e "$BLUE_ARROW Installing ripgrep for telescope..."
        brew install ripgrep
        echo -e "$GREEN_CHECK ripgrep installed"
    fi

    ##############################
    # Install docker
    # TODO: Investigate colima
    ##############################

    echo -e "$YELLOW***** Installing docker *****$RESET_COLOR"
    if docker_installed; then
        echo -e "$GREEN_CHECK Docker is already installed!"
    else
        if [ -d "/Applications/Docker.app" ]; then
            echo -e "$GREEN_CHECK Docker Desktop is already installed!"
            echo -e "  * ${YELLOW}docker is not on path. You may need to run the Desktop app to start it.$RESET_COLOR"
        else
            echo -e "$BLUE_ARROW downloading docker..."
            curl -L https://desktop.docker.com/mac/main/arm64/Docker.dmg -o /tmp/Docker.dmg
            # mount an move docker
            echo -e "$BLUE_ARROW mounting docker..."
            hdiutil attach /tmp/Docker.dmg
            echo -e "$BLUE_ARROW moving docker..."
            sudo cp -R /Volumes/Docker/Docker.app /Applications
            echo -e "$BLUE_ARROW unmounting docker..."
            hdiutil detach /Volumes/Docker
            echo -e "$GREEN_CHECK Docker installed!"
        fi
    fi

    ##############################
    # Install rainbow
    ##############################

    echo -e "$YELLOW***** Installing rainbow (lolcat in go) *****$RESET_COLOR"

    if command -v rainbow > /dev/null; then
        echo -e "$GREEN_CHECK rainbow is already installed!"
    else
        echo -e "$BLUE_ARROW downloading rainbow..."
        curl -L https://github.com/arsham/rainbow/releases/download/v1.2.1/figurine_darwin_v1.2.1.tar.gz -o /tmp/rainbow.tar.gz
        echo -e "$BLUE_ARROW unpacking rainbow..."
        tar -xzf /tmp/rainbow.tar.gz -C /tmp
        echo -e "$BLUE_ARROW installing rainbow..."
        sudo cp /tmp/deploy/rainbow /usr/local/bin/
        sudo chmod +x /usr/local/bin/rainbow
        echo -e "$GREEN_CHECK rainbow installed!"
    fi

    ##############################
    # Xcode command line tools
    ##############################

    echo -e "$YELLOW***** Installing Xcode command line tools *****$RESET_COLOR"
    if xcode-select -p > /dev/null; then
        echo -e "$GREEN_CHECK Xcode command line tools are already installed!"
    else
        echo -e "$BLUE_ARROW Installing Xcode command line tools..."
        xcode-select --install
        echo -e "$GREEN_CHECK Xcode command line tools installed!"
    fi

    ##############################
    # Install nvm
    ##############################

    echo -e "$YELLOW***** Installing nvm *****$RESET_COLOR"
    if [ -d "$HOME/.nvm" ]; then
        echo -e "$GREEN_CHECK nvm is already installed!"
    else
        echo -e "$BLUE_ARROW Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        echo -e "$GREEN_CHECK nvm installed!"
    fi

    ##############################
    # Install gvm
    ##############################

    echo -e "$YELLOW***** Installing gvm *****$RESET_COLOR"
    if brew list --formula -1 | grep -q "^bison\$"; then
        echo -e "$GREEN_CHECK bison is already installed"
    else
        echo -e "$BLUE_ARROW Installing bison ..."
        brew install bison
        echo -e "$GREEN_CHECK bison installed"
    fi
    if brew list --formula -1 | grep -q "^mercurial\$"; then
        echo -e "$GREEN_CHECK mercurial is already installed"
    else
        echo -e "$BLUE_ARROW Installing mercurial ..."
        brew install mercurial
        echo -e "$GREEN_CHECK mercurial installed"
    fi
    if [ -d "$HOME/.gvm" ]; then
        echo -e "$GREEN_CHECK gvm is already installed!"
    else
        echo -e "$BLUE_ARROW Installing gvm..."
        bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
        echo -e "$GREEN_CHECK gvm installed!"
        echo -e "$YELLOW Please read https://github.com/moovweb/gvm for more information on how to use gvm."
    fi

    ##############################
    # Install poetry
    ##############################

    echo -e "$YELLOW***** Installing poetry *****$RESET_COLOR"
    if command -v poetry > /dev/null; then
        echo -e "$GREEN_CHECK poetry is already installed!"
    else
        echo -e "$BLUE_ARROW Installing poetry..."
        curl -sSL https://install.python-poetry.org | python3 -
        echo -e "$GREEN_CHECK poetry installed!"
    fi

    # Install Success!
    echo
    for i in {1..14}
    do
        echo -ne "${PARTYPOPPER}"
    done
    echo
    echo -e "${PARTYPOPPER}                        ${PARTYPOPPER}"
    echo -e "${PARTYPOPPER}     GREAT SUCCESS!!    ${PARTYPOPPER}"
    echo -e "${PARTYPOPPER}                        ${PARTYPOPPER}"
    for i in {1..14}
    do
        echo -ne "${PARTYPOPPER}"
    done
    echo
    echo -e "\nI messed around with your env variables alot..."
    echo -e "You should restart your shell for everything to take effect."
    echo -e "also...."
    echo -e "* You should run \`p10k configure\` to configure your prompt if this was the first time you ran zsh theme install."
}

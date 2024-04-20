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

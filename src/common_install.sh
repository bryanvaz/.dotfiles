#!/usr/bin/env bash

install_zsh_theme() {
    REQUIRED_THEME=$(grep '^ZSH_THEME="' $DIR/zsh/.zshrc | awk -F'"' '{print $2}')
    if [ "$REQUIRED_THEME" == "powerlevel10k/powerlevel10k" ]; then 
        if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
            echo -e "$GREEN_CHECK ZSH theme ${REQUIRED_THEME} already installed!"
            return 0 # true
        fi
        echo -e "$BLUE_ARROW Installing ZSH theme ${REQUIRED_THEME}..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        echo -e "${YELLOW}In theory if you run \`p10k configure\` if you're fonts are weird you should be good to go!$RESET_COLOR"
        echo -e "******* ZSH theme ${REQUIRED_THEME} installed! *******\n"

        return 0 # true
    fi

    echo -e "${RED}Warning could not install ZSH theme ${REQUIRED_THEME}! Unknown theme!$RESET_COLOR"

    return 1 # false
}


has_neovim() {
    if command -v nvim > /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}


has_gh() {
    if command -v gh > /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}

docker_installed() {
    if command -v docker > /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}


#!/bin/bash

# Meant to be run from a curl command from github
# curl -s https://raw.githubusercontent.com/bryanvaz/.dotfiles/main/install.sh | bash


CONFIG_HOME="${HOME}/.config/"
REPO_BASE="bryanvaz/.dotfiles"
SSH_REPO="git@github.com:${REPO_BASE}.git"


# Determine the operating system (either `linux` or `darwin` or `windows`)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

main() {
    exec 3<>/dev/tty
    echo "Begining installation of dotfiles"
    ensure_prerequisites
}


ensure_prerequisites() {
    if [ "$OS" == "darwin" ]; then
        # ensure_mac_prequisites
        echo "Mac not supported yet!"
        exit 1
    elif [ "$OS" == "windows" ]; then
        # ensure_windows_prequisites
        echo "Windows not supported yet!"
        exit 1
    fi

    # Check if git is installed
    echo "Verifying git installation ..."
    if ! [ -x "$(command -v git)" ]; then
        echo "Git not installed! Installing git ..." >&2
        install_git
    fi

    echo "Verifying ssh keys ..."
    # NO_SSH_KEYS=$(no_ssh_keys)
    # echo "Value of NO_SSH_KEYS: $NO_SSH_KEYS"
    if no_ssh_keys; then
        echo "SSH keys have not been setup for git"
        echo "Generating SSH keys for git. Please follow the prompts ..."
        generate_ssh_keys
    fi

    # NO_GITHUB_ACCESS=$(no_github_authorization)
    # echo "Value of NO_GITHUB_ACCESS: $NO_GITHUB_ACCESS"
    echo "Verifying github keys ..."
    # if [ "$NO_GITHUB_ACCESS" == "1" ]; then
    if no_github_authorization; then
        echo "Please add the following SSH key to your github account:"
        echo "\n================ SSH KEY BELOW ====================="
        cat ~/.ssh/id_rsa.pub
        echo "================ SSH KEY ABOVE =====================\n"
        echo "Your Github SSH keys can be accessed at: https://github.com/settings/keys"
        echo "Press any key to continue ..."
        read -u 3 -n 1 -s 
    fi

    # DOTFILES_FOLDER_EXISTS=$(dotfiles_folder_exists)
    # echo "Value of dotfiles_folder_exists: $dotfiles_folder_exists"
    # if [ "$DOTFILES_FOLDER_EXISTS" == "1" ]; then
    if dotfiles_folder_exists; then
        echo "Warning, dotfiles folder already exists at ~/.dotfiles. Please delete it and try again; or run `cfg` from inside the folder"
        exit 1
    fi
    echo "Cloning dotfiles repo into home directory"
    git clone $SSH_REPO ~/.dotfiles

    echo "dotfiles repo cloned successfully. Please manually run \`cfg\` from inside ~/.dotfiles to complete installation"
}


install_git() {
    # Install git
    if [ "$OS" == "linux" ]; then
        sudo apt-get update
        sudo apt-get install git
    elif [ "$OS" == "darwin" ]; then
        xcode-select --install
    elif [ "$OS" == "windows" ]; then
        choco install git
    fi
}

no_ssh_keys() {
    if [ -f ~/.ssh/id_rsa ]; then
        return 1 # false
    else
        return 0 # true
    fi
}

generate_ssh_keys() {
    # Generate SSH keys for the current user
    ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)-$(date -I)" -f ~/.ssh/id_rsa
}

no_github_authorization() {
    # Test if git has ssh access to a github repo
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        return 1 # false
    else
        return 0 # true
    fi
}

dotfiles_folder_exists() {
    if [ -d ~/.dotfiles ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

# Main starts here
main

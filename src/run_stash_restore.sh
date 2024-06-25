#!/usr/bin/env bash

run_stash() {
    # Loop through CONFIG_BACKUP_DIRS and backup each directory
    for config_backup_dir in "${CONFIG_BACKUP_DIRS[@]}"; do
        if [ -d "${CONFIG_HOME}/${config_backup_dir}" ]; then
            echo -e "Backing up ${config_backup_dir} config..."
            mkdir -p "${CONFIG_BACKUP}/${config_backup_dir}"
            rm -rf "${CONFIG_BACKUP}/${config_backup_dir}"
            mkdir -p "${CONFIG_BACKUP}/${config_backup_dir}"
            cp -r "${CONFIG_HOME}/${config_backup_dir}" "${CONFIG_BACKUP}/"
        fi
    done

    # Backup zsh
    echo -e "Backing up zsh config..."
    mkdir -p "${ZSH_BACKUP}"
    cp -r "${HOME}/.zshrc" "${ZSH_BACKUP}/.zshrc"
    cp -r "${HOME}/.zsh_profile" "${ZSH_BACKUP}/.zsh_profile"
    cp -r "${HOME}/.zprofile" "${ZSH_BACKUP}/.zprofile"
    cp -r "${HOME}/.zsh_util" "${ZSH_BACKUP}/.zsh_util"
    cp -r "${HOME}/.p10k.zsh" "${ZSH_BACKUP}/.p10k.zsh"

    # Backup banner
    echo -e "Backing up banner..."
    cp -r "${HOME}/.banner" "${DIR}/.banner"

    # Backup aws config
    echo -e "Backing up aws config..."
    mkdir -p "${AWS_BACKUP}"
    cp -r "${HOME}/.aws/config" "${AWS_BACKUP}/config"

    # Backup git config
    echo -e "Backing up git config..."
    mkdir -p "${GIT_BACKUP}/${OS}"
    cp -r "${HOME}/.gitconfig" "${GIT_BACKUP}/${OS}/.gitconfig"

    # backup scritps
    echo -e "Backing up scripts..."
    # mkdir -p "${LOCAL_BACKUP}/scripts"
    cp -r "${HOME}/.local/scripts" "${LOCAL_BACKUP}/"

    # TODO: Backup vscode settings
}

run_restore() {
    # restore config from backup
    for dir in "${CONFIG_BACKUP_DIRS[@]}"; do
        if [ -d "${CONFIG_BACKUP}/${dir}" ]; then
            echo -e "Restoring ${dir} config..."
            mkdir -p "${CONFIG_HOME}/${dir}"
            cp -r "${CONFIG_BACKUP}/${dir}" "${CONFIG_HOME}/"
        fi
    done

    # Restore zsh
    echo -e "Restoring zsh config..."
    cp -r "${ZSH_BACKUP}/.zshrc" "${HOME}/.zshrc"
    cp -r "${ZSH_BACKUP}/.zsh_profile" "${HOME}/.zsh_profile"
    cp -r "${ZSH_BACKUP}/.zprofile" "${HOME}/.zprofile"
    cp -r "${ZSH_BACKUP}/.zsh_util" "${HOME}/.zsh_util"
    cp -r "${ZSH_BACKUP}/.p10k.zsh" "${HOME}/.p10k.zsh"

    # Restore banner
    echo -e "Restoring banner..."
    cp -r "${DIR}/.banner" "${HOME}/.banner"

    # Restore aws config
    echo -e "Restoring aws config..."
    mkdir -p "${HOME}/.aws"
    cp -r "${AWS_BACKUP}/config" "${HOME}/.aws/config"

    # Restore git config
    echo -e "Restoring git config..."
    cp -r "${GIT_BACKUP}/${OS}/.gitconfig" "${HOME}/.gitconfig"

    # Restore scripts
    echo -e "Restoring scripts..."
    mkdir -p "${HOME}/.local/scripts"
    cp -r "${LOCAL_BACKUP}/scripts" "${HOME}/.local/"

    echo -e "Restoring complete!"
    echo -e "Run \`cfg install\` to install packages"
}

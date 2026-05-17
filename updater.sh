#!/usr/bin/env bash

sudo systemctl stop clamav-freshclam || exit 1
sudo freshclam || exit 1
sudo rkhunter --update || exit 1
sudo systemctl start clamav-freshclam || exit 1

hblock || exit 1

paru -Syu --noconfirm || exit 1

flatpak update -y || exit 1

# Apps

    if command -v atuin &>/dev/null; then
        atuin update
    fi

    if command -v brew &>/dev/null; then
        brew update || exit 1
        brew upgrade || exit 1
    fi

    if command -v nix &>/dev/null; then
        nix-channel --update || exit 1
        nix profile upgrade --all || exit 1
    fi

# Shell Tools

    if [ -d "$HOME/.local/share/blesh" ] && [ ! -d "$HOME/.local/share/blesh/.git" ]; then
        if command -v nix &>/dev/null && nix profile list 2>/dev/null | grep -q ble-sh; then
            echo "Updating ble.sh via nix..."
            nix profile upgrade ble-sh 2>/dev/null || true
        fi
    fi

    if [ -d "$HOME/.local/share/blesh/.git" ]; then
        echo "Updating ble.sh..."
        git -C "$HOME/.local/share/blesh" pull --recurse-submodules
        make -C "$HOME/.local/share/blesh" install PREFIX="$HOME/.local"
    fi

    if [ -d "$HOME/.oh-my-zsh/.git" ]; then
        echo "Updating Oh My Zsh..."
        git -C "$HOME/.oh-my-zsh" pull --ff-only
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions/.git" ]; then
        echo "Updating zsh-autosuggestions..."
        git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull --ff-only
    fi
    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/.git" ]; then
        echo "Updating zsh-syntax-highlighting..."
        git -C "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" pull --ff-only
    fi

    if command -v auto-cpufreq &>/dev/null; then
        sudo auto-cpufreq --update || echo "auto-cpufreq update skipped"
    fi

echo "====================================="
echo "       All Updates Completed.        "
echo "====================================="

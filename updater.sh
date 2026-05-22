#!/usr/bin/env bash

# == UI helpers ==
RED='\033[0;31m'; GREEN='\e[1;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${YELLOW}=> $1${NC}"; }
ok()    { echo -e "${GREEN}=> $1${NC}"; }
err()   { echo -e "${RED}=> $1${NC}"; }
header(){ echo; echo -e "${GREEN}══ $1 ══${NC}"; }

sudo systemctl stop clamav-freshclam || exit 1
sudo freshclam || exit 1
sudo rkhunter --update || exit 1
sudo systemctl start clamav-freshclam || exit 1

hblock || exit 1

paru -Syu --noconfirm || exit 1

flatpak update -y || exit 1

# == Apps ==
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

# == Shell Tools ==
    if [ -d "$HOME/.local/share/blesh" ] && [ ! -d "$HOME/.local/share/blesh/.git" ]; then
        if command -v nix &>/dev/null && nix profile list 2>/dev/null | grep -q ble-sh; then
            info "Updating ble.sh via nix..."
            nix profile upgrade ble-sh 2>/dev/null || true
        fi
    fi

    if [ -d "$HOME/.local/share/blesh/.git" ]; then
        info "Updating ble.sh..."
        git -C "$HOME/.local/share/blesh" pull --recurse-submodules
        make -C "$HOME/.local/share/blesh" install PREFIX="$HOME/.local"
    fi

    if [ -d "$HOME/.oh-my-zsh/.git" ]; then
        info "Updating Oh My Zsh..."
        git -C "$HOME/.oh-my-zsh" pull --ff-only
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions/.git" ]; then
        info "Updating zsh-autosuggestions..."
        git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull --ff-only
    fi
    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/.git" ]; then
        info "Updating zsh-syntax-highlighting..."
        git -C "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" pull --ff-only
    fi

    if command -v auto-cpufreq &>/dev/null; then
        sudo auto-cpufreq --update || info "auto-cpufreq update skipped"
    fi

ok "All Updates Completed."

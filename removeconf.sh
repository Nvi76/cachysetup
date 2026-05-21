#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

if yn "Remove Firejail?"; then
    sudo pacman -Rns firejail || { echo "Failed to remove Firejail."; exit 1; }
    sudo rm -rf /etc/firejail || true
    rm -rf ~/.config/firejail || true
    info "Firejail Removed"
else
    info "Skipping..."
fi

clear
if yn "Remove Additionals?"; then
    remove_if_installed() {
        local packages=("$@")
        local to_remove=()
            for package in "${packages[@]}"; do
                if pacman -Q "$package" &>/dev/null; then
                    to_remove+=("$package")
                fi
            done
            if [ ${#to_remove[@]} -eq 0 ]; then
                info "None installed."
            return 0
            fi
            sudo pacman -Rns "${to_remove[@]}"
    }
    remove_if_installed torbrowser-launcher proton-vpn-cli i2pd
else
    info "Skipping..."
fi

clear
echo "Remove AI Apps?"
echo "1) Yes"
echo "2) No"
case $(pick "Choice [1-2]" 1 2) in
    '1')
        if command -v opencode &>/dev/null; then
            sudo rm -f "$(command -v opencode)" 2>/dev/null || true
        fi
        if command -v ollama &>/dev/null; then
            sudo rm -f "$(command -v ollama)" 2>/dev/null || true
            sudo systemctl stop ollama 2>/dev/null || true
            sudo systemctl disable ollama 2>/dev/null || true
        fi
        if flatpak info com.jeffser.Alpaca &>/dev/null; then
            flatpak remove -y com.jeffser.Alpaca 2>/dev/null || true
        fi
        rm -rf ~/.config/opencode 2>/dev/null || true
        rm -rf ~/.ollama 2>/dev/null || true
        ok "AI Apps Removed"
        ;;
    '2') info "Skipping." ;;
esac

clear
echo "Remove GameDev Apps?"
echo "1) Yes"
echo "2) No"
case $(pick "Choice [1-2]" 1 2) in
    '1')
        rm -f ~/cachysetup/Godot* 2>/dev/null || true
        rm -f ~/cachysetup/LDtk* 2>/dev/null || true
        rm -f ~/cachysetup/LibreSprite* 2>/dev/null || true
        rm -rf ~/.config/godot 2>/dev/null || true
        rm -rf ~/.config/ldtk 2>/dev/null || true
        rm -rf ~/.local/share/LibreSprite 2>/dev/null || true
        rm -rf ~/.local/share/libresprite 2>/dev/null || true
        ok "GameDev Apps Removed"
        ;;
    '2') info "Skipping." ;;
esac

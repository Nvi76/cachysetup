#!/usr/bin/env bash
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

clear
echo "Did you install the nvidia drivers already? (y/n):"
while true; do
    read -p "Answer [y/n]: " reply
    case $reply in
        Y|y) echo "Continuing..."; break ;;
        N|n) echo "Install nvidia driver first."; break ;;
        *) echo "Please enter 'y' or 'n'." ;;
    esac
done

sudo pacman -Syu --noconfirm

# ===============
#      Apps
# ===============

if yn_default "Do you want to install base apps?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm vulkan-tools base-devel python-tkinter tmux unzip xclip fish neovim fzf ranger btop thefuck trash-cli fastfetch
fi

# Nix
if yn_default "Do you want to install NixPkg Manager?" "Installing..." "Skipping."; then
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    mkdir -p ~/.config/nix
    grep -q 'experimental-features = nix-command' ~/.config/nix/nix.conf 2>/dev/null || echo 'experimental-features = nix-command' >> ~/.config/nix/nix.conf
fi

# Homebrew
if yn_default "Do you want to install Homebrew?" "Installing..." "Skipping."; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    if command -v brew &>/dev/null; then
        brew install distrobox podman fzf ranger btop thefuck trash-cli fastfetch
    fi
fi

# Browsers
clear
echo "=========================================="
echo "           Additional Browsers"
echo "=========================================="
timeout 2s sleep 2

if yn_default "Do you want to install Helium?" "Installing..." "Skipping."; then
    paru -S --needed helium-browser-bin
fi

if yn_default "Do you want to install Zen?" "Installing..." "Skipping."; then
    paru -S --needed zen-browser-bin
fi

if yn_default "Do you want to install Mullvad Browser?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm mullvad-browser-bin
fi

if yn_default "Do you want to install Librewolf?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm librewolf-bin
fi

if yn_default "Do you want to install Firefox?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm firefox
fi

if yn_default "Do you want to install Floorp?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm floorp-bin
fi

clear
echo "============================================="
echo "           Additional Tools & Games          "
echo "============================================="
timeout 2s sleep 2

# Game Dev
if yn_default "Do you want to install GameDev Apps?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm godot libresprite

    info "Instal LDtk Manually"
fi

# Games
if yn_default "Do you want to install Games?" "Installing..." "Skipping."; then
    flatpak install flathub org.luanti.luanti info.beyondallreason.bar org.openttd.OpenTTD net.openra.OpenRA net.wz2100.wz2100 --noninteractive
fi

# Educational
if yn_default "Do you want Educational Apps?" "Installing..." "Skipping."; then
    edu_apps
fi

# VSCode
if yn_default "Do you want to install VSCode?" "Installing..." "Skipping."; then
    paru -S --needed visual-studio-code-bin
fi

# Codium
if yn_default "Do you want to install VSCodium?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm vscodium
fi

# Logseq
if yn_default "Do you want to install Logseq (y/n):" "Installing Logseq..." "Skipping Logseq installation."; then
    flatpak install flathub com.logseq.Logseq --noninteractive
fi

# VirtManager
if yn_default "Do you want to install VirtManager?" "Installing..." "Skipping."; then
    sudo pacman -S --needed virt-manager qemu libvirt
    sudo systemctl enable --now libvirtd
fi

# AI Tools
clear
echo "=============================="
echo "           AI Tools"
echo "=============================="
timeout 2s sleep 2

if yn_default "Do you want to install Ollama?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm ollama
    sudo systemctl enable ollama
fi

if yn_default "Do you want to install OpenCode?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm opencode
fi

if yn_default "Do you want to install Oterm?" "Installing..." "Skipping."; then
    brew install oterm
    mkdir -p "$(oterm --data-dir 2>/dev/null || echo ~/.local/share/oterm)"
    config="$(oterm --data-dir 2>/dev/null || echo ~/.local/share/oterm)/config.json"
    if [ -f "$config" ]; then
        tmp=$(mktemp) && jq '. + {"splash-screen": false}' "$config" > "$tmp" && mv "$tmp" "$config"
    else
        echo '{"splash-screen": false}' > "$config"
    fi
fi

if yn_default "Do you want to install Alpaca?" "Installing..." "Skipping."; then
    paru -S --needed alpaca-ai
fi

has_ollama=$(command -v ollama)
has_opencode=$(command -v opencode)
if [ -n "$has_ollama" ] || [ -n "$has_opencode" ]; then
    clear
    echo "Configuring AI tools..."
    ~/cachysetup/ai_confs.sh
fi

# Flatpak apps
if yn_default "Do you want to install flatpak apps?" "Installing..." "Skipping."; then
    sudo pacman -S --needed --noconfirm flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub \
    com.rtosta.zapzap \
    org.telegram.desktop \
    org.gimp.GIMP \
    com.github.tchx84.Flatseal \
    net.agalwood.Motrix \
    org.localsend.localsend_app \
    org.kde.kate \
    org.kde.kdenlive \
    --noninteractive
fi

# Power Management
echo "Power / Battery Utilities"
echo "1) auto-cpufreq"
echo "2) TLP"
echo "3) Skip"
read -p "Enter choice [1-3]: " choice
case $choice in
    '1')
        git clone https://github.com/AdnanHodzic/auto-cpufreq.git
        cd auto-cpufreq
        sudo ./auto-cpufreq-installer || exit 1
        cd .. && rm -rf auto-cpufreq
        sudo systemctl enable --now auto-cpufreq
        ;;
    '2')
        sudo pacman -S --noconfirm tlp tlp-rdw
        sudo systemctl enable --now tlp || exit 1
        ;;
    '3') echo "Exiting." ;;
    *) echo "Invalid option."; exit 1 ;;
esac

sudo pacman -Syu --noconfirm


echo "=================================================="
echo "     Setup Complete :> , Please Reboot Your PC    "
echo "=================================================="

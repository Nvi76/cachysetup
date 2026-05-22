#!/usr/bin/env bash
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

clear
echo "Did you install the nvidia drivers already? (y/n):"
while true; do
    read -rp "Answer [y/n]: " reply
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

clear
header "Apps"

if yn "Do you want to install base apps?" Y; then
    sudo pacman -S --needed --noconfirm vulkan-tools base-devel python-tkinter tmux unzip xclip fish neovim fzf ranger btop thefuck trash-cli fastfetch
fi

# Office
if yn "Install Office Apps? (Libreoffice & Onlyoffice?)" Y; then
    if yn "Install Libreoffice?" Y; then sudo pacman -S --needed --noconfirm libreoffice; fi
    if yn "Install OnlyOffice?" Y; then sudo pacman -S --needed --noconfirm onlyoffice-bin; fi
fi

# Flatpak apps
if yn "Do you want to install flatpak apps?" Y; then
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

# Browsers
clear
header "Additional Browsers"

if yn "Do you want to install Helium?" Y; then
    paru -S --needed helium-browser-bin
fi

if yn "Do you want to install Zen?" Y; then
    paru -S --needed zen-browser-bin
fi

if yn "Do you want to install Mullvad Browser?" Y; then
    sudo pacman -S --needed --noconfirm mullvad-browser-bin
fi

if yn "Do you want to install Librewolf?" Y; then
    sudo pacman -S --needed --noconfirm librewolf-bin
fi

if yn "Do you want to install Firefox?" Y; then
    sudo pacman -S --needed --noconfirm firefox
fi

if yn "Do you want to install Floorp?" Y; then
    sudo pacman -S --needed --noconfirm floorp-bin
fi

clear
header "Additional Tools & Games"

# Game Dev
if yn "Do you want to install GameDev Apps?" Y; then
    sudo pacman -S --needed --noconfirm godot libresprite

    info "Instal LDtk Manually"
fi

# Games
if yn "Do you want to install Games?" Y; then
    flatpak install flathub org.luanti.luanti info.beyondallreason.bar org.openttd.OpenTTD net.openra.OpenRA net.wz2100.wz2100 --noninteractive
fi

# Educational
if yn "Do you want Educational Apps?" Y; then
    edu_apps
fi

# VSCode
if yn "Do you want to install VSCode?" Y; then
    paru -S --needed visual-studio-code-bin
fi

# Codium
if yn "Do you want to install VSCodium?" Y; then
    sudo pacman -S --needed --noconfirm vscodium
fi

# Logseq
if yn "Do you want to install Logseq (y/n):" "Installing Logseq..." "Skipping Logseq installation."; then
    flatpak install flathub com.logseq.Logseq --noninteractive
fi

# VirtManager
if yn "Do you want to install VirtManager?" Y; then
    sudo pacman -S --needed virt-manager qemu libvirt
    sudo systemctl enable --now libvirtd
fi

clear
header "Addition Package Managers"

# Nix
if yn "Do you want to install NixPkg Manager?" Y; then
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    mkdir -p ~/.config/nix
    grep -q 'experimental-features = nix-command' ~/.config/nix/nix.conf 2>/dev/null || echo 'experimental-features = nix-command' >> ~/.config/nix/nix.conf
fi

# Homebrew
if yn "Do you want to install Homebrew?" Y; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    if command -v brew &>/dev/null; then
        brew install distrobox podman fzf ranger btop thefuck trash-cli fastfetch
    fi
fi

# AI Tools
clear
header "AI Tools"

if yn "Do you want to install Ollama?" Y; then
    sudo pacman -S --needed --noconfirm ollama
    sudo systemctl enable ollama
fi

if yn "Do you want to install OpenCode?" Y; then
    sudo pacman -S --needed --noconfirm opencode
fi

if yn "Do you want to install Oterm?" Y; then
    brew install oterm
    mkdir -p "$(oterm --data-dir 2>/dev/null || echo ~/.local/share/oterm)"
    config="$(oterm --data-dir 2>/dev/null || echo ~/.local/share/oterm)/config.json"
    if [ -f "$config" ]; then
        tmp=$(mktemp) && jq '. + {"splash-screen": false}' "$config" > "$tmp" && mv "$tmp" "$config"
    else
        echo '{"splash-screen": false}' > "$config"
    fi
fi

if yn "Do you want to install Alpaca?" Y; then
    paru -S --needed alpaca-ai
fi

has_ollama=$(command -v ollama)
has_opencode=$(command -v opencode)
if [ -n "$has_ollama" ] || [ -n "$has_opencode" ]; then
    clear
    info "Configuring AI tools..."
    "$SCRIPT_DIR"/ai_confs.sh
fi

# Power Management
echo "Power / Battery Utilities"
echo "1) auto-cpufreq"
echo "2) TLP"
echo "3) Skip"
case $(pick :Choice [1-3] 1 3) in
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
    '3') info "Skipping..." ;;
    *) err "Invalid option."; exit 1 ;;
esac

sudo pacman -Syu --noconfirm

clear
header "Base Setup Complete. Please Reboot Your PC"

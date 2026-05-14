#!/usr/bin/env bash

# Update system
paru -Syu --noconfirm || exit 1

# Install Apps
sudo pacman -S --noconfirm --needed gimp discover -bin kdenlive localsend vulkan-tools os-prober mesa-utils \
ffmpeg distrobox podman fzf ranger btop thefuck trash-cli fastfetch gnupg cava fish neovim figlet tmux atuin \
python-pipx tk wl-clipboard

paru -S --nonconfirm --needed logseq-desktop-bin zapzap

# Installing Browsers
clear
echo "========================================="
echo "           Installing Browsers"
echo "========================================="
timeout 2s sleep 2

# Helium Browser
clear
echo "Do you want to install Helium Browser? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing browser..."
                if pacman -Qs firejail &>/dev/null; then
                    paru -S --needed helium-browser-bin
                    sudo cp ~/cachysetup/firejail-configs/helium.desktop /usr/share/applications/helium.desktop
                    cp ~/cachysetup/firejail-configs/helium.desktop ~/.local/share/applications/helium.desktop
                else
                    sudo pacman -S --noconfirm --needed helium-browser-bin
                fi
            break
            ;;
        N|n)
            echo "Skipping browser installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Zen Browser
clear
echo "Do you want to install Zen Browser? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing browser..."
                if pacman -Qs firejail &>/dev/null; then
                    paru -S --needed zen-browser-bin
                    sudo cp ~/cachysetup/firejail-configs/zen.desktop /usr/share/applications/zen.desktop
                    cp ~/cachysetup/firejail-configs/zen.desktop ~/.local/share/applications/zen.desktop
                else
                    sudo pacman -S --noconfirm --needed zen-browser-bin
                fi
            break
            ;;
        N|n)
            echo "Skipping browser installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Mullvad Browser
clear
echo "Do you want to install Mullvad Browser? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing browser..."
                sudo pacman -S --noconfirm --needed mullvad-browser-bin
            break
            ;;
        N|n)
            echo "Skipping browser installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Librewolf Browser
clear
echo "Do you want to install Librewolf? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing browser..."
                sudo pacman -S --noconfirm --needed librewolf-bin
            break
            ;;
        N|n)
            echo "Skipping browser installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Firefox Browser
clear
echo "Do you want to install Firefox? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing browser..."
                sudo pacman -S --noconfirm --needed firefox
            break
            ;;
        N|n)
            echo "Skipping browser installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Floorp Browser
clear
echo "Do you want to install Floorp? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing browser..."
                sudo pacman -S --noconfirm --needed floorp-bin
            break
            ;;
        N|n)
            echo "Skipping browser installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

clear
echo "============================================="
echo "           Additional Tools & Games          "
echo "============================================="
timeout 2s sleep 2

# Flatpak
clear
echo "Do you want to install Flatpak? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing Flatpak..."
                sudo pacman -S --needed --noconfirm flatpak

                # Flathub repo
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

            break
            ;;
        N|n)
            echo "Skipping Flatpak installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Game Dev
clear
echo "Do you want to install GameDev Apps? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing Godot & libresprite..."
                sudo pacman -S --needed --noconfirm godot libresprite

            echo "Installing LDtk"
                curl -fL \
                    https://itchio-mirror.cb031a832f44726753d6267436f3b414.r2.cloudflarestorage.com/upload2/game/740403/9503070?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=3edfcce40115d057d0b5606758e7e9ee%2F20260505%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260505T142657Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=75fafce31d8729e512db446c0c5f9f16a8590dec129accad7ef14a5da1785195 \
                    -o LDtk.zip || exit 1

                unzip LDtk.zip
                paru -S --needed --noconfirm gearlever
                gearlever ~/cachysetup/LDtk*.AppImage

                trash-put LDtk.zip
                break
            ;;
        N|n)
            echo "Skipping GameDev Apps installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Games
clear
echo "Do you want to install Games aswell? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing Games..."
            flatpak install flathub org.luanti.luanti info.beyondallreason.bar org.openttd.OpenTTD net.openra.OpenRA net.wz2100.wz2100
            break
            ;;
        N|n)
            echo "Skipping installation of games."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done


# AI Tools
clear
echo "=========================================="
echo "           AI Tools"
echo "=========================================="
timeout 2s sleep 2

# Ollama
clear
echo "Do you want to install Ollama? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing Ollama..."
            sudo pacman -S --needed --noconfirm ollama
            break
            ;;
        N|n)
            echo "Skipping Ollama installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# OpenCode
clear
echo "Do you want to install OpenCode? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing OpenCode..."
            sudo pacman -S --needed --noconfirm opencode
            break
            ;;
        N|n)
            echo "Skipping OpenCode installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Alpaca
clear
echo "Do you want to install Alpaca? (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing Alpaca..."
            paru -S --needed --noconfirm alpaca-ai
            break
            ;;
        N|n)
            echo "Skipping Alpaca installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Run ai_confs.sh if Ollama or OpenCode were installed
has_ollama=$(command -v ollama)
has_opencode=$(command -v opencode)

if [ -n "$has_ollama" ] || [ -n "$has_opencode" ]; then
    clear
    echo "Configuring AI tools..."
    ~/cachysetup/ai_confs.sh
fi

# Codium
clear
echo "Do you want to install VSCodium (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing VSCodium..."
                sudo pacman -S --needed --noconfirm vscodium
            break
            ;;
        N|n)
            echo "Skipping VSCodium installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Code
clear
echo "Do you want to install VSCode (y/n):"
while true; do
    read -t 5 -p "Answer [y/n]: " reply
    if [ -z "$reply" ]; then
        reply="Y"
    fi
    case $reply in
        Y|y)
            echo "Installing VSCode..."
                paru -S --needed visual-studio-code-bin
            break
            ;;
        N|n)
            echo "Skipping VSCode installation."
            break
            ;;
        *)
            echo "Please enter 'y' or 'n'."
            ;;
    esac
done

# Powerutils
echo "================================================"
echo "           Power / Battery Utilities"
echo "================================================"
echo "Which power management tool would you like to install?"
echo "1) Auto-Cpufreq + asusctl"
echo "2) TLP + asusctl "
echo "3) Tuned"
echo "4) None"
echo "5) Exit"

read -p "Enter choice [1-5]: " choice

# Check for AUR helper (Paru or Yay)
        if ! command -v paru &>/dev/null && ! command -v yay &>/dev/null; then
            echo "No AUR helper found. Installing paru..."
            sudo pacman -S --needed base-devel git || exit 1
            git clone https://aur.archlinux.org/paru-bin.git || exit 1
            cd paru-bin; makepkg -si; cd ..; rm -rf paru-bin || exit 1
        fi

case $choice in
    '1')
        echo "Installing auto-cpufreq and asusctl..."
        aur_helper=$(command -v paru || command -v yay)

        # Install auto-cpufreq & asusctl
        $aur_helper -S --needed --noconfirm auto-cpufreq || exit 1
        sudo pacman -S --needed --noconfirm asusctl
        sudo systemctl enable --now auto-cpufreq asusd

        ;;
    '2')
        echo "Installing TLP and asusctl..."
        sudo pacman -S --noconfirm tlp tlp-rdw asusctl || exit 1
        sudo systemctl enable --now tlp asusd || exit 1

        ;;
    '3')
        echo "Installing Tuned and asusctl..."
        sudo pacman -Rns --noconfirm power-profiles-daemon
        sudo pacman -S --noconfirm tuned tuned-ppd asusd || exit 1
        sudo systemctl enable --now tuned asusd || exit 1

        ;;
    '4')
        echo "Skipping power management tool installation."

        ;;
    '5')
        echo "Exiting."
        exit 0

        ;;
    '*')
        echo "Invalid option."
        exit 1
        ;;
esac

# Nvidia drivers
echo "================================================"
echo "        Nvidia Driver Installation (AUR)"
echo "================================================"
read -p "Install NVIDIA 580xx drivers? [y/N] incase the one on the repo doesn't exist': " install_nvidia

if [ "$install_nvidia" = "y" ] || [ "$install_nvidia" = "Y" ]; then
    echo "Installing NVIDIA 580xx drivers..."

    # Check for AUR helper again
    aur_helper=$(command -v paru || command -v yay)

    $aur_helper -S --needed \
        libxnvctrl-580xx nvidia-580xx-dkms nvidia-580xx-utils \
        nvidia-580xx-settings lib32-nvidia-580xx-utils \
        opencl-nvidia-580xx lib32-opencl-nvidia-580xx || exit 1

echo "Configuring Kernel Mode Setting (KMS)..."

        limine_cfg=/boot/limine/limine.cfg
        if [ -f "$limine_cfg" ]; then
            if ! grep -q "nvidia-drm.modeset=1" "$limine_cfg"; then
                echo "Adding nvidia-drm.modeset=1 to Limine entries..."
                # Minimal: append to every CMDLINE that doesn't already have it.
                sudo sed -E -i '/^CMDLINE=/!b; /nvidia-drm.modeset=1/!s/(CMDLINE=.*)$/\1 nvidia-drm.modeset=1/' "$limine_cfg"
            else
                echo "KMS already configured in Limine."
            fi
        else
            echo "Warning: Limine config $limine_cfg not found."
        fi

# Add NVIDIA modules to mkinitcpio

echo "Updating initramfs (mkinitcpio)..."

# Only touch MODULES if it's empty or not matching at all.
if ! grep -q "MODULES=(.*nvidia.*nvidia_modeset.*nvidia_uvm.*nvidia_drm.*)" /etc/mkinitcpio.conf; then
    if grep -q "MODULES=()" /etc/mkinitcpio.conf; then
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    else
        echo "MODULES line already non-empty; please manually add 'nvidia nvidia_modeset nvidia_uvm nvidia_drm' if needed."
        sudo nano /etc/mkinitcpio.conf
    fi
fi

# Rebuild initramfs
echo "==== Update initramfs ==="
sudo limine-mkinitcpio || {
    clear
    echo "limine-mkinitcpio command failed. Is it installed? Installing limine-mkinitcpio-hook..."
    sudo pacman -S --needed limine-mkinitcpio-hook
    sudo limine-mkinitcpio || {
        clear
        echo "limine-mkinitcpio command failed again. Please check manually."
        true
    }
}

sudo limine-update || { clear; echo "limine-update command failed, is it installed?"; true; }

# Automation Complete
    echo "NVIDIA setup complete. Please reboot."
else
    echo "Skipping NVIDIA driver installation."
fi

echo "==============================================="
echo "       Power Management Setup Complete.        "
echo "==============================================="

# Enforce AppArmor + Firejail
if pacman -Qs firejail &>/dev/null; then
    sudo rm /etc/apparmor.d/brave
    sudo rm /etc/apparmor.d/chrome
    sudo rm /etc/apparmor.d/chromium
    sudo rm /etc/apparmor.d/element-desktop
    sudo rm /etc/apparmor.d/epiphany
    sudo rm /etc/apparmor.d/firefox
    sudo rm /etc/apparmor.d/flatpak
    sudo rm /etc/apparmor.d/foliate
    sudo rm /etc/apparmor.d/loupe
    sudo rm /etc/apparmor.d/msedge
    sudo rm /etc/apparmor.d/nautilus
    sudo rm /etc/apparmor.d/opera
    sudo rm /etc/apparmor.d/plasmashell
    sudo rm /etc/apparmor.d/signal-desktop
    sudo rm /etc/apparmor.d/slirp4netns
    sudo rm /etc/apparmor.d/systemd-coredump
    sudo rm /etc/apparmor.d/thunderbird
    sudo rm /etc/apparmor.d/unix-chkpwd
    sudo rm /etc/apparmor.d/virtiofsd
    sudo apparmor_parser -a /etc/apparmor.d/kioworker
    sudo aa-disable /etc/apparmor.d/kioworker
    sudo systemctl reload apparmor
    sudo aa-enforce firejail-default
fi

# sbctl status
sudo sbctl status

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1

# Install Nixpkgmngr
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

# Configuring nix
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command' >> ~/.config/nix/nix.conf   

# Load Homebrew for current session
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "======================="
echo "     50% Complete      "
echo "======================="

# Installing LazyVim
echo "============================"
echo "     Installing LazyVim     "
echo "============================"

mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null || true
mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null || true

# Clone LazyVim starter
echo "Cloning LazyVim starter..."
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove git history
rm -rf ~/.config/nvim/.git

# Enable system clipboard
mkdir -p ~/.config/nvim/lua/config
grep -q "clipboard.*unnamedplus" ~/.config/nvim/lua/config/options.lua 2>/dev/null || echo 'vim.opt.clipboard = "unnamedplus"' >> ~/.config/nvim/lua/config/options.lua

# Run Nvim
nvim

# Run & Config zsh
zsh

echo "======================="
echo "     70% Complete      "
echo "======================="

# Homebrew apps
if command -v brew &>/dev/null; then
    brew install mailsy || exit 1
fi

echo "======================="
echo "     90% Complete      "
echo "======================="

# Shell Configuration
configure_shells() {
    clear
    echo "================================================="
    echo "           Setup & Configure Shells"
    echo "================================================="
    echo "Which shell(s) would you like to configure?"
    echo "1) Bash (ble.sh, atuin, homebrew)"
    echo "2) Zsh (Oh My Zsh, autosuggestions, syntax-highlighting)"
    echo "3) Fish (Config, aliases)"
    echo "4) All of the above"
    echo "5) Skip"

    read -p $'\e[32mEnter choice [1-5]: \e[0m' shell_choice

    case $shell_choice in
        '1')
            clear
            echo "================================================="
            echo "               Configuring Bash"
            echo "================================================="

            # Install Atuin
            sudo pacman -S --needed --noconfirm atuin

            # ble.sh
            clear
            echo "Do you want to install ble.sh? (y/n):"
            while true; do
                read -t 5 -rp "Answer [y/n]: " reply
                reply=${reply:-Y}
                case $reply in
                    [Yy])
                        echo "How would you like to install ble.sh?"
                        echo "1) Git"
                        echo "2) Nix"
                        read -p $'\e[32mEnter choice [1-2]: \e[0m' ble_choice
                        case $ble_choice in
                            '1')
                                git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
                                make -C /tmp/ble.sh install PREFIX="$HOME/.local"
                                grep -q "blesh/ble.sh" "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" << 'EOF'

# ble.sh
[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"
EOF
                                ;;
                            '2')
                                nix profile install nixpkgs#ble-sh
                                grep -q "blesh/ble.sh" "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" << 'EOF'

# ble.sh
[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"
EOF

cat > ~/.blerc << 'EOF'
# Performance tweaks
bleopt highlight_syntax=off
bleopt highlight_filename=off
bleopt complete_auto_delay=100
EOF
                                ;;
                            *)
                                echo "Invalid choice. Skipping ble.sh."
                                ;;
                        esac
                        break
                        ;;
                    [Nn])
                        echo "Skipping ble.sh installation."
                        break
                        ;;
                    *)
                        echo "Please answer y or n."
                        ;;
                esac
            done

grep -q "=== apps.sh managed block" "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" << 'BASHEOF'
# === apps.sh managed block - do not edit manually ===
eval "$(atuin init bash)"

[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"

alias lsa="ls -a"
alias update="~/.updater.sh"
alias scan="clamscan -r"
alias trm="trash-put"
alias trestore="trash-restore"
alias tbin="trash-empty"
alias listt="trash-list"
alias copy="wl-copy <"
alias paste="wl-paste >"
alias rkscan="sudo rkhunter --check --sk"

# Homebrew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Thefuck
if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

# OpenCode
export PATH="$PATH:$HOME/.opencode/bin"
if command -v opencode &>/dev/null; then
    source <(opencode completion bash 2>/dev/null) 2>/dev/null || true
fi

# === end of apps.sh block ===
BASHEOF
            echo "Bash configured at ~/.bashrc"
            timeout 1s sleep 1
            ;;

        '2')
            clear
            echo "================================================="
            echo "               Configuring Zsh"
            echo "================================================="

            # Install zsh
            sudo pacman -S --needed --noconfirm zsh

            # Install Oh My Zsh
            if [ ! -d "$HOME/.oh-my-zsh" ]; then
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            fi

            # Install zsh-autosuggestions
            if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
            fi

            # Install zsh-syntax-highlighting
            if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
            fi

            # Configure .zshrc plugins
            if grep -q "^plugins=" "$HOME/.zshrc" 2>/dev/null; then
                sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
            fi

            # Install Atuin
            sudo pacman -S --needed --noconfirm atuin



            grep -q "=== apps.sh managed block" "$HOME/.zshrc" 2>/dev/null || cat >> "$HOME/.zshrc" << 'ZSHEOF'
# === apps.sh managed block - do not edit manually ===
eval "$(atuin init zsh)"

alias lsa="ls -a"
alias update="~/.updater.sh"
alias scan="clamscan -r"
alias trm="trash-put"
alias trestore="trash-restore"
alias tbin="trash-empty"
alias listt="trash-list"
alias copy="wl-copy <"
alias paste="wl-paste >"
alias rkscan="sudo rkhunter --check --sk"

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

# Opencode
export PATH="$PATH:$HOME/.opencode/bin"
if command -v opencode &>/dev/null; then
    source <(opencode completion zsh 2>/dev/null) 2>/dev/null || true
fi

# === end of apps.sh block ===
ZSHEOF
            echo "Zsh configured at ~/.zshrc"
            timeout 1s sleep 1
            ;;

        '3')
            clear
            echo "================================================="
            echo "                Configuring Fish"
            echo "================================================="

            # Install fish if not present
            sudo pacman -S --needed --noconfirm fish

            # Install Atuin
            sudo pacman -S --needed --noconfirm atuin



            # Configure fish
            FISH_CONFIG_DIR="$HOME/.config/fish"
            FISH_CONFIG_FILE="$FISH_CONFIG_DIR/config.fish"
            mkdir -p "$FISH_CONFIG_DIR"

            cat > "$FISH_CONFIG_FILE" << 'FISHEOF'
if status is-interactive
    set -gx ATUIN_NOBIND true
    atuin init fish | source

    bind \e\[A _atuin_bind_up
    bind \cr _atuin_search

    if bind -M insert >/dev/null 2>&1
        bind -M insert \e\[A _atuin_bind_up
        bind -M insert \cr _atuin_search
    end

    bind \e\[3\;5~ kill-word
    bind \cH backward-kill-word
end

# Aliases
alias lsa "ls -a "
alias update "~/.updater.sh "
alias scan "clamscan -r "
alias trm "trash-put "
alias trestore "trash-restore "
alias tbin "trash-empty "
alias listt "trash-list "
alias copy "wl-copy < "
alias paste "wl-paste > "
alias rkscan "sudo rkhunter --check --sk "

# Homebrew
if test -f /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

# Thefuck
if command -v thefuck >/dev/null
    thefuck --alias | source
end

FISHEOF
            echo "Fish configured at $FISH_CONFIG_FILE"
            timeout 1s sleep 1
            ;;

        '4')
            clear
            echo "================================================="
            echo "                Configuring Bash"
            echo "================================================="

            # Install Atuin
            sudo pacman -S --needed --noconfirm atuin

            # ble.sh
            clear
            echo "Do you want to install ble.sh? (y/n):"
            while true; do
                read -t 5 -rp "Answer [y/n]: " reply
                reply=${reply:-Y}
                case $reply in
                    [Yy])
                        echo "How would you like to install ble.sh?"
                        echo "1) Git"
                        echo "2) Nix"
                        read -p $'\e[32mEnter choice [1-2]: \e[0m' ble_choice
                        case $ble_choice in
                            '1')
                                git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh
                                make -C /tmp/ble.sh install PREFIX="$HOME/.local"
                                grep -q "blesh/ble.sh" "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" << 'EOF'

# ble.sh
[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"
EOF
                                ;;
                            '2')
                                nix profile install nixpkgs#ble-sh
                                grep -q "blesh/ble.sh" "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" << 'EOF'

# ble.sh
[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"
EOF
                                ;;
                            *)
                                echo "Invalid choice. Skipping ble.sh."
                                ;;
                        esac
                        break
                        ;;
                    [Nn])
                        echo "Skipping ble.sh installation."
                        break
                        ;;
                    *)
                        echo "Please answer y or n."
                        ;;
                esac
            done

grep -q "=== apps.sh managed block" "$HOME/.bashrc" 2>/dev/null || cat >> "$HOME/.bashrc" << 'BASHEOF'
# === apps.sh managed block - do not edit manually ===
eval "$(atuin init bash)"

[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"

alias lsa="ls -a"
alias update="~/.updater.sh"
alias scan="clamscan -r"
alias trm="trash-put"
alias trestore="trash-restore"
alias tbin="trash-empty"
alias listt="trash-list"
alias copy="wl-copy <"
alias paste="wl-paste >"
alias rkscan="sudo rkhunter --check --sk"

# Homebrew
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Thefuck
if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

# OpenCode
export PATH="$PATH:$HOME/.opencode/bin"
if command -v opencode &>/dev/null; then
    source <(opencode completion bash 2>/dev/null) 2>/dev/null || true
fi

# === end of apps.sh block ===
BASHEOF
            echo "Bash configured at ~/.bashrc"
            timeout 1s sleep 1

            clear
            echo "================================================="
            echo "                Configuring Zsh"
            echo "================================================="

            # Install zsh
            sudo pacman -S --needed --noconfirm zsh

            # Install Oh My Zsh
            if [ ! -d "$HOME/.oh-my-zsh" ]; then
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            fi

            # Install zsh-autosuggestions
            if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
            fi

            # Install zsh-syntax-highlighting
            if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
            fi

            # Configure .zshrc plugins
            if grep -q "^plugins=" "$HOME/.zshrc" 2>/dev/null; then
                sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
            fi

            # Install Atuin
            sudo pacman -S --needed --noconfirm atuin



            grep -q "=== apps.sh managed block" "$HOME/.zshrc" 2>/dev/null || cat >> "$HOME/.zshrc" << 'ZSHEOF'
# === apps.sh managed block - do not edit manually ===
eval "$(atuin init zsh)"

alias lsa="ls -a"
alias update="~/.updater.sh"
alias scan="clamscan -r"
alias trm="trash-put"
alias trestore="trash-restore"
alias tbin="trash-empty"
alias listt="trash-list"
alias copy="wl-copy <"
alias paste="wl-paste >"
alias rkscan="sudo rkhunter --check --sk"

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

# Opencode
export PATH="$PATH:$HOME/.opencode/bin"
if command -v opencode &>/dev/null; then
    source <(opencode completion zsh 2>/dev/null) 2>/dev/null || true
fi

# === end of apps.sh block ===
ZSHEOF

            echo "Zsh configured at ~/.zshrc"
            timeout 1s sleep 1

            clear
            echo "================================================="
            echo "                Configuring Fish"
            echo "================================================="

            # Install fish if not present
            sudo pacman -S --needed --noconfirm fish

            # Install Atuin
            sudo pacman -S --needed --noconfirm atuin



            # Configure fish
            FISH_CONFIG_DIR="$HOME/.config/fish"
            FISH_CONFIG_FILE="$FISH_CONFIG_DIR/config.fish"
            mkdir -p "$FISH_CONFIG_DIR"

            cat > "$FISH_CONFIG_FILE" << 'FISHEOF'
if status is-interactive
    set -gx ATUIN_NOBIND true
    atuin init fish | source

    bind \e\[A _atuin_bind_up
    bind \cr _atuin_search

    if bind -M insert >/dev/null 2>&1
        bind -M insert \e\[A _atuin_bind_up
        bind -M insert \cr _atuin_search
    end

    bind \e\[3\;5~ kill-word
    bind \cH backward-kill-word
end

# Aliases
alias lsa "ls -a "
alias update "~/.updater.sh "
alias scan "clamscan -r "
alias trm "trash-put "
alias trestore "trash-restore "
alias tbin "trash-empty "
alias listt "trash-list "
alias copy "wl-copy < "
alias paste "wl-paste > "
alias rkscan "sudo rkhunter --check --sk "

# Homebrew
if test -f /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

# Thefuck
if command -v thefuck >/dev/null
    thefuck --alias | source
end

FISHEOF
            echo "Fish configured at $FISH_CONFIG_FILE"
            timeout 1s sleep 1
            ;;

        '5')
            echo "=================================================="
            echo "          Skipping Shell Configuration.          "
            echo "=================================================="
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

configure_shells

# Set default shell
clear
echo "======================================="
echo "           Set Default Shell"
echo "======================================="
echo "1) Bash"
echo "2) Keep Fish"
echo "3) Zsh"
echo "4) Skip"

# Use ANSI escape codes for colored prompt
read -p $'\e[32mEnter choice [1-4]: \e[0m' choice

case $choice in
    '1')
        # Bash
        sudo chsh -s /bin/bash
        timeout 1s sleep 1
        ;;

    '2')
        # Fish
        echo "Keeping Fish.."
        sudo chsh -s "$(which fish)" "$USER"
        timeout 1s sleep 1
        ;;
    '3')
        # Zsh
        sudo chsh -s "$(which zsh)" "$USER"
        timeout 1s sleep 1
        ;;

    '4')
        clear
        echo "================================"
        echo "          Skipping.....         "
        echo "================================"
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

# Final Checks
traur scan
sudo limine-mkinitcpio
sudo limine-update

echo "=================================================="
echo "     Setup Complete :> , Please Reboot Your PC    "
echo "=================================================="

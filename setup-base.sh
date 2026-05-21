#!/usr/bin/env bash
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

sudo -v

chmod +x updater.sh removeconf.sh setup-desktop.sh ai_confs.sh

sudo cp /etc/hosts "$HOME/cachysetup/hosts.backup"
cp ~/cachysetup/updater.sh ~/.updater.sh || exit 1

# ===============
#    Security
# ===============

# Needed / base packages
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git curl fish figlet wget jq gawk python shellcheck

# Hblock
if yn "Do you want to install Hblock?" Y; then
    curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.5.1/hblock'
    echo 'd010cb9e0f3c644e9df3bfb387f42f7dbbffbbd481fb50c32683bbe71f994451  /tmp/hblock' | shasum -c
    sudo mv /tmp/hblock /usr/local/bin/hblock
    sudo chown 0:0 /usr/local/bin/hblock
    sudo chmod 755 /usr/local/bin/hblock
    hblock
fi

# Firejail Configuration
if yn "Install & Configure Firejail?" Y; then
    firejail_install
fi

# Rkhunter
if yn "Install & Configure Rkhunter?" Y; then
    sudo pacman -S --needed rkhunter
    if command -v rkhunter &>/dev/null; then
        sudo sed -i 's/^MIRRORS_MODE=1/MIRRORS_MODE=0/' /etc/rkhunter.conf
        sudo sed -i 's/^UPDATE_MIRRORS=0/UPDATE_MIRRORS=1/' /etc/rkhunter.conf
        sudo sed -i 's/^WEB_CMD="\/bin\/false"/WEB_CMD=""/' /etc/rkhunter.conf
        sudo rkhunter --propupd || true
        sudo rkhunter --update || true
        sudo rkhunter --config-check || true
    fi
fi

# Fail2ban
if yn "Install & Configure Fail2ban?" Y; then
    sudo pacman -S --needed fail2ban
    if ! sudo test -f /etc/fail2ban/jail.local; then
        sudo bash -c "cat << 'EOF' > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
backend = auto
mode = aggressive

[recidive]
enabled = true
logpath = /var/log/fail2ban.log
bantime = 604800
findtime = 86400
maxretry = 2
EOF"
        sudo systemctl enable --now fail2ban || true
        sudo systemctl reload fail2ban
    fi
fi

# Clamav
if yn "Install & Configure ClamAV?" Y; then
    sudo pacman -S --needed clamav
    sudo systemctl enable --now clamav-freshclam || true
fi

# UFW
if yn "Install & Configure UFW?" Y; then
    sudo pacman -S --needed ufw gufw
    sudo ufw default deny incoming || exit 1
    sudo ufw default allow outgoing || exit 1
    sudo ufw enable || exit 1
    sudo systemctl enable --now ufw || exit 1
fi

# ===============
#   Development
# ===============

# Git Setup
if yn "Configure Git?" Y; then
    echo "Setting up Git..."
    read -rp "Enter your name: " git_name
    read -rp "Enter your email: " git_email
    git config --global user.name "$git_name" || exit 1
    git config --global user.email "$git_email" || exit 1
    echo "Git configured."
    if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
        mkdir -p "$HOME/.ssh"
        ssh-keygen -t ed25519 -C "$git_email" -N "" -f "$HOME/.ssh/id_ed25519"
        cat "$HOME/.ssh/id_ed25519.pub"
    fi
fi

# Homebrew
if yn "Do you want to install Homebrew?" Y; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1

    # Load Homebrew for current session
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

fi

# Installing LazyVim
if yn "Do you want to install Neovim? & configure LazyVim?" Y; then

    # Homebrew apps
    brew install neovim || {
    err "Warning neovim installation failed. is homebrew installed?"
    exit 1
    }

    # Files & Folders
    mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
    mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null || true
    mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null || true
    mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null || true

    # Clone LazyVim starter
    info "Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter ~/.config/nvim

    # Remove git history
    rm -rf ~/.config/nvim/.git

    # Enable system clipboard
    mkdir -p ~/.config/nvim/lua/config
    grep -q "clipboard.*unnamedplus" ~/.config/nvim/lua/config/options.lua 2>/dev/null || echo 'vim.opt.clipboard = "unnamedplus"' >> ~/.config/nvim/lua/config/options.lua

    # Neovim Config
    nvim
fi

sudo systemctl enable --now apparmor || true

if command -v clamscan &>/dev/null; then
    sudo systemctl stop clamav-freshclam || true
    sudo freshclam || true
    sudo systemctl start clamav-freshclam || true
fi

if command -v rkhunter &>/dev/null; then
    sudo rkhunter --update || true
fi

# ================
#   Shell Config
# ================

# Shell Configuration
configure_shells() {
    clear
    header "Configure Shells"
    if yn "Setup & Configure Shells?" Y; then
    echo "1) Bash (ble.sh, bash-completion, atuin)"
    echo "2) Zsh (Oh My Zsh, autosuggestions, syntax-highlighting)"
    echo "3) Fish (Config, aliases)"
    echo "4) All of the above"
    echo "5) Skip"

    case $(pick "Choice [1-5]" 1 5) in
        '1') configure_bash ;;
        '2') configure_zsh ;;
        '3') configure_fish ;;
        '4') configure_bash; configure_zsh; configure_fish ;;
        '5') info "Skipping Shell Configuration." ;;
        *) err "Invalid choice."; exit 1 ;;
    esac

    # Set default shell
    clear
    echo "Set Default Shell"
    echo "1) Keep Bash"
    echo "2) Fish"
    echo "3) Zsh"
    echo "4) Skip"
    case $(pick "Choice [1-4]" 1 4) in
        '1') sudo chsh -s /bin/bash ;;
        '2') sudo chsh -s "$(which fish)" "$USER" ;;
        '3') sudo chsh -s "$(which zsh)" "$USER" ;;
        '4') info "Skipping..." ;;
        *) err "Invalid choice." ;;
    esac
    fi
}

configure_shells

clear
header "Security Setup Complete. "

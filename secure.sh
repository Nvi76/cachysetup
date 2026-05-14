#!/usr/bin/env bash
set -euo pipefail

# Ensure sudo access
sudo -v

# Chmod +x all files
chmod +x updater.sh apps.sh removeconf.sh ai_confs.sh

# Backup & Copy file
sudo cp /etc/hosts "$HOME/cachysetup/hosts.backup"
cp ~/cachysetup/updater.sh ~/.updater.sh

# Install Hblock
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.5.1/hblock'
echo 'd010cb9e0f3c644e9df3bfb387f42f7dbbffbbd481fb50c32683bbe71f994451  /tmp/hblock' | shasum -c
sudo mv /tmp/hblock /usr/local/bin/hblock
sudo chown 0:0 /usr/local/bin/hblock
sudo chmod 755 /usr/local/bin/hblock
hblock

# Install base packages security apps
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel figlet git wget fish curl python clamav ufw gufw fail2ban rkhunter dkms linux-headers sbctl

# Git Setup
echo "Setting up Git..."
read -p "Enter your name: " git_name
read -p "Enter your email: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"

echo "Git configured with name: $git_name and email: $git_email"

# Generate SSH key for GitHub
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$git_email" -N "" -f "$HOME/.ssh/id_ed25519"
    echo "SSH key generated. Add this to GitHub -> Settings -> SSH keys:"
    cat "$HOME/.ssh/id_ed25519.pub"
else
    echo "SSH key already exists at ~/.ssh/id_ed25519.pub"
fi

# UFW Configuration
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Rkhunter Config
echo "Fixing rkhunter configuration..."
sudo sed -i 's/^MIRRORS_MODE=1/MIRRORS_MODE=0/' /etc/rkhunter.conf
sudo sed -i 's/^UPDATE_MIRRORS=0/UPDATE_MIRRORS=1/' /etc/rkhunter.conf
sudo sed -i 's/^WEB_CMD="\/bin\/false"/WEB_CMD=""/' /etc/rkhunter.conf

sudo rkhunter --propupd || true
sudo rkhunter --update || true
sudo rkhunter --config-check || true

# Fail2ban Configuration
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
filter = sshd[mode=aggressive]

[recidive]
enabled = true
logpath = /var/log/fail2ban.log
bantime = 604800
findtime = 86400
maxretry = 2
EOF"

    sudo systemctl reload fail2ban && \
    echo "Fail2Ban configuration applied." || \
    echo "Reload failed."
else
    echo "jail.local already exists. No changes made."
fi

# AppArmor & Firejail Configuration
echo "================================================="
echo "           Setup Firejail & AppArmor?"
echo "================================================="
echo "Do you want to install Firejail & AppArmor? WARNING will make system more secure but harder to use (Still works though) and (probably) make it slower"
echo "1) Yes, Setup Firejail & AppArmor"
echo "2) Yes, Setup Firejail, but no AppArmor"
echo "3) Yes, Setup AppArmor but no Firejail"
echo "4) No, Don't Setup Firejail & AppArmor"

# Use ANSI escape codes for colored prompt
read -p $'\e[32mEnter choice [1-4]: \e[0m' choice

setup_firejail_configs() {
    sudo mkdir -p /etc/firejail/firecfg.d
    mkdir -p "$HOME/.config/firejail"
    mkdir -p "$HOME/Allowed"
    mkdir -p "$HOME/Allowed/AllowedCodes"
    mkdir -p "$HOME/Allowed/AllowedDocs"
    mkdir -p "$HOME/Allowed/AllowedDownloads"
    mkdir -p "$HOME/Allowed/AllowedPics"
    mkdir -p "$HOME/.local/share/applications"
    touch "$HOME/.local/share/applications/helium.desktop"

    cp ~/cachysetup/firejail-configs/helium.profile ~/.config/firejail/helium.profile
    cp ~/cachysetup/firejail-configs/brave.local ~/.config/firejail/brave.local
    cp ~/cachysetup/firejail-configs/zen-browser.profile ~/.config/firejail/zen-browser.profile
    cp ~/cachysetup/firejail-configs/mullvad-browser.local ~/.config/firejail/mullvad-browser.local
    cp ~/cachysetup/firejail-configs/librewolf.local ~/.config/firejail/librewolf.local
    cp ~/cachysetup/firejail-configs/firefox.local ~/.config/firejail/firefox.local
    cp ~/cachysetup/firejail-configs/floorp.local ~/.config/firejail/floorp.local
    cp ~/cachysetup/firejail-configs/codium.local ~/.config/firejail/codium.local
    cp ~/cachysetup/firejail-configs/code.local ~/.config/firejail/code.local

    sudo tee /etc/firejail/firecfg.d/ExcludedApps.conf > /dev/null << 'EOF'
    !org.kde.spectacle
    !spectacle
    !libreoffice
    !libreoffice-startcenter
    !org.libreoffice.LibreOffice
    !libreoffice-calc
    !libreoffice-writer
    !libreoffice-impress
    !libreoffice-draw
    !libreoffice-base
    !libreoffice-math
    !firefox
    !floorp-bin
EOF

    cp ~/.local/share/applications/org.kde.spectacle.desktop ~/cachysetup/firejail-configs/Originals/org.kde.spectacle.desktop
    rm -f ~/.local/share/applications/org.kde.spectacle.desktop

    sudo firecfg --clean
    sudo firecfg
}

case $choice in
    '1')
        # Firejail + AppArmor
        sudo pacman -Syu --noconfirm --needed firejail apparmor apparmor.d plymouth cachyos-plymouth-theme cachyos-plymouth-bootanimation
        sudo systemctl enable --now apparmor
        sudo plymouth-set-default-theme -R cachyos-bootanimation

# Required kernel parameters for AppArmor
UUID=$(findmnt -no UUID /)

AA_PARAMS="quiet splash apparmor=1 security=apparmor lsm=landlock,lockdown,yama,integrity,apparmor,bpf root=UUID=$UUID rw rootflags=subvol=/@"

# Ensure /etc/default/limine exists
if [ ! -f /etc/default/limine ]; then
    echo "Creating /etc/default/limine skeleton"
    sudo mkdir -p /etc/default
    sudo tee /etc/default/limine >/dev/null <<EOF
KERNEL_CMDLINE[default]="$AA_PARAMS"
EOF
fi

# Limine config
if ! grep -q "apparmor=1" /etc/default/limine; then
    echo "> Backing up /etc/default/limine"
    sudo cp /etc/default/limine "/etc/default/limine.bak.$(date +%s)"

    echo "> Adding AppArmor parameters"
    if grep -q '^KERNEL_CMDLINE\[default\]' /etc/default/limine; then
        sudo sed -i "s|^KERNEL_CMDLINE\[default\].*\$|KERNEL_CMDLINE[default]=\"$AA_PARAMS\"|" /etc/default/limine
    else
        echo "KERNEL_CMDLINE[default]=\"$AA_PARAMS\"" | sudo tee -a /etc/default/limine
    fi

    echo "Limine config updated!"
else
    echo "!! AppArmor params already in Limine config"
fi

# Apparmor caching
echo "> Configuring AppArmor parser" || exit 1
sudo install -Dm644 /dev/null /etc/apparmor/parser.conf || exit 1

cat << EOF | sudo tee -a /etc/apparmor/parser.conf >/dev/null || exit 1
write-cache
Optimize=compress-fast
cache-loc=/var/cache/apparmor
EOF

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

        echo "== Verification =="
        echo "Limine config:"
        grep KERNEL_CMDLINE /etc/default/limine || echo "No KERNEL_CMDLINE found!"
        echo ""

        setup_firejail_configs
        sudo systemctl reload apparmor

        clear
        echo "=================================================="
        echo "        AppArmor, Firejail Config Success         "
        echo "      Reboot is REQUIRED for kernel params."
        echo "=================================================="

        echo "AppArmor status:"
        sudo aa-status || echo "AppArmor not loaded (normal before reboot)"
        ;;

    '2')
        # Firejail only
        sudo pacman -Syu --noconfirm --needed firejail plymouth cachyos-plymouth-theme cachyos-plymouth-bootanimation
        sudo plymouth-set-default-theme -R cachyos-bootanimation

        setup_firejail_configs
        ;;

    '3')
        # AppArmor
        # Install needed packages & Fixes
        sudo pacman -Syu --noconfirm --needed apparmor apparmor.d plymouth cachyos-plymouth-theme cachyos-plymouth-bootanimation
        sudo systemctl enable --now apparmor
        sudo plymouth-set-default-theme -R cachyos-bootanimation

# Required kernel parameters for AppArmor
UUID=$(findmnt -no UUID /)

AA_PARAMS="quiet splash apparmor=1 security=apparmor lsm=landlock,lockdown,yama,integrity,apparmor,bpf root=UUID=$UUID rw rootflags=subvol=/@"

# Ensure /etc/default/limine exists
if [ ! -f /etc/default/limine ]; then
    echo "Creating /etc/default/limine skeleton"
    sudo mkdir -p /etc/default
    sudo tee /etc/default/limine >/dev/null <<EOF
KERNEL_CMDLINE[default]="$AA_PARAMS"
EOF
fi

# Limine config
if ! grep -q "apparmor=1" /etc/default/limine; then
    echo "> Backing up /etc/default/limine"
    sudo cp /etc/default/limine "/etc/default/limine.bak.$(date +%s)"

    echo "> Adding AppArmor parameters"
    if grep -q '^KERNEL_CMDLINE\[default\]' /etc/default/limine; then
        sudo sed -i "s|^KERNEL_CMDLINE\[default\].*\$|KERNEL_CMDLINE[default]=\"$AA_PARAMS\"|" /etc/default/limine
    else
        echo "KERNEL_CMDLINE[default]=\"$AA_PARAMS\"" | sudo tee -a /etc/default/limine
    fi

    echo "Limine config updated!"
else
    echo "!! AppArmor params already in Limine config"
fi

# Apparmor caching
echo "> Configuring AppArmor parser" || exit 1
sudo install -Dm644 /dev/null /etc/apparmor/parser.conf || exit 1

cat << EOF | sudo tee -a /etc/apparmor/parser.conf >/dev/null || exit 1
write-cache
Optimize=compress-fast
cache-loc=/var/cache/apparmor
EOF

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

        echo "== Verification =="
        echo "Limine config:"
        grep KERNEL_CMDLINE /etc/default/limine || echo "No KERNEL_CMDLINE found!"
        echo ""

        clear
        echo "=================================================="
        echo "        AppArmor, Firejail Config Success         "
        echo "      Reboot is REQUIRED for kernel params."
        echo "=================================================="

        echo "AppArmor status:"
        sudo aa-status || echo "AppArmor not loaded (normal before reboot)"
        ;;

    '4')
        clear
        echo "=================================================="
        echo "          Skipping Firejail Installation.         "
        echo "=================================================="
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Install Portmaster
paru -S --noconfirm portmaster-bin traur-bin

# Install Additional
clear
echo "Do you want to install Additional tool? (Might not be needed for desktop usage) (y/n)"

while true; do
    read -t 5 -rp "Answer [y/n]: " reply
    reply=${reply:-N}

    case "$reply" in
        [Yy])

            echo "Installing tools..."

            sudo pacman -S --needed --noconfirm \
                proton-vpn-cli \
                torbrowser-launcher

            sudo systemctl start proton-vpn-daemon.service
            protonvpn-cli login
            protonvpn connect --fastest > /dev/null

            break
            ;;

        [Nn])
            echo "Skipping installation."
            break
            ;;

        *)
            echo "Please answer y or n."
            ;;
    esac
done

# Additionals2
clear
URL="http://127.0.0.1:7657/"
BROWSERS=("firefox" "floorp")

# Function to install browser
install_browser() {
    local browser=$1

    echo "Installing $browser..."

    if [[ "$browser" == "firefox" ]]; then
            sudo pacman -S --needed --noconfirm firefox
            browser="firefox"
    else
        if ! pacman -Q "$browser" >/dev/null 2>&1; then
            sudo pacman -S --needed --noconfirm "$browser" || sudo pacman -S --needed --noconfirm floorp-bin
        fi
    fi
}

# Install Additionals2
echo "Do you want to install Additional tools? (2) (y/n)"

while true; do
    read -t 5 -rp "Answer [y/n]: " reply
    reply=${reply:-N}

    case "$reply" in
        [Yy])

            echo "Installing tools..."

            sudo pacman -S --needed --noconfirm \
                java-runtime-headless i2pd

            sudo systemctl start i2pd > /dev/null 2>&1

            until curl -s http://127.0.0.1:7657 > /dev/null; do
                sleep 2
            done

            found=false

            for browser in "${BROWSERS[@]}"; do
                if command -v "$browser" &>/dev/null; then
                    echo "Launching $browser..."
                    "$browser" "$URL" >/dev/null 2>&1 &
                    found=true
                fi
            done

            if ! $found; then
            echo "No supported browser found."
            echo "No supported browser found."
            echo "No supported browser found."
            echo "Select one to install:"
            echo "1) firefox"
            echo "2) floorp"

            read -rp "Choice [1-2]: " choice

            case "$choice" in
                1) install_browser "firefox" ;;
                2) install_browser "floorp" ;;
                *) echo "Invalid option" ;;
            esac

            break
            fi
            ;;

        [Nn])
            echo "Skipping installation."
            break
            ;;

        *)
            echo "Please answer y or n."
            ;;
    esac
done

# Config ClamvAV
sudo touch /var/log/clamav/freshclam.log
sudo chown clamav:clamav /var/log/clamav/freshclam.log

# Enabling Services
sudo systemctl enable --now clamav-freshclam
sudo systemctl enable --now portmaster
sudo systemctl enable --now fail2ban
sudo systemctl enable --now ufw
sudo systemctl disable NetworkManager-wait-online

# Secure boot
sudo sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft

echo "==========================================="
echo "       Reboot, Set Sb to custom mode       "
echo "==========================================="

# Clamav & Rkhunter
sudo systemctl stop clamav-freshclam
sudo freshclam || true
sudo rkhunter --update || true
sudo systemctl start clamav-freshclam

# configure_shells will be called from apps.sh
clear
echo "========================================"
echo "       Security Setup Complete.         "
echo "========================================"

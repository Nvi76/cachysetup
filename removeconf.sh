#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo "           Remove SecConf?"
echo "======================================"
echo "Do you want to remove SecConf (Firejail, AppArmor, / Firejail + AppArmor)? WARNING will make changes to kernels and stuff"
echo "1) Yes, Remove SecConf (Firejail)"
echo "2) Yes, Remove SecConf (AppArmor)"
echo "3) Yes, Remove SecConf (Firejail + AppArmor)"
echo "4) No, Don't Remove SecConf"

# Use ANSI escape codes for colored prompt
read -p $'\e[32mEnter choice [1-4]: \e[0m' choice

case $choice in
    '1')
     # Remove Firejail
        sudo pacman -Rns firejail || { echo "Failed to remove Firejail, is it installed?"; exit 1; }

    # Remove Folders & Profiles
        sudo rm /usr/share/applications/zen.desktop || true
        sudo rm /usr/share/applications/helium.desktop || true
        sudo rm -rf /etc/firejail || true
        rm -rf ~/.config/firejail || true

    # Replace Apps
    if pacman -Qs helium-browser-bin > /dev/null 2>&1; then
        paru -Rns --noconfirm helium-browser-bin || true
        sudo pacman -S --noconfirm --needed helium-browser-bin || true
        echo "Helium Replaced...."
    fi

        if pacman -Qs zen-browser-bin > /dev/null 2>&1; then
        paru -Rns --noconfirm zen-browser-bin || true
        sudo pacman -S --noconfirm --needed zen-browser-bin || true
        echo "Zen Replaced...."
    fi
    # Replace .desktops to use original
        clear
        echo "Copy Original the .desktop? WARNING may not work (y/n):"
        while true; do
            read -rp "Answer [y/n]: " reply
                case "$reply" in
                    [Yy]*)
                        clear
                        echo "Copying..."
                            sudo cp ~/cachysetup/firejail-configs/Originals/helium2.desktop /usr/share/applications/helium.desktop
                            sudo cp ~/cachysetup/firejail-configs/Originals/zen2.desktop /usr/share/applications/zen.desktop
                            cp ~/cachysetup/firejail-configs/Originals/zen2.desktop ~/.local/share/applications/zen.desktop
                        break
                    ;;

                    [Nn]*)
                    echo "Skipping browser installation."
                    break
                    ;;

                    *)
                    echo "Please enter 'y' or 'n'."
                    ;;
                esac
        done

        echo "================================="
        echo "        Firejail Removed         "
        echo "================================="
        ;;

    '2')
    # Remove AppArmor
        sudo systemctl disable --now apparmor || true
        sudo pacman -Rns apparmor.d apparmor  || true

        echo "Removing AppArmor kernel parameters from Limine..."
        if grep -q "apparmor=1" /etc/default/limine; then
            sudo cp /etc/default/limine "/etc/default/limine.bak.$(date +%s)"
            # Remove apparmor=1 and security=apparmor, keep other params
            sudo sed -i 's/ apparmor=1//g; s/ security=apparmor//g; s/ lsm=[^ ]*//g' /etc/default/limine
            echo "AppArmor kernel parameters removed."
        else
            echo "No AppArmor kernel params found."
        fi

        echo "Removing AppArmor parser config..."
        sudo rm -f /etc/apparmor/parser.conf

        echo "Rebuilding initramfs..."
        sudo limine-mkinitcpio
        sudo limine-update

        echo "===================================================="
        echo "        AppArmor Removed, Reboot is REQUIRED        "
        echo "===================================================="
        ;;

    '3')
     # Remove Firejail & AppArmor
        sudo systemctl disable --now apparmor || true
        sudo pacman -Rns firejail || { echo "Failed to remove Firejail, is it installed?"; sudo systemctl enable --now apparmor && exit 1; }
        sudo pacman -Rns apparmor.d apparmor || { echo "Failed to remove Apparmor packages, is it installed?"; sudo systemctl enable --now apparmor && exit 1; }

    # Remove Folders & Profiles
        sudo rm /usr/share/applications/zen.desktop || true
        sudo rm /usr/share/applications/helium.desktop || true
        sudo rm -rf /etc/firejail || true
        rm -rf ~/.config/firejail || true

    # Replace Apps
    if pacman -Qs helium-browser-bin > /dev/null 2>&1; then
        paru -Rns --noconfirm helium-browser-bin || true
        sudo pacman -S --noconfirm --needed helium-browser-bin || true
        echo "Helium Replaced...."
    fi

        if pacman -Qs zen-browser-bin > /dev/null 2>&1; then
        paru -Rns --noconfirm zen-browser-bin || true
        sudo pacman -S --noconfirm --needed zen-browser-bin || true
        echo "Zen Replaced...."
    fi

    # Replace .desktops to use original
        clear
        echo "Copy Original the .desktop? WARNING may not work (y/n):"
        while true; do
            read -rp "Answer [y/n]: " reply
                case "$reply" in
                    [Yy]*)
                        clear
                        echo "Copying..."
                            sudo cp ~/cachysetup/firejail-configs/Originals/helium2.desktop /usr/share/applications/helium.desktop
                            sudo cp ~/cachysetup/firejail-configs/Originals/zen2.desktop /usr/share/applications/zen.desktop
                            cp ~/cachysetup/firejail-configs/Originals/zen2.desktop ~/.local/share/applications/zen.desktop
                        break
                    ;;

                    [Nn]*)
                    echo "Skipping browser installation."
                    break
                    ;;

                    *)
                    echo "Please enter 'y' or 'n'."
                    ;;
                esac
        done

        echo "Removing AppArmor kernel parameters from Limine..."
        if grep -q "apparmor=1" /etc/default/limine; then
            sudo cp /etc/default/limine "/etc/default/limine.bak.$(date +%s)"
            # Remove apparmor=1 and security=apparmor, keep other params
            sudo sed -i 's/ apparmor=1//g; s/ security=apparmor//g; s/ lsm=[^ ]*//g' /etc/default/limine
            echo "AppArmor kernel parameters removed."
        else
            echo "No AppArmor kernel params found."
        fi

        echo "Removing AppArmor parser config..."
        sudo rm -f /etc/apparmor/parser.conf

        echo "Rebuilding initramfs..."
        sudo limine-mkinitcpio
        sudo limine-update

        echo "==========================================="
        echo "        AppArmor & Firejail Removed,       "
        echo "            Reboot is REQUIRED             "
        echo "==========================================="
        ;;

    '4')
        echo "================================"
        echo "        Cancelling......        "
        echo "================================"
        exit 0
        ;;

      *)
        echo "Invalid option."
        exit 1
esac

# Remove Additionals
clear
echo "Remove Additionals?"
        while true; do
            read -rp "Answer [y/n]: " reply
                case "$reply" in
                    [Yy]*)
                        clear
                        remove_if_installed() {
                            local packages=("$@")
                            local to_remove=()

                            # Check which packages are installed
                            for package in "${packages[@]}"; do
                                if pacman -Q "$package" &>/dev/null; then
                                    to_remove+=("$package")
                                else
                                    echo "$package is not installed" > /dev/null 2>&1
                                fi
                            done

                            # Remove only the installed packages
                            if [ ${#to_remove[@]} -eq 0 ]; then
                                echo "None of the packages are installed."
                                return 0
                            elif [ ${#to_remove[@]} -eq ${#packages[@]} ]; then
                                echo "All packages are installed. Removing all..."
                            else
                                echo "Removing only the installed packages..."
                            fi

                            sudo pacman -Rns "${to_remove[@]}" > /dev/null 2>&1
                        }

                        remove_if_installed torbrowser-launcher proton-vpn-cli i2pd
                        break
                    ;;

                    [Nn]*)
                    echo "Skipping..."
                    break
                    ;;

                    *)
                    echo "Please enter 'y' or 'n'."
                    ;;
                esac
        done

# Remove AI Apps (OpenCode, Ollama, Alpaca)
clear
echo "======================================"
echo "           Remove AI Apps?"
echo "======================================"
echo "This will remove OpenCode, Ollama, and Alpaca along with their configs."
echo "Do you want to continue?"
echo "1) Yes, Remove AI Apps"
echo "2) No, Skip"

read -p $'\e[32mEnter choice [1-2]: \e[0m' choice

case $choice in
    '1')
        echo "Removing AI apps..."

        if command -v opencode &>/dev/null; then
            sudo rm -f "$(command -v opencode)" 2>/dev/null || true
            echo "Removed OpenCode binary."
        fi

        if command -v ollama &>/dev/null; then
            sudo rm -f "$(command -v ollama)" 2>/dev/null || true
            sudo systemctl stop ollama 2>/dev/null || true
            sudo systemctl disable ollama 2>/dev/null || true
            rm -f /etc/systemd/system/ollama.service 2>/dev/null || true
            sudo rm -f /etc/systemd/system/multi-user.target.wants/ollama.service 2>/dev/null || true
            echo "Removed Ollama."
        fi

        if flatpak info com.jeffser.Alpaca &>/dev/null; then
            flatpak remove -y com.jeffser.Alpaca 2>/dev/null || true
            echo "Removed Alpaca."
        fi

        rm -rf ~/.config/opencode 2>/dev/null || true
        rm -rf ~/.ollama 2>/dev/null || true
        echo "Removed AI app configs."

        echo "================================="
        echo "        AI Apps Removed          "
        echo "================================="
        ;;

    '2')
        echo "Skipping AI removal."
        ;;
esac

# Remove GameDev Apps (Godot, LDtk, Libresprite)
clear
echo "======================================"
echo "         Remove GameDev Apps?"
echo "======================================"
echo "This will remove Godot, LDtk, and Libresprite along with their configs."
echo "Do you want to continue?"
echo "1) Yes, Remove GameDev Apps"
echo "2) No, Skip"

read -p $'\e[32mEnter choice [1-2]: \e[0m' choice

case $choice in
    '1')
        echo "Removing GameDev apps..."

        rm -f ~/cachysetup/Godot* 2>/dev/null || true
        rm -f ~/cachysetup/LDtk* 2>/dev/null || true
        rm -f ~/cachysetup/LibreSprite* 2>/dev/null || true

        rm -rf ~/.config/godot 2>/dev/null || true
        rm -rf ~/.config/ldtk 2>/dev/null || true
        rm -rf ~/.local/share/LibreSprite 2>/dev/null || true
        rm -rf ~/.local/share/libresprite 2>/dev/null || true
        rm -rf ~/.config/GearLever 2>/dev/null || true
        echo "Removed GameDev apps and configs."

        echo "================================="
        echo "      GameDev Apps Removed       "
        echo "================================="
        ;;

    '2')
        echo "Skipping GameDev removal."
        ;;
esac


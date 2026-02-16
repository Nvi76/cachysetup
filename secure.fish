#!/usr/bin/env fish

# Ensure sudo access
sudo -v

# Chmod +x all files
chmod +x updater.fish cliapps.fish apps.fish additionalutils.fish

# Backup directory
mkdir -p "$HOME/archsetup"

# Backup hosts
sudo cp /etc/hosts "$HOME/archsetup/hosts.backup"

# Install base packages and AUR helper (paru is common on CachyOS)
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel fish curl figlet git clamav apparmor apparmor-utils dkms linux-headers

# Editing kernel parameters
sudo pacman -S --noconfirm apparmor apparmor.d; or exit 1
sudo sed "s/GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]* /&apparmor=1 security=apparmor lsm=landlock,lockdown,yama,integrity,apparmor,bpf /" /etc/default/grub | sudo tee /etc/default/grub >/dev/null; or exit 1
sudo grub-mkconfig -o /boot/grub/grub.cfg; or exit 1
sudo systemctl enable --now apparmor.service; or exit 1
figlet "Reboot required to activate AppArmor."; or exit 1

# Install Portmaster (from AUR) and ClamAV
# Note: CachyOS usually has paru; if not, use 'yay'
paru -S --noconfirm portmaster-bin

# Enabling Services
sudo systemctl enable --now clamav-freshclam
sudo systemctl enable --now portmaster

# Update ClamAV
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam

# Install Nix (Multi-user install is standard on Arch)
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

# Set default shell
chsh -s /usr/bin/fish

figlet Setup Complete. Restart your PC!

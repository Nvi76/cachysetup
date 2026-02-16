#!/usr/bin/env fish

# Update ClamAV
sudo systemctl stop clamav-freshclam; or exit 1
sudo freshclam; or exit 1
sudo systemctl start clamav-freshclam; or exit 1

# Update System and AUR packages
paru -Syu --noconfirm; or exit 1

# Update Nixpkgs
if type -q nix
    nix-channel --update; or exit 1
    nix profile upgrade --all; or exit 1
end

# Update Flatpak
flatpak update -y; or exit 1

# Update Atuin
if type -q atuin
    atuin self-update
end

# Update Homebrew
if type -q brew
    brew update; or exit 1
    brew upgrade; or exit 1
end

figlet All Updates Completed
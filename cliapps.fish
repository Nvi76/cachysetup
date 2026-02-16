#!/usr/bin/env fish

# Update system
sudo pacman -Syu --noconfirm; or exit 1

# Install CLI Apps from official repos
sudo pacman -S --needed --noconfirm \
    figlet fish curl git vulkan-tools os-prober tk \
    neovim fzf ranger btop thefuck trash-cli fastfetch atuin \
    python-pipx mesa-utils gnupg wl-clipboard cava; or exit 1

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; or exit 1

# Add Homebrew to Fish config
if not grep -q "brew shellenv" $config_file
    echo 'eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)' >> $config_file
end

# Load Homebrew for current session
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)

figlet CLI-Apps Installation Complete
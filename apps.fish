#!/usr/bin/env fish

# Update system
sudo pacman -Syu --noconfirm; or exit 1

# Progress
figlet "30% Complete" 2>/dev/null; or echo "30% Complete"

# Install Flatpak apps
flatpak install com.rtosta.zapzap app.zen_browser.zen org.gimp.GIMP \
    com.github.tchx84.Flatseal org.luanti.luanti --noninteractive; or exit 1

figlet "50% Complete" 2>/dev/null; or echo "50% Complete"

# Install GUI Apps (using paru for AUR packages)
# visual-studio-code-bin is the official MS build
paru -S --noconfirm vscodium-bin brave-bin visual-studio-code-bin; or exit 1

# Homebrew apps
if type -q brew
    brew install ffmpeg 
end

figlet Setup Complete Enjoy Your PC
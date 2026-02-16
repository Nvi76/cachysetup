#!/usr/bin/env fish

# Installing additional utils from the aur
if paru -S --noconfirm auto-cpufreq libxnvctrl-580xx nvidia-580xx-dkms nvidia-580xx-utils nvidia-580xx-settings lib32-nvidia-580xx-utils opencl-nvidia-580xx lib32-opencl-nvidia-580xx
    figlet "Nvidia drivers & autocpufreq installed successfully "
else
    figlet "Error: Nvidia driver & autocpufreq installation failed"
    exit 1
end   

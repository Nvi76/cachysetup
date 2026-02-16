#!/usr/bin/env fish

# Installing auto-cpufreq from the aur
if paru -S --noconfirm auto-cpufreq
    figlet "Installation in progress"
else
    figlet "Error: auto-cpufreq installation failed"
    exit 1
end   
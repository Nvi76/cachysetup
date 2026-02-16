# archsetup

# 1.Fish Config file ~/.config/fish/config.fish looks like this
```
if status is-interactive
    # Prevent Atuin from setting its own (broken) bindings
    set -gx ATUIN_NOBIND true
    atuin init fish | source

    # Manually bind keys using modern Fish syntax
    bind \e\[A _atuin_bind_up # Up Arrow
    bind \cr _atuin_search # Ctrl+R

    # Vi mode bindings (if Vi mode exists)
    if bind -M insert >/dev/null 2>&1
        bind -M insert \e\[A _atuin_bind_up
        bind -M insert \cr _atuin_search
    end

    # Ctrl+Delete = delete word forward
    bind \e\[3\;5~ kill-word

end

# Aliases
alias lsa "ls -a"
alias update "~/.updater.fish"
alias copy "wl-copy <"
alias paste "wl-paste >"
alias scan "clamscan"
alias trm "trash-put"
alias trestore "trash-restore"
alias tbin "trash-empty"
alias listt "trash-list"

thefuck --alias | source

/home/linuxbrew/.linuxbrew/bin/brew shellenv | source
```
# 2. after installing homebrew, manually copy the command homebrew gave you just to make sure
```
# Ensure the config directory exists
if not test -d ~/.config/fish
    mkdir -p ~/.config/fish
end

# Append the Homebrew setup to Fish config
echo 'eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)' >> ~/.config/fish/config.fish

# Evaluate the Homebrew environment in the current session
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
```
# 3. Edit /etc/nix/nix.conf file to have this
    experimental-features = nix-command flakes
    
# 4. after secure.fish edit kernel parameters at /etc/default/grub, after that do sudo grub-mkconfig -o /boot/grub/grub.cfg && sudo systemctl enable --now apparmor.service
```
GRUB_CMDLINE_LINUX_DEFAULT: apparmor=1 security=apparmor lsm=landlock,lockdown,yama,integrity,apparmor,bpf   
```

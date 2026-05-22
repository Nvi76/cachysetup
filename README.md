<!-- # CachyOS Setup -->
Setup and configuration script for CachyOS.

# 1. Git Manual
1) **Git & GitHub Setup**

After running `setup-base.sh`, an SSH key is generated automatically.
If you need to do it manually:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2) **Add the key to GitHub**

1. Print your public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
2. Copy the output
3. Go to GitHub → **Settings** → **SSH and GPG keys** → **New SSH key**
4. Paste the key and save

3) **First-time push (new repo)**

```bash
cd ~/Projects/Scripts/cachysetup
git remote add origin git@github.com:YOUR_USERNAME/cachysetup.git # this is if there's no origin yet
git init
git remote set-url origin git@github.com:YOUR_USERNAME/cachysetup.git
git add .
git commit -m "Initial setup"
git push -u origin main
```

4) **Subsequent pushes**

```bash
cd ~/Projects/Scripts/cachysetup
git add .
git commit -m "description of changes"
git push
```

# 2. Shell Configs
**Bash**
```
# === setup-base.sh managed block - do not edit manually ===
eval "$(atuin init bash)"

[ -f "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"

alias lsa="ls -a"
alias update="~/.updater.sh"
alias scan="clamscan -r"
alias trm="trash-put"
alias trestore="trash-restore"
alias tbin="trash-empty"
alias listt="trash-list"
alias copy="wl-copy <"
alias paste="wl-paste >"
alias rkscan="sudo rkhunter --check --sk"
alias kate="flatpak run org.kde.kate"

# Extra functions
gitpush_installscript() {
    for dir in linuxmintsetup fedorasetup voidsetup cachysetup nixsetup; do
        cd ~/Projects/Scripts/"$dir" 2>/dev/null || continue
        git add . && git diff --cached --quiet || git commit -m "New changes"
        git push 2>/dev/null || true
    done
}

gitpush_installscript_force() {
    for dir in linuxmintsetup fedorasetup voidsetup cachysetup nixsetup; do
        cd ~/Projects/Scripts/"$dir" 2>/dev/null || continue
        git add . && git diff --cached --quiet || git commit -m "New changes"
        git push --force 2>/dev/null || true
    done
}

ollama_model() {
  local model_name=$1
  if [ -z "$model_name" ]; then
    echo "Usage: copy_ollama_model <model-name>"
    return 1
  fi
  ollama export "$model_name" "./${model_name//:/_}.bin"
  echo "Model '$model_name' exported to $(pwd)/${model_name//:/_}.bin"
}

ollama_models_all() {
  local export_dir="./ollama-backup"
  mkdir -p "$export_dir"
  ollama list --format json | jq -r '.[].name' | while read model; do
    echo "Exporting $model..."
    ollama export "$model" "$export_dir/${model//:/_}.bin"
  done
  echo "All models exported to $export_dir"
}

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

export PATH="$PATH:$HOME/.opencode/bin"
if command -v opencode &>/dev/null; then
    source <(opencode completion bash 2>/dev/null) 2>/dev/null || true
fi

# === end of setup-base.sh block ===
```
**Zsh**
```
# === setup-base.sh managed block - do not edit manually ===
eval "$(atuin init zsh)"

alias lsa="ls -a"
alias update="~/.updater.sh"
alias scan="clamscan -r"
alias trm="trash-put"
alias trestore="trash-restore"
alias tbin="trash-empty"
alias listt="trash-list"
alias copy="wl-copy <"
alias paste="wl-paste >"
alias rkscan="sudo rkhunter --check --sk"
alias kate="flatpak run org.kde.kate"

# Extra functions
gitpush_installscript() {
    for dir in linuxmintsetup fedorasetup voidsetup cachysetup nixsetup; do
        cd ~/Projects/Scripts/"$dir" 2>/dev/null || continue
        git add . && git diff --cached --quiet || git commit -m "New changes"
        git push 2>/dev/null || true
    done
}

gitpush_installscript_force() {
    for dir in linuxmintsetup fedorasetup voidsetup cachysetup nixsetup; do
        cd ~/Projects/Scripts/"$dir" 2>/dev/null || continue
        git add . && git diff --cached --quiet || git commit -m "New changes"
        git push --force 2>/dev/null || true
    done
}

ollama_model() {
  local model_name=$1
  if [ -z "$model_name" ]; then
    echo "Usage: copy_ollama_model <model-name>"
    return 1
  fi
  ollama export "$model_name" "./${model_name//:/_}.bin"
  echo "Model '$model_name' exported to $(pwd)/${model_name//:/_}.bin"
}

ollama_models_all() {
  local export_dir="./ollama-backup"
  mkdir -p "$export_dir"
  ollama list --format json | jq -r '.[].name' | while read model; do
    echo "Exporting $model..."
    ollama export "$model" "$export_dir/${model//:/_}.bin"
  done
  echo "All models exported to $export_dir"
}

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)"
fi

export PATH="$PATH:$HOME/.opencode/bin"
if command -v opencode &>/dev/null; then
    source <(opencode completion zsh 2>/dev/null) 2>/dev/null || true
fi

# === end of setup-base.sh block ===
```
**Fish**
```
# === setup-base.sh managed block ===
if status is-interactive
    set -gx ATUIN_NOBIND true
    atuin init fish | source

    bind \e\[A _atuin_bind_up
    bind \cr _atuin_search

    if bind -M insert >/dev/null 2>&1
        bind -M insert \e\[A _atuin_bind_up
        bind -M insert \cr _atuin_search
    end

    bind \e\[3\;5~ kill-word
    bind \cH backward-kill-word
end

alias lsa "ls -a "
alias update "~/.updater.sh "
alias scan "clamscan -r "
alias trm "trash-put "
alias trestore "trash-restore "
alias tbin "trash-empty "
alias listt "trash-list "
alias copy "wl-copy < "
alias paste "wl-paste > "
alias rkscan "sudo rkhunter --check --sk "
alias kate "flatpak run org.kde.kate "

# Extra functions
function gitpush_installscript
    for dir in linuxmintsetup fedorasetup voidsetup cachysetup nixsetup
        cd ~/Projects/Scripts/$dir 2>/dev/null; or continue
        git add .; and git diff --cached --quiet; or git commit -m "New changes"
        git push 2>/dev/null; or true
    end
end

function gitpush_installscript_force
    for dir in linuxmintsetup fedorasetup voidsetup cachysetup nixsetup
        cd ~/Projects/Scripts/$dir 2>/dev/null; or continue
        git add .; and git diff --cached --quiet; or git commit -m "New changes"
        git push --force 2>/dev/null; or true
    end
end

function ollama_model
    set -l model_name $argv[1]
    if test -z "$model_name"
        echo "Usage: ollama_model <model-name>"
        return 1
    end
    set -l parts (string split ":" "$model_name")
    set -l model $parts[1]
    set -l tag "latest"
    if test (count $parts) -ge 2
        set tag $parts[2]
    end
    set -l manifest_path "$HOME/.ollama/models/manifests/registry.ollama.ai/library/$model/$tag"
    if not test -f "$manifest_path"
        echo "Model '$model_name' not found in Ollama store"
        return 1
    end
    set -l digest (jq -r '.layers[] | select(.mediaType == "application/vnd.ollama.image.model") | .digest' "$manifest_path")
    if test -z "$digest"
        echo "Could not find model data layer for '$model_name'"
        return 1
    end
    set -l blob_name (string replace ":" "-" "$digest")
    set -l blob_path "$HOME/.ollama/models/blobs/$blob_name"
    if not test -f "$blob_path"
        echo "Model blob not found at $blob_path"
        return 1
    end
    set -l filename (string replace ":" "_" "$model_name").bin
    cp "$blob_path" "./$filename"
    echo "Model '$model_name' exported to "(pwd)"/"$filename
end

function ollama_models_all
    set -l export_dir "./ollama-backup"
    mkdir -p "$export_dir"
    for manifest_path in $HOME/.ollama/models/manifests/registry.ollama.ai/library/*/*
        set -l name (basename (dirname "$manifest_path"))
        set -l tag (basename "$manifest_path")
        set -l model "$name:$tag"
        echo "Exporting $model..."
        set -l digest (jq -r '.layers[] | select(.mediaType == "application/vnd.ollama.image.model") | .digest' "$manifest_path")
        if test -n "$digest"
            set -l blob_name (string replace ":" "-" "$digest")
            set -l blob_path "$HOME/.ollama/models/blobs/$blob_name"
            if test -f "$blob_path"
                set -l filename (string replace ":" "_" "$model").bin
                cp "$blob_path" "$export_dir/$filename"
            end
        end
    end
    echo "All models exported to $export_dir"
end

if test -f /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

if command -v thefuck >/dev/null
    thefuck --alias | source
end

# === end of setup-base.sh block ===
```

# 3. Fixes

**1) If you use systemd-boot and there's no windows option at boot run this command**

**For Bash:**
```
sudo cp -r /boot/efi/EFI/Microsoft /boot/efi/EFI/ && echo -e "title Windows Boot Manager\nefi \\EFI\\Microsoft\\Boot\\bootmgfw.efi" | sudo tee /boot/efi/loader/entries/windows.conf && sudo sed -i 's/^#timeout.*/timeout 10/' /boot/efi/loader/loader.conf
```
**For Fish:**
```
sudo cp -r /boot/efi/EFI/Microsoft /boot/efi/EFI/; and echo -e "title Windows Boot Manager\nefi \\EFI\\Microsoft\\Boot\\bootmgfw.efi" | sudo tee /boot/efi/loader/entries/windows.conf; and sudo sed -i 's/^#timeout.*/timeout 10/' /boot/efi/loader/loader.conf   
```

**2) After running AppArmor and the secure.sh script fails to config run this manually**
```
sudo nano /etc/default/limine 
# Code to add = lsm=landlock,lockdown,yama,integrity,apparmor,bpf apparmor=1 security=apparmor

sudo nano /etc/apparmor/parser.conf
# Code to add = write-cache
                Optimize=compress-fast
                cache-loc=/var/cache/apparmor
```

**3) If ollama.service is not working properly try to run**
```
sudo mkdir -p /usr/share/ollama && sudo chown ollama:ollama /usr/share/ollama
sudo systemctl restart ollama
```
# 3. Custom Search Engines
```
Arch: https://archlinux.org/packages/?q=%s (archs)
Aur: https://aur.archlinux.org/packages?O=0&K=%s (aurs)
YouTube Search: https://www.youtube.com/search?q=%s (ytu)
Nixpkg Search: https://search.nixos.org/packages?channel=25.11&query=%s (nixpkg)
Brave Search: https://search.brave.com/search?q=%s
Brave Search Ask: https://search.brave.com/ask?q=%s
Startpage: https://startpage.com/search?q=%s
Ecosia: https://ecosia.org/search?q=%s
```

# Fixes
**1) /etc/nix/nix.conf**
```
Edit /etc/nix/nix.conf file to have this
    experimental-features = nix-command flakes
```
    
**2) Kernel parameters @ /etc/default/grub**
After secure.fish edit kernel parameters at /etc/default/grub, after that do sudo grub-mkconfig -o /boot/grub/grub.cfg && sudo systemctl enable --now apparmor.service
```
GRUB_CMDLINE_LINUX_DEFAULT: apparmor=1 security=apparmor lsm=landlock,lockdown,yama,integrity,apparmor,bpf   
```

**3) Change Mouse Cursor (Cosmic)**
If you need to change the mouse cursor or its size its this command 
```
sudo nano /etc/environment
# Put in this XCURSOR_THEME=[theme] for changing the mouse cursor and XCURSOR_SIZE=[size] for its size
```

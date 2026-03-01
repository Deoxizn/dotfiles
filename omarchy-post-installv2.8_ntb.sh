#!/bin/bash

# Script to remove specified applications from Arch Linux and install Snow_Black theme for Omarchy
remove_apps=(
    "1password-beta"
    "1password-cli"
    "kdenlive"
    "obs-studio"
    "obsidian"
    "signal-desktop"
    "xournalpp"
    "alacritty"
    "pinta"
    "aether"
    "typora"
)

pacman_apps=(
    "android-tools"
    "android-udev"
    "fish"
    "adw-gtk-theme"
    "lutris"
    "nfs-utils"
)

aur_apps=(
    "spicetify-cli"
    "nautilus-open-any-terminal"
    "vesktop"
    "wowup-cf-bin"
)

echo "Removing the following applications:"
for app in "${remove_apps[@]}"; do
    echo "  - $app"
done

echo
echo "Installing the following pacman applications:"
for app in "${pacman_apps[@]}"; do
    echo "  - $app"
done

echo
echo "Installing the following AUR applications:"
for app in "${aur_apps[@]}"; do
    echo "  - $app"
done

echo
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo
echo "Refreshing package caches and repositories..."
sudo pacman -Syy --noconfirm
yay -Syy --noconfirm

echo "Removing packages..."
removed_count=0
not_installed_count=0

for app in "${remove_apps[@]}"; do
    if pacman -Qq "$app" &>/dev/null; then
        echo "Removing $app..."
        sudo pacman -Rsn --noconfirm "$app"
        if [ $? -eq 0 ]; then
            ((removed_count++))
        fi
    else
        echo "$app is not installed, skipping..."
        ((not_installed_count++))
    fi
done

echo
echo "Removed $removed_count package(s), skipped $not_installed_count package(s)."

echo
echo "Removing desktop application files..."
desktop_files=(
    "Basecamp.desktop"
    "ChatGPT.desktop"
    "Discord.desktop"
    "Figma.desktop"
    "Fizzy.desktop"
    "GitHub.desktop"
    "Google Messages.desktop"
    "Google Maps.desktop"
    "Google Contacts.desktop"
    "Google Photos.desktop"
    "HEY.desktop"
    "WhatsApp.desktop"
    "X.desktop"
    "YouTube.desktop"
    "Zoom.desktop"
    "Typora.desktop"
)

removed_desktop_count=0
for file in "${desktop_files[@]}"; do
    desktop_path="$HOME/.local/share/applications/$file"
    if [ -f "$desktop_path" ]; then
        echo "Removing $file..."
        rm "$desktop_path"
        if [ $? -eq 0 ]; then
            ((removed_desktop_count++))
        fi
    else
        echo "$file not found, skipping..."
    fi
done

echo "Removed $removed_desktop_count desktop file(s)."

echo
echo "Refreshing repositories before pacman package installation..."
sudo pacman -Syy --noconfirm

echo "Installing pacman packages..."
installed_count=0
already_installed_count=0

for app in "${pacman_apps[@]}"; do
    if pacman -Qq "$app" &>/dev/null; then
        echo "$app is already installed, skipping..."
        ((already_installed_count++))
    else
        echo "Installing $app..."
        sudo pacman -Sy --noconfirm "$app"
        if [ $? -eq 0 ]; then
            ((installed_count++))
        fi
    fi
done

echo
echo "Refreshing repositories before AUR package installation..."
yay -Syy --noconfirm

echo "Installing AUR packages..."
for app in "${aur_apps[@]}"; do
    if pacman -Qq "$app" &>/dev/null; then
        echo "$app is already installed, skipping..."
        ((already_installed_count++))
    else
        echo "Installing $app from AUR..."
        yay -S --noconfirm --needed --removemake "$app"
        if [ $? -eq 0 ]; then
            ((installed_count++))
        fi
    fi
done

echo
echo "Installed $installed_count package(s), skipped $already_installed_count package(s)."

echo "Cloning dotfiles repository..."
mkdir -p "$HOME/git"
cd "$HOME/git"

if [ -d "dotfiles" ]; then
    echo "dotfiles directory already exists. Removing it first..."
    rm -rf dotfiles
fi

git clone https://github.com/Deoxizn/dotfiles.git

if [ $? -eq 0 ]; then
    echo
    echo "Successfully cloned dotfiles to $HOME/git/dotfiles"
else
    echo
    echo "Failed to clone dotfiles repository. Check the output above."
    exit 1
fi

echo
echo "Copying configuration files to .config..."
mkdir -p "$HOME/.config"

config_folders=("autostart" "fastfetch" "hypr" "mpv" "waybar" "OpenRGB" "uwsm" "vesktop" "elephant" "fish" "ghostty" "gtk-3.0" "pacman" "uwsm" "fish" )
config_files=("starship.toml")

for folder in "${config_folders[@]}"; do
    if [ -d "$HOME/git/dotfiles/$folder" ]; then
        echo "Copying $folder to .config..."
        cp -r "$HOME/git/dotfiles/$folder" "$HOME/.config/"
    else
        echo "Warning: $folder not found in dotfiles"
    fi
done

for file in "${config_files[@]}"; do
    if [ -f "$HOME/git/dotfiles/$file" ]; then
        echo "Copying $file to .config..."
        cp "$HOME/git/dotfiles/$file" "$HOME/.config/"
    else
        echo "Warning: $file not found in dotfiles"
    fi
done

echo
echo "Copying .bashrc to home directory..."
if [ -f "$HOME/git/dotfiles/.bashrc" ]; then
    echo "Copying .bashrc..."
    cp "$HOME/git/dotfiles/.bashrc" "$HOME/.bashrc"
else
    echo "Warning: .bashrc not found in dotfiles"
fi

echo
echo "Copying cargo configuration to .cargo..."
if [ -d "$HOME/git/dotfiles/cargo" ]; then
    echo "Copying cargo to .cargo..."
    cp -r "$HOME/git/dotfiles/cargo" "$HOME/.cargo"
else
    echo "Warning: cargo folder not found in dotfiles"
fi

echo
echo "Copying wallpaper folder to Pictures..."
mkdir -p "$HOME/Pictures"
if [ -d "$HOME/git/dotfiles/wallpaper" ]; then
    echo "Copying wallpaper to Pictures..."
    cp -r "$HOME/git/dotfiles/wallpaper" "$HOME/Pictures/"
else
    echo "Warning: wallpaper folder not found in dotfiles"
fi

echo
echo "Configuration files copied successfully."

echo
echo "Creating folders in /mnt..."
mnt_folders=("Applications" "AudioBooks" "Backups" "Books" "Comics" "Downloads" "Music" "Photos" "Video")

for folder in "${mnt_folders[@]}"; do
    if [ ! -d "/mnt/$folder" ]; then
        echo "Creating /mnt/$folder..."
        sudo mkdir -p "/mnt/$folder"
        if [ $? -eq 0 ]; then
            echo "Successfully created /mnt/$folder"
        else
            echo "Failed to create /mnt/$folder"
        fi
    else
        echo "/mnt/$folder already exists, skipping..."
    fi
done

echo "Folder creation complete."

echo
echo "Installing Fisher plugin manager and plugins..."
echo "Installing Fisher..."
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

if [ $? -eq 0 ]; then
    echo "Fisher installed successfully!"
    echo "Installing Sponge plugin..."
    fisher install meaningful-ooo/sponge

    if [ $? -eq 0 ]; then
        echo "Sponge plugin installed successfully!"
    else
        echo "Warning: Failed to install Sponge plugin."
    fi
else
    echo "Warning: Failed to install Fisher."
fi

echo
echo "Configuring i2c..."
echo "Adding user to i2c group..."
sudo usermod "$USER" -aG i2c

echo "Loading i2c-dev module..."
sudo modprobe i2c-dev

echo "Configuring i2c-dev to load on boot..."
sudo bash -c 'echo "i2c-dev" > /etc/modules-load.d/i2c.conf'

echo
echo "i2c configuration complete."

echo
echo "Installing Snow_Black theme..."
echo "Installing theme using omarchy-theme-install..."
omarchy-theme-install https://github.com/ankur311sudo/snow_black

if [ $? -eq 0 ]; then
    echo "Snow_Black theme installed successfully!"
else
    echo "Warning: Failed to install Snow_Black theme. You may need to install it manually."
fi

echo
echo "Running omarchy-theme-hook installation..."
curl -fsSL https://imbypass.github.io/omarchy-theme-hook/install.sh | bash

if [ $? -eq 0 ]; then
    echo "omarchy-theme-hook installed successfully!"
else
    echo "Warning: Failed to install omarchy-theme-hook."
fi

echo
echo "Post Installation Done"
read -n 1 -s -r -p "Press any key to exit..."

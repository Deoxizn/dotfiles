---
name: arch
description: >
  Expert knowledge for administering and troubleshooting Arch Linux, including
  pacman/AUR package management, systemd boot and user sessions, mkinitcpio,
  kernel parameters, networking, hardware, and general system administration.
  REQUIRED when diagnosing package, boot, login, service, or system-level issues,
  or when running pacman/AUR commands. Grounded heavily in the Arch Wiki.
  Covers pacman, paru/yay, AUR, makepkg, PKGBUILD, systemd, systemd-boot,
  GRUB, mkinitcpio, kernel parameters, fstab, LVM, users/groups, sudo,
  networking (NetworkManager/systemd-networkd), audio (PipeWire), Bluetooth
  (BlueZ), printing (CUPS), fonts, locale, time, Secure Boot, mirrors,
  partial upgrade avoidance, rollback, and troubleshooting. Triggers: arch,
  pacman, paru, yay, AUR, makepkg, PKGBUILD, systemctl, systemd, journalctl,
  systemd-boot, grub, mkinitcpio, kernel param, boot, login, fstab, sudo,
  NetworkManager, nmcli, PipeWire, BlueZ, bluetoothctl, CUPS, locale,
  timedatectl, reflector, pacman-mirrors, downgrade, orphan, cache clean.
---

# Arch Linux Skill

Expert agent for **Arch Linux** system administration and troubleshooting.
This machine runs Arch with the **niri** Wayland compositor and the
**noctalia** desktop shell (see those skills). Grounded in current Arch
practices; the **Arch Wiki is the authoritative reference** throughout.

## 0. Primary references (Arch Wiki is canonical)

Core system & package management:
- **ArchWiki main page**: <https://wiki.archlinux.org/>
- **General recommendations**: <https://wiki.archlinux.org/title/General_recommendations>
- **Pacman**: <https://wiki.archlinux.org/title/Pacman>
- **Pacman/Tips and tricks**: <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks>
- **Pacman/Rosetta**: <https://wiki.archlinux.org/title/Pacman/Rosetta>
- **Arch User Repository (AUR)**: <https://wiki.archlinux.org/title/Arch_User_Repository>
- **AUR helpers**: <https://wiki.archlinux.org/title/AUR_helpers>
- **makepkg**: <https://wiki.archlinux.org/title/Makepkg>
- **PKGBUILD**: <https://wiki.archlinux.org/title/PKGBUILD>
- **Mirrors**: <https://wiki.archlinux.org/title/Mirrors>
- **pacman/Q&A / troubleshooting**: <https://wiki.archlinux.org/title/Pacman/Troubleshooting>

Boot, initramfs & systemd:
- **Systemd**: <https://wiki.archlinux.org/title/Systemd>
- **Systemd/User**: <https://wiki.archlinux.org/title/Systemd/User>
- **Systemd/Timers**: <https://wiki.archlinux.org/title/Systemd/Timers>
- **Systemd-boot**: <https://wiki.archlinux.org/title/Systemd-boot>
- **GRUB**: <https://wiki.archlinux.org/title/GRUB>
- **Unified kernel images**: <https://wiki.archlinux.org/title/Unified_kernel_images>
- **MKINITCPIO**: <https://wiki.archlinux.org/title/Mkinitcpio>
- **Kernel parameters**: <https://wiki.archlinux.org/title/Kernel_parameters>
- **Kernel modules**: <https://wiki.archlinux.org/title/Kernel_module>
- **Arch boot process**: <https://wiki.archlinux.org/title/Arch_boot_process>
- **Silent boot**: <https://wiki.archlinux.org/title/Silent_boot>
- **Secure Boot**: <https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot>
- **fstab**: <https://wiki.archlinux.org/title/Fstab>
- **fstab (Auto-mounting)**: <https://wiki.archlinux.org/title/Fstab/Automount>

Users, security & sudo:
- **Users and groups**: <https://wiki.archlinux.org/title/Users_and_groups>
- **sudo**: <https://wiki.archlinux.org/title/Sudo>
- **Polkit**: <https://wiki.archlinux.org/title/Polkit>
- **Security**: <https://wiki.archlinux.org/title/Security>
- **AppArmor**: <https://wiki.archlinux.org/title/AppArmor>

Networking, audio, Bluetooth, printing:
- **Network configuration**: <https://wiki.archlinux.org/title/Network_configuration>
- **NetworkManager**: <https://wiki.archlinux.org/title/NetworkManager>
- **systemd-networkd**: <https://wiki.archlinux.org/title/Systemd-networkd>
- **Wireless**: <https://wiki.archlinux.org/title/Wireless>
- **PipeWire**: <https://wiki.archlinux.org/title/PipeWire>
- **PulseAudio compatibility (PipeWire)**: <https://wiki.archlinux.org/title/PipeWire#PulseAudio-compatible>
- **Bluetooth**: <https://wiki.archlinux.org/title/Bluetooth>
- **BlueZ**: <https://wiki.archlinux.org/title/Bluetooth>
- **CUPS (printing)**: <https://wiki.archlinux.org/title/CUPS>
- **Advanced Linux Sound Architecture (ALSA)**: <https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture>

Graphics, display managers, Wayland:
- **Xorg**: <https://wiki.archlinux.org/title/Xorg>
- **Wayland**: <https://wiki.archlinux.org/title/Wayland>
- **Wayland compositors**: <https://wiki.archlinux.org/title/Wayland_compositors>
- **Display manager**: <https://wiki.archlinux.org/title/Display_manager>
- **SDDM**: <https://wiki.archlinux.org/title/SDDM> (see the `sddm` skill for detail)
- **GDM**: <https://wiki.archlinux.org/title/GDM>
- **Env vars for apps (Wayland)**: <https://wiki.archlinux.org/title/Wayland#GUI_libraries>
- **NVIDIA**: <https://wiki.archlinux.org/title/NVIDIA>
- **Intel graphics**: <https://wiki.archlinux.org/title/Intel_graphics>
- **AMDGPU**: <https://wiki.archlinux.org/title/AMDGPU>

Locale, time, fonts, hardware:
- **Localization (locale)**: <https://wiki.archlinux.org/title/Localization>
- **Time**: <https://wiki.archlinux.org/title/System_time>
- **Fonts**: <https://wiki.archlinux.org/title/Fonts>
- **Font configuration**: <https://wiki.archlinux.org/title/Font_configuration>
- **Power management**: <https://wiki.archlinux.org/title/Power_management>
- **Appearance (cursor/theme)**: <https://wiki.archlinux.org/title/Cursor_themes>
- **Solid state drive (TRIM)**: <https://wiki.archlinux.org/title/Solid_state_drive>
- **Laptop (acpid/tlp)**: <https://wiki.archlinux.org/title/Laptop>
- **tlp**: <https://wiki.archlinux.org/title/TLP>

Troubleshooting & recovery:
- **General troubleshooting**: <https://wiki.archlinux.org/title/General_troubleshooting>
- **Pacman troubleshooting**: <https://wiki.archlinux.org/title/Pacman/Troubleshooting>
- **Downgrading packages**: <https://wiki.archlinux.org/title/Downgrading_packages>
- **Chroot / arch-chroot**: <https://wiki.archlinux.org/title/Chroot>
- **Reinstalling/repairing (boot)**: <https://wiki.archlinux.org/title/Arch_boot_process#Re-installing_the_bootloader>
- **System maintenance**: <https://wiki.archlinux.org/title/System_maintenance>
- **Systemd-resolved**: <https://wiki.archlinux.org/title/Systemd-resolved>

## 1. Core principles

- **Rolling release** — packages update frequently; read the **Arch news**
  (<https://archlinux.org/news/>) and check for **pre-upgrade notices**
  before partial upgrades. **Never do a partial upgrade** (mixing repo
  states) — see "Partial upgrades are unsupported":
  <https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported>
- If a partial upgrade was forced, **roll back the affected packages**
  from cache (`/var/cache/pacman/pkg/`) before continuing. See PacmanTips
  (Reinstalling a package / Downgrading): <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks>
  and <https://wiki.archlinux.org/title/Downgrading_packages>.
- **Arch Wiki "Installation guide"** is the canonical install reference:
  <https://wiki.archlinux.org/title/Installation_guide>.
- Package versions: both [core] and [extra] repos; [multilib] for 32-bit libs.
- The kernel is **linux**; `linux-lts` available for fallback.

## 2. Package management (pacman)

### Basics
```bash
pacman -Sy foo                    # BAD: partial upgrade — refreshes db then installs only foo
pacman -Syu                       # full system upgrade (correct)
pacman -S package                 # install
pacman -R package                 # remove (keep deps... they may be orphaned)
pacman -Rns package               # remove with config + unneeded deps
pacman -Ss query                  # search repos
pacman -Si package                # repo package info
pacman -Qi package                # installed package info
pacman -Q package                 # check if installed (exit 0/1)
pacman -Qo /path/to/file          # which package owns a file
pacman -Ql package                # list files in package
pacman -Qs query                  # search installed
pacman -F search                  # search which package provides a file (sync db)
pacman -Fy                        # update file database
```
- `-s` = search, `-i` = info, `-Q` = query local, `-F` = files db.
- **Sync before full upgrade**: `pacman -Syu` does both.
- Clean the package cache: `pacman -Sc` (keep current), `pacman -Scc` (all),
  or the safer conservative `paccache -r` (keep last N). See
  <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Clean_the_package_cache>.

### Querying / inspection
```bash
pacman -Qq       # all installed package names
pacman -Qq | wc -l               # count
pacman -Qkk      # verify file integrity of all packages
pacman -Qm       # foreign (AUR/manually installed) packages
pacman -Qdt      # orphaned packages (no longer required)
pacman -Qe       # explicitly installed
pacman -D --asdeps foo   # mark as dependency
```
- **Keyring issues** (e.g., delays, tampered/missing `archlinux-keyring`):
  reinstall/refresh: `pacman -S archlinux-keyring`, then
  `pacman-key --init && pacman-key --populate archlinux` only if needed.
- **Mirrors out of date / sync issues**: run `reflector` (see §3) or edit
  `/etc/pacman.d/mirrorlist`.

### Downgrading / rollback
```bash
pacman -U /var/cache/pacman/pkg/foo-1.0-1-x86_64.pkg.tar.zst
```
- Available cached versions in `/var/cache/pacman/pkg/`.
- If already purged, `downgrade` (AUR) offers historical builds.
- See <https://wiki.archlinux.org/title/Downgrading_packages>.

### pacman.conf / caching
- `/etc/pacman.conf` — options like `Color`, `ParallelDownloads`, `ILoveCandy`,
  `VerbosePkgLists`, `[multilib]` inclusion, and `SigLevel`.
- Global cache in `/var/cache/pacman/pkg/`; **CacheDir order matters**.
- Older versions may persist in package dirs; see
  <https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Package_caching>.

## 3. Mirrors

- Mirrors list: `/etc/pacman.d/mirrorlist`. Current recommended tool is
  **reflector** (or `rate-mirrors`). See
  <https://wiki.archlinux.org/title/Mirrors#Automated_sorting>.
```bash
reflector --country 'United States' --latest 10 --protocol https \
  --sort rate --save /etc/pacman.d/mirrorlist
```
- Print current best: `reflector --country ... --latest 20 --protocol https --sort rate`.
- Check sync status: <https://archlinux.org/mirrors/status/>.

## 4. AUR (Arch User Repository)

- The AUR is community-uploaded build scripts (**PKGBUILDs**) — packages are
  **built locally** with **makepkg**, not binary. Only `[core]`/`[extra]`/`[multilib]`
  provide official binaries.
- **AUR homepage**: <https://aur.archlinux.org/>
- **AUR submission guidelines (Trusted User/Binaries inconclusive)**:
  <https://wiki.archlinux.org/title/AUR_submission_guidelines>
- **AUR helpers** (paru, yay, etc.): on Arch, only `makepkg`/`pacman -U` of a
  built pkg is guaranteed; helpers automate lookup/build/install.
  <https://wiki.archlinux.org/title/AUR_helpers>
- **Never run pacman with AUR helper for official packages blindly**; the helper
  should map AUR→build, official→pacman.

### makepkg / manual AUR install
```bash
git clone https://aur.archlinux.org/<pkg>.git
cd <pkg>
makepkg -si          # build; -s sync deps, -i install
makepkg -si --noconfirm
# to update later: git pull, then rebuild
```

### paru (a common AUR helper, Rust)
```bash
paru -S <pkg>            # install AUR or repo package
paru -Syu                # update repos AND AUR
paru -Qdt                # orphans
paru --clean             # clean build cache
```
- paru config: `~/.config/paru/paru.conf`; set flags like `SkipReview`,
  `BottomUp`, `CombinedUpgrade`.
- Keep `PKGBUILD` review as good practice — you are running build scripts as
  yourself. Antibuild behavior: AUR helpers print diffs by default; keep that on.
- See <https://wiki.archlinux.org/title/AUR_helpers>.

## 5. Boot, initramfs & kernel parameters

### Kernel parameters
- Set via the bootloader line, e.g. for **systemd-boot** in
  `/boot/loader/entries/*.conf` (`options ...`) and for **GRUB** via
  `/etc/default/grub` → `GRUB_CMDLINE_LINUX` / `GRUB_CMDLINE_LINUX_DEFAULT`,
  then `grub-mkconfig -o /boot/grub/grub.cfg`.
- Common: `quiet`, `loglevel=3`, `nowatchdog`, `splash`, and mitigations
  (e.g., `mitigations=off` — performance over security).
- **NVIDIA**: `nvidia-drm.modeset=1 nvidia-drm.fbdev=1` (also `nvidia-drm.modeset=1`
  needed for GBM/Wayland). See <https://wiki.archlinux.org/title/NVIDIA#DRM_kernel_mode_setting>.
- **Kernel command line** reference: <https://wiki.archlinux.org/title/Kernel_parameters>.

### mkinitcpio (initramfs)
- Config: `/etc/mkinitcpio.conf` (`HOOKS`, `MODULES`, `BINARIES`, `FILES`).
- Rebuild after kernel/hook changes:
```bash
sudo mkinitcpio -P          # rebuild all presets
sudo mkinitcpio -p linux    # specific preset
```
- `mkinitcpio` reads presets in `/etc/mkinitcpio.d/` (e.g., `linux.preset`).
- Common hooks order: `base udev autodetect microcode modconf kms keyboard
  keymap consolefont block filesystems fsck` (systemd hook variant uses
  `systemd` instead of `udev` for the systemd-based init).
- **Microcode**: install `intel-ucode` or `amd-ucode`; hook/preload in bootloader
  (systemd-boot: separate loader entry `.efi`; GRUB: auto via `os-prober`/grub-mkconfig).
- If the machine won't boot and you added a module/hook, rebuild with `mkinitcpio -P`.
- See <https://wiki.archlinux.org/title/Mkinitcpio>.

### Bootloader
- **systemd-boot** (UEFI, the modern default for Arch):
  - Entries: `/boot/loader/entries/*.conf`; loader config: `/boot/loader/loader.conf`.
  - Rebuild: `bootctl update` (also `bootctl list`, `bootctl status`).
  - Create entry with `bootctl` or manually; generate by just writing entries.
  - See <https://wiki.archlinux.org/title/Systemd-boot>.
- **GRUB** (BIOS or UEFI):
  - `grub-install` + `grub-mkconfig -o /boot/grub/grub.cfg`.
  - Detect other OS: `os-prober` (script may need enabling).
  - See <https://wiki.archlinux.org/title/GRUB>.

### Unified kernel images (UKI) / modern
- **mkinitcpio + UKI**: single `.efi` bundling kernel + initramfs + cmdline,
  enabled via `mkinitcpio.conf` (`default_uki`) and `/etc/kernel/cmdline`.
  See <https://wiki.archlinux.org/title/Unified_kernel_images>.

## 6. systemd (see also the `systemd` skill)

### System services
```bash
systemctl start/stop/enable/disable/restart <svc>
systemctl status <svc>            # state + recent logs
systemctl daemon-reload           # after editing unit files
systemctl list-unit-files         # enabled/disabled/masked
systemctl is-enabled <svc>
systemctl mask / unmask <svc>     # prevent start (strong)
systemctl cat <svc>               # show unit
systemctl edit <svc>              # drop-in override
systemctl list-units --type=service --state=running
systemctl get-default             # default target
```

### User services (critical for desktop: niri, noctalia, etc.)
```bash
systemctl --user start/stop/enable/disable/restart <svc>
systemctl --user daemon-reload
systemctl --user cat/edit <svc>
journalctl --user -u <svc> -e     # logs
journalctl --user -f              # follow all user logs
```
- Default unit dirs: `~/.config/systemd/user/` (user), `/usr/lib/systemd/user/` (system pkg).
- User services run in the `user@<uid>.service` instance; they start when the
  user's systemd user manager starts (see `loginctl enable-linger` for services
  that must run without a login session).
- **graphical-session.target**: desktop shells/DEs start user services in a
  `graphical-session` scope (see niri/noctalia skills for how they integrate).
- See <https://wiki.archlinux.org/title/Systemd/User>.

### Journal (logging)
```bash
journalctl -b                           # current boot
journalctl -u <svc> -e                  # service, tail
journalctl -u <svc> -f                  # follow
journalctl --since "1 hour ago"
journalctl -p err -b                     # errors this boot
journalctl -x                            # (-x) add explanatory text
journalctl -k                            # kernel messages
journalctl -b -1                         # previous boot
```
- Persistent journal: set `Storage=persistent` in `/etc/systemd/journald.conf`
  or create `/var/log/journal`.
- See <https://wiki.archlinux.org/title/Systemd#Logging>.

## 7. Users, groups, sudo, polkit

```bash
useradd -m -G wheel -s /bin/zsh newuser
usermod -aG wheel username
passwd username
sudo -l                       # what you can run
```
- **wheel** group + `/etc/sudoers` (`%wheel ALL=(ALL:ALL) ALL`) for sudo.
- Edit sudoers with `visudo` (NEVER directly, to avoid syntax lockout).
- **polkit**: graphical privilege escalation used by GNOME/KDE stuff and
  system tools (e.g., UPower, NetworkManager actions). Power buttons / more use it.
  - User logs in via SDDM are usually in a local seat → polkit auto-grants
    standard desktop actions (reboot/shutdown from a graphical session).
  - Troubleshoot with `pkaction` (list) and checking `journalctl` for polkit denials.
- See <https://wiki.archlinux.org/title/Users_and_groups>,
  <https://wiki.archlinux.org/title/Sudo>, <https://wiki.archlinux.org/title/Polkit>.

## 8. Networking

- **NetworkManager** is the common desktop network stack:
  ```bash
  nmcli device status
  nmcli radio wifi on
  nmcli device wifi connect "SSID" password "pass"
  nmcli connection show
  nmcli connection up <name>
  nmcli device wifi list
  ```
  - NM Service: `systemctl enable --now NetworkManager`.
  - Tray/UI: `nm-applet` (X11/GTK) or a shell tray (Noctalia has wifi support).
  - See <https://wiki.archlinux.org/title/NetworkManager>.
- **systemd-networkd** (alternative, lightweight):
  - `systemctl enable --now systemd-networkd` + `systemd-resolved`.
  - Config in `/etc/systemd/network/*.network`.
  - See <https://wiki.archlinux.org/title/Systemd-networkd>.
- **systemd-resolved** DNS: `/etc/resolv.conf` symlink handling; `resolvectl status`.
- **Firewall**: `ufw`, `firewalld`, or nftables; usually `ufw`/`firewalld`
  for desktop. Check status before assuming a port is open.

## 9. Audio (PipeWire), Bluetooth (BlueZ), Printing (CUPS)

### PipeWire (current audio server)
- Install: `pipewire pipewire-pulse wireplumber` (wireplumber as session manager).
- Service (user): `systemctl --user enable --now pipewire pipewire-pulse wireplumber`.
- PipeWire replaces both PulseAudio (via `pipewire-pulse`) and JACK (`pipewire-jack`).
- Control volume: `wpctl status`, `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+`,
  `wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle`.
- See <https://wiki.archlinux.org/title/PipeWire>.

### Bluetooth (BlueZ)
```bash
systemctl enable --now bluetooth        # system service
bluetoothctl
  power on
  agent on
  scan on
  pair <MAC>
  trust <MAC>
  connect <MAC>
  scan off
```
- Adapter may need `rfkill unblock bluetooth` if blocked.
- See <https://wiki.archlinux.org/title/Bluetooth>.

### Printing (CUPS)
```bash
pacman -S cups cups-pdf
systemctl enable --now cups
# web UI at http://localhost:631/
# CLI: lpadmin, lpstat -p -d
```
- Driverless via IPP Everywhere on most modern printers.
- See <https://wiki.archlinux.org/title/CUPS>.

## 10. NVIDIA / graphics

- **NVIDIA proprietary** (`nvidia` / `nvidia-lts` matching the kernel variant):
  - Wayland requires **GBM**: kernel param `nvidia-drm.modeset=1`; for newer
    full GBM include `nvidia-drm.fbdev=1`.
  - Ensure `nvidia_*` modules are in initramfs **MODULES** if needed for early boot.
  - On Wayland compositors set env vars: `__GLX_VENDOR_LIBRARY_NAME=nvidia`,
    `LIBVA_DRIVER_NAME=nvidia`, `WLR_NO_HARDWARE_CURSORS=1` (if cursors broken).
  - See <https://wiki.archlinux.org/title/NVIDIA> and the `niri` skill §Nvidia.
- **Intel**: `mesa`, `vulkan-intel`, `intel-media-driver` (VA-API);
  `libva-utils` for `vainfo`. See <https://wiki.archlinux.org/title/Intel_graphics>.
- **AMD**: `mesa`, `vulkan-radeon`, `libva-mesa-driver`; kernel module `amdgpu` (default). See <https://wiki.archlinux.org/title/AMDGPU>.

## 11. Locale, time, fonts, power

### Locale
- Generate locales: edit `/etc/locale.gen` (uncomment e.g. `en_US.UTF-8 UTF-8`),
  run `locale-gen`.
- Set default in `/etc/locale.conf`: `LANG=en_US.UTF-8`.
- See <https://wiki.archlinux.org/title/Localization>.

### Time
```bash
timedatectl set-timezone Region/City
timedatectl set-ntp true        # enable NTP (systemd-timesyncd)
timedatectl status
```
- See <https://wiki.archlinux.org/title/System_time>.

### Fonts
- Font packages: `ttf-jetbrains-mono-nerd`, `ttf-nerd-fonts-symbols` (icons),
  `noto-fonts`, `otf-font-awesome`. Audit: `fc-list`.
- Fontconfig: `~/.config/fontconfig/fonts.conf`; aliases typical for shells.
- See <https://wiki.archlinux.org/title/Fonts>.

### Power management
- **TLP/auto-cpufreq** for laptops (disable both if you use a desktop DE's
  own power tool). `systemctl enable --now tlp`.
- Check `systemctl status tlp`.
- Suspend toggles: `systemctl suspend`, `loginctl lock-session` (see niri/noctalia lock).
- See <https://wiki.archlinux.org/title/Power_management>, <https://wiki.archlinux.org/title/TLP>.

## 12. Display managers & graphical login

- Arch does not default to a display manager; you can start Wayland sessions
  from the TTY. Many use **SDDM** or **GDM**.
- **SDDM** — see the `sddm` skill (this machine's login manager).
- Related Arch Wiki: <https://wiki.archlinux.org/title/Display_manager>,
  <https://wiki.archlinux.org/title/SDDM>.
- **Session files** for Wayland compositors live in
  `/usr/share/wayland-sessions/*.desktop` (e.g. `niri.desktop`); for X in
  `/usr/share/xsessions/`. If a login manager doesn't list your compositor,
  its `.desktop` session file is missing or malformed.
- **login commands** like `niri --session` set up the D-Bus/systemd user bus
  (`$XDG_RUNTIME_DIR`, `WAYLAND_DISPLAY`) properly for the desktop session.
- See the `niri` skill §Session startup.

## 13. Troubleshooting workflow (system-level)

Start general, then narrow:

```bash
# 1. Is it a boot problem? — journal + bootloader
journalctl -b -p err
systemctl status   # degraded? (`systemctl --failed` lists failed units)

# 2. Is it a specific service? — check the unit
systemctl --failed
journalctl -u <svc> -e --no-pager
systemctl status <svc>

# 3. Is it a package problem? — integrity / ownership
pacman -Qkk <pkg>
pacman -Qo <file>

# 4. Hardware? — dmesg / lspci / lsusb
dmesg -T | grep -i -E 'error|fail|nvidia|nouveau'
lspci -nnk | grep -iA3 'vga|3d'

# 5. Graphics / Wayland — env vars, niri validate, GPU modules
lsmod | grep nvidia        # is the driver loaded?
modinfo nvidia | head       # version matches kernel?
```

### Common failure classes & remedies

- **Boot fails / initramfs**: rebuild `mkinitcpio -P`; check `MODULES`/`HOOKS`;
  boot from a live USB, `arch-chroot` into the root, reinstall bootloader.
  See <https://wiki.archlinux.org/title/Chroot> (arch-chroot (from arch-install-scripts):
  `mkdir -p /mnt; mount /dev/sdX1 /mnt ...; arch-chroot /mnt`).
- **Stuck at login / won't return to gfx**: check SDDM logs (§SDDM skill),
  `systemctl status sddm`, journal at the failure; check for a missing
  `niri.desktop`/Wayland session, or graphics module issues.
- **Keyboard/mouse not working after boot**: USB modules, `rfkill`, bootloader
  kernel params (e.g., `iommu=pt` for PCIe issues, `acpi_osi=Linux` rarely).
- **Network not up**: `nmcli device status`, `systemctl status NetworkManager`,
  `ip a` for interfaces, ping gateway.
- **Pacman keyring / gpg failures**: reinstall `archlinux-keyring`, then
  `pacman-key --init && pacman-key --populate archlinux` (see
  <https://wiki.archlinux.org/title/Pacman/Package_signing>).
- **Pacman "unable to lock database"**: a previous pacman crashed; remove
  `/var/lib/pacman/db.lck` only if sure no pacman is running
  (`pgrep -x pacman`).
- **"failed to commit transaction (conflicting files)"**: another package owns
  a file; inspect `pacman -Qo /path` and run the documented fix, or use
  `--overwrite` sparingly (know what you're overwriting).
- **Disk full / cache**: `paccache -r`, `du -sh /var/cache/pacman/pkg`,
  delete old kernels (see pacman hook behavior), `journalctl --vacuum-size=200M`.

## 14. Safety rules

- **Never run a partial upgrade.** `pacman -Sy` without `-u` is almost always
  wrong and causes database mismatch ("failed to prepare transaction").
- **Read the Arch News / pre-upgrade notices** before large upgrades.
- Back up config before editing system files; copy edited `*.conf` files to
  `.bak` before `pacman -Syu` that may rewrite them.
- Prefer editing user config (`~/.config/`) over system defaults.
- When diagnosing: **gather evidence first** (journal, exit codes, `-Qkk`,
  `dmesg`) — see the `diagnose-crash` skill for core-dump crash analysis.
- Don't run destructive commands (`pacman -Rns`, `rm -rf`, disk tools) without
  user confirmation.

## Example requests

- "pacman database error / -Sy issue" → explain partial upgrade rule; fix with `pacman -Syu`.
- "I removed a package and now X breaks" → `pacman -Qo` the binary, reinstall.
- "Which package owns /usr/bin/foo" → `pacman -Qo /usr/bin/foo`.
- "Nvidia + Wayland blank/cursors trash" → kernel params `nvidia-drm.modeset=1 fbdev=1`, env vars.
- "Boost time / won't boot" → `journalctl -b -p err`, `mkinitcpio -P`, bootloader, chroot.
- "Audio not working" → pipewire user units, `wpctl status`.
- "Bluetooth can't connect" → `bluetoothctl`, `rfkill`.

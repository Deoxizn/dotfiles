---
name: systemd
description: >
  Expert knowledge for systemd on Arch Linux — system and user services,
  targets, units, journal logging, timers, sockets, sessions/logind,
  environment management, and system/eXternal boot integration. REQUIRED when
  writing or troubleshooting systemd units, ~/.config/systemd/user/ services,
  graphical-session handling, journalctl analysis, timers, or logind/session
  behavior, or when integrating desktop shells (niri, noctalia) with systemd.
  Grounded in the Arch Wiki. Covers systemctl (system + --user), unit file
  syntax, drop-ins, targets, WantedBy=, PartOf=, StartLimit*, resource control,
  journalctl, journald.conf, systemd-resolved, systemd-networkd, systemd-boot,
  logind/sessions, enable-linger, XDG environment.d, and troubleshooting.
  Triggers: systemd, systemctl, systemctl --user, unit file, service, target,
  WantedBy, PartOf, journalctl, journal, journald, timer, oncalendar,
  loginctl, linger, enable-linger, environment.d, dbus, graphical-session,
  user@.service, daemon-reload, masked, enabled, failed unit.
---

# systemd Skill

Expert agent for **systemd** on Arch Linux. systemd is Arch's init system and
service manager — it controls boot, services, sessions, logging and more.
Crucial here because this machine's desktop integration (niri as a systemd
session, noctalia as a user service, SDDM as the display-manager service) is
all managed through it.

## 0. Primary references

- **Arch Wiki — systemd**: <https://wiki.archlinux.org/title/Systemd>
- **Arch Wiki — systemd/User**: <https://wiki.archlinux.org/title/Systemd/User>
- **Arch Wiki — systemd/Timers**: <https://wiki.archlinux.org/title/Systemd/Timers>
- **Arch Wiki — systemd-networkd**: <https://wiki.archlinux.org/title/Systemd-networkd>
- **Arch Wiki — systemd-resolved**: <https://wiki.archlinux.org/title/Systemd-resolved>
- **Arch Wiki — systemd-boot**: <https://wiki.archlinux.org/title/Systemd-boot>
- **Arch Wiki — Environment variables**: <https://wiki.archlinux.org/title/Environment_variables>
- **Arch Wiki — auto-login (logind/autologin)**: <https://wiki.archlinux.org/title/General_troubleshooting#Session_reset>
- **freedesktop systemd docs**: <https://www.freedesktop.org/software/systemd/man/systemd.unit.html>
- **freedesktop systemd.service(5)**: <https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html>
- **freedesktop systemd.unit(5)**: <https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html>
- **logind man**: <https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html>

## 1. Core concepts

- **Unit** — a resource systemd manages: `.service`, `.target`, `.timer`,
  `.socket`, `.mount`, `.path`, `.slice`, `.scope`, `.device`, `.swap`.
- **Unit files locations** (resolution order):
  1. `/etc/systemd/system/` (admin, highest precedence)
  2. `/run/systemd/system/`
  3. `/usr/lib/systemd/system/` (packaged defaults)
  - User manager uses `$XDG_CONFIG_HOME/systemd/user/` (i.e.
    `~/.config/systemd/user/`), then `/usr/lib/systemd/user/`.
- **Targets** are groups of units; `default.target` is what boot reaches.
  Example targets: `graphical.target`, `multi-user.target`, `basic.target`,
  `sysinit.target`, `shutdown.target`.
- **Dependencies**: `Requires=`, `Wants=`, `After=`, `Before=`, `PartOf=`,
  `Requisite=`, `Conflicts=`. `After=` orders; `Wants=` starts (non-fatal);
  `Requires=` starts (fatal); `PartOf=` ties stop/restart to a parent.
- **System manager** (PID 1) vs **user manager**: each logged-in user gets a
  systemd user instance (`user@<uid>.service`), controllable with `systemctl --user`.
  This is how desktop shells are often run.

## 2. systemctl reference

### System
```bash
systemctl start/enable/enable --now <unit>
systemctl stop/disable/disable --now <unit>
systemctl restart <unit>
systemctl status <unit>          # state + journal tail + main PID
systemctl is-active / is-enabled <unit>
systemctl daemon-reload          # re-read unit files/drop-ins
systemctl cat <unit>             # effective unit (incl. drop-ins)
systemctl edit <unit>            # create drop-in override
systemctl edit --full <unit>     # edit full unit copy
systemctl mask/unmask <unit>     # unstartable even by deps
systemctl list-units --type=service --state=running
systemctl list-unit-files | grep enabled
systemctl --failed               # units that failed
systemctl get-default / set-default graphical.target
systemctl poweroff / reboot / suspend / hibernate
```

### User (see §6)
```bash
systemctl --user list-units
systemctl --user --failed
systemctl --user restart <unit>
systemctl --user daemon-reload
```
- `systemctl --user` works when your user manager is running (inside a
  graphical session or after `loginctl enable-linger`).

## 3. Unit file syntax (service example)

```ini
[Unit]
Description=Short description
Documentation=man:... https://...
After=graphical-session.target network.target dbus.service
Wants=graphical-session.target
PartOf=graphical-session.target
ConditionUser=!
StoppingTimeoutSec=

[Service]
Type=simple                 # simple|exec|forking|oneshot|notify|dbus|idle
ExecStart=/usr/bin/foo -a --flag
ExecStartPre=/usr/bin/prep
ExecStop=/usr/bin/cleanup
Environment=FOO=bar BAZ=qux
# EnvironmentFile=-/etc/foo.env   # prefixed '-' = missing file OK
WorkingDirectory=/opt/foo
Restart=on-failure           # no|on-success|on-failure|on-abnormal|always|on-abort
RestartSec=5s
User=foo
Group=foo
UMask=0027
TimeoutStartSec=90
TimeoutStopSec=90
KillMode=mixed
# sandboxing (recommended on Arch):
PrivateTmp=yes
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=read-only

[Install]
WantedBy=multi-user.target
# Also: RequiredBy=, Alias=
```

- **`Type=simple`** — main process is `ExecStart` itself (default; most common).
- **`Type=forking`** — process daemonizes; `PIDFile=` often needed.
- **`Type=oneshot`** — runs once and exits; use `RemainAfterExit=yes` to keep
  "active".
- **`Type=notify`** — process signals readiness via sd_notify; common for
  user session services (e.g. a shell).
- `WantedBy=`/`RequiredBy=` in `[Install]` are only applied at `enable`.

### Drop-in overrides (preferred customization)
```bash
systemctl edit --force <unit>    # /etc/systemd/system/<unit>.d/override.conf
```
Standard pattern:
```ini
[Service]
Environment="FOO=bar"
Restart=always
```
Drop-ins never overwrite the unit; they merge. Remove by deleting the file.

## 4. Journal (logging) — the Arch way to debug

### Common commands
```bash
journalctl -b                          # current boot
journalctl -b -1                       # previous boot
journalctl -u <unit> -e                # unit's log, end
journalctl -u <unit> -f                # follow
journalctl -u <unit> --since "2 hours ago"
journalctl -p warning -b               # warnings+ this boot
journalctl -x                          # add explanatory text
journalctl -k                          # kernel
journalctl --vacuum-size=200M          # keep journal small
journalctl --vacuum-time=14d
```
- **PID of a unit**: `systemctl show -p MainPID <unit>`.

### Persistent journal
`journalctl` on Arch by default may be volatile (lost on reboot). To persist:
```bash
sudo mkdir -p /var/log/journal
sudo systemctl restart systemd-journald
```
Or set in `/etc/systemd/journald.conf`: `Storage=persistent`.
See <https://wiki.archlinux.org/title/Systemd#Logging>.

## 5. Timers (cron replacement)

```ini
# /etc/systemd/system/backup.service
[Unit]
Description=Backup script

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup

# /etc/systemd/system/backup.timer
[Unit]
Description=Daily backup

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```
```bash
systemctl enable --now backup.timer
systemctl list-timers
systemctl start backup.service   # run once manually
```

### OnCalendar syntax (common)
`daily`, `weekly`, `monthly`, `*-*-* 02:00:00` (daily at 2am),
`Mon..Fri 09:00`, `*:0/5` (every 5 min). See
<https://wiki.archlinux.org/title/Systemd/Timers#Calendar_events> or
`systemd.time(7)`.

## 6. User services & the graphical session

### How desktop services run
- When you log in graphically (via **SDDM** → niri session → niri starts the
  systemd user manager if `niri --session` is used), a user manager runs under
  your UID. Services in `~/.config/systemd/user/` are enabled with
  `systemctl --user`.
- **`graphical-session.target`**: desktop sessions start this target so that
  services scoped to it (`WantedBy=graphical-session.target` +
  `PartOf=graphical-session.target`) start together and stop when the session
  ends. This is how a shell like noctalia typically integrates.
- **Environment**: systemd user services inherit `~/.config/environment.d/*.conf`
  (see §9) — NOT your interactive shell env.

### Example user service for noctalia
```ini
# ~/.config/systemd/user/noctalia.service
[Unit]
Description=Noctalia desktop shell
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=dbus                       # or Type=simple
ExecStart=/usr/bin/noctalia
Restart=on-failure
RestartSec=3

[Install]
WantedBy=graphical-session.target
```
```bash
systemctl --user daemon-reload
systemctl --user enable --now noctalia
systemctl --user status noctalia
```

### Which units run? Standard targets for user services
- `default.target` (user) — the user default target (starts most user services).
- `graphical-session.target` — session-scoped; started/stopped by the session
  wrapper. "Log out" stops these even though the user manager persists.

### enable-linger
- Without an active login, the user systemd instance does not persist unless
  **lingering** is enabled: `sudo loginctl enable-linger <user>`.
  Linger keeps user units running (e.g. headless services) and starts the user
  manager at boot. A desktop user usually does NOT need linger.

## 7. logind & sessions

- **logind** (`systemd-logind`) manages seats, sessions and power keys.
- Commands:
  ```bash
  loginctl list-sessions
  loginctl session-status <id>
  loginctl show-user <user>
  loginctl lock-session / unlock-session
  loginctl enable-linger <user>
  ```
- **Screens/lock**: SDDM creates a graphical session; lock can be via
  `loginctl lock-session`. Desktop shells may use inhibit (`loginctl` or
  systemd-inhibit) to delay sleep.
- **Power buttons**: handled by logind; `loginctl set-hostname` etc.

## 8. systemd-resolved & systemd-networkd (if used)

- `resolvectl status` shows DNS; `resolvectl query <host>`.
- systemd-networkd: `systemctl enable --now systemd-networkd`.
- On Arch, NetworkManager is the common choice (works with resolved if
  configured). See the `arch` skill §Networking.

## 9. environment.d (per-user env for user services)

- Files: `~/.config/environment.d/*.conf` (and `/etc/environment.d/`).
- Syntax: `NAME=value` lines; supports shell-style `${VAR}` expansion.
- These set env for the **systemd user manager** → inherited by user services
  and child processes, and by `systemctl --user` spawned apps. This is the
  right place to set `WAYLAND_DISPLAY`-independent vars like `QT_QPA_PLATFORM`,
  `XDG_CURRENT_DESKTOP`, `GTK_THEME`, `PATH` additions, etc.
- See <https://wiki.archlinux.org/title/Environment_variables>.

## 10. Troubleshooting workflow

```bash
# 1. Identify scope — system or user
systemctl --failed                 # system
systemctl --user --failed          # user

# 2. Unit status + logs
systemctl status <unit>            # state, main PID, exec line
journalctl -u <unit> -e --no-pager # the story

# 3. Was it ever enabled/expected at boot?
systemctl is-enabled <unit>
systemctl list-unit-files | grep <unit>

# 4. Dependency/ordering problems
systemctl list-dependencies <unit>
systemctl list-dependencies graphical.target | grep <unit>

# 5. Recent changes? (Arch: package updates are top suspect)
journalctl -b -p err
# or for boot/startup failures: journalctl -b | grep -i error
```

### Common failure modes & fixes

- **"Failed to start ... Operation not permitted"** → sandbox options
  (`ProtectSystem=strict`, `PrivateTmp`) too strict for the service.
- **"main process exited, code=killed"** → OOM or signal; check
  `journalctl -k | grep -i oom`.
- **"Unit <x>.service not found"** → unit file missing (wrong name/path) or
  `daemon-reload` needed.
- **"Failed to enable unit: File exists"** / symlink conflict → multiple
  providers; find the symlink in `/etc/systemd/system/*.wants/` and remove.
- **masked unit**: `systemctl unmask <unit>`.
- **StartLimit hit**: default `StartLimitIntervalSec`/`StartLimitBurst`
  (e.g., `StartLimitBurst=5`) stops restart loops. Clear with
  `systemctl reset-failed <unit>`; adjust with `StartLimitBurst=10` +
  `StartLimitIntervalSec=0` in the unit `[Unit]`.
- **Services racing at login** (desktop) → ensure `After=`/`PartOf=` on
  `graphical-session.target`; start-order fights are a top user-trouble source.
- **Environment not seen by service** → env vars from your interactive shell
  do not propagate; use `environment.d` or `Environment=`/syinit.

## 11. Safety rules

- **`daemon-reload` after editing any unit/drop-in.**
- Back up unit files before edits (copy to `.bak`).
- Don't `mask` units casually; `disable` is reversible and enough in most cases.
- Avoid editing packaged units in `/usr/lib/systemd/system/` — use drop-ins
  (`systemctl edit`), which survive package updates.
- Logout ends `graphical-session.target` services — if your user service dies
  at lock/logout unexpectedly, re-examine `PartOf=`/`WantedBy=` rather than
  Restart= settings.
- Read the Arch Wiki <https://wiki.archlinux.org/title/Systemd> and
  <https://wiki.archlinux.org/title/Systemd/User> before restructuring boot or
  session units.

## Example requests

- "Add a user service to autostart with my desktop" → `~/.config/systemd/user/`, `WantedBy=graphical-session.target`.
- "Why did <svc> die?" → `journalctl -u <svc> -e`, `systemctl status <svc>`, `systemctl --failed`.
- "Service won't start after update" → check `is-enabled`, log, recent packages (`pacman -Qkk`).
- "Timer to run X at 3am daily" → `.timer` with `OnCalendar=*-*-* 03:00:00`.
- "Persist logs across reboots" → `/var/log/journal` or `Storage=persistent`.
- "my shell/bar dies on logout instead of stopping cleanly" → scope user services to `graphical-session.target` via `PartOf=`, and use `Type=notify`/`WantedBy=`.
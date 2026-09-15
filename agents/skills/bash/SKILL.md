---
name: bash
description: >
  Expert knowledge for bash scripting and safe shell practice on Arch Linux.
  REQUIRED when writing or reviewing *.sh / *.bash scripts, systemd ExecStart
  helpers, cron jobs, or any bash one-liner pasted into runbooks. Grounded in
  bash 5.3 behavior with set -euo pipefail discipline. Covers safe headers,
  quoting and expansion, arrays and assoc arrays, functions, getopts parsing,
  process substitution, redirection, [[ ]] conditionals, loops, error handling,
  debugging with set -x and ShellCheck (SC2086/SC2046/SC2006/SC2181), shfmt,
  bashisms vs sh portability, and systemd/cron gotchas. Triggers: bash,
  shellcheck, shfmt, set -euo pipefail, getopts, assoc array, process
  substitution, ExecStart, *.sh, shell script.
---

# Bash Skill

Expert agent for **bash** scripting on Arch Linux. This machine runs
**bash 5.3.15** at `/usr/bin/bash` (system and scripting shell) alongside
**fish 4.9.3** as the interactive shell (see the **fish** skill). Use bash
for portable scripts, `/usr/bin` utilities, systemd helpers, and anything
cron or another user may run. Default to strict mode, ShellCheck-clean
code, and `shfmt` formatting in every new script.

## 0. Primary references

Canonical docs for the installed 5.3 series:

- **Bash manual (current)**: <https://www.gnu.org/software/bash/manual/>
- **Bash 5.3 NEWS / changes**: <https://git.savannah.gnu.org/cgit/bash.git/tree/NEWS>
- **BashGuide (Wooledge)**: <https://mywiki.wooledge.org/BashGuide>
- **BashFAQ (Wooledge)**: <https://mywiki.wooledge.org/BashFAQ>
- **BashPitfalls (read this)**: <https://mywiki.wooledge.org/BashPitfalls>
- **ShellCheck wiki / checks**: <https://github.com/koalaman/shellcheck/wiki/Checks>
- **shfmt (mvdan/sh)**: <https://github.com/mvdan/sh>
- **ArchWiki bash**: <https://wiki.archlinux.org/title/Bash>
- **ArchWiki systemd/Timers**: <https://wiki.archlinux.org/title/Systemd/Timers>

Local references on this machine:

```bash
bash --version              # expect 5.3.x; here 5.3.15
man bash                    # full manual for the installed build
help set trap read mapfile  # builtin help, faster than man for one builtin
shellcheck --version        # expect 0.11.0 (August 2025 stable)
shfmt --version             # expect v3.14.x (3.14.1, September 2026)
```

## 1. Version and runtime facts (September 2026)

Bash **5.3** (July 2025) is the current stable series. Headline changes:

- New command-substitution form running in the **current shell execution
  context** (no subshell fork), in output-capture and `$REPLY` variants.
  Check the installed manual/NEWS for exact syntax; classic `$()` is
  unchanged.
- `GLOBSORT` controls sorting of pathname expansion and completion.
- `compgen` can write completions into a named variable instead of stdout.
- `read -E` uses readline with default plus programmable completion.
- `source -p PATH` controls path search behavior.
- C23 source conformance; readline 8.3 adds case-insensitive search and
  completion-export helpers.

Write for `bash >= 4.4` unless the file must also run as `sh` (see
section 9 for that case).

## 2. Safe scripting header

Every new script starts from this header. Do not ship scripts without it.

```bash
#!/usr/bin/env bash
# mytool — one-line purpose here.
set -euo pipefail
IFS=$'\n\t'
```

- `#!/usr/bin/env bash` finds bash on Arch, Nix, and macOS. Never use
  `#!/bin/sh` for a file containing bashisms.
- `set -e` aborts on first failure, `set -u` errors on unset variables,
  `set -o pipefail` fails pipelines when any stage fails.
- `IFS=$'\n\t'` narrows splitting so spaces in filenames survive.

Add tracing context and cleanup:

```bash
export PS4='+ ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:-main}: '
trap 'echo "interrupted" >&2; exit 130' INT TERM
shopt -s inherit_errexit 2>/dev/null || true  # propagate -e into subshells
```

`set -e` does not fire inside `if`/`while` conditions, `&&`/`||` lists,
or command substitutions in those contexts. Be explicit:

```bash
if ! cd "$dir"; then
    echo "cannot cd to $dir" >&2
    exit 1
fi
output=$(some_command) || exit 1
grep -q pattern file || { echo "pattern missing" >&2; exit 1; }
```

## 3. Quoting and expansion rules

Quote every expansion unless you can state why it must stay unquoted.
Expansion order: brace, tilde, parameter, command, arithmetic, splitting,
glob, quote removal.

```bash
name="ada"
echo "$name"              # quoted — always one word
echo "$@"                 # quoted — one word per argument (never bare $@)
echo "${name:-default}"   # default when unset or empty
echo "${name:?missing}"   # abort when unset or empty
echo "${#name}" "${name:0:2}"  # length 3, slice "ad"
```

```bash
mkdir -p project/{src,tests,docs}   # brace expansion
cp app.conf{,.bak}
today=$(date +%F)                   # always $( ), never backticks
n=$((n + 1)); pct=$((done * 100 / total))
shopt -s nullglob
logs=(/var/log/*.log)     # empty array when no match, not literal '*.log'
```

The only safe forwarding and iteration forms:

```bash
run "$@"                  # one word per argument — correct
for f in *.log; do echo "$f"; done    # glob directly, never for f in $(ls)
rm -- "$f"                # -- stops flag parsing for dash-leading names
while IFS= read -r line; do printf '%s\n' "$line"; done < file
find . -name '*.tmp' -print0 | while IFS= read -r -d '' f; do rm -f -- "$f"; done
```

## 4. Conditionals, case, loops

Prefer `[[ ]]` over `[ ]`/`test`: no quoting needed on the left,
`==` globs and `=~` regex work, nothing splits.

```bash
if [[ -f $config ]]; then
    echo "config: $config"
elif [[ -d ${config%/*} ]]; then
    echo "config dir exists, file missing" >&2
else
    echo "no config" >&2; exit 1
fi

[[ -n ${DEBUG:-} ]] && echo "debug on"
[[ $branch == feature/* ]] && echo "feature branch"
[[ $sha =~ ^[0-9a-f]{7,40}$ ]] && echo "looks like a git sha"
[[ $count -gt 10 ]] && echo "many"
((n++)); ((total += line_count))
```

```bash
case ${1:-} in
    -h|--help|help) usage; exit 0 ;;
    -e|--env) env_name=${2:?--env needs a value}; shift 2 ;;
    --) shift; break ;;
    -*) echo "unknown flag: $1" >&2; exit 2 ;;
    *) break ;;
esac
```

```bash
for f in *.sh; do
    [[ -e $f ]] || continue
    shellcheck --severity=warning -- "$f"
done

mapfile -t failed < <(systemctl list-units --type=service --state=failed --no-legend | awk '{print $1}')
for u in "${failed[@]}"; do echo "failed: $u"; done

attempt=0
until curl -fsS http://localhost:8080/health; do
    ((++attempt >= 30)) && { echo "service never came up" >&2; exit 1; }
    sleep 1
done
```

`break`/`continue` accept a level (`break 2`). `select` is for
interactive menus only, never scripts.

## 5. Arrays and associative arrays

```bash
services=(nginx postgres redis)
services+=(caddy)
echo "${services[0]}"           # nginx — indexing starts at 0
echo "${services[-1]}"          # last element
echo "${#services[@]}"          # length
printf '%s\n' "${services[@]}"  # the only safe iteration
unset 'services[1]'

declare -A colors=([red]=31 [green]=32 [yellow]=33)  # assoc needs declare -A
colors[blue]=34
for k in "${!colors[@]}"; do echo "$k -> ${colors[$k]}"; done
[[ -v colors[red] ]] && echo "red known"
```

Mistakes to avoid: `echo $services` prints only element 0;
`cp $files /dest` splits — always `cp -- "${files[@]}" /dest/`.
Fill arrays safely with `mapfile -t lines < file` or
`IFS=, read -ra parts <<< "a,b,c"`.

## 6. Functions and argument parsing

Functions use `local`, return status codes, print data on stdout.

```bash
log()  { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*" >&2; }
die()  { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

deploy() {
    local env_name=staging dry_run=0
    local OPTIND opt
    while getopts ':e:nh-:' opt; do
        case $opt in
            e) env_name=$OPTARG ;;
            n) dry_run=1 ;;
            h) usage; return 0 ;;
            -) case $OPTARG in
                   env=*) env_name=${OPTARG#*=} ;;
                   dry-run) dry_run=1 ;;
                   *) echo "unknown --$OPTARG" >&2; return 2 ;;
               esac ;;
            :) echo "option -$OPTARG needs a value" >&2; return 2 ;;
            ?) echo "unknown flag -$OPTARG" >&2; return 2 ;;
        esac
    done
    shift $((OPTIND - 1))
    echo "deploying to $env_name (dry-run=$dry_run), rest: $*"
}
```

- `local` every non-exported variable. `return <0-255>` is status only.
- `getopts` covers short flags; the `-` trick adds `--long` flags
  without GNU `getopt`. For complex CLIs use the `case` loop in 10.1.
- `export -f deploy` exposes a function to child `bash -c` processes
  (rare; used with `xargs -I{} bash -c '...'`).

## 7. Redirection, pipes, process substitution

```bash
cmd >out.log 2>err.log     # truncate both separately
cmd >combined.log 2>&1     # stderr into stdout's target
cmd &>all.log              # bash shorthand for the above
cmd >>append.log 2>&1
cmd <<<"$string"           # herestring (adds trailing newline)

cat >file.conf <<'EOF'     # quoted delimiter: literal, no expansion
root = "$HOME"
EOF
cat >run.sh <<EOF          # unquoted: expands now (code generation)
generated_at=$(date -u +%FT%TZ)
EOF
```

```bash
set -o pipefail
journalctl -u myapp --since today | grep -i error | tail -n 20
echo "stages: ${PIPESTATUS[*]}"   # every stage, e.g. 0 1 0

diff <(sort a.txt) <(sort b.txt)  # process substitution: pseudo-files
while IFS= read -r line; do echo "got: $line"; done < <(generate_lines)

exec 9>/run/lock/mytool.lock      # lockfile fd for single-instance scripts
flock -n 9 || die "another instance is running"
```

## 8. Error handling and debugging

```bash
err() { printf 'ERROR [%s:%s] %s\n' "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "$*" >&2; }
trap 'err "command failed: $BASH_COMMAND (rc=$?)"' ERR

retry() { # retry <tries> <delay> <cmd...>
    local tries=$1 delay=$2; shift 2
    local i rc=0
    for ((i = 1; i <= tries; i++)); do
        "$@" && return 0 || rc=$?
        ((i < tries)) && sleep "$delay"
    done
    return "$rc"
}
retry 5 2 curl -fsS https://example.com/health
```

```bash
bash -n script.sh             # parse check only
bash -x script.sh --dry-run   # full trace
PS4='+ ${BASH_SOURCE}:${LINENO}: ' bash -x script.sh
{
    set -x                    # scoped trace, keeps logs readable
    deploy --env staging --dry-run
    set +x
} 2>trace.log
```

ShellCheck v0.11.0 is mandatory before committing; shfmt v3.14.x formats:

```bash
shellcheck --severity=warning --shell=bash script.sh
shellcheck -x --enable=all script.sh
shfmt --language-dialect bash --indent 4 --case-indent --diff script.sh
shfmt --language-dialect bash --indent 4 --case-indent --write script.sh
```

The four warnings you will meet weekly:

```bash
# SC2086: Double quote to prevent globbing and word splitting.
rm $file                      # BAD
rm -- "$file"                 # GOOD

# SC2046: Quote this to prevent word splitting.
cp $(find . -name '*.conf') /dest/          # BAD
mapfile -t confs < <(find . -name '*.conf')
cp -- "${confs[@]}" /dest/                  # GOOD

# SC2006: Use $(...) notation instead of legacy backticks.
msg=`date`                    # BAD
msg=$(date)                   # GOOD

# SC2181: Check exit code directly, not indirectly with $?.
mycmd
if [[ $? -ne 0 ]]; then ... fi              # BAD
if ! mycmd; then ... fi                     # GOOD
```

Wire both into editors and CI so violations fail the build, not review.

## 9. Portability, systemd, cron

Bashisms (`[[`, `((`, arrays, `&>`, `<()`, `local`) mean the file is
bash, not sh — declare it honestly:

```bash
#!/usr/bin/env bash          # bash features used — correct
shellcheck --shell=sh script.sh   # proves POSIX-clean (or finds bashisms)
```

For `sh` compatibility: no arrays (use `"$@"`), no `[[` (quote inside
`[`), no `&>` (use `>f 2>&1`), no `source` (use `.`), no `<()` (use
temp files plus trap).

systemd `ExecStart=` is not a shell: no pipes, redirects, or `$VAR`
expansion. These fail:

```ini
# WRONG — pipe/redirect passed as literal arguments.
ExecStart=myapp --flag > /var/log/myapp.log 2>&1
```

```ini
# Preferred: binary with arguments, no shell at all.
ExecStart=/usr/bin/myapp --config /etc/myapp/config.toml
# Shell wrapper only when shell features are genuinely needed.
ExecStart=/usr/bin/bash -c 'exec /usr/bin/myapp --config /etc/myapp/config.toml'
ExecStart=/usr/bin/bash /usr/local/bin/myapp-helper.sh
```

```bash
# /usr/local/bin/myapp-helper.sh — logic systemd must not inline.
#!/usr/bin/env bash
set -euo pipefail
exec /usr/bin/myapp --config /etc/myapp/config.toml >>/var/log/myapp.log 2>&1
```

Validate with `systemd-analyze verify myapp.service`.

Cron has a minimal environment (`PATH=/usr/bin:/bin`, `%` means newline).
On Arch prefer systemd user timers (see the **systemd** skill):

```bash
export PATH=/usr/bin:/bin:/usr/local/bin  # cron-safe scripts set PATH
exec 9>/run/user/$(id -u)/myjob.lock; flock -n 9 || exit 0
```

```ini
# myjob.timer — preferred over cron on Arch.
[Unit]
Description=Run myjob every 15 minutes
[Timer]
OnCalendar=*:0/15
Persistent=true
[Install]
WantedBy=timers.target
```

## 10. Copy-paste examples

Robust script template with arg parsing and logging:

```bash
#!/usr/bin/env bash
# backup-dots — rsync dotfiles to a backup dir.
# Usage: backup-dots [--dest DIR] [--dry-run]
set -euo pipefail
IFS=$'\n\t'

readonly PROG=${0##*/}
log() { printf '[%s] %s\n' "$PROG" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

DEST=$HOME/backups/dots
DRY_RUN=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --dest) DEST=${2:?--dest needs a value}; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) sed -n '2,4p' "$0"; exit 0 ;;
        --) shift; break ;;
        -*) die "unknown flag: $1" ;;
        *) break ;;
    esac
done

[[ $DRY_RUN -eq 1 ]] && RSYNC_ARGS=(--dry-run) || RSYNC_ARGS=()
have rsync || die "rsync not installed"
rsync -a --delete "${RSYNC_ARGS[@]}" "$HOME/.config/fish/" "$DEST/fish/"
log "backup complete -> $DEST"
```

Logging helpers with tempdir trap and backoff retry:

```bash
VERBOSE=${VERBOSE:-0}
debug() { [[ $VERBOSE -eq 1 ]] && printf '[DEBUG] %s\n' "$*" >&2 || true; }

WORKDIR=$(mktemp -d -t mytool.XXXXXX)
trap 'rm -rf -- "$WORKDIR"' EXIT
trap 'die "interrupted" 130' INT TERM

retry_backoff() { # retry_backoff <tries> <delay> <cmd...>
    local tries=$1 delay=$2; shift 2
    local i rc=0
    for ((i = 1; i <= tries; i++)); do
        if "$@"; then return 0; else rc=$?; fi
        ((i < tries)) || break
        sleep "$delay"; delay=$((delay * 2))
    done
    return "$rc"
}
retry_backoff 5 1 curl -fsS -o /tmp/release.json https://api.example.com/release
```

Run `shellcheck` and `shfmt --diff` on every new script; both must be
silent before commit.

---
name: fish
description: >
  Expert knowledge for the fish shell (friendly interactive shell), covering
  interactive setup and scripting on Arch Linux. REQUIRED when editing
  config.fish, conf.d/, functions/, completions/, abbreviations, key bindings,
  prompts, or any *.fish script. Grounded in fish 4.x (Rust rewrite) behavior.
  Covers config layout, set scopes, lists, conditionals, loops, functions with
  argparse, string builtin, command substitution, pipes and $pipestatus, test,
  math, completions, fisher plugins, tide/starship prompts, and POSIX
  incompatibility troubleshooting. Triggers: fish, fishshell, config.fish,
  conf.d, fish_add_path, fish_config, abbr, fisher, tide, starship,
  fish_vi_key_bindings, universal variable, *.fish.
---

# Fish Shell Skill

Expert agent for the **fish shell** on Arch Linux. This machine uses
**fish 4.9.3 as the interactive login shell** and **bash 5.3.15** at
`/usr/bin/bash` for system scripting (see the **bash** skill). Fish is
intentionally **not POSIX compatible**: prefer fish for interactive use and
fish-native scripts, bash/sh for portable scripts and system units.

## 0. Primary references

Upstream docs (canonical for installed 4.x):

- **fish docs (current)**: <https://fishshell.com/docs/current/>
- **Tutorial**: <https://fishshell.com/docs/current/tutorial.html>
- **Language reference**: <https://fishshell.com/docs/current/language.html>
- **Commands (builtins)**: <https://fishshell.com/docs/current/cmds/index.html>
- **FAQ**: <https://fishshell.com/docs/current/faq.html>
- **Release notes (4.x)**: <https://fishshell.com/docs/current/relnotes.html>
- **fish on GitHub**: <https://github.com/fish-shell/fish-shell>

Arch and ecosystem:

- **ArchWiki fish**: <https://wiki.archlinux.org/title/Fish>
- **fisher (plugin manager)**: <https://github.com/jorgebucaran/fisher>
- **tide prompt**: <https://github.com/IlanCosman/tide>
- **starship prompt**: <https://starship.rs/>
- **direnv**: <https://direnv.net/>

Local references on this machine:

```fish
fish --version          # expect 4.x (Rust build); here 4.9.3
help                    # local HTML docs for the installed version
man fish-language       # language reference as a man page
fish_config             # web UI for prompt, theme, bindings, abbreviations
```

## 1. Version and runtime facts (September 2026)

Fish **4.0.0** (February 2025) rewrote the core from C++ in **Rust**.
Latest in the 4.x series is **4.9.x** (4.9 released September 2026 with
faster tab completion around slow symlinks and pager descriptions for
abbreviations). Language behavior is unchanged by the rewrite; builds now
need a Rust toolchain (MSRV 1.85 as of 4.6+) and no C++ compiler.

```fish
echo $version            # e.g. 4.9.3
status --is-interactive; and echo interactive; or echo script
status --is-login; and echo login
status filename          # file of the running script/function
which fish               # /usr/bin/fish on Arch
echo $SHELL              # /usr/bin/fish for this user
```

## 2. Interactive setup and config layout

Config lives under `~/.config/fish/`. Fish auto-sources `conf.d/*.fish`
and lazily autoloads `functions/*.fish` by function name.

```fish
~/.config/fish/
├── config.fish          # main file; keep small
├── conf.d/              # *.fish auto-sourced at startup
├── functions/           # one function per file, lazy-loaded
├── completions/         # custom completions, one file per command
└── fish_variables       # universal variable store (do not hand-edit)
```

```fish
# ~/.config/fish/config.fish — keep interactive-only things guarded.
if status is-interactive
    set -g fish_greeting
    fish_vi_key_bindings  # or fish_default_key_bindings
end
```

```fish
# conf.d/00-env.fish — environment, PATH, editors.
fish_add_path -g ~/.local/bin ~/.cargo/bin ~/go/bin
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
```

`fish_add_path` prepends, dedupes, and by default persists to universal
`$fish_user_paths`. Pass `-g` for a session-only entry.

### 2.1 Abbreviations vs aliases vs functions

Prefer abbreviations first, functions second, aliases last.

```fish
# Abbreviations expand inline on space/enter. Visible and editable.
abbr -a gs 'git status -sb'
abbr -a gco 'git checkout'
abbr -a ... '../..'
abbr --show
abbr -e gs                # erase one

# Aliases are thin function wrappers. Fine for static commands.
alias ll 'ls -lh --group-directories-first'
alias grep 'grep --color=auto'

# Functions for anything with logic or arguments.
# Save as ~/.config/fish/functions/<name>.fish for autoloading.
function mkcd -d "Create a directory and cd into it"
    mkdir -p $argv; and cd $argv[-1]
end
```

```fish
type -a ll
functions ll              # show body
```

### 2.2 Plugin managers and prompts

```fish
# One-time fisher install (interactive):
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher
fisher install jethrokuan/z franciscolourenco/done
fisher list; and fisher update
```

Use exactly one prompt, not both:

```fish
# Option A: tide (native fish prompt).
fisher install IlanCosman/tide:latest
tide configure

# Option B: starship (cross-shell, in conf.d/20-tools.fish):
starship init fish | source
```

Starship config at `~/.config/starship.toml` is shared with bash. Tide
config lives in universal variables; rerun `tide configure` after major
fish upgrades.

### 2.3 Key bindings

```fish
fish_vi_key_bindings       # vi-style modal editing
# fish_default_key_bindings  # emacs-style (the default)
# fish_hybrid_key_bindings   # emacs insert + vi normal on Escape

bind --mode insert \cf accept-autosuggestion
bind | grep autosuggestion
bind --key-names           # key names for your terminal
fish_key_reader            # prints escape sequence + key name to bind
```

In fish 4.x `fish_user_key_bindings` is legacy; put `bind` commands in
`conf.d/` so they apply after the mode is set. The vi indicator comes from
`fish_mode_prompt`; starship hides it unless its `character` vi-mode symbol
is enabled.

## 3. Scripting essentials

Every script starts with the fish shebang and assumes no POSIX features
(`$()`, backticks, `&&`, `||`, `[[`, `$1`, `export` do not exist here).

```fish
#!/usr/bin/env fish
# mytool.fish — one-line purpose here.
```

### 3.1 Variables and scopes

```fish
set name "ada"              # block-local by default
set -f helper "tmp"         # function-scoped
set -g app_dir ~/.local/share/myapp
set -gx EDITOR nvim         # global + exported to children
set -U my_pref "value"      # universal: persisted across restarts
set -l count 1              # explicit local in functions/blocks
set -a mylist newitem       # append (-p prepends)
set -e old_var              # erase
set -S EDITOR               # show scope (debug scoping bugs)
set --show fish_user_paths  # scopes searched, in order
```

Rules that bite newcomers:

- `set -U` persists to `fish_variables`. Use it for preferences only,
  never for loop temporaries: concurrent shells merge them.
- `set -x` without `-g` in a function exports only there. Real
  environment variables need `set -gx`.
- No `VAR=value cmd` prefix syntax. Use `env` or a block:

```fish
env FOO=bar mycmd --flag
begin
    set -lx FOO bar
    mycmd --flag
end
```

### 3.2 Lists

Everything is a list; indexing starts at 1.

```fish
set fruits apple banana cherry
echo $fruits                # apple banana cherry
echo $fruits[1]             # apple
echo $fruits[-1]            # cherry
echo $fruits[2..-1]         # banana cherry
count $fruits               # 3

for f in $fruits
    echo "fruit: $f"
end

set -a fruits date
contains -- banana $fruits; and echo yes
```

Fish never word-splits. Quotes control expansion, not splitting:

```fish
set q "a b"
count $q                    # 1 — one element with a space
printf '%s\n' $q            # one line: a b
echo "$HOME/bin"            # double quotes: $VAR expands
echo '$HOME/bin'            # literal $HOME/bin
```

### 3.3 Conditionals, switches, loops

```fish
if test -f ~/.config/fish/config.fish
    echo "config present"
else if test -d ~/.config/fish/conf.d
    echo "conf.d only"
else
    echo "no config" >&2
    exit 1
end

# `and` / `or` replace POSIX && and ||.
command -q rg; and set -g HAVE_RG 1; or set -g HAVE_RG 0

switch $argv[1]
    case -h --help help
        mytool_help
    case '-*'
        echo "unknown flag: $argv[1]" >&2; return 2
    case '*'
        mytool_run $argv
end

for i in (seq 1 5)
    echo "iteration $i"
end

while not test -S /tmp/my.sock
    sleep 0.2
end

if string match -qr '^[0-9a-f]{7,40}$' $argv[1]
    echo "looks like a git sha"
end
```

`test` (aka `[`) is the portable conditional; `string match` covers
glob/regex checks.

### 3.4 Functions and argument parsing

```fish
function deploy -d "Deploy the current project"
    argparse -n deploy 'h/help' 'e/env=' 'dry-run' -- $argv
    or return 1

    if set -ql _flag_help
        echo "usage: deploy [--env NAME] [--dry-run]"
        return 0
    end

    set -l env (set -q _flag_env; and echo $_flag_env; or echo staging)
    echo "deploying to $env"
end
```

- `$argv` is the argument list: `$argv[1]`, `$argv`, `(count $argv)`.
  There is no `$1`, `$@`, or `$#`.
- `argparse` fills `$_flag_<name>`; always follow with `or return 1`.
- `return <n>` exits the function; `exit <n>` exits the whole shell.
- Event hooks for reactive config:

```fish
function on_pwd_change --on-variable PWD
    status --is-command-substitution; and return
end
```

### 3.5 Strings, math, command substitution, pipes

```fish
string join / foo bar baz
string split . archive.tar.gz
string replace -r '\.tar\.gz$' '' archive.tar.gz
string upper $hostname
string trim --chars=/ /etc/fstab/

math 2 + 3
math -s0 '1024 * 1024 * 5 / 100'
set -l pct (math -s1 "$done / $total * 100")

# Command substitution is always ( ... ), never $() or backticks.
set -l today (date +%F)
command -q git; and set -l branch (git branch --show-current 2>/dev/null)

# Pipes pass stdout; $pipestatus holds every stage's exit code.
cat /var/log/pacman.log | string match '*upgraded*' | tail -n 5
echo "stages: $pipestatus"       # e.g. 0 0 0
somecmd | string collect > /tmp/out.txt
```

```fish
false
echo $status                 # 1 — last foreground job only
true | false
echo $status                 # 1 (last stage)
echo $pipestatus             # 0 1 (all stages)
```

## 4. Config examples

`conf.d/10-aliases.fish`:

```fish
abbr -a g 'git'
abbr -a gs 'git status -sb'
abbr -a gd 'git diff'
abbr -a gl 'git log --oneline -10'
alias ls 'ls --color=auto'
alias ll 'ls -lh --group-directories-first'
```

`conf.d/20-tools.fish`:

```fish
command -q direnv; and direnv hook fish | source
command -q zoxide; and zoxide init fish | source

# Reuse one ssh-agent per login, never one per shell.
if status is-login; and not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) >/dev/null
end

# Guard slow init so non-interactive shells stay fast.
if not status is-interactive
    exit
end
command -q starship; and starship init fish | source
```

Custom completion `completions/mytool.fish`:

```fish
complete -c mytool -f
complete -c mytool -s h -l help -d 'Show help'
complete -c mytool -s e -l env -rf -d 'Target environment'
complete -c mytool -n __fish_use_subcommand -a deploy -d 'Deploy project'
complete -c mytool -n __fish_use_subcommand -a rollback -d 'Roll back'
complete -c mytool -n '__fish_seen_subcommand_from deploy' -a 'staging prod'
```

## 5. Troubleshooting

### 5.1 POSIX translation table

| POSIX / bash            | fish equivalent                      |
|-------------------------|--------------------------------------|
| `cmd1 && cmd2`          | `cmd1; and cmd2`                     |
| `cmd1 \|\| cmd2`        | `cmd1; or cmd2`                      |
| `! cmd`                 | `not cmd`                            |
| `VAR=value cmd`         | `env VAR=value cmd`                  |
| `export FOO=bar`        | `set -gx FOO bar`                    |
| `$(cmd)` / backticks    | `(cmd)`                              |
| `$1`, `$@`, `$#`        | `$argv[1]`, `$argv`, `(count $argv)` |
| `$?`                    | `$status` / `$pipestatus`            |
| `$((1 + 2))`            | `(math 1 + 2)`                       |

```fish
make && sudo make install
# fish: Unsupported use of '&&'. In fish, please use 'COMMAND; and COMMAND'.
make; and sudo make install
```

### 5.2 Variables that "do not expand" and universal-var repairs

- No word splitting: if `$VAR` looks empty it is unset or mis-scoped.
  Check with `set --show VAR`.
- Braces expand as cartesian products: `echo {a,b}.fish` is two words.
  Quote to suppress: `echo '{a,b}.fish'`.
- `~` expands only at word start; `"~/quoted"` never expands, use `$HOME`.
- Run bash snippets explicitly instead of pasting bash syntax into fish:

```fish
set --show MYVAR
printf '%s\n' $MYVAR         # one line per element
bash -c 'set -o pipefail; curl -sL https://example.com/x | tar -xz'
bash ./legacy-posix-script.sh arg1 arg2
```

```fish
set -U --show                # dump universal vars
set -Ue BAD_VAR              # erase a stale one everywhere
fish_add_path -g ~/bin       # session-only (not persisted)
fish_add_path ~/bin          # persisted (universal fish_user_paths)
```

### 5.3 Debugging checklist

```fish
fish --no-config -c 'source my-script.fish; my-function --help'
fish --private -c '...'      # no config, no history, no universal vars
fish -n my-script.fish       # parse check only (no execution)
fish --profile /tmp/fish.prof -ic 'exit'
sort -nk2 /tmp/fish.prof | tail
```

Read `$status` immediately after the command; even `echo` overwrites it.
Replace `export` with `set -gx`, `$?` with `$status`, `[[` with `test` or
`string match`, and backticks with `( )`. Keep secrets out of universal
vars and out of dotfiles repos.

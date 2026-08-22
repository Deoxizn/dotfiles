# --- Environment & Cache Setup ---
# Set the cache to RAM and ensure it exists silently before aliases load
set -gx XDG_CACHE_HOME /tmp/$USER-cache
if not test -d "$XDG_CACHE_HOME/fish/generated_completions"
    command mkdir -p "$XDG_CACHE_HOME/fish/generated_completions"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias fz="fzf --preview 'bat --style=numbers --color=always {}'"
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System & Tool Aliases
alias nfs='sudo mount -a'
alias svr='foot ssh deoxizn@192.168.8.209'
alias kids='foot ssh clug@192.168.8.231'
alias psync='docker compose run --rm plextraktsync sync'
alias omup='omarchy-update'
alias ga='git add .'
alias gp='git push'
alias gpl='git pull'
alias clr='clear'
alias snprl='sudo snapper list'
alias snprd='sudo snapper delete'
alias ff='fastfetch'
alias c='opencode'
alias d='docker'
alias r='rails'
alias sptx='bash (curl -sSL https://spotx-official.github.io/run.sh | psub)'

function gc
    git commit -m "$argv"
end

# Clean orphans
function co
    set orphans (pacman -Qdtq)
    if test -n "$orphans"
        echo "$orphans" | sudo pacman -Rns -
    else
        echo "No orphans to remove."
    end
end

# Init Key Tools
set -gx STARSHIP_CONFIG $HOME/.config/starship.toml
zoxide init fish | source
starship init fish | source

# General Settings
set -U fish_greeting
set -gx ZED_ALLOW_ROOT true
alias zroot='sudo -E zeditor'
alias mkdir='mkdir -pv'
alias path='readlink -e'
alias rmm='rm -rvI'
alias cpp='cp -R'
alias cp='cp -i'
alias mv='mv -i'
alias add-to-path='set -U fish_user_paths (pwd) $fish_user_paths'
alias path-update='set -gx PATH (bash -c "source ~/Work/stuff/config/path; echo \$PATH")'

# System Monitoring
alias df='df -h'
alias du='du -ch'
alias free='free -m'
alias fs='df -h -x squashfs -x tmpfs -x devtmpfs'
alias disks='lsblk -o HOTPLUG,NAME,SIZE,MODEL,TYPE | awk "NR == 1 || /disk/"'
alias partitions='lsblk -o HOTPLUG,NAME,LABEL,MOUNTPOINT,SIZE,MODEL,PARTLABEL,TYPE,UUID | grep -v loop | cut -c1-$COLUMNS'
alias sizeof="du -hs"

# Networking & Utilities
alias connect=nmtui
alias lockblock='killall xautolock; xset s off; xset -dpms; echo ok'
alias wget='wget --content-disposition'
alias unset='set --erase'

function ll --description "Scroll ll if there are more files than fit on screen"
  ls -l $argv --color=always | less -R -X -F
end

function mkcd --description "Create and cd to directory"
  command mkdir -p $argv
  and cd $argv
end

function copy --description "Copy pipe or argument (wl-copy)"
  if [ "$argv" = "" ]
    wl-copy
  else
    printf "$argv" | wl-copy
  end
end

function copypath --description "Copy full file path"
  readlink -e $argv | wl-copy
  echo "copied to clipboard"
end

function color --description "Print color"
  echo (set_color (string trim -c '#' "$argv"))"██"
end

function run --description "Make file executable, then run it"
  chmod +x "$argv"
  eval "./$argv"
end

function launch --description "Launch GUI program"
  eval "$argv >/dev/null 2>&1 &" & disown
end

function open --description "Open file by default application"
  env XDG_CURRENT_DESKTOP=X-Generic xdg-open $argv >/dev/null 2>&1 & disown
end

function b --description "Exec command in bash"
  bash -c "$argv"
end

function m --description "Math using Python"
  python -c "print($argv)"
end

if type -q nicl
  alias cal="nicl -w3 -f ~/Work/stuff/documents/bank_days.csv"
else
  alias cal="ncal -bM3"
end

if type -q sssh2
  alias ssh=sssh2
end

if type -q plug
  alias unplug='plug -u'
  alias plug='cd (command plug)'
end

function qr --description "Prints QR as unicode blocks (works in foot)"
  if [ "$argv" = "" ]
    qrencode -t ANSIUTF8
  else
    printf "%s" "$argv" | qrencode -t ANSIUTF8
  end
end

alias sharewifi='qr "WIFI:T:WPA;S:aaa;P:bbb;;"'

function lockblock --description "Toggle idle locking (hypridle)"
  if pgrep -x hypridle >/dev/null
    pkill -x hypridle
    echo "idle locking blocked"
  else
    setsid hypridle >/dev/null 2>&1 &
    echo "idle locking active"
  end
end

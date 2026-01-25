# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc


# alias
alias nfs='sudo mount -a'
alias svr='ssh deoxizn@192.168.8.209'
alias psync='docker compose run --rm plextraktsync sync'
alias omup='omarchy-update'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias co='cleanorphans'
alias clr='clear'
alias snprl='sudo snapper list'
alias snprd='sudo snapper delete'
alias ff='fastfetch'


# Settings for history control and spelling correction
HISTCONTROL=ignoreboth
shopt -s cdspell

# Function to clean up history: trim trailing spaces, remove duplicates, respect HISTIGNORE
function history_cleanup {
  local HISTFILE_SRC=~/.bash_history
  local HISTFILE_DST=/tmp/.$USER.bash_history.clean
  if [ -f "$HISTFILE_SRC" ]; then
    history -a                    # Append current session's history
    cp "$HISTFILE_SRC" "$HISTFILE_SRC.backup"
    sed -i 's/ *$//' "$HISTFILE_SRC"  # Trim trailing whitespace
    awk '!a[$0]++' "$HISTFILE_SRC" | grep -vxFf <(echo "$HISTIGNORE" | sed 's/:/\\|/g; s/*/.\*/g') > "$HISTFILE_DST"
    mv "$HISTFILE_DST" "$HISTFILE_SRC"
    chmod go-r "$HISTFILE_SRC"
    history -c                    # Clear in-memory history
    history -r                    # Reload cleaned history
  fi
}

# Automatically run cleanup when shell exits
trap 'history_cleanup' EXIT


#cleanup
cleanorphans() {
    local ORPHANS=$(pacman -Qtdq)
    [ -n "$ORPHANS" ] && sudo pacman - Rns "$ORPHANS" || echo "no orphaned packages."
}


#path
export PATH="$HOME/.local/bin:$PATH"
export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
export CARGO_BUILD_JOBS=$(nproc)
export GOMAXPROCS=$(nproc)
export DOTNET_MSBUILD_CLI_OPTIONS="-m:$(nproc)"

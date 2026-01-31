if status is-interactive
# Commands to run in interactive sessions can go here
end

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Directories
alias ..='cd ..'
alias ...='cd ../..'

# alias
alias nfs='sudo mount -a'
alias svr='ssh deoxizn@192.168.8.209'
alias psync='docker compose run --rm plextraktsync sync'
alias omup='omarchy-update'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias co='cleanorphans'
alias clr='clear'
alias snprl='sudo snapper list'
alias snprd='sudo snapper delete'
alias ff='fastfetch'

#key tools
zoxide init fish | source
starship init fish | source

#disable greeting
set -U fish_greeting

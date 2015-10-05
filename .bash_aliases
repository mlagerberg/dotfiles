# start tmux 
#if command -v tmux>/dev/null; then
#  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
#fi

# Navigation shortcuts
alias sn='sudo nano'
alias ..='cd ..'
alias cd..='cd ..'
alias cddocs='cd /media/hdd/bitsync/Docs'
alias cdmedia='cd /media/hdd'
alias la='ls -la'

# scripts
alias status='/home/pi/scripts/status.sh'
alias btc='python ~/scripts/btc.py'
alias isrunning='/home/pi/scripts/services.sh isrunning'
alias chess='/home/pi/bitchess/chess'
alias tmuxhelp='less ~/dotfiles/dotfiles/tmux.txt'

# nano
#alias nano='nano --smooth --autoindent --const'
alias nano='nano --autoindent --const'

# statements I can't remember
alias users='cat /etc/passwd | grep "/home" |cut -d: -f1'
alias size='du -sh'
alias network='iftop -nNP'
alias memory='ps aux --sort -rss | head'
alias path='echo -e ${PATH//:/\\n}'

# for when I switch between BATCH and BASH and get confused:
alias edit='nano'
alias cls='clear'


# perform 'ls' after 'cd' if successful.
cdls() {
  builtin cd "$*"
  RESULT=$?
  if [ "$RESULT" -eq 0 ]; then
    ls
  fi
}
mkdircd() {
  mkdir -p "$@" && eval cd "\"\$$#\"";
}

# And finally, attach to tmux
# (tmux config makes sure a new session is created if none exist)
tmux attach

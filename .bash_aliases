# Navigation shortcuts
alias sn='sudo nano'
alias ..='cd ..'
alias cddocs='cd /media/hdd/bitsync/Docs'
alias cdmedia='cd /media/hdd'

# scripts
alias status='/home/pi/scripts/status.sh'
alias btc='python ~/scripts/btc.py'
alias isrunning='/home/pi/scripts/services.sh isrunning'

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

# Navigation shortcuts
alias sn='sudo nano'
alias ..='cd ..'
alias cd..='cd ..'
alias la='ls -la'

# nano
#alias nano='nano --smooth --autoindent --const'
alias nano='nano --autoindent --const'
alias nanon='nano --const'

# statements I can't remember
alias users='cat /etc/passwd | grep "/home" |cut -d: -f1'
alias size='du -sh'
alias network='iftop -nNP'
alias memory='ps aux --sort -rss | head'

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

# Execute ADB command on all connected devices
adbplus() {
  DEVICES=`adb devices | grep -v devices | grep device | cut -f 1`
  for device in $DEVICES; do
    echo "$device $@ ..."
    adb -s $device $@
  done
}

#. .bash_aliases_pi


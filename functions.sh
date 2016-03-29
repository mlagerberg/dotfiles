#!/bin/bash
#/home/pi/scripts/functions.sh

function pause(){
   read -p "$*"
}

# Output pretty colors
function blue	{
	echo -e "\e[1;34m$1\e[0m"
}
function green	{
	echo -e "\e[0;32m$1\e[0m"
}
function yellow	{
	echo -e "\e[1;33m$1\e[0m"
}
function lred	{
	echo -e "\e[1;31m$1\e[0m"
}
function red	{
	echo -e "\e[0;31m$1\e[0m"
}


# Usage: echo "Een ${fcyellow}twee${fcreset} drie"
fcreset=$(tput sgr0)    # reset foreground color
fcdark=$(tput bold; tput setaf 0)
fcred=$(tput setaf 1)
fcgreen=$(tput setaf 2)
fcyellow=$(tput setaf 3)
fcdblue=$(tput setaf 4)
fcblue=$(tput bold; tput setaf 4)
fcpink=$(tput setaf 5)
fclblue=$(tput setaf 6)


bold=$(tput bold)
dim=$(tput dim)
underline=$(tput smul)
emph=$(tput smso)  # Stand-out mode (bold)
xemph=$(tput rmso) # Exit stand-out mode

# Pretend the terminal is like Android LogCat
function debug  {
	blue "$1"
}
function error  {
	red "$1"
}
function info   {
	green "$1"
}
function warn   {
	yellow "$1"
}


###
# Usage:
# is_running "display name" "processname"
#
function is_running {
        ps cax | grep $2 > /dev/null
        if [ $? -eq 0 ]; then
               # echo -e "$1: \e[1;33mOK\e[0m"
               echo "$1: ${fcgreen}OK${fcreset}."
        else
               # echo -e "$1: \e[0;31mNot running\e[0m;"
               echo "$1: ${fcred}Not running${fcreset}."
        fi
}


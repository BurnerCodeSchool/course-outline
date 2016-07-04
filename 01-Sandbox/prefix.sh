#!/usr/bin/env bash
# Usage: box $1
# Summary: write a summary for your new command
# Help:
#
# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function banner() {
  clear
  info '
               _                      _
  ___ ___   __| | ___ _ __ ___  _ __ (_)_ __
 / __/ _ \ / _  |/ _ \  __/ _ \|  _ \| |  _ \
| (_| (_) | (_| |  __/ | | (_) | | | | | | | |
 \___\___/ \__,_|\___|_|  \___/|_| |_|_|_| |_|
'
}

function get_platform() {
  if [ "$(uname -s)" == "Darwin" ]; then
    # Do something for OSX
    export NS_PLATFORM="darwin"
    running "darwin platform detected"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  	# Do something for Linux platform
  	# assume ubuntu - but surely this can be extended to include other distros
  	export NS_PLATFORM="linux"
    running "linux platform detected"
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something for Windows NT platform
  	export NS_PLATFORM="windows"
    running "windoze platform detected"
    die "Windows not supported"
  fi
  ok
}

function ok() { echo -e "$COL_GREEN[ok]$COL_RESET"; }

function bot() { echo -e "\n$COL_GREEN\[._.]/$COL_RESET - $1"; }

function running() { echo -en "$COL_YELLOW ⇒ $COL_RESET $1: "; }

function action() { echo -e "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1..."; }

function line() { echo -e "------------------------------------------------------------------------------------"; }

function info() { echo -e "$COL_GREEN $1 $COL_RESET"; }

function warn() { echo -e "$COL_YELLOW $1 $COL_RESET"; }

function error() { echo -e "$COL_RED $1 $COL_RESET "; }

function die() { echo "$@" 1>&2 ; exit 1; }

function profile_write {
  # try to ensure we don't create duplicate entries in the .coderonin file
  "$BASH" -c "touch $2"
  if ! grep -q "$1" "$2" ; then
    "$BASH" -c "echo \"$1\" >> \"$2\""
  fi
}

function sudo_write {
  # try to ensure we don't create duplicate entries in the .coderonin file
  sudo "$BASH" -c "touch $2"
  if ! grep -q "$1" "$2" ; then
    sudo "$BASH" -c "echo \"$1\" >> \"$2\""
  fi
}


















banner

get_platform

if [ "$NS_PLATFORM" == "darwin" ]; then
  echo "not meant for darwin"
fi

if [ "$NS_PLATFORM" == "linux" ]; then

  bot "PreFixing your sandbox"

  action "Allowing sudo without password"
    DEV=`whoami`
    sudo_write "$DEV ALL=(ALL) NOPASSWD: ALL" "/etc/sudoers.d/$DEV"
  ok

  action "Updating apt cache"
    sudo apt-get update > /dev/null
  ok

  action "Install DKMS"
    sudo apt-get -y install dkms > /dev/null
  ok

  action "Install GIT"
    sudo apt-get install -y git > /dev/null
  ok

fi


exit

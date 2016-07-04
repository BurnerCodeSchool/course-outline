#!/usr/bin/env bash
# Usage: box $1
# Summary: write a summary for your new command
# Help:
#
# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_GREEN=$ESC_SEQ"32;01m"

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

function info() { echo -e "$COL_GREEN $1 $COL_RESET"; }

function sudo_write {
  # try to ensure we don't create duplicate entries in the .coderonin file
  sudo "$BASH" -c "touch $2"
  if ! grep -q "$1" "$2" ; then
    sudo "$BASH" -c "echo \"$1\" >> \"$2\""
  fi
}

function prompt_name {
  echo -n "Enter your name and press [ENTER]: "
  read name
  export USER_NAME=$name
}

function prompt_email {
  echo -n "Enter your email and press [ENTER]: "
  read email
  export USER_EMAIL=$email
}

banner

get_platform

if [ "$NS_PLATFORM" == "darwin" ]; then
  echo "not meant for darwin"
fi

if [ "$NS_PLATFORM" == "linux" ]; then
  bot "PreFixing your sandbox"

  prompt_name
  prompt_email

  bot "Allowing sudo without password"
    DEV=`whoami`
    sudo_write "$DEV ALL=(ALL) NOPASSWD: ALL" "/etc/sudoers.d/$DEV"
  ok

  # bot "Install DKMS"
  #   sudo apt-get -y install dkms
  # ok

  # bot "Install VBoxLinuxAdditions"
  #   ( cd /media/$DEV/VBOXADDITIONS_5.0.20_106931/ && sudo ./VBoxLinuxAdditions.run )
  # ok

  bot "Install GIT"
    sudo apt-get install -y git
  ok

  bot "Installing .Box"
    git clone https://github.com/bhedana/.box.git $HOME/.box
  ok

  bot "Installing .Box essentials"
    $HOME/.box/bin/box essentials
  ok

  bot "Installing .Proj"
    $HOME/.box/bin/box add-proj
  ok

  # bot "Installing .Box defaults"
  #   $HOME/.box/bin/box defaults
  # ok

  bot "Installing Atom text editor"
    $HOME/.box/bin/box atom
  ok

  bot "Installing GitFlow and GIBO"
    $HOME/.box/bin/box git
  ok

  bot "Installing Git Kraken"
    $HOME/.box/bin/box gitkraken
  ok

  bot "Installing NodeJS"
    $HOME/.box/bin/box nodejs
  ok

  #bot "Installing Docker"
  #  $HOME/.box/bin/box docker
  #ok

  #bot "Installing Python"
  #  $HOME/.box/bin/box python
  #ok

  #bot "Installing Ansible"
  #  $HOME/.box/bin/box ansible
  #ok

  bot "Installing Z Shell"
    $HOME/.box/bin/box zsh
  ok

  bot "Cleaning Up"
    rm -rf Documents
    rm -rf Downloads
    rm -rf Music
    rm -rf Pictures
    rm -rf Public
    rm -rf Templates
    rm -rf Videos
    # rm -f automated_sandbox.sh

fi

exit

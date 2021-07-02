#!/bin/bash

### VARIABLES

base='zsh vim tmux htop wget'
useful='dnsutils ssh ncdu rsync ripgrep fd-find ranger fzf tldr lshw zathura feh'
python='python3 python3-pip python3-is-python'
heavy='steam spotify wine virtualbox virtualbox—ext–pack'
cybsec='nmap'

### FUNCTIONS

install_sublime () {
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  apt install apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  apt update
  apt install -y sublime-text
}

install_base () {
    echo "Installing base packages."
    sudo apt install $base
}

install_python () {
    echo "Installing Python packages."
    sudo apt install $python
}

install_useful () {
    echo "Installing useful packages (includes base)."
    sudo apt install $base $useful
    
    # Setup fd symlink
    ln -s $(which fdfind) ~/.local/bin/fd
}

install_heavy () {
    echo "Installing heavyweight packages."
    sudo apt install $heavy
}

install_cybsec () {
   echo "Installing cyber security tools."
   sudo apt install $cybsec
}

install_all () {
    echo "Installing all packages."
    install_base
    install_useful
    install_python
    install_heavy
    install_cybsec
    install_sublime
}

setup_dirs () {
    mkdir -p ~/.local/bin
    mkdir ~/opt ~/tmp
}

### MAIN

sudo apt update
sudo apt upgrade

setup_dirs

while getopts bapuhs flag
do
    case "${flag}" in
	b) install_base;;
	a) install_all;;
	p) install_python;;
	u) install_useful;;
	h) install_heavy;;
	s) install_sublime;;
    esac
done


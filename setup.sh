#!/bin/bash

### VARIABLES

base='zsh vim tmux htop wget net-tools'
useful='dnsutils ssh ncdu rsync ripgrep fd-find ranger fzf lshw zathura feh'
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

install_ohmyzsh () {
# Install oh-my-zsh plus extras
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
  git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k
}

install_rust () {
# Install Rust and additional tools
# The apt package of cargo is typically too outdated for debian systems.
# Therefore, use rustup.

    # Install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup update
    cargo install exa sd bat du-dust ytop tealdeer zoxide grex
    tldr --update
}

install_base () {
    echo "Installing base packages."
    sudo apt install $base
}

install_python () {
    echo "Installing Python packages."
    sudo apt install $python
}

install_alacritty () {
    sudo snap install alacritty --classic
    # Get fonts
    FONTDIR=$HOME/.local/share/fonts
    mkdir -p $FONTDIR
    curl --output-dir $FONTDIR -fLo "mononoki Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Mononoki/Regular/complete/mononoki-Regular%20Nerd%20Font%20Complete.ttf
    curl --output-dir $FONTDIR -fLo "mononoki Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Mononoki/Italic/complete/mononoki%20Italic%20Nerd%20Font%20Complete.ttf
    curl --output-dir $FONTDIR -fLo "mononoki Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Mononoki/Bold/complete/mononoki%20Bold%20Nerd%20Font%20Complete.ttf
}

install_useful () {
    echo "Installing useful packages (includes base)."
    sudo apt install $base $useful
    
    install_ohmyzsh
    install_rust
    

    
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
	y) install_alacritty;;
    esac
done


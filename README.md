# my-nix-env

## Overview
Shell configuration files for a consistent look and feel for all of my *nix systems across multibpel shells
Initial goal is to get nearly identical BASH and ZSH environments on Linux, OSX and FreeBSD sytems

TODO: move the following to 'version history'/'roadmap' files
* Version 1.0.x:
  * Add .zshrc file(s) that works in all OS's
  * Add .alias files for each OS and a common file for all OS's
  * Add installer and un-installer scripts
* Version 1.1.x:
  * Port ZSH to BASH

## Installation
### Download and change folder
```
cd ~
git clone https://github.com/rscameron42/my-nix-env.git

cd my-nix-env
```
### Run install
```
./install.sh
```

# Uninstallation

### Change to dotfiles folder
```
cd ~/my-nix-env
```

### Run uninstaller
```
./uninstall.sh
```

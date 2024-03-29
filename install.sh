#!/bin/bash

# Find all dot files then if the original file exists, create a backup
# Once backed up to {file}.mnebak symlink the new dotfile in place
#for file in $(find . -maxdepth 1 -name ".*" -type f  -printf "%f\n" ); do
for file in $(find . -maxdepth 1 -name ".*" -type f  | sed s/".\/"// ); do
    if [ -f ~/$file -a ! -h ~/$file ]; then
        mv -f ~/$file{,.mnebak}
    fi
    ln -sf $PWD/$file ~/$file
done


# Check if vim-addon installed, if not, install it automatically
#if hash vim-addon  2>/dev/null; then
#    echo "vim-addon (vim-scripts)  installed"
#else
#    echo "vim-addon (vim-scripts) not installed, installing"
#    sudo apt update && sudo apt -y install vim-scripts
#fi

echo "Installed"

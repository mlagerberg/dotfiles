#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR

# Creates links to the files in the repo
for file in $(ls -1a | grep "^\.[a-z][a-z\._-]\+$" ); do
  if [ "$file" == ".git" ]; then
    continue
  fi
  if [ -f "$HOME/$file" ] || [ -h "$HOME/$file" ] || [ -d "$HOME/$file" ]
  then
    echo -n "$HOME/$file already exists. do you want to overwrite? this will remove the existing file or folder. (y/n): "
    read response
    if [ "$response" == "y" ]
    then
      rm -rf $HOME/$file
      echo "Removing $HOME/$file.."
      echo "Installing $HOME/$file"
      ln -s $DIR/$file $HOME/$file
    fi
  else
    echo "Installing $HOME/$file"
    ln -s $DIR/$file $HOME/$file
  fi
done

chmod +x backup_pi.sh
chmod +x status.sh
chmod +x run_rsync.sh
chmod +x pishrink.sh

# Other convenient configurations
git config --global color.ui auto


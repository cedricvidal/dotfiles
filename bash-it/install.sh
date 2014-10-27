#!/bin/bash

# Install Missing Homebrew formulas
#
BASHIT_DIR=~/.bash_it

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f $BASHIT_DIR/bash_it.sh ]; then
  echo 'Install Bash it: https://github.com/cedricvidal/bash-it'
  exit 1
fi

function install_bashit_piece {
  piece=$1
  if [ -f $DIR/$piece ]; then
    cat $DIR/$piece | while read i; do
      if [ ! -f $BASHIT_DIR/$piece/enabled/$i.aliases.bash ]; then
        echo "Enabling bash-it $piece $i"
        ln -s $BASHIT_DIR/$piece/available/$i.aliases.bash $BASHIT_DIR/$piece/enabled/$i.aliases.bash;
      fi
    done
  fi
}

install_bashit_piece aliases
install_bashit_piece plugins
install_bashit_piece completion

source ~/.bash_profile

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
  pieces=$1
  piece=$2
  if [ -f $DIR/$pieces ]; then
    mkdir -p $BASHIT_DIR/$pieces/enabled/
    cat $DIR/$pieces | while read i; do
      if [ ! -f $BASHIT_DIR/$pieces/enabled/$i.$piece.bash ]; then
        echo "Enabling bash-it $piece $i"
        ln -s $BASHIT_DIR/$pieces/available/$i.$piece.bash $BASHIT_DIR/$pieces/enabled/$i.$piece.bash;
      fi
    done
  fi
}

install_bashit_piece aliases aliases
install_bashit_piece plugins plugin
install_bashit_piece completion completion

source ~/.bash_profile

#!/bin/bash

# Install Missing Homebrew formulas
#
BASHIT_DIR=~/.bash_it

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f $BASHIT_DIR/bash_it.sh ]; then
  echo "Installing Bash-it"
  git clone --depth=1 https://github.com/Bash-it/bash-it.git $BASHIT_DIR
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

source ~/.bash_profile

bash-it update

install_bashit_piece aliases aliases
install_bashit_piece plugins plugin
install_bashit_piece completion completion


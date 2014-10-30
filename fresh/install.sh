#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -e ~/.freshrc ]; then
	echo "Installing ~/.freshrc"
	ln -s $DIR/freshrc ~/.freshrc
fi

if [ ! -d ~/.fresh ]; then

	echo -n "Fresh not installed, install it? (Y/n): "
	read CONFIRM
	case $CONFIRM in
	  y|Y) break ;;
	  n|N) exit ;;
	  *) ;;
	esac

	echo "Installing Fresh"
	bash -c "`curl -sL get.freshshell.com`"
else
	~/.fresh/source/freshshell/fresh/bin/fresh
fi

if ! (cat ~/.bash_profile | grep "source ~/.fresh/build/shell.sh" > /dev/null); then
	echo "Adding Fresh shell to ~/.bash_profile"
	echo "source ~/.fresh/build/shell.sh" >> ~/.bash_profile
fi

command -v fresh >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
	echo "Adding fresh to path"
    source ~/.fresh/build/shell.sh
fi

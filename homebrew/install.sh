#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

command -v brew >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
    echo 'Install Homebrew: http://brew.sh/'
    exit 1
fi

updated="no"
function update {
	if [ "$updated" != "done" ]; then
		echo "Updating brew before installing new stuff"
		brew update
		brew doctor
		brew upgrade
	fi
	updated="done"
}

if [[ $(brew tap) != *cask* ]]; then
	echo "Detected missing brew cask"
	update
	brew install caskroom/cask/brew-cask
fi

# Install Missing Taps
#
brew tap > /tmp/installed
cat $DIR/taps | tr -d "\t " | cut -d "#" -f 1 | sort -u > /tmp/toinstall
TO_INSTALL=$(comm -13 /tmp/installed /tmp/toinstall)

if [ ! -z "${TO_INSTALL}" ]; then
	echo "Missing brew taps should be installed"
	update
	for TAP in ${TO_INSTALL}; do
		echo "Installing tap $TAP"
		brew tap ${TAP}
	done
else
	echo "All brew taps are already installed"
fi

# Install Missing Homebrew formulas
#
brew list > /tmp/installed
cat $DIR/formulas | tr -d "\t " | cut -d "#" -f 1 | sort -u > /tmp/toinstall
TO_INSTALL=$(comm -13 /tmp/installed /tmp/toinstall)

if [ ! -z "${TO_INSTALL}" ]; then
	echo "Missing brew formulas should be installed"
	update
	echo "Installing brew formulas ${TO_INSTALL}"
	brew install ${TO_INSTALL}
else
	echo "All brew formulas are already installed"
fi

# Install Missing Cask formulas
#
brew cask list > /tmp/installed
cat $DIR/cask-formulas | tr -d "\t " | cut -d "#" -f 1 | sort -u > /tmp/toinstall
TO_INSTALL=$(comm -13 /tmp/installed /tmp/toinstall)

if [ ! -z "${TO_INSTALL}" ]; then
	echo "Missing brew cask formulas should be installed"
	update
	echo "Installing brew cask formulas ${TO_INSTALL}"
	brew cask install ${TO_INSTALL}
else
	echo "All brew cask formulas are already installed"
fi


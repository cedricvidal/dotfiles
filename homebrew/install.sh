#!/bin/sh

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

# Install Missing Homebrew formulas
#
brew list > /tmp/installed
TO_INSTALL=$(comm -13 /tmp/installed formulas)

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
TO_INSTALL=$(comm -13 /tmp/installed cask-formulas)

if [ ! -z "${TO_INSTALL}" ]; then
	echo "Missing brew cask formulas should be installed"
	update
	echo "Installing brew cask formulas ${TO_INSTALL}"
	brew cask install ${TO_INSTALL}
else
	echo "All brew cask formulas are already installed"
fi


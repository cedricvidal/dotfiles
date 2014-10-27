#!/bin/sh

command -v brew >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
    echo 'Install Homebrew: http://brew.sh/'
    exit 1
fi

brew update
brew doctor
brew upgrade

if [[ $(brew tap) != *cask* ]]; then
	brew install caskroom/cask/brew-cask
fi

# Install Missing Homebrew formulas
#
brew list > /tmp/installed
TO_INSTALL=$(comm -13 /tmp/installed formulas)

if [ ! -z "${TO_INSTALL}" ]; then
	echo "Installing brew formulas ${TO_INSTALL}"
	brew install ${TO_INSTALL}
fi

# Install Missing Cask formulas
#
brew cask list > /tmp/installed
TO_INSTALL=$(comm -13 /tmp/installed cask-formulas)

if [ ! -z "${TO_INSTALL}" ]; then
	echo "Installing brew cask formulas ${TO_INSTALL}"
	brew cask install ${TO_INSTALL}
fi


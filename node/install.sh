#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

command -v npm >/dev/null 2>&1
if [ "$?" -ne "0" ]; then
    echo 'Install Node.js: brew install node'
    exit 1
fi

# Install Missing modules
#
find /usr/local/lib/node_modules -type d -depth 1 | sort | while read path; do basename $path; done > /tmp/installed
TO_INSTALL=$(comm -13 /tmp/installed $DIR/modules)

if [ ! -z "${TO_INSTALL}" ]; then
  echo "Updating node modules before installing new ones"
  npm update -g

  echo $TO_INSTALL | while read module; do
    echo "Installing node module $module"
    npm install -g ${module}
  done
else
  echo "All modules are already installed"
fi


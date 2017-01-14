Cédric's Dotfiles
=================

This is my take at managing dotfiles with [Fresh](http://freshshell.com/). It adds to normal fresh usage a reusable and shareable (in the team sens) way of automating the installation of [Homebrew](http://brew.sh/) formulas (with taps and cask formulas), [Node.js](http://nodejs.org/) modules and [Bash-it](https://github.com/Bash-it/bash-it) aliases, plugins and themes.

(This repository was at first inspired by [@dgageot 's dotfiles](https://github.com/dgageot/dotfiles) but has since evolved a lot and very differently from the original).

How does it work ?
---

The idea is to source lists of homebrew formulas and node modules from different places, aggregate them using [Fresh](http://freshshell.com/) and install them all at once (using installer scripts you'll find in [this](https://github.com/cedricvidal/dotfiles) repository).

This is meant for individuals working in teams which need the same sets of tools and configuration while at the same time having personnal requirements.

When somebody in your team adds a usefull tool, everybody will get it on next `fresh` run.

With this script, you can provision a new workstation (almost) without supervision.

There is no dependency graph management so if some cask formulas, brew formulas and node global modules have mutual dependencies, you might need to run `fresh` multiple times. This is to keep things simple.

Cedric

Step by step setup
---

**Install fresh**

and initialize ~/.dotfiles repository

```
# Install fresh
bash <(curl -sL get.freshshell.com)
echo "source ~/.fresh/build/shell.sh" >> ~/.bash_profile

# Create your dotfiles folder
mkdir ~/.dotfiles

# Move the default freshrc configuration file to your dotfiles folder and link back from there
mv ~/.freshrc ~/.dotfiles/freshrc
ln -s ~/.dotfiles/freshrc ~/.freshrc

# Version your folder
cd ~/.dotfiles
git init
git add .
git commit -m "Initial fresh dotfiles"
```

**Enable installers**

Installers are script which manage the installation of specific types of artifacts such as homebrew formulas, node modules or OSX defaults.

You can either enable [all of them](installers/) (it doesn't hurt as it will only install supporting tools such as brew, node.js and bash-it).

```
fresh cedricvidal/dotfiles installers/fresh-install-\* --bin
```

NB: For each fresh command, you'll need to hit `y` when asked whether to add the line to your `freshrc` file.

You can also enable only [specific installers](installers/) like this

```
fresh cedricvidal/dotfiles installers/fresh-install-homebrew --bin
```

**Mandatory**: Activate the `fresh_after_build` fresh callback which will call the installers after fresh has finished collecting and building dotfiles

```
cat << EOF >> ~/.dotfiles/freshrc
fresh_after_build() {
	# Run all sourced installers
	fresh install-all
}
EOF
```

**Homebrew formulas**

You can source someone else's homebrew formulas ([mine are here](homebrew/) `cedricvidal/dotfiles`), cask formulas or taps with the following commands

```
fresh cedricvidal/dotfiles homebrew/formulas --file=$FRESH_PATH/installers/homebrew/formulas
fresh cedricvidal/dotfiles homebrew/cask-formulas --file=$FRESH_PATH/installers/homebrew/cask-formulas
fresh cedricvidal/dotfiles homebrew/taps --file=$FRESH_PATH/installers/homebrew/taps
```

But you are encouraged to create your own homebrew formulas file (what's the point of all this if you don't ;) ) and load them all

```
mkdir -p ~/.dotfiles/homebrew/
echo "most # If less is more than more, most is more than less" >> ~/.dotfiles/homebrew/formulas
fresh homebrew/formulas\* --file=$FRESH_PATH/installers/homebrew/formulas
```

NB: The wildcard allows you to split your homebrew formulas into multiple files by category of usage and source them all at once. This is encouraged to allow easier reuse by others. You can have a look at [mine](homebrew/) to see how it can be done.

NB: if you want to share your dotfiles between OSX and non OSX environments, you might want to embed your OSX specific fresh calls into a darwin check like this:

```
if [[ "$OSTYPE" == "darwin"* ]]; then
  fresh ...
fi
```

**Running fresh**

At this point, you can already run `fresh` to see the magic happen

```
fresh
```

This will checkout my `cedricvidal/dotfiles` repository into a hidden `fresh` directory and launch the installer scripts from there. The homebrew installer will install homebrew then install the formulas you sourced from my repository as well as the formulas you sourced from your own repository. All formulas will be merged and installed at once.

**Homebrew taps**

You can add additional homebrew taps

```
mkdir -p ~/.dotfiles/homebrew/
echo "homebrew/science # Science tools" >> ~/.dotfiles/homebrew/taps
fresh homebrew/taps --file=$FRESH_PATH/installers/homebrew/taps
```

To managed homebrew cask formulas, simply repeat the previous steps by replacing the formulas filename by cask-formulas.

**Bash-it**

First, bash-it requires some shell configuration, a good practice is to create a `shell` directory and to load all shell scripts from there

```
mkdir -p ~/.dotfiles/shell/
fresh shell/\*.sh
```

You can then start with this base bash-it configuration in which you can for example change the theme:

```
cat << EOF >> ~/.dotfiles/shell/bash_it.sh
# Path to the bash it configuration
export BASH_IT=~/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source ~/.bash_it/bash_it.sh
EOF
```

You can also configure `Bash-it` aliases

```
mkdir -p ~/.dotfiles/bash-it/
echo "osx" >> ~/.dotfiles/bash-it/aliases
fresh bash-it/aliases\* --file=$FRESH_PATH/installers/bash-it/aliases
```

You can also configure `Bash-it` plugins

```
mkdir -p ~/.dotfiles/bash-it/
echo "java" >> ~/.dotfiles/bash-it/plugins
fresh bash-it/plugins\* --file=$FRESH_PATH/installers/bash-it/plugins
```

**Brew completions**

You can source [my brew completion loading script](shell/completions/brew.sh) directly

```
fresh cedricvidal/dotfiles shell/completions/brew.sh
```

**Node global modules**

You can source my global modules listings

```
fresh cedricvidal/dotfiles node/modules\* --file=$FRESH_PATH/installers/node/modules
```

But you are encouraged to create your own Node global modules file (what's the point of all this if you don't ;) )

```
mkdir -p ~/.dotfiles/node/
echo "bower # Browser package manager" >> ~/.dotfiles/node/modules
fresh node/modules --file=$FRESH_PATH/installers/node/modules
```

Reproducing your setup on a different machine
---

Assuming you have pushed your newly created dotfiles repository to your github account as `yourname/dotfiles`, you can reinstall everything on a different machine with the following one-liner:

```
FRESH_LOCAL_SOURCE=yourname/dotfiles bash <(curl -sL get.freshshell.com)
```

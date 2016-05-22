Cédric's Dotfiles
=================

Inspired by [@dgageot 's dotfiles](https://github.com/dgageot/dotfiles) but managed by [Fresh](http://freshshell.com/) and focusing on automating the installation of [Homebrew](http://brew.sh/) formulas (with taps and cask formulas), [Node.js](http://nodejs.org/) modules and a [slightly forked bash-it](https://github.com/cedricvidal/bash-it).

Installation
---

```
FRESH_LOCAL_SOURCE=cedricvidal/dotfiles bash <(curl -sL get.freshshell.com)
```

About
---

The idea is to source lists of homebrew formulas and node modules from different places, aggregate them and install them all at once (only if not already installed). Formulas are never removed.

Cedric

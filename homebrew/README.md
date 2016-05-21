Directory layout
---

| File  | Usage  |
|---|---|
| `taps*`  | Install all taps listed using the `brew tap` command  |
| `formulas*`  | Install all formulas listed using the `brew install` command  |
| `cask-formulas*`  | Install all cask formulas listed using the `brew cask install` command  |

Each line contains a formula (or cask or tap) to be installed and can be commented after the `#` symbol. All caracters following the `#` are ignored.


Following files are meant to be freshed using the following fresh commands:

```
fresh homebrew/formulas\* --file=~/.brewinstall/formulas
fresh homebrew/cask-formulas\* --file=~/.brewinstall/cask-formulas
fresh homebrew/taps\* --file=~/.brewinstall/taps
```


When running the `fresh` command, the files will be concatenated into the `.brewinstall` directory.

When running the `install.sh`, it checks from the `.brewinstall` directory what formulas, cask formulas and taps need to be installed and installs them.

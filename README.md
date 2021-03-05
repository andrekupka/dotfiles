# dotfiles

A collection of my personal dotfiles.

## Installation

Clones this repository to `$HOME/.dotfiles` and creates symlinks for all files under `base` in `$HOME`.
If a dotfile already exists you can decide whether to overwrite it or not.

```bash
wget https://raw.githubusercontent.com/andrekupka/dotfiles/master/install.sh \
    && chmod +x install.sh \
    &&./install.sh
```

If you want to overwrite all files for sure, just use the following command.

```bash
curl https://raw.githubusercontent.com/andrekupka/dotfiles/master/install.sh | base -s -- -y
```

#!/bin/bash

link_file() {
    local name=$(basename '$1')
    local target="$HOME/.$(basename '$1')"

    echo "Linking $1 to $target..."

    if [[ ! -f $target ]]; then
        ln -s "$1" "$target"
        echo "Linked $1 to $target."
    fi


}

echo "Clone dotfiles."
git clone git@github.com:andrekupka/dotfiles $HOME/.dotfiles

for i in $(ls -d "$HOME/.dotfiles/dotfiles/*"); do
    link_file "$i"
done

echo "Setup finished"

# vim: set et ts=4 sw=4:

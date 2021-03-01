#!/bin/bash

DOTFILES_PATH=$HOME/.dotfiles

link() {
    ln -s "$1" "$2"
    echo "  -> Linked $1 to $2."
}

ask_link() {
    read -p "$2 already exists. Replace with link to $1? [y|N]" choice
    case "$choice" in
    y|Y)
        rm $2
        link $1 $2
        ;;
    *)
        echo "Skipping $2"
        ;;
    esac
}

link_file() {
    local name=$(basename $1)
    local target="$HOME/.$(basename $1)"

    if [[ -f $target ]]; then
        ask_link $1 $target
    else
        link $1 $target
    fi


}

clone_dot_files() {
    git clone git@github.com:andrekupka/dotfiles $DOTFILES_PATH
    echo "Cloned dotfiles to $DOTFILES_PATH."
}

ask_repo_replace() {
    read -p "$DOTFILES_PATH already exists, delete and create fresh clone. [y|N]" choice
    case "$choice" in
    y|Y)
        rm -rf $DOTFILES_PATH
        clone_dot_files
        ;;
    *)
        echo "User aborted."
        exit 1
        ;;
    esac
}

prepare_dot_files() {
    echo "Cloning dotfiles to $DOTFILES_PATH..."
    if [[ -d $DOTFILES_PATH ]]; then
        ask_repo_replace
    else
        clone_dotfiles
    fi
}

install() {
    prepare_dot_files

    for i in $(ls -d $HOME/.dotfiles/dotfiles/*); do
        link_file "$i"
    done

    echo "Setup finished"
}

install

# vim: set et ts=4 sw=4:

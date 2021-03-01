#!/bin/bash

DOTFILES_PATH=$HOME/.dotfiles
BLUE_COLONS="\e[34;1m::\e[m"
GREEN_ARROW="\e[32;1m->\e[m"
BOLD="\e[1m"
END="\e[m"

clone_dot_files() {
    git clone git@github.com:andrekupka/dotfiles $DOTFILES_PATH
    echo -e "$GREEN_ARROW ${BOLD}Cloned dotfiles to $DOTFILES_PATH.$END"
}

ask_repo_replace() {
    read -p "$DOTFILES_PATH already exists, delete and create fresh clone? [y|N]" choice
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
    echo -e "$BLUE_COLONS ${BOLD}Cloning dotfiles to $DOTFILES_PATH...$END"
    if [[ -d $DOTFILES_PATH ]]; then
        ask_repo_replace
    else
        clone_dot_files
    fi
}

link() {
    ln -s "$1" "$2"
    echo -e "$GREEN_ARROW ${BOLD}Linked $1 to $2.$END"
}

ask_link() {
    read -p "$2 already exists. Replace with link to $1? [y|N]" choice
    case "$choice" in
    y|Y)
        rm $2
        link $1 $2
        ;;
    *)
        echo "$GREEN_ARROW ${BOLD}Skipping $2$END"
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

link_files() {
    echo -e "$BLUE_COLONS ${BOLD}Linking dotfiles from $DOTFILES_PATH to $HOME$END"
    for i in $(ls -d $DOTFILES_PATH/dotfiles/*); do
        link_file "$i"
    done
}


install() {
    prepare_dot_files

    link_files

    echo -e "$GREEN_ARROW ${BOLD}Installation finished.${END}"
}

install

# vim: set et ts=4 sw=4:

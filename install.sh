#!/bin/bash

OPTIND=1

DOTFILES_PATH=$HOME/.dotfiles
BLUE_COLONS="\e[34;1m::\e[m"
GREEN_ARROW="\e[32;1m->\e[m"
YELLOW_WARNING="\e[33;1m!!\e[m"
RED_ERROR="\e[31;1m!!\e[m"
BOLD="\e[1m"
END="\e[m"

yes_mode=0

show_help() {
    echo "Usage: install.sh [-hy]"
    exit 0
}

while getopts "h?y" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        y)
            yes_mode=1
            ;;
    esac
done

ask_user() {
    if [[ $yes_mode -eq 1 ]]; then
        echo -e "$YELLOW_WARNING ${BOLD}Auto-answering '$1' with yes.$END"
        return 1
    else
        read -p "$1 " choice
        if [[ "$choice" =~ y|Y ]]; then
            return 1
        else
            return 0
        fi
    fi
}

confirm_user() {
    ask_user "$1"
    if [[ $? -ne 1 ]]; then
        echo -e "$RED_ERROR ${BOLD}User aborted.$END"
        exit 1
    fi
}

clone_dot_files() {
    git clone https://github.com/andrekupka/dotfiles.git $DOTFILES_PATH
    echo -e "$GREEN_ARROW ${BOLD}Cloned dotfiles to $DOTFILES_PATH.$END"
}

ask_repo_replace() {
    confirm_user "$DOTFILES_PATH already exists, delete and create fresh clone? [y|N]"
    rm -rf $DOTFILES_PATH
    clone_dot_files
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
    ask_user "$2 already exists. Replace with link to $1? [y|N]"
    if [[ $? -eq 1 ]]; then
        rm $2
        link $1 $2
    else
        echo "$GREEN_ARROW ${BOLD}Skipping $2$END"
    fi
}

link_file() {
    local name=$(basename $1)
    local target="$HOME/.$(basename $1)"

    if [[ ( -f "$target" ) || ( -L "$target" ) ]]; then
        ask_link $1 $target
    else
        link $1 $target
    fi
}

link_files() {
    local directory=$DOTFILES_PATH/$1
    echo -e "$BLUE_COLONS ${BOLD}Linking dotfiles from $directory to $HOME$END"
    for i in $(ls -d $directory/*); do
        link_file "$i"
    done
}

install() {
    if [[ $yes_mode -eq 1 ]]; then
        echo -e "$YELLOW_WARNING ${BOLD}Automatically answering all questions with yes$END"
    fi

    prepare_dot_files

    link_files "base" 

    echo -e "$GREEN_ARROW ${BOLD}Installation finished.$END"
}

install

# vim: set et ts=4 sw=4:

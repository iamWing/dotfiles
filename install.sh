#!/usr/bin/env sh

set -e

# cd to script's directory
cd "$(dirname "$(readlink -f -- "$0")")"

CWD=$(pwd) # Set current working directory


create_symlinks() {
  # Get a list of all dot files in the working directory.
  _dotfiles="$(find "$CWD" -maxdepth 1 -type f -name ".*")"

  for _file in $_dotfiles; do
    _filename="$(basename "$_file")"

    if [ "$_filename" = ".gitignore" ]; then
      continue
    fi

    printf "Creating symlink to %s in home directory.\n" "$_filename"
    ln -s "$CWD/$_filename" "$HOME"/"$_filename"
  done

  unset _filename _file _dotfiles
}

# shellcheck source=vim/vim-setup.sh
. "$CWD"/vim/vim-setup.sh

create_symlinks

unset CWD

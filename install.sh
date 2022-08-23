#!/usr/bin/env sh

set -e

# cd to script's directory
cd "$(dirname "$(readlink -f -- "$0")")"

CWD=$(pwd) # Set current working directory


create_symlinks() {
  # Get a list of all dot files in the working directory.
  dotfiles="$(find "$CWD" -maxdepth 1 -type f -name ".*")"

  for file in $dotfiles; do
    filename="$(basename "$file")"

    if [ "$filename" = ".gitignore" ]; then
      continue
    fi

    echo "Creating symlink to $filename in home directory."
    ln -s "$CWD/$filename" "$HOME"/"$filename"
  done
}

# shellcheck source=scripts/vim-setup.sh
. "$CWD"/scripts/vim-setup.sh

create_symlinks

#!/usr/bin/env sh

# cd to script's directory
cd "$(dirname "$(readlink -f -- "$0")")" || exit 1
CWD=$(pwd)
ROOT=$(dirname "$(pwd)")

# Source utility scripts
# shellcheck source=utils/printf-helpers.sh
. "$ROOT"/utils/printf-helpers.sh

FORCE=false

usage() {
  printf "Usage: %s [-f|h|v]\n\n" "$0"
  printf "OPTIONS:\n"
  printf "  -f\t\tforce mode; overwrites existing files\n"
  printf "  -v\t\tverbose mode\n"
  printf "  -h\t\thelp\n"
}

while getopts "fhv" opt; do
  case "$opt" in
    f) FORCE=true ;;
    h)
      usage
      exit 0
      ;;
    v) VERBOSE=true ;;
    *)
      usage
      exit 2
      ;;
  esac
done

# Setup `onedark.vim` theme
verbose_print "> Setting up VIM theme 'onedark.vim'...\n\n"

ONEDARK_PATH="$HOME"/.vim/pack/plugins/opt/onedark.vim

if [ -e "$ONEDARK_PATH" ]; then
  verbose_print "Existing 'onedark.vim' found at '%s'\n" "$ONEDARK_PATH"
  if [ "$FORCE" = false ]; then
    verbose_print "Aborting...\n\n"
    exit 1
  fi

  verbose_print "Removing existing 'onedark.vim' at '%s'...\n" "$ONEDARK_PATH"
  rm -rf "$ONEDARK_PATH"
fi
mkdir -p "$HOME"/.vim/pack/plugins/opt
git clone https://github.com/joshdick/onedark.vim.git "$ONEDARK_PATH"
verbose_print "DONE\n\n"

# Link `.vimrc` to `$HOME`
verbose_print "> Linking '.vimrc' to '%s/.vimrc'...\n\n" "$HOME"
if [ -e "$HOME"/.vimrc ]; then
  verbose_print "'.vimrc' exists at '%s/.vimrc'\n" "$HOME"
  if [ "$FORCE" = false ]; then
    verbose_print "Aborting...\n\n"
    exit 1
  fi

  verbose_print "Removing existing '.vimrc' at '%s/.vimrc'\n" "$HOME"
  rm -rf "$HOME"/.vimrc
fi
verbose_print "Creating symlink...\n"
ln -s "$SCRIPT_PATH"/.vimrc "$HOME"/.vimrc
verbose_print "DONE\n\n"

# Cleanup
unset CWD ROOT ONEDARK_PATH
unset usage

# Not unset VERBOSE as this variable is intended to be shared across
# different sctips.

#!/usr/bin/env sh

# cd to script's directory
cd "$(dirname "$(readlink -f -- "$0")")" || exit 1
CWD=$(pwd)
ROOT=$(dirname "$(pwd)")

# Source utility scripts
# shellcheck source=utils/printf-helpers.sh
. "$ROOT"/utils/printf-helpers.sh

usage() {
  printf "Usage: %s [-v|h]\n\n" "$0"
  printf "OPTIONS:\n"
  printf "  -v\t\tverbose mode\n"
  printf "  -h\t\thelp\n"
}

while getopts "hv" opt; do
  case "$opt" in
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
verbose_print "Setting up VIM theme 'onedark.vim'...\n"
mkdir -p "$HOME"/.vim/pack/plugins/opt
git clone https://github.com/joshdick/onedark.vim.git \
  "$HOME"/.vim/pack/plugins/opt/onedark.vim
verbose_print "DONE\n"

# Cleanup
unset CWD ROOT
unset usage

# Not unset VERBOSE as this variable is intended to be shared across
# different sctips.

#!/usr/bin/env bash

# Get script's directory
SCRIPT_PATH=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ROOT=$(dirname "$SCRIPT_PATH")

# Source utility scripts
# shellcheck source=utils/printf-helpers.sh
. "$ROOT"/utils/printf-helpers.sh

usage() {
  printf "Usage: %s [-h]\n\n" "$0"
  printf "OPTIONS:\n"
  printf "  -h\t\thelp\n"
}

while getopts "h" opt; do
  case "$opt" in
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

printf "> %s" "${BASH_SOURCE[0]}"
printf " %s" "$@"
printf "\n> Test file '.vimrc'\n\n"

# Test
printf "Test using '.vimrc' in VIM...\n"
if ! err=$(vim -E -N -u "$SCRIPT_PATH"/.vimrc +qall 2>&1); then
  test_failed "%s\n" "$err"
  exit 1
fi
test_passed
unset err

unset opt
unset SCRIPT_PATH ROOT

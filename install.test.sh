#!/usr/bin/env bash

# cd to script's directory
cd -- "$(dirname "${BASH_SOURCE[0]}")" || exit 1
CWD=$(pwd) # Set current working directory

# Source utility scripts
# shellcheck source=utils/printf-helpers.sh
. "$CWD"/utils/printf-helpers.sh

MOCK=true

usage() {
  printf "Usage: %s [-c|h|n]\n\n" "${BASH_SOURCE[0]}"
  printf "OPTIONS:\n"
  printf "  -c\t\tcleanup output directory\n"
  printf "  -n\t\tdisable mock on \$HOME\n"
}

cleanup() {
  if [ "$MOCK" = true ]; then
    if [ -e "$CWD"/tmp ]; then
      printf "Removeing existing test output directory '%s/tmp'...\t" "$CWD"
      rm -rf "$CWD"/tmp
      task_done
    fi
  else
    printf "Cleaning up VIM related files...\t"
    local onedark_path="$HOME"/.vim/pack/plugins/opt/onedark.vim
    local vimrc_path="$HOME"/.vimrc
    [ -e "$onedark_path" ] && rm -rf "$onedark_path"
    [ -e "$vimrc_path" ] && rm -rf "$vimrc_path"
    task_done
  fi
}

while getopts "chn" opt; do
  case "$opt" in
    c) CLEANUP=true ;;
    h)
      usage
      exit 0
      ;;
    n) MOCK=false ;;
    *)
      usage
      exit 2
      ;;
  esac
done
unset opt

printf "> %s" "${BASH_SOURCE[0]}"
printf " %s" "$@"
printf "\n> Test script 'install.sh'\n\n"

# Set up
printf ": Set up :\n"
if [ "$MOCK" = true ]; then
  printf "Mocking '\$HOME' path as '%s/tmp'...\t" "$CWD"
  HOME="$CWD"/tmp
  task_done
fi

[ "$CLEANUP" = true ] && cleanup

# Test
printf "\n: Execute test cases :\n"

printf "Executing script '%s/install.sh'...\n" "$CWD"
# shellcheck source=install.sh
if ! err=$(. "$CWD"/install.sh 2>&1 1>/dev/null); then
  test_failed "%s\n" "$err"
  exit 1
fi
test_passed
unset err

printf -- ":: VIM related tests ::\n"

printf "Verifying if theme 'onedark.vim' is set up as expected...\n"
ONEDARK_PATH="$HOME"/.vim/pack/plugins/opt/onedark.vim
if [ -d "$ONEDARK_PATH" ]; then
  ONEDARK_TEST_CMD="try | packadd onedark.vim | catch | silent exec \
    \"!echo \" shellescape(v:exception) | cq | endtry | q"

  if ! err=$(vim -u NONE -c "$ONEDARK_TEST_CMD" 2>/dev/null); then
    TEST_FAILED=true
    test_failed "%s\n" "$err"
  fi

  unset err
else
  TEST_FAILED=true
  test_failed "VIM theme 'onedark.vim' not found on expected path '%s'\n" \
    "$ONEDARK_PATH"
fi
test_passed
unset ONEDARK_PATH

printf "Verifying if '.vimrc' is set up as expected...\n"
if [ -L "$HOME"/.vimrc ]; then
  if ! err=$(vim -E -N -u "$HOME"/.vimrc +qall 2>&1); then
    TEST_FAILED=true
    test_failed "%s\n" "$err"
  fi

  unset err
else
  TEST_FAILED=true
  test_failed "'.vimrc' not found on expected path '%s'\n" "$HOME/.vimrc"
fi
test_passed 
# VIM tests completed

[ "$CLEANUP" = true ] && cleanup
[ "$TEST_FAILED" = true ] && exit 1

unset cleanup usage
unset MOCK CWD

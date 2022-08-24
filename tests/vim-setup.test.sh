#!/usr/bin/env sh
# shellcheck disable=SC2059

printf "> %s" "$0"
printf " %s" "$@"
printf "\n> Test script 'scripts/vim-setup.sh'\n\n"

# cd to repo's root directory
cd "$(dirname "$(readlink -f -- "$0")")" || exit 1
cd ..
CWD=$(pwd)

# Source utility scripts
# shellcheck source=utils/printf-helpers.sh
. "$CWD"/utils/printf-helpers.sh

MOCK=false
CLEANUP=false

task_done() ( printf_green -- "- Done\n\n" )

test_passed() ( printf_green "%s Passed\n\n" "-" )

test_failed() { 
  _fail_msg="$1"
  shift

  printf_red "%s Failed\n" "-"
  printf "  "
  printf_red "$_fail_msg" "$@" 1>&2

  unset _fail_msg
}

usage() {
  printf "Usage: %s [-c|h|m]\n" "$0"
}

cleanup() {
  if [ "$MOCK" = true ]; then
    if [ -e "$CWD"/tests/.vim ]; then 
      printf "Removing existing file(s) on path '%s/tests/.vim'...\n" "$CWD"
      rm -rf "$CWD"/tests/.vim
      task_done
    fi
  else
    if [ -e "$DIR_ONEDARK" ]; then
      printf "Removing existing file(s) on path '%s'...\n" "$DIR_ONEDARK"
      rm -rf "$DIR_ONEDARK"
      task_done
    fi
  fi
}

while getopts "chm" opt; do
  case "$opt" in
    c) CLEANUP=true ;;
    h) 
      usage
      exit 0
      ;;
    m) MOCK=true ;;
    *)
      usage
      exit 2
      ;;
  esac
done

# Set up
if [ "$MOCK" = true ]; then HOME="$CWD"/tests; fi

DIR_ONEDARK="$HOME"/.vim/pack/plugins/opt/onedark.vim

cleanup


# Test
printf "Executing script '%s/scripts/vim-setup.sh'...\n" "$CWD"
# shellcheck source=scripts/vim-setup.sh
if ! err=$(. "$CWD"/scripts/vim-setup.sh 2>&1 1>/dev/null); then
  test_failed "%s\n" "$err"
  exit 1
fi
test_passed
unset err

printf "Checking is VIM theme 'onedark.vim' exists on path '%s'...\n" \
  "$DIR_ONEDARK"
if [ ! -d "$DIR_ONEDARK" ]; then
  test_failed "VIM theme 'onedark.vim' not found on expected path '%s'.\n" \
    "$DIR_ONEDARK"
  exit 1
fi
test_passed

VIM_TEST_CMD="try | packadd onedark.vim | catch | silent exec \"!echo \" \
  shellescape(v:exception) | cq | endtry | q"

printf "Test activate 'onedark.vim' in VIM...\n"
if ! err=$(vim -u NONE -c "$VIM_TEST_CMD" 2>/dev/null); then
  test_failed "%s\n" "$err"
  exit 1
fi
test_passed
unset err

# Cleanup
if [ "$CLEANUP" = true ]; then cleanup; fi

unset CWD MOCK CLEANUP

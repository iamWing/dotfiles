#!/usr/bin/env bash
# shellcheck disable=SC2059

# cd to script's directory
SCRIPT_PATH=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
ROOT=$(dirname "$SCRIPT_PATH")

# Source utility scripts
# shellcheck source=utils/printf-helpers.sh
. "$ROOT"/utils/printf-helpers.sh

MOCK=true
CLEANUP=false

task_done() ( printf_green -- "- Done\n" )

test_passed() ( printf_green "%s Passed\n" "-" )

test_failed() { 
  _fail_msg="$1"
  shift

  printf_red "%s Failed\n" "-"
  printf "  "
  printf_red "$_fail_msg" "$@" 1>&2

  unset _fail_msg
}

usage() {
  printf "Usage: %s [-c|h|n]\n\n" "$0"
  printf "OPTIONS:\n"
  printf "  -c\t\tcleanup output directory\n"
  printf "  -n\t\tdiable mock on \$HOME\n"
  printf "  -h\t\thelp\n"
}

cleanup() {
  if [ "$MOCK" = true ]; then
    if [ -e "$ROOT"/tmp/.vim ]; then 
      printf "Removing existing file(s) on path '%s/tmp/.vim'...\t" "$ROOT"
      rm -rf "$ROOT"/tmp/.vim
      task_done
    fi
    if [ -e "$ROOT"/tmp/.vimrc ]; then
      printf "Removing existing '.vimrc' on path '%s/tmp/.vimrc'...\t" "$ROOT"
      rm -rf "$ROOT"/tmp/.vimrc
      task_done
    fi
  else
    if [ -e "$DIR_ONEDARK" ]; then
      printf "Removing existing file(s) on path '%s'...\t" "$DIR_ONEDARK"
      rm -rf "$DIR_ONEDARK"
      task_done
    fi
    if [ -e "$HOME"/.vimrc ]; then
      printf "Removing existing '.vimrc' on path '%s'...\t" "$PATH_VIMRC"
      rm -rf "$HOME"/.vimrc
      task_done
    fi
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

printf "> %s" "$0"
printf " %s" "$@"
printf "\n> Test script 'vim/vim-setup.sh'\n\n"

# Set up
printf ": Set up :\n"
if [ "$MOCK" = true ]; then 
  printf "Mocking '\$HOME' path as '%s/tmp'...\t" "$ROOT"
  HOME="$ROOT"/tmp
  task_done
fi

DIR_ONEDARK="$HOME"/.vim/pack/plugins/opt/onedark.vim
PATH_VIMRC="$HOME"/.vimrc

if [ "$CLEANUP" = true ]; then cleanup; fi


# Test
printf "\n: Execute test cases :\n"

printf "Executing script '%s/vim/vim-setup.sh'...\n" "$ROOT"
# shellcheck source=vim/vim-setup.sh
if ! err=$(. "$SCRIPT_PATH"/vim-setup.sh 2>&1 1>/dev/null); then
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

printf "Checking is '.vimrc' exists on path '%s'...\n" "$PATH_VIMRC"
if [ ! -f "$PATH_VIMRC" ]; then
  test_failed "'.vimrc' not found on expected path '%s'.\n" "$PATH_VIMRC"
  exit 1
fi
test_passed 

# Cleanup
printf "\n: Clean up :\n"
if [ "$CLEANUP" = true ]; then cleanup; fi

unset SCRIPT_PATH ROOT MOCK CLEANUP
unset task_done task_passed task_failed usage
unset DIR_ONEDARK PATH_VIMRC

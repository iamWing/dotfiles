#!/usr/bin/env sh
# shellcheck disable=SC2059

printf_green() {
  _fmt=$1
  shift

  printf "\033[0;32m"
  printf "$_fmt" "$@"
  printf "\033[0m"

  unset _fmt
}

printf_yellow() {
  _fmt=$1
  shift

  printf "\033[0;33m"
  printf "$_fmt" "$@"
  printf "\033[0m"

  unset _fmt
}

printf_red() {
  _fmt=$1
  shift

  printf "\033[0;31m"
  printf "$_fmt" "$@"
  printf "\033[0m"

  unset _fmt
}

verbose_print() {
  if [ "$VERBOSE" = true ]; then
    _fmt=$1
    shift

    printf "$_fmt" "$@"

    unset _fmt
  fi
}

task_done() ( printf_green -- "- Done\n" )

test_passed() ( printf_green "%s Passed\n" "-" )

test_failed() { 
  _fail_msg="$1"
  shift

  printf_red "%s Failed\n" "-"
  printf_red "$_fail_msg" "$@" 1>&2

  unset _fail_msg
}

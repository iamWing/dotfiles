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

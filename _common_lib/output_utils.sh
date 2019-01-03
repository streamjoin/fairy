#!/bin/bash
#
# Output utilities

info() {
  printf "[\033[1m\033[34mINFO\033[0m] $@\n" >&1  # to stdout
}

info_bold_green() {
  info "\033[1m\033[32m$@\033[0m"
}

warn() {
  printf "[" >&2
  printf "\033[1m\033[33m" >&1
  printf "WARNING" >&2
  printf "\033[0m" >&1
  printf "] $@\n" >&2
}

err() {
  printf "[" >&2
  printf "\033[1m\033[31m" >&1
  printf "ERROR" >&2
  printf "\033[0m" >&1
  printf "] $@\n" >&2
}

check_err() {
  local -r EXIT_CODE="$?"
  if [[ "${EXIT_CODE}" -ne 0 ]]; then
    err "$@ [EXIT:${EXIT_CODE}]"
    exit "${EXIT_CODE}"
  fi
}

check_cmd_exists() {
  [[ "$(command -v "$1")" ]]
  check_err "command ${1:+'$1'} not found${2:+: $2}"
}

failed() {
  printf "\033[31m" >&1  # set to red font for stdout
  printf "$@" >&2  # to stderr
  printf "\033[0m\n" >&1  # reset color for stdout
}

check_failed() {
  local -r EXIT_CODE="$?"
  if [[ "${EXIT_CODE}" -ne 0 ]]; then
    failed "$@ [EXIT:${EXIT_CODE}]"
    exit "${EXIT_CODE}"
  fi
}

check_cmd_args() {
  local -r EXIT_CODE="$?"
  if [[ "${EXIT_CODE}" -ne 0 ]]; then
    err "Usage: $(basename "$0") $@"
    exit "${EXIT_CODE}"
  fi
}

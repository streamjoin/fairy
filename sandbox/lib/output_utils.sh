#!/bin/bash
#
# Output utilities

err() {
  echo -e "$@" >&2  # output to stderr
}

check_err() {
  local -r RET="$?"
  if [[ "${RET}" -ne 0 ]]; then
    err "$@"
    exit "${RET}"
  fi
}

failed() {
  printf "\033[31m" >&1  # set to red font for stdout
  printf "$@" >&2  # output to stderr
  printf "\033[0m\n" >&1  # reset color for stdout
}

check_failed() {
  local -r RET="$?"
  if [[ "${RET}" -ne 0 ]]; then
    failed "$@"
    exit "${RET}"
  fi
}

check_cmd_args() {
  local -r RET="$?"
  if [[ "${RET}" -ne 0 ]]; then
    err "Usage: $(basename "$0") $@"
    exit "${RET}"
  fi
}

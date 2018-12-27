#!/bin/bash
#
# Output utilities

info() {
  echo -e "[INFO] $@" >&2
}

err() {
  echo -e "[ERROR] $@" >&2  # output to stderr
}

check_err() {
  local -r EXIT_CODE="$?"
  if [[ "${EXIT_CODE}" -ne 0 ]]; then
    err "$@ [EXIT:${EXIT_CODE}]"
    exit "${EXIT_CODE}"
  fi
}

failed() {
  printf "\033[31m" >&1  # set to red font for stdout
  printf "$@" >&2  # output to stderr
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

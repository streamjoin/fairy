#!/usr/bin/env bash

# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

IFS=$'\t\n'    # Split on newlines and tabs (but not on spaces)

# Global variables
[[ -n "${__SCRIPT_DIR+x}" ]] ||
readonly __SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

[[ -n "${__SCRIPT_NAME+x}" ]] ||
readonly __SCRIPT_NAME="$(basename -- "$0")"

# The main function
main() {
  check_args "$@"
  # Start your code here
  
}

# Helper functions
check_args() {
  unset -v FLAG_ARG_SET_VAR
  
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_usage
        exit 0
      ;;
      # Handler of some option
      '--opt'|'-o' )
        deal_with_arg_opt "${arg}"
      ;;
      '--set-var'|'-v' )
        deal_with_arg_set_var "--set-var" "FLAG_ARG_SET_VAR"
      ;;
      # Unknown options
      '-'* )
        echo "Unknown command argument(s) '${arg}' (see '--help' for usage)"
        exit 126
      ;;
      # Default: assign variable
      * )
        arg_set_var "--set-var" "FLAG_ARG_SET_VAR" "ARG_VAR" "${arg}"
      ;;
    esac
  done
  
  check_dangling_arg_set_var "--set-var" "FLAG_ARG_SET_VAR"
}

deal_with_arg_set_var() {
  check_dangling_arg_set_var "$1" "$2"
  eval "$2"="true"
}

arg_set_var() {
  if [[ "${!2}" = "true" ]]; then
    if [[ -n "${!3}" ]]; then
      echo "Cannot set the option '$1' multiple times"
      exit 126
    fi
    eval "$3"="$4"
    unset -v "$2"
  fi
}

check_dangling_arg_set_var() {
  if [[ -n "${!2}" ]]; then
    echo "Found redundant option '$1', or its value assignment is missing (see '--help' for usage)"
    exit 126
  fi
}

deal_with_arg_opt() {
  printf "'%s' is specified\n" "$1"
}

print_usage() {
cat <<EndOfMsg
Usage: ${__SCRIPT_NAME} [OPTION]...

Options:
  -h, -?, --help    display this help and exit

EndOfMsg
}

# Execution (SHOULDN'T EDIT AFTER THIS LINE!)
main "$@"
[[ "$0" != "${BASH_SOURCE[0]}" ]] || exit 0

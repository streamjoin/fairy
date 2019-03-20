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
  unset_arg_var_flags
  
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_usage
        exit 0
      ;;
      # Handler of some option
      '--opt'|'-o' )
        deal_with_opt "${arg}"
      ;;
      '--set-var'|'-v' )
        deal_with_set_var
      ;;
      # Unknown options
      '-'* )
        echo "Unknown command argument(s) '${arg}' (see '--help' for usage)"
        exit 126
      ;;
      # Default: assign variable
      * )
        assign_var "${arg}"
      ;;
    esac
  done
  
  check_arg_var_settings
}

unset_arg_var_flags() {
  unset -v OPT_SET_VAR
}

check_arg_var_settings() {
  check_dangling "${OPT_SET_VAR:-}"
}

check_dangling() {
  if [[ -n "$1" ]]; then
    echo "The expected variable setting is missing (see '--help' for usage)"
    exit 126
  fi
}

print_usage() {
cat <<EndOfMsg
Usage: ${__SCRIPT_NAME} [OPTION]...

Options:
  -h, -?, --help    display this help and exit

EndOfMsg
}

deal_with_opt() {
  printf "'%s' is specified\n" "$1"
}

assign_var () {
  if [[ "${OPT_SET_VAR:-}" = "true" ]]; then
    if [[ -n "${ARG_VAR:-}" ]]; then
      echo "Cannot set the same variable multiple times"
      exit 126
    fi
    ARG_VAR="$1"
    unset -v OPT_SET_VAR
  fi
}

# Execution (SHOULDN'T EDIT AFTER THIS LINE!)
main "$@"
[[ "$0" != "${BASH_SOURCE[0]}" ]] || exit 0

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
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_usage
        exit 0
      ;;
      # Handler of some option
      '--arg1'|'-a1' )
        deal_with_arg1 "${arg}"
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
}

print_usage() {
cat <<EndOfMsg
Usage: ${__SCRIPT_NAME} [OPTION]...

Options:
  -h, -?, --help    display this help and exit

EndOfMsg
}

deal_with_arg1() {
  printf "'%s' is specified\n" "$1"
}

assign_var () {
  export ARG_VAR="$1"
}

# Execution (SHOULDN'T EDIT AFTER THIS LINE!)
main "$@"
[[ "$0" != "${BASH_SOURCE[0]}" ]] || exit 0

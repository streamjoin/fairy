#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# Global variables
readonly SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE}")" && pwd -P)"
readonly SCRIPT_NAME="$(basename -- "$0")"

# The main function
main() {
  check_args "$@"
  # Start your coder here
  
}

# Helper functions
check_args() {
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_help_msg
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

print_help_msg() {
cat <<EndOfMsg
Usage: ${SCRIPT_NAME} [OPTION]...

Options:
  -h, -?, --help    display this help and exit

EndOfMsg
}

deal_with_arg1() {
  printf "'%s' is specified\n" "$1"
}

assign_var () {
  ARG_VAR="$1"
}

# Execution (SHOULDN'T EDIT AFTER THIS LINE!)
main "$@"
exit "$?"

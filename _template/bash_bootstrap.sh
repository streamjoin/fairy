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

#######################################
# Check and process command-line arguments.
# Globals:
#   <none>
# Arguments:
#   Command-line arguments
# Returns:
#   Variables and flags set according to the command-line arguments (e.g., ARG_VAR)
#
# Notes: Programming instructions for adding variables to be set by command-line argument
#   (1) Add "unset -v FLAG_ARG_SET_XXX" at the head
#   (2) Add a case entry for the option
#   (3) Add an "arg_set_var" entry with variable name specified in the default case
#   (4) Add a "check_dangling_arg_set_var" entry at the end
#######################################
check_args() {
  unset -v FLAG_ARG_SET_VAR
  
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_usage
        exit 0
      ;;
      # Handler of some boolean option
      '--opt'|'-o' )
        deal_with_arg_opt "${arg}"
      ;;
      # Handler of some option with variable to be set
      '--set-var'|'-v' )
        deal_with_arg_set_var "--set-var" "FLAG_ARG_SET_VAR"
      ;;
      # Unknown options
      '-'* )
        echo "Unknown command argument(s) '${arg}' (see '--help' for usage)"
        exit 126
      ;;
      # Default: assign variables
      * )
        arg_set_var "--set-var" "FLAG_ARG_SET_VAR" "ARG_VAR" "${arg}"
      ;;
    esac
  done
  
  check_dangling_arg_set_var "--set-var" "FLAG_ARG_SET_VAR"
}

#######################################
# Handler of argument option.
# Globals:
#   <none>
# Arguments:
#   $1: Option descriptor
#   $2: Name of flag variable
# Returns:
#   Flag variable set according to the option
#######################################
deal_with_arg_set_var() {
  declare -r opt="$1" flag_name="$2"
  
  check_dangling_arg_set_var "${opt}" "${flag_name}"
  eval "${flag_name}=true"
}

# TODO(linqian): Add function description.
#######################################
# Handler of argument variable assignment.
# Globals:
#   <none>
# Arguments:
#   $1: Option descriptor
#   $2: Name of flag variable
#   $3: Name of variable to set
#   $4: Assignment value
# Returns:
#   Variable set with the value specified
#######################################
arg_set_var() {
  declare -r opt="$1" flag_name="$2" var_name="$3" value="$4"
  
  if [[ "${!flag_name}" = "true" ]]; then
    if [[ -n "${!var_name:-}" ]]; then
      echo "Cannot apply option '${opt}' multiple times"
      exit 126
    fi
    eval "${var_name}=${value}"
    unset -v "${flag_name}"
  fi
}

# TODO(linqian): Add function description.
check_dangling_arg_set_var() {
  declare -r opt="$1" flag_name="$2"
  
  if [[ -n "${!flag_name:-}" ]]; then
    echo "Found redundant option '${opt}', or its value assignment is missing (see '--help' for usage)"
    exit 126
  fi
}

deal_with_arg_opt() {
  printf "'%s' is specified\n" "$1"
}

# TODO(linqian): Add help message for other sample options.
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

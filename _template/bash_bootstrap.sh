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
[[ -n "${__SCRIPT_DIR+x}" ]] || readonly __SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
[[ -n "${__SCRIPT_NAME+x}" ]] || readonly __SCRIPT_NAME="$(basename -- "$0")"

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
#   Variables and flags set according to the command-line arguments
#
# Notes: Programming instructions for adding variables to be set by
#        command-line argument
#   (1) Add 'unset -v FLAG_ARG_SET_XXX' at the head
#   (2) Add a case entry with 'deal_with_arg_opt' for the option
#   (3) Add an 'arg_set_opt_var' entry with variable name specified in the
#       default case, ending with "||"
#   (4) Add a 'check_dangling_arg_opt' entry at the end
#
# To add boolean option to be set by command-line argument, just follow
# the above steps (1) and (2) but not (3) and (4). The flag variable should
# follow the naming convention 'FLAG_ARG_XXX'.
#######################################
check_args() {
  # unset variables of option flags
  unset -v FLAG_ARG_OPT
  unset -v FLAG_ARG_SET_VAR
  
  # process each command-line argument
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_usage
        exit 0
      ;;
      # Handler of some boolean option
      '--opt'|'-o' )
        deal_with_arg_opt "--opt" "FLAG_ARG_OPT"
      ;;
      # Handler of some option with variable to be set
      '--set-var'|'-v' )
        deal_with_arg_opt "--set-var" "FLAG_ARG_SET_VAR"
      ;;
      # Unknown options
      '-'* )
        echo "Unknown command argument(s) '${arg}' (see '--help' for usage)"
        exit 126
      ;;
      # Default: assign variables
      * )
        arg_set_opt_var "--set-var" "FLAG_ARG_SET_VAR" "ARG_VAR" "${arg}" ||
        arg_set_pos_var "${arg}"    # KEEP THIS AT THE TAIL
      ;;
    esac
  done
  
  # sanity check
  check_dangling_arg_opt "--set-var" "FLAG_ARG_SET_VAR"
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
deal_with_arg_opt() {
  declare -r opt="$1" flag_name="$2"
  
  check_dangling_arg_opt "${opt}" "${flag_name}"
  eval "${flag_name}=true"
}

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
#   0 if the variable is set with the value specified;
#   non-zero if no assignment is executed
#######################################
arg_set_opt_var() {
  declare -r opt="$1" flag_name="$2" var_name="$3" value="$4"
  
  [[ "${!flag_name:-}" = "true" ]] || return 1
  
  if ! assign_var_once "${var_name}" "${value}"; then
    echo "Cannot apply option '${opt}' multiple times"
    exit 126
  fi
  eval "${var_name}=${value}"
  unset -v "${flag_name}"
}

#######################################
# Assign value to variable.
# Globals:
#   <none>
# Arguments:
#   $1: Name of variable to set
#   $2: Assignment value
# Returns:
#   0 if the variable is successfully set with the value specified;
#   non-zero if the variable has been previously set
#######################################
assign_var_once() {
  declare -r var_name="$1" value="$2"
  
  [[ -z "${!var_name:-}" ]] || return 1
  eval "${var_name}=${value}"
}

#######################################
# Handler of positional argument variable assignment.
# Globals:
#   <none>
# Arguments:
#   $1: Assignment value
# Returns:
#   Variable "ARG_POS_VAR_X" set with the value specified,
#   where "X" is the positional index starting from 1
#######################################
arg_set_pos_var() {
  declare -r value="$1"
  
  __POS_ARG_CURSOR="${__POS_ARG_CURSOR:-0}"
  ((++__POS_ARG_CURSOR))
  eval "ARG_POS_VAR_${__POS_ARG_CURSOR}=${value}"
}

#######################################
# Check dangling argument option and exit on error.
# Globals:
#   <none>
# Arguments:
#   $1: Option descriptor
#   $2: Name of flag variable
# Returns:
#   <none>
#######################################
check_dangling_arg_opt() {
  declare -r opt="$1" flag_name="$2"
  
  if [[ -n "${!flag_name:-}" ]]; then
    echo "Found redundant option '${opt}', or its value assignment is missing (see '--help' for usage)"
    exit 126
  fi
}

print_usage() {
cat <<EndOfMsg
Usage: ${__SCRIPT_NAME} [OPTION]...

Options:
  -h, -?, --help    display this help and exit
  -v, --set-var     sample: assign value to a variable
  -o, --opt         sample: boolean option

EndOfMsg
}

# Execution (SHOULDN'T EDIT AFTER THIS LINE!)
main "$@"
[[ "$0" != "${BASH_SOURCE[0]}" ]] || exit 0

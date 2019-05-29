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

[[ -n "${__SCRIPT_DIR+x}" ]] || readonly __SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
[[ -n "${__SCRIPT_NAME+x}" ]] || readonly __SCRIPT_NAME="$(basename -- "$0")"

# Include libraries
[[ -n "${FAIRY_HOME+x}" ]] || readonly FAIRY_HOME="${__SCRIPT_DIR}/.."
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/argument_utils.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/filesystem.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/output_utils.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/system.sh"

# Global variables
[[ -n "${__START_TIME+x}" ]] || readonly __START_TIME="$(timer)"

# The main function
main() {
  check_args "$@"
  # Start your code here
  
  
  # Do cleaning up and bookkeeping in 'finish()', if necessary
  finish
}

finish() {
  info "Completed in $(timer "${__START_TIME}")"
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
        err "Unknown command argument(s) '${arg}' (see '--help' for usage)"
        exit 126
      ;;
      # Default: assign variables
      * )
        arg_set_opt_var "--set-var" "FLAG_ARG_SET_VAR" "ARG_VAR" "${arg}" ||
        arg_set_pos_var "${arg}"  # KEEP THIS AT THE TAIL
      ;;
    esac
  done
  
  # sanity check
  check_dangling_arg_opt "--set-var" "FLAG_ARG_SET_VAR"
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

#!/bin/bash
#
# Load script configuration
#
# Dependencies: output_utils.sh

DEFAULT_SANDBOX_SCRIPT_CONF=\
"${HOME}/sandbox/scripts/conf/sandbox_script.conf.default"

# Inlcude script configuration
readonly SCRIPT_CONF="${SANDBOX_SCRIPT_CONF:-${DEFAULT_SANDBOX_SCRIPT_CONF}}"
[[ -n "${SCRIPT_CONF}" ]]
check_err "Script configuration is not specified"

source "${SCRIPT_CONF}"
check_err "Failed to load script configuration: ${SCRIPT_CONF}"

# Identify script itself
readonly SCRIPT_NAME="$(basename "$0")"

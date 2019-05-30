#!/usr/bin/env bash
#
# Load script configuration

[[ -n "${__FAIRY_ACCOUNT_LIB_LOAD_SCRIPT_CONF_SH__+x}" ]] && return
readonly __FAIRY_ACCOUNT_LIB_LOAD_SCRIPT_CONF_SH__=1

# Include dependencies
[[ -n "${FAIRY_HOME+x}" ]] || readonly FAIRY_HOME="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/../.."
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/output_utils.sh"

# Inlcude script configuration
readonly SCRIPT_CONF="${ACCOUNT_SCRIPT_CONF:-"${FAIRY_HOME}/account/conf/account_script.conf.default"}"
[[ -n "${SCRIPT_CONF}" ]] ||
check_err "Script configuration is not specified"

[[ -f "${SCRIPT_CONF}" ]] ||
check_err "Invalid path of script configuration: ${SCRIPT_CONF}"

# shellcheck disable=SC1090
source "${SCRIPT_CONF}" ||
check_err "Failed to load script configuration: ${SCRIPT_CONF}"

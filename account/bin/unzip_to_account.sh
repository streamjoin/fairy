#!/usr/bin/env bash
#
# Uncompress a file to an account.

# set -o nounset
# set -o errexit
set -o pipefail

# Include libraries
readonly SCRIPT_HOME="$(cd "$(dirname -- "$0")"; pwd -P)"
source "${FAIRY_HOME:-${SCRIPT_HOME}/../..}/_common_lib/output_utils.sh"
source "${FAIRY_HOME:-${SCRIPT_HOME}/../..}/_common_lib/system.sh"
source "${FAIRY_HOME:-${SCRIPT_HOME}/../..}/account/lib/load_script_conf.sh"

# Command parameters
readonly ZIP_FILE="$1"
readonly ID="$2"
[[ -f "${ZIP_FILE}" ]] && [[ -n "${ID}" ]]
check_cmd_args "<file>" "<account_id>"

# Set variables
readonly USERNAME_INIT="${ACCOUNT_USERNAME_INIT-${DEFAULT_USERNAME_INIT}}"

readonly USERNAME="${USERNAME_INIT:+"${USERNAME_INIT}-"}${ID}"

# Validate the existence of account
id -u "${USERNAME}" > /dev/null 2>&1
check_failed "account '${USERNAME}' does not exist"

EXT="$()"

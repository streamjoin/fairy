#!/usr/bin/env bash
#
# Delete SSH key pair for current account or a specified account.

set -o nounset
# set -o errexit
set -o pipefail

# Include libraries
readonly SCRIPT_HOME="$(cd "$(dirname -- "$0")"; pwd -P)"
source "${SCRIPT_HOME}/../_common_lib/output_utils.sh"

# Command parameters
readonly USERNAME="${1:-${USER}}"

# Set variables
readonly USER_SSH_ROOT="$(dirname -- "${HOME}")/${USERNAME}/.ssh"

# Validate the existence of user account
id -u "${USERNAME}" > /dev/null 2>&1
check_failed "account '${USERNAME}' does not exist"

# TODO
head -n1 id_rsa.pub | cut -d ' ' -f2

# End of script
echo "SSH key pair for account '${USERNAME}' has been deleted"
exit 0

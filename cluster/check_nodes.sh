#!/bin/bash
set -o nounset
# set -o errexit
# set -o pipefail

# Specify the configuration file of registering the worker nodes. 
HOSTS="./slaves.conf"

######## End of User Settings ########

PROGRESS_HEAD="testing"

SCRIPT='printf ""'

REPORT_FILE="./failed_nodes.txt"
rm -f ${REPORT_FILE}
printf "${PROGRESS_HEAD} "
SSH_OPTS="-o StrictHostKeyChecking=no"

while read LINE; do
	IFS=' ' read -a P <<< ${LINE}

	ssh ${SSH_OPTS} ${P[0]} "${SCRIPT}" < /dev/null 2>/dev/null

	if [[ $? -ne 0 ]]; then
		echo "${P[0]}" >> ${REPORT_FILE}
		printf "x"
	else
		printf "."
	fi
done < ${HOSTS}
echo "done"

if [[ -f ${REPORT_FILE} ]]; then
	echo "Failed node(s):"
	cat ${REPORT_FILE}
fi

exit $?

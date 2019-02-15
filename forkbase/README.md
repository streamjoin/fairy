# ForkBase Facilities #

## Installing Dependencies ##

For example, save the following script as `install_deps.sh` and run it. 

    #!/bin/bash
    set -o errexit
    set -o pipefail

    export FAIRY_HOME="${HOME}/fairy"

    export USTORE_BASH_PROFILE="${HOME}/.profile"
    export USTORE_DEPS_DIR="${HOME}/forkbase_deps"

    source "${FAIRY_HOME}/forkbase/install_deps"

This will install all the dependencies to the `${HOME}/forkbase_deps` folder and append the corresponding configurations to the `${HOME}/.profile` file. In addition, you make set the `USTORE_TEMP_DIR` variable to specify the temporary folder used for dependency compilation. Note that the temporary folder will be deleted after the dependency installation completes. 

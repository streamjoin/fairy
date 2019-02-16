# ForkBase Facilities #

## Installing Dependencies ##

The `install_deps` script will download, compile and install the dependencies of [ForkBase](https://github.com/ooibc88/forkbase). Currently, it can only run on Ubuntu since it internally invokes `apt`. To use it, the following environment variables should be set as necessary. 

- `FAIRY_HOME`: Path of the root of the fairy project. This must be set in order to properly resolved dependencies required in the script. 
- `USTORE_BASH_PROFILE`: The configuration file that will be updated in order to apply the dependencies. By default, it is set to `${HOME}/.bash_profile`.
- `USTORE_DEPS_DIR`: The folder that the dependencies will install to. By default, it is set to `/usr/local/share`.
- `USTORE_TEMP_DIR`: The temporary folder used for dependency compilation. Note that the temporary folder will be deleted after the dependency installation completes. By default, it is set to `${HOME}/deps_install`.

For example, save the following script as `my_install_deps.sh` and run it. 

    #!/bin/bash
    set -o errexit
    set -o pipefail

    export FAIRY_HOME="${HOME}/fairy"
    export USTORE_BASH_PROFILE="${HOME}/.profile"
    export USTORE_DEPS_DIR="${HOME}/forkbase_deps"

    source "${FAIRY_HOME}/forkbase/install_deps"

This will install all the dependencies to the `${HOME}/forkbase_deps` folder and append the corresponding configurations to the `${HOME}/.profile` file.  

Note that `sudo` permission is required for running `install_deps`. You don't need to specify `sudo` in front of the script invocation, as `sudo` has been encoded into the script. 

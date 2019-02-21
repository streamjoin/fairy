# ForkBase Facilities #

## Installing Dependencies ##

The `install_deps` script will download, compile and install the dependencies of [ForkBase](https://github.com/ooibc88/forkbase). Currently, it can only run on Ubuntu since it internally invokes `apt`. To use it, the following environment variables should be set as necessary. 

- `FAIRY_HOME`: Path of the root of the fairy project. This must be set in order to properly resolved dependencies required in the script. 
- `USTORE_BASH_PROFILE`: The configuration file that will be updated in order to apply the dependencies. By default, it is set to `${HOME}/.bash_profile`.
- `USTORE_DEPS_DIR`: The folder that the dependencies will install to. By default, it is set to `/usr/local/share`.
- `USTORE_TEMP_DIR`: The temporary folder used for dependency compilation. Note that the temporary folder will be deleted after the dependency installation completes. By default, it is set to `${HOME}/deps_install`.

For example, save the following script as `my_install_deps.sh` and run it. 

    #!/usr/bin/env bash
    set -o errexit
    set -o pipefail

    export FAIRY_HOME="${HOME}/fairy"
    export USTORE_BASH_PROFILE="${HOME}/.profile"
    export USTORE_DEPS_DIR="${HOME}/forkbase_deps"

    source "${FAIRY_HOME}/forkbase/install_deps"

This will install all the dependencies to the `${HOME}/forkbase_deps` folder and append the corresponding configurations to the `${HOME}/.profile` file.  

Note that `sudo` permission is required for running `install_deps` unless the `--download` option is used (see [below](#downloading-dependency-packages)). You don't need to specify `sudo` in front of the script invocation, as `sudo` has been encoded into the script. 

### Downloading Dependency Packages ###

The `install_deps` script also supports the option of downloading the dependency packages only, i.e., without immediate installation. This could be useful for preparing the required packages when doing on-site setup with limited internet access. To that end, you just invoke the above `my_install_deps.sh` with the `--download` option (or `-D` for short). For example, 

    $ ./my_install_deps.sh --download

This will download all the dependency packages to the `${HOME}/deps_install` folder (according to the default setting of `USTORE_TEMP_DIR`). Then by invoking `my_install_deps.sh` again (e.g., on the target machine) without specifying any option, the installation will proceed with the downloaded packages. 

At times, you may want to specify the on-demand path to store the packages. You can achieve this purpose by simply providing the path in the above commands. For example, 

	# For downloading packages
    $ ./my_install_deps.sh -D /path/to/package/store
    
    # For installing package
    $ ./my_install_deps.sh /path/to/package/store

Note that once a dependency is successfully installed, the corresponding package will be deleted automatically. 

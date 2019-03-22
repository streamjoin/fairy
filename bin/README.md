# Facilities #

I strongly suggest that every Bash script should start with [`bash_bootstrap.sh`](../_template/bash_bootstrap.sh), no matter how simple (or complex) the script is. Moreover, the `bootstrap_sh` utility can help you to bootstrap the coding more easily. 

## Setup ##

**Step-1:** Clone the Fairy project. 

    $ git clone https://github.com/streamjoin/fairy.git

**Step-2:** Add `bin/` to the system `PATH` by adding the following lines to `~/.bashrc` or `~/.bash_profile`. 

    # Fairy
    export FAIRY_HOME="/path/to/fairy"
    export PATH="${FAIRY_HOME}/bin:${PATH}"

## Basic Usage ##

Once the above configuration takes effect (e.g., `source` the above configuration file), you can call `bootstrap_sh <script_name>` to bootstrap your Bash script. For example, 

    $ bootstrap_sh my_script.sh

The `my_script.sh` script will be instantiated from `bash_bootstrap.sh`. Then you can start coding in the `main()` function. 

    ...
    main() {
      check_args "$@"
      # Start your code here
      
    }
    ...

You may also want to modify the `check_args()` function on demand for the customization of command-line argument handling. 

## Advanced Usage ##

The `bootstrap_sh` utility also supports bootstrapping other task-specific Bash scripts. Please see `--help` for the details. 

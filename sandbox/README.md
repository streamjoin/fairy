# Managing Sandbox Accounts #

Currently, sandbox is account based. The development environment is shared among all the sandbox accounts. 

## Creating Account ##

Administrator can create a new account using `add_sandbox_account` which takes an ID as parameter. For example, 

    $ add_sandbox_account 00
    account 'sandbox-00' has been created successfully

Default password for the generated account is `sb<ID>`. A randomly generated SSH private key is copied to `$HOME/sandbox/private_keys`, and the corresponding public key is activated for the account. `HOME` refers to the home folder of the administrator account. 

Once the account is created, administrator can pass the account name (e.g. `sandbox-00`) and the private key (e.g. `sandbox-00.pem`) to user for login. 

## Managing Account ##

The following scripts are used for sandbox account management: 

- `ls_sandbox_accounts`: list all sandbox accounts. 
- `chg_sandbox_account_password <ID> <Password>`: update the password of a sandbox account. 
- `del_sandbox_account <ID>`: delete a sandbox account. Note that the associated private key will be also deleted. 

Note that all the above scripts (including `add_sandbox_account`) must be run by administrator who has the `sudo` privilege. 


## Customization ##

By default, the above scripts load configuration from `sandbox_script.conf.default` whose path is *hard-coded* as the `DEFAULT_SANDBOX_SCRIPT_CONF` variable in each script. The default configuration contains settings of the following variables: 

- `DEFAULT_PEM_HOME`: Default folder used to store private keys associated with active sandbox accounts. 
- `DEFAULT_ENV_CONF_REF_ROOT`: Default folder containing the account configuration files. 
- `DEFAULT_ENV_CONF_LIST`: Default list of account configuration files such as `.bashrc`, `.bash_profile`, `.profile` and `.vimrc`. As long as these configuration files exist in the folder specified by `SANDBOX_ENV_CONF_REF_ROOT` (or `DEFAULT_ENV_CONF_REF_ROOT` by default), they will be copied to the home folder of sandbox account upon account creation. Any missing of configuration file will cause the corresponding initialization of configuration for the sandbox account to be omitted.
- `DEFAULT_ADD_ON_GROUPS`: Default list of groups that each sandbox account would be added to. If any group does not exist, it will be created automatically along with the execution of `add_sandbox_account`. Note that each sandbox account is implicitly added to the group named by `SANDBOX_USERNAME_INIT` (or `DEFAULT_USERNAME_INIT` by default), which is referred as the *common sandbox group*. Therefore, this variable should list the groups other than the common sandbox group. 
- `DEFAULT_USERNAME_INIT`: Default initial string of username of sandbox account. This variable also defines the name of the common sandbox group. 
- `DEFAULT_PASSWORD_INIT`: Default initial string of password of sandbox account. 

Generally, there are two ways to change the script configuration without modifying the scripts. 

### Using Customized Default Configuration ### 

By all means, it is *not recommended* to edit the `sandbox_script.conf.default` file. Instead, you are suggested to copy it out, e.g. saved as `sandbox_script.conf`, and further make changes in `sandbox_script.conf`. Once the customization is done, set the environment variable `SANDBOX_SCRIPT_CONF` to refer to the path of the customized configuration file. For example, 

    export SANDBOX_SCRIPT_CONF="/path/to/sandbox_script.conf"

Then use the sandbox scripts as usual and the customized configuration should take effect. Basically, for loading default configuration, each sandbox script first looks for `SANDBOX_SCRIPT_CONF` (environment variable) and, if not found, falls back to `DEFAULT_SANDBOX_SCRIPT_CONF` (script-scoped variable). 

### Setting Customized Environment Variable ###

The following environment variables starting with `SANDBOX_` correspond to the aforementioned variables starting with `DEFAULT_`: 

- `SANDBOX_PEM_HOME`: Customized folder used to store private keys associated with active sandbox accounts.
- `SANDBOX_ENV_CONF_REF_ROOT`: Customized folder containing the account configuration files.
- `SANDBOX_ENV_CONF_LIST`: Customized list of account configuration files. 
- `SANDBOX_ADD_ON_GROUPS`: Customized list of groups that each sandbox account would be added to. Note that the common sandbox group named by `SANDBOX_USERNAME_INIT` (or `DEFAULT_USERNAME_INIT` by default) should be excluded.
- `SANDBOX_USERNAME_INIT`: Customized initial string of username of sandbox account. It is also used to name the common sandbox group. 
- `SANDBOX_PASSWORD_INIT`: Customized initial string of password of sandbox account.

Settings specified by these `SANDBOX_` environment variables are prioritized over their default configuration counterparts. In other words, once a `SANDBOX_` environment variable is set, the corresponding `DEFAULT_` setting would be ignored. 
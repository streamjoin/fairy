# Managing Sandbox Accounts #

Currently, sandbox is account based. The development environment is shared among all the sandbox accounts. 

## Creating Account ##

Administrator can create a new account using `add_account` which takes an ID as parameter. For example, 

    $ add_account 00
    account 'sandbox-00' has been created successfully

Default password for the generated account is `sb<ID>`. A randomly generated SSH private key is copied to `$HOME/sandbox/private_keys`, and the corresponding public key is activated for the account. `HOME` refers to the home folder of the administrator account. 

Once the account is created, administrator can pass the account name (e.g. `sandbox-00`) and the private key (e.g. `sandbox-00.pem`) to user for login. 

## Managing Account ##

The following scripts are used for sandbox account management: 

- `ls_account`: List all sandbox accounts. 
- `chg_password <ID> <Password>`: Update the password of a sandbox account. 
- `del_account <ID>`: Delete a sandbox account. Note that the associated private key will be also deleted. 

Note that all the above scripts (including `add_account`) must be run by administrator who has the `sudo` privilege. 

## Customization ##

By default, the above scripts load configuration from `conf/account_script.conf.default` whose path is *hard-coded* as the `DEFAULT_ACCOUNT_SCRIPT_CONF` variable in the common script `lib/load_script_conf.sh`. The default configuration contains settings of the following variables: 

- `DEFAULT_PEM_HOME`: Default folder used to store private keys associated with active sandbox accounts.
- `DEFAULT_USER_HOME_ROOT`: Default common parent folder of home folders of sandbox accounts. 
- `DEFAULT_ENV_CONF_REF_ROOT`: Default folder containing the account configuration files. 
- `DEFAULT_ENV_CONF_LIST`: Default list of account configuration files such as `.bashrc`, `.bash_profile`, `.profile` and `.vimrc`. As long as these configuration files exist in the folder specified by `ACCOUNT_ENV_CONF_REF_ROOT` (or `DEFAULT_ENV_CONF_REF_ROOT` by default), they will be copied to the home folder of sandbox account upon account creation. Any missing of configuration file will cause the corresponding initialization of configuration for the sandbox account to be omitted.
- `DEFAULT_ADD_ON_GROUPS`: Default list of groups that each sandbox account would be added to. If any group does not exist, it will be created automatically along with the execution of `add_account`. Note that each sandbox account is implicitly added to the group named by `ACCOUNT_USERNAME_INIT` (or `DEFAULT_USERNAME_INIT` by default), which is referred as the *common sandbox group*. Therefore, this variable should list the groups other than the common sandbox group. 
- `DEFAULT_USERNAME_INIT`: Default initial string of username of sandbox account. This variable also defines the name of the common sandbox group. 
- `DEFAULT_PASSWORD_INIT`: Default initial string of password of sandbox account. 

Generally, there are two ways to change the script configuration without modifying the scripts. 

### Using Customized Default Configuration ### 

By all means, it is *not recommended* to edit the `account_script.conf.default` file. Instead, you are suggested to copy it out, e.g. saved as `account_script.conf`, and further make changes in `account_script.conf`. Once the customization is done, set the environment variable `ACCOUNT_SCRIPT_CONF` to refer to the path of the customized configuration file. For example, 

    export ACCOUNT_SCRIPT_CONF="/path/to/account_script.conf"

Then use the sandbox scripts as usual and the customized configuration should take effect. Basically, for loading default configuration, each sandbox script first looks for `ACCOUNT_SCRIPT_CONF` (environment variable) and, if not found, falls back to `DEFAULT_ACCOUNT_SCRIPT_CONF` (script-scoped variable). 

### Setting Customized Environment Variable ###

The following environment variables starting with `ACCOUNT_` correspond to the aforementioned variables starting with `DEFAULT_`: 

- `ACCOUNT_PEM_HOME`: Customized folder used to store private keys associated with active sandbox accounts.
- `ACCOUNT_USER_HOME_ROOT`: Customized common parent folder of home folders of sandbox accounts.
- `ACCOUNT_ENV_CONF_REF_ROOT`: Customized folder containing the account configuration files.
- `ACCOUNT_ENV_CONF_LIST`: Customized list of account configuration files. 
- `ACCOUNT_ADD_ON_GROUPS`: Customized list of groups that each sandbox account would be added to. Note that the common sandbox group named by `ACCOUNT_USERNAME_INIT` (or `DEFAULT_USERNAME_INIT` by default) should be excluded.
- `ACCOUNT_USERNAME_INIT`: Customized initial string of username of sandbox account. It is also used to name the common sandbox group. 
- `ACCOUNT_PASSWORD_INIT`: Customized initial string of password of sandbox account.

Settings specified by these `ACCOUNT_` environment variables are prioritized over their default configuration counterparts. In other words, once a `ACCOUNT_` environment variable is set, the corresponding `DEFAULT_` setting would be ignored. 

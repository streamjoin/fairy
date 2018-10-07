# Managing Sandbox Accounts #

Current sandbox is account based. The development environment is shared among all the sandbox accounts. 

## Creating Account ##

Create a new account using `add_sandbox_account` which takes an ID as parameter. For example, 

    $ add_sandbox_account 0000
    account 'sandbox0000' has been created successfully

Initial password for the generated account is `sb<ID>`. A randomly generated SSH private key is copied to `/home/ubuntu/sandbox_private_keys`, and the corresponding public key is activated for the account. 

Once the account is created, administrator can pass the account name (e.g. `sandbox0000`) and the private key (e.g. `sandbox0000.pem`) to user for login. 

## Managing Account ##

The following scripts are used for sandbox account management: 

1. `ls_sandbox_accounts`: list all sandbox accounts. 
2. `chg_sandbox_account_password <ID> <Password>`: update the password of a sandbox account. 
3. `del_sandbox_account <ID>`: delete a sandbox account. Note that the associated private key will be also deleted. 

----

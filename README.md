update_ssh_personal_environment(1) -- Copy personal environment through SSH connections
================================================================================

## SYNOPSIS

`update_ssh_personal_environment` [--debug] [file|pattern ...]

## DESCRIPTION

Pack files given in `SSH_PERS_ENV_FILES` together with those given as arguments into a tar.gz archive and store the result in the `SSH_PERS_ENV_DATA` environment variable.

## CONFIGURATION

SSH personal environment can be configured via environment variables:

  * `SSH_PERS_ENV_FILES`:
    List of files or directories to copy. Relative paths are relative to your HOME directory. Can contain shell patterns.

  * `SSH_PERS_ENV_DEBUG`:
    Optional variable. Non-empty value enables debug output, both on sending and receiving side.

  * `SSH_PERS_ENV_DATA`:
    This environment variable contains the actual data as base64 encoded tar.gz archive.

## INSTALLATION

On Debian/Ubuntu simply build and install the DEB package. 

Everywhere else please follow these manual steps:

  1. Copy sshrc.sh to /etc/ssh/sshrc
  2. Copy ssh_personal_environment.sh to /etc/profile.d/ssh_personal_environment.sh
  3. Add this to /etc/ssh/sshd_config and restart the SSH service: AcceptEnv SSH_PERS_ENV_DATA SSH_PERS_ENV_FILES SSH_PERS_ENV_DEBUG
  4. Add this to /etc/ssh/ssh_config: SendEnv SSH_PERS_ENV_DATA SSH_PERS_ENV_FILES SSH_PERS_ENV_DEBUG

And please submit a pull request with packaging automation for your environment.

## NOTES

`update_ssh_personal_environment` is a shell function because it modifies the environment of your shell.

The size of data that can be transferred is limited. To find out how much random data your system can transfer, you can use the `determine_maximum_transfer_size.sh` script to test your system:

```
$ MIN=90 STEP=1 ./determine_maximum_transfer_size.sh ubuntu@ec2-54-154-241-31.eu-west-1.compute.amazonaws.com
TESTING 90 KB
TESTING 91 KB
TESTING 92 KB
TESTING 93 KB
TESTING 94 KB
TESTING 95 KB
FAILED to transfer 95 KB, safe size is 94 KB
```

## DEVELOPMENT

To build simply run `make deb` from the source distribution.
Build Requirements are debuild(1) and [ronn](http://rtomayko.github.io/ronn/).
 

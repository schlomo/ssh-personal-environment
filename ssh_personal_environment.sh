update_ssh_personal_environment() {
    if [ $# -gt 0 -a "$1" = "--debug" ] ; then
        export SSH_PERS_ENV_DEBUG=1
        shift
    fi
    if test -n "$SSH_PERS_ENV_FILES" -o "$#" -gt 0  ; then
        export SSH_PERS_ENV_FILES=$(eval echo $@ $SSH_PERS_ENV_FILES | tr " " "\n" | sort -u | tr "\n" " ") # pattern expansion
        test "${SSH_PERS_ENV_DEBUG:-}" && echo "Packing as SSH Personal Environment: $SSH_PERS_ENV_FILES" 1>&2
        export SSH_PERS_ENV_DATA=$(tar -C ~ -cz $SSH_PERS_ENV_FILES | base64)
    fi
}
update_ssh_personal_environment

# vim:autoindent:tabstop=4:shiftwidth=4:expandtab:softtabstop=4:

#!/bin/sh
# this must be strictly POSIX sh compatible
if which xauth >/dev/null 2>&1 && read proto cookie && test "$DISPLAY" ; then
        if test "$(expr substr "$DISPLAY" 1 10)" = localhost: ; then
                # X11UseLocalhost=yes
                echo add unix:"$(expr substr "$DISPLAY" 11 99)" $proto $cookie
        else
                # X11UseLocalhost=no
                echo add "$DISPLAY" $proto $cookie
        fi | xauth -q -
fi
 
# unpack personal environment
if test "$SSH_PERS_ENV_DATA" ; then
    test "$SSH_PERS_ENV_DEBUG" && echo "Unpacking SSH Personal Environment Data..."
    echo "$SSH_PERS_ENV_DATA" | base64 -d | tar ${SSH_PERS_ENV_DEBUG:+-v} -xzC ~
fi

# vim:autoindent:tabstop=4:shiftwidth=4:expandtab:softtabstop=4:

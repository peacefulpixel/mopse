#!/bin/awk -f

BEGIN {
    decl_consts()

    __VERBOSE = 1

    Mode = MODE_EC
}

# Skipping empty lines
/^[ \t]*$/ { next }

Mode == MODE_RT {
    Rt_readline()
}

Mode == MODE_EC && /^plug( .*)?$/ {
    Com = COM_PLUG
    Mode_set_rt()

    if (NF == 1) next

    shift()
    Rt_readline(1)
}

Mode == MODE_EC && /^set( .*)?$/ {
    Com = COM_SET
    Mode_set_rt()

    if (NF == 1) next
}

END {
    print XML_make_tag(Rt_tree)
}
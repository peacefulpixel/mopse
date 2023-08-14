################################################################################
# > main.awk                                                                   #
# The root of the program. Contains BEGIN, END and all the pattern/condition   #
# matchers. In other words, this file declares everything order-sensetive,     #
# because project building doesn't consider the source files order, so any     #
# other src/ file will contain only functions.                                 #
################################################################################

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
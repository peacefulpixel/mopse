################################################################################
# > main.awk                                                                   #
# The root of the program. Contains BEGIN, END and all the pattern/condition   #
# matchers. In other words, this file declares everything order-sensetive,     #
# because project building doesn't consider the source files order, so any     #
# other src/ file will contain only functions.                                 #
################################################################################

BEGIN {
    Const_decl()

    __VERBOSE = 1 # TODO: Remove

    Arr_def(C_put_data)

    Mode = MODE_EC
}

# Skipping empty lines and comments
/^[ \t#]*$/ { next }

Mode == MODE_RT {
    Rt_readline()
}

Mode == MODE_EC && /^put( .*)?$/ {
    Rt_begin(COM_PUT, C_put_data)
}

END {
    print XML_make_tag(Rt_tree)
}
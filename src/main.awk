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
    Arr_def(C_set_data)
    Arr_def(C_dep_data)

    Mode = MODE_EC
}

# Skipping empty lines and comments
/^[ \t]*$/ || /^#.*$/ { debug("Skipping empty line or comment"); next }

Mode == MODE_RT {
    if (/^[^ \t]+/) {
        Mode_set(MODE_EC, "")
    } else Rt_readline()
}

Mode == MODE_EC && /^put( .*)?$/ {
    Rt_begin(COM_PUT, "C_put_data")
}

Mode == MODE_EC && /^set( .*)?$/ {
    Rt_begin(COM_SET, "C_set_data")
}

Mode == MODE_EC && /^dep( .*)?$/ {
    Rt_begin(COM_DEP, "C_dep_data")
}

END {
    print XML_make_tag(Rt_tree)
}
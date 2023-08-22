################################################################################
# > main.awk                                                                   #
# The root of the program. Contains BEGIN, END and all the pattern/condition   #
# matchers. In other words, this file declares everything order-sensetive,     #
# because project building doesn't consider the source files order, so any     #
# other src/ file will contain only functions.                                 #
################################################################################

BEGIN {
    Const_decl()

    __VERBOSE = 0 # TODO: Remove

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

function printGenericTag(c_data,    i, x) {
    for (i in c_data) {
        if (c_data[i]["NAME"] == "$ROOT") {
            for (x = 1; x in c_data[i]; x++) {
                print XML_make_tag(c_data[i][x])
            }
        } else
            print XML_make_tag(c_data[i])
    }
}

END {
    print Const_hedaer()

    if (Arr_length(C_put_data) > 0) {
        printGenericTag(C_put_data)
    }

    if (Arr_length(C_set_data) > 0) {
        print "<properties>"
        printGenericTag(C_set_data)
        print "</properties>"
    }

    if (Arr_length(C_dep_data) > 0) {
        print "<dependencies>"
        printGenericTag(C_dep_data)
        print "</dependencies>"
    }

    print Const_footer()
}
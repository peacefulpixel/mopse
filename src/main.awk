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

    Arr_def(MODE_TAB)

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
    Rt_begin(COM_PUT)
}

Mode == MODE_EC && /^set( .*)?$/ {
    Rt_begin(COM_SET)
}

Mode == MODE_EC && /^dep( .*)?$/ {
    Rt_begin(COM_DEP)
}

function printGenericTag(c_data,    i, x) {
    for (i = 1; i <= Arr_sub_length(MODE_TAB, c_data); i++) {
        if (MODE_TAB[Arr_mdkey(c_data, i, "NAME")] == "$ROOT") {
            for (x = 1; Arr_mdkey(c_data, i, x) in MODE_TAB; x++) {
                print XML_make_tag(MODE_TAB, Arr_mdkey(c_data, i, x))
            }
        } else
            print XML_make_tag(MODE_TAB, Arr_mdkey(c_data, i))
    }
}

END {
    print Const_hedaer()

    if (Arr_sub_length(MODE_TAB, COM_PUT) > 0) {
        printGenericTag(COM_PUT)
    }

    if (Arr_sub_length(MODE_TAB, COM_SET) > 0) {
        print "<properties>"
        printGenericTag(COM_SET)
        print "</properties>"
    }

    if (Arr_sub_length(MODE_TAB, COM_DEP) > 0) {
        print "<dependencies>"
        printGenericTag(COM_DEP)
        print "</dependencies>"
    }

    print Const_footer()
}
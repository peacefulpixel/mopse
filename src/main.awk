#!/bin/awk -f

function Mode_set_rt() {
    Mode = MODE_RT

    delete Rt_tree      # Actual tree of values
    Rt_stackp = 0
}


function Rt_really_put(tag, val, arr, idx) {
    if (val) { # Tag has text value, so no other children here
        debug("Rt_really_put: END")
        arr[idx] = tag SUBSEP val
    } else {   # Tag is empty for now, might have children in future
        debug("Rt_really_put: EMPTY")
        arr[idx]["NAME"] = tag
        arr[idx]["LEN"] = "NONE"
    }
}

function Rt_put(tag, val, len, arr,   x) {
    x = arr_length(arr)
    debug("Rt_put: tag=" tag " val=" val " len=" len " x=" x)

    if (arr["LEN"] == "NONE")
        arr["LEN"] = len

    if (x < 1) { # If current branch has no items at all
        Rt_really_put(tag, val, arr, 1)
    } else if (isarray(arr[x])) { # If last item of branch is also a branch
        if (! "LEN" in arr) fail("Fatal processing error #4001")
        if (arr["LEN"] < len) { # If branch nesting is less then current item nesting
            Rt_put(tag, val, len, arr[x]) # Trying to put to child branch
        } else {
            if (arr["LEN"] != len) fail("Invalid nesting #1002")
            Rt_really_put(tag, val, arr, ++x) # If nesting is same, put tag as following
        }
    } else {
        if (arr["LEN"] != len) fail("Invalid nesting #1003")
        Rt_really_put(tag, val, arr, ++x) # If nesting is same, put tag as following
    }
}

function Rt_readline(   len, x, _rest) {
    if (NF < 1) fail("Unable to read tag/tags from line #1001")

    len = ws_cnt()
    debug("Rt_readline: len=" len)

    if (Rt_stackp == 0) {
        Rt_tree["NAME"] = "$ROOT"
        Rt_tree["LEN"] = "NONE"
        Rt_stackp++
    }

    for (x = 2; x <= NF; x++) {
        _rest[x - 1] = $(x)
    }

    print "s" $1 "s" $2 "d" $3

    debug("Rt_readline: _rest=" length(_rest) " tag=" $1)

    if (length(_rest)) Rt_put($1, str_join(_rest, SUBSEP), len, Rt_tree)
    else Rt_put($1, "", len, Rt_tree)
}

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
    Rt_readline()
}

Mode == MODE_EC && /^set( .*)?$/ {
    Com = COM_SET
    Mode_set_rt()

    if (NF == 1) next
}

END {
    print XML_make_tag(Rt_tree)
}
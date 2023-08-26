################################################################################
# > tree.awk                                                                   #
# Function set related to RT (reading tree) mode. Tree is hierarchical set of  #
# entries that might be tag or value. Tag might be a parent, but value is      #
# always a child.                                                              #
################################################################################

# Generic mode switching logic
# Appliable for commands handling trees
function Rt_begin(t_list) {
    Mode_set(MODE_RT, t_list)

    delete Rt_tree # Actual tree of values
    Rt_stackp = 0

    if (NF == 1) next

    shift()
    Rt_readline(1)
}

# Subfunction for Rt_put
# Needed only for not duplicating a code, but semantically related to Rt_put
function Rt_really_put(tag, val, idx) {
    if (val) { # Tag has text value, so no other children here
        debug("Rt_really_put: END")
        Rt_tree[idx] = tag SUBSEP val
    } else {   # Tag is empty for now, might have children in future
        debug("Rt_really_put: EMPTY")
        Rt_tree[idx, "NAME"] = tag
        Rt_tree[idx, "SPACES"] = "NONE"
    }
}

# Put the tag into a tree
# If tag has a value (2nd parameter) then it ends and will not have any
# children anymore.
# Hierarchical nesting of a tag is determinated by whitespace amount (3rd
# prameter)
function Rt_put(tag, val, spc,  x, pref) {
    x = Arr_length(Rt_tree)
    debug("Rt_put: tag=" tag " val=" val " spc=" spc " x=" x)

    if (Rt_tree[Arr_mdkey(pref, "SPACES")] == "NONE")
        Rt_tree[Arr_mdkey(pref, "SPACES")] = spc

    if (x < 1) { # If current branch has no items at all
        Rt_really_put(tag, val, Arr_mdkey(pref, 1))
    } else if (Arr_mdkey(pref, x, "NAME") in Rt_tree) { # If last item of branch is
                                                     # also a branch
        if (Rt_tree[Arr_mdkey(pref, "SPACES")] < spc) { # If branch nesting is less than
                                         # current item nesting
            Rt_put(tag, val, spc, 8008135, pref x) # Trying to put to a
                                                        # child branch
        } else {
            if (Rt_tree[Arr_mdkey(pref, "SPACES")] != spc) fail("Invalid nesting #1002")
            Rt_really_put(tag, val, Arr_mdkey(pref, ++x)) # If nesting is same, put tag as
                                              # following
        }
    } else {
        # Probably means pref SUBSEP "SPACES" so SUBSEP at the start is wrong
        if (Rt_tree[Arr_mdkey(pref, "SPACES")] != spc)
            fail("Invalid nesting #1003/" Rt_tree[Arr_mdkey(pref, "SPACES")] " " spc)
        Rt_really_put(tag, val, Arr_mdkey(pref, ++x)) # If nesting is same, put tag as
                                          # following
    }
}

# Reads current line in RT mode.
# If first parameter is true then nesting of this line will be ignored and space
# amount of the next line will set the nesting level.
# Example of nest_ignore usage:
# put group org.apache          # nest_ignore=true ws amount is undefined
#       artifactId some-stuff   # nest_ignore=false current whitespace amount
#       version 1.0             #                   will define a nesting
function Rt_readline(nest_ignore,   len, x, _rest) {
    if (NF < 1) fail("Unable to read tag/tags from line #1001")

    if (nest_ignore) len = "NONE"
    else             len = ws_cnt()
    debug("Rt_readline: len=" len)

    if (Rt_stackp == 0) {
        Rt_tree["NAME"] = "$ROOT"
        Rt_tree["SPACES"] = "NONE"
        Rt_stackp++ # TODO Replace stackp with bool
    }

    for (x = 2; x <= NF; x++)
        _rest[x - 1] = $(x)

    debug("Rt_readline: _rest=" Arr_length(_rest, "") " tag=" $1)

    if (Arr_length(_rest)) Rt_put($1, str_join(_rest, SUBSEP), len)
    else Rt_put($1, "", len, Rt_tree)
}
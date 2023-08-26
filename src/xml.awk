###############################################################################
# > xml.awk                                                                   #
# An utility set that convers different things to XML string                  #
# Core entry point is XML_make_tag()                                          #
###############################################################################

# Creates XML from tag tree or tag-value pair
# Expecting format for pair is "tag" SUBSEP "value"
function XML_make_tag(array, key) {

    if (Arr_mdkey(key, "SPACES") in array)
            return INTERNAL_XML_make_tag_node(array, key)
    else    return INTERNAL_XML_make_tag_single(array, key)
}

function INTERNAL_XML_make_tag_node(array, key,     x, res) {

    if (! Arr_mdkey(key, "NAME") in array) {
        print "Feature is not supported yet #867172"
    }

    debug("INTERNAL_XML_make_tag_node " array[Arr_mdkey(key, "NAME")] " %% " \
        array[Arr_mdkey(key, "SPACES")])

    res = ""
    for (x = 1; Arr_mdkey(key, x, "SPACES") in array ||
                Arr_mdkey(key, x) in array; x++) {

        res = res XML_make_tag(array, Arr_mdkey(key, x))
    }

    return  "<" array[Arr_mdkey(key, "NAME")] ">" ORS res "</" \
            array[Arr_mdkey(key, "NAME")] ">" ORS
}

function INTERNAL_XML_make_tag_single(array, key,   buf, entry) {
    entry = array[key]
    debug("INTERNAL_XML_make_tag_single " entry)

    if (split(entry, buf, SUBSEP) > 1) {
        return "<" buf[1] ">" buf[2] "</" buf[1] ">" ORS1
    }

    if (length(entry) < 1) return ""

    fail("Feature is not supported yet #262392")
}
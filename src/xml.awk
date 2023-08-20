###############################################################################
# > xml.awk                                                                   #
# An utility set that convers different things to XML string                  #
# Core entry point is XML_make_tag()                                          #
###############################################################################

# Converts array or string to an XML
# Expecting format for string is "tag" SUBSEP "value"
function XML_make_tag(thing) {

    if (isarray(thing)) return INTERNAL_XML_make_tag_node(thing)
    else                return INTERNAL_XML_make_tag_single(thing)
}

function INTERNAL_XML_make_tag_node(node,   x, res) {

    if (!"LEN" in node) {
        fail("Invalid node")
    }

    if (!"NAME" in node) {
        print "Feature is not supported yet #867172"
    }

    debug("INTERNAL_XML_make_tag_node " node["NAME"] " %% " node["LEN"])

    res = ""
    for (x = 1; isarray(node[x]) || node[x]; x++) {
        res = res XML_make_tag(node[x])
    }

    return "<" node["NAME"] ">" ORS INTERNAL_XML_tab(res) "</" node["NAME"] ">"
            ORS
}

function INTERNAL_XML_make_tag_single(entry,    buf) {

    debug("INTERNAL_XML_make_tag_single " entry)

    if (split(entry, buf, SUBSEP) > 1) {
        return "<" buf[1] ">" buf[2] "</" buf[1] ">" ORS1
    }

    if (length(entry) < 1) return ""

    fail("Feature is not supported yet #262392")
}

function INTERNAL_XML_tab(xml,  buf, x, l) {
    l = split(xml, buf, ORS)
    xml = ""
    for (x = 0; x < l; x++)
        xml = xml "  " buf[x + 1] ORS

    return xml
}

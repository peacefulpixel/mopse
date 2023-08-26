function Const_decl() {

    # Available commands. Used for store trees for each command
    COM_SET  = "COMMAND_SET"
    COM_PLUG = "COMMAND_PLUG"
    COM_PUT  = "COMMAND_PUT"
    COM_DEP  = "COMMAND_DEP"

    # Modes of parser
    MODE_EC="MODE_EXPECTING_COMMAND"
    MODE_RT="MODE_READING_TAGTREE"
    MODE_RV="MODE_READING_VALUES"
}

# Creates a pom.xml header
# Also declares a module version
# TODO: support different versions
function Const_hedaer() {
    return  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" ORS \
            "<project xmlns=\"http://maven.apache.org/POM/4.0.0\"" ORS \
            "         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" \
            ORS \
            "         xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0\"" \
            ORS \
            "         http://maven.apache.org/xsd/maven-4.0.0.xsd\">" ORS \
            "    <modelVersion>4.0.0</modelVersion>" ORS \
}

# Creates a pom.xml file footer
function Const_footer() {
    return ORS "</project>"
}
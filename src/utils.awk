###############################################################################
# > utils.awk                                                                 #
# An utility set which is not directly related to the processing logic which  #
# means it has no external dependencies. You can copy and use this file in    #
# any of your projects.                                                       #
###############################################################################

# Shift all the parameters one step left and decreases an NF
# Note that $0 will never by changed by that
function shift() {
    if (NF > 1) {
        for (_x = 2; _x <= NF; _x++) {
            $(_x - 1) = $(_x)
        }
    }

    NF--
}

# Counts all the spaces or tabs at the start of the line.
# Each tab counts as single whitespace.
function ws_cnt() {
    split($0, _tmp, "[^ \t]")
    _len = length(_tmp[1])
    delete _tmp
    return _len
}

function log_error(error_msg) {
    print error_msg | "cat 1>&2"
}

function debug(msg) {
    if (__VERBOSE == 1)
        print "[DEBUG] " NR " >> " msg
}

function fail(error_msg) {
    log_error("Error at " NR ": " error_msg "\nLine: " $0)
    exit 1
}

# Joins all the elements of INTEGER INDEXED array from 0 or 1 to the end
# Returns the joined string
function str_join(arr, delimiter,   x, len, res) {
    len = Arr_length(arr)

    if (0 in arr) x = 0
    else x = 1

    if (len < 1) return ""
    if (len < 2) return arr[x]

    res = arr[x++]
    for (; x in arr; x++) {
        res = res delimiter arr[x]
    }

    return res
}
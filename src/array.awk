# TODO DOC

function Arr_def(_array) {
    _array[""] = ""
    delete _array[""]
}

function Arr_length(array,  x) {
    for (x = 1; x in array; x++) {}
    return x - 1
}

function Arr_sub_length(array, prefix,  x) {
    for (x = 1; INTERNAL_Arr_has_key_like(array, Arr_mdkey(prefix, x)); x++) {}
    return x - 1
}

# Internal function for Arr_sub_length
# Checks does the array has a key that starts with a "like" parameter
function INTERNAL_Arr_has_key_like(array, like,     k) {

    for (k in array)
        if (substr(k, 0, length(like)) == like)
            return 1

    return 0
}

function Arr_copy(src, dst, dst_addr,   i) {
    for (i in src)
        dst[dst_addr, i] = src[i]
}

# Creates a key for multidimentional array
# Not adds empty items to the final key, so not adding SUBSEPs
# May be built of 5 items at most
function Arr_mdkey(d1, d2, d3, d4, d5,  res) {
    if (d1) res = d1
    if (d2) { if (res) res = res SUBSEP d2; else res = d2 }
    if (d3) { if (res) res = res SUBSEP d3; else res = d3 }
    if (d4) { if (res) res = res SUBSEP d4; else res = d4 }
    if (d5) { if (res) res = res SUBSEP d5; else res = d5 }

    return res
}

function Arr_mdprint(array,     k) {
    for (k in array)
        print k "=" array[k]
}

function Arr_print_full(arr, pre,   x) {
    for (x in arr) {
        if (isarray(arr[x])) Arr_print_full(arr[x], pre " " x)
        else print pre x "=" arr[x]
    }
}
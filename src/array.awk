function Arr_def(_array) {
    _array[""] = ""
    delete _array[""]
}

function Arr_length(_array,  x) {
    for (x = 1; x in _array; x++) {}
    return x - 1
}

function Arr_sort_begin() {
    if ("sorted_in" in PROCINFO && ! PROCINFO_ORIGINAL_SORTING)
        PROCINFO_ORIGINAL_SORTING = PROCINFO["sorted_in"]

    PROCINFO["sorted_in"] = "@ind_num_asc"
}

function Arr_sort_end() {
    if (PROCINFO_ORIGINAL_SORTING)
        PROCINFO["sorted_in"] = PROCINFO_ORIGINAL_SORTING
    else PROCINFO["sorted_in"] = "@unsorted"

    PROCINFO_ORIGINAL_SORTING = ""
}

function Arr_print_full(arr, pre,   x) {
    for (x in arr) {
        if (isarray(arr[x])) Arr_print_full(arr[x], pre " " x)
        else print pre x "=" arr[x]
    }
}
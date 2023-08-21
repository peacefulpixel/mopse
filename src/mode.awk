
function Mode_set(mode, t_list_name) {
    debug("Mode_set: " Mode " > " mode)

    if (Mode && Mode != MODE_EC)
        Mode_flush()

    Mode_current_list = t_list_name
    Mode = mode
}

function Mode_flush(    len) {
    if (!Mode_current_list)
        log_error("Unexpected state #6818")

    if (Mode == MODE_RT) {
        len = Arr_length(SYMTAB[Mode_current_list])
        SYMTAB[Mode_current_list][len + 1][""] = "" # Special declaration for
                                                    # SYMTAB
        Arr_copy(Rt_tree, SYMTAB[Mode_current_list][len + 1])
    } else if (Mode == MODE_RV) {
        fail("Not supported yet #5512225")
    } else {
        fail("Unknown mode: " Mode)
    }
}

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
        len = Arr_sub_length(MODE_TAB, Mode_current_list)
        Arr_copy(Rt_tree, MODE_TAB, Mode_current_list SUBSEP len + 1)
    } else if (Mode == MODE_RV) {
        fail("Not supported yet #5512225")
    } else {
        fail("Unknown mode: " Mode)
    }
}

function Mode_set(mode, t_list) {
    debug("Mode_set: " Mode " > " mode)

    if (Mode && Mode != MODE_EC)
        Mode_flush(t_list)

    Mode = mode
}

function Mode_flush(t_list,    len) {
    if (Mode == MODE_RT) {
        len = Arr_length(t_list)
        t_list[len + 1] = Rt_tree
    } else if (Mode == MODE_RV) {
        fail("Not supported yet #5512225")
    } else {
        fail("Unknown mode: " Mode)
    }
}
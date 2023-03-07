function check_error(error_code)
    error_code == RPR_SUCCESS && return
    return error("Error code returned: $(error_code)")
end

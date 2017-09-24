

const c_types = Dict(
    "char" => "Cchar",
    "unsigned char" => "Cuchar",
    "int" => "Cint",
    "unsigned int" => "Cuint",
    "long" => "Clong",
    "unsigned long" => "Culong",
    "short" => "Cshort",
    "unsigned short" => "Cushort",
    "float" => "Cfloat",
    "double" => "Cdouble",
    "short int" => "Cshort",
    "long long" => "Clonglong",
    "long int" => "Int64",
    "long unsigned int" => "UInt64",
    "short unsigned int" => "Cushort",
    "long long int" => "Int64",
    "void*" => "Ptr{Void}",
    "void" => "Void",
    "size_t" => "Csize_t",
    "void *" => "Ptr{Void}"
)

parsed_types = String[]
i = 1
function print_comment(m::RegexMatch, io)
    print(io, "#")
    for elem in m.captures
        elem != nothing && print(io, elem)
    end
    println(io)
end
function print_typedef(m::RegexMatch, io)
    typ = strip(m.captures[2])
    typ = get(c_types, typ, typ)
    println(io, "const ", m.captures[4], " = ", typ)
end
function print_define(m::RegexMatch, io)
    number = m.captures[4]
    number = replace(number, "X", "x") #there seems to be a type in the header
    println(io, "const ", m.captures[2], m.captures[3], "= ", number)
end
function print_function(m::RegexMatch, io)
    args = m.captures[3]
    names = []
    types = []
    for (i,arg) in enumerate(split(args, ","))
        isptr = false
        if contains(arg,"*")
            isptr = true
            arg = replace(arg, "*", "")
        end
        typ_name = split(strip(arg), " ")
        #remove consts
        filter!(typ_name) do x
            x!="const" && !isempty(x)
        end
        typ = typ_name[1]
        typ = get(c_types, typ, typ)
        if length(typ_name) <= 1
            name = "arg$i"
        else
            name = typ_name[2]
        end
        if isptr && !startswith(name, "out_")
            typ = "Ptr{$(typ)}"
        end

        if name == "type"
            name = "typ"
        end
        push!(names, name)
        push!(types, typ)
    end
    out_types = filter(enumerate(names)) do i_name
        i, name = i_name
        startswith(name, "out_")
    end
    out_nametype = map(out_types) do i_name
        i, name = i_name
        name, types[i]
    end
    names_arg = filter(x->!startswith(x, "out_"), names)
    out_init = ["$name = Ref{$(typ)}();" for (name, typ) in out_nametype]
    out_names = ["$(name)[]" for (name,typ) in out_nametype]
    out_expr = isempty(out_names) ? "nothing" : join(out_names, ", ")
    println(io,
    """
    function $(m.captures[2])($(join(names_arg, ", ")))
        $(join(out_init, " "))
        is_error = ccall(
            (:rpr$(m.captures[2]), firelib), rpr_int,
            ($(join(types, ", ")),),
            $(join(names, ", "))
        )
        check_error(is_error)
        $out_expr
    end
    """
    )
end


const comment_regex = r"/\*(.*)\*/|\*(.*)|//(.*)"
const function_regex = r"extern RPR_API_ENTRY[ \t]+rpr_int[ \t]+(rpr)([a-zA-Z_0-9]+)\((.*)\);"
const define_regex = r"#define (RPR_)([A-Z_\d]+)([ ]+)(.*)"
const typedef_regex = r"typedef([\t ]+)(.+)([\t ]+)(.+);"
const matchers = [
    (comment_regex, print_comment),
    (define_regex, print_define),
    (typedef_regex, print_typedef),
    (function_regex, print_function)
]
header = open("../../../Rpr/RadeonProRender.h")

jw = open(Pkg.dir("FireRender", "src", "c_interface2.jl"), "w")
println(jw, """
cd(homedir()*"/3dstuff/RadeonProRender-Baikal/Bin/Debug/x64/")
const firelib = homedir()*"/3dstuff/RadeonProRender-Baikal/Bin/Debug/x64/libRpr64D.so"
""")
println(jw, """
function check_error(error_code)
    error_code == SUCCESS && return
    ERROR_COMPUTE_API_NOT_SUPPORTED == error_code && error("ERROR_COMPUTE_API_NOT_SUPPORTED")
    ERROR_OUT_OF_SYSTEM_MEMORY == error_code && error("ERROR_OUT_OF_SYSTEM_MEMORY")
    ERROR_OUT_OF_VIDEO_MEMORY == error_code && error("ERROR_OUT_OF_VIDEO_MEMORY")
    ERROR_INVALID_LIGHTPATH_EXPR == error_code && error("ERROR_INVALID_LIGHTPATH_EXPR")
    ERROR_INVALID_IMAGE == error_code && error("ERROR_INVALID_IMAGE")
    ERROR_INVALID_AA_METHOD == error_code && error("ERROR_INVALID_AA_METHOD")
    ERROR_UNSUPPORTED_IMAGE_FORMAT == error_code && error("ERROR_UNSUPPORTED_IMAGE_FORMAT")
    ERROR_INVALID_GL_TEXTURE == error_code && error("ERROR_INVALID_GL_TEXTURE")
    ERROR_INVALID_CL_IMAGE == error_code && error("ERROR_INVALID_CL_IMAGE")
    ERROR_INVALID_OBJECT == error_code && error("ERROR_INVALID_OBJECT")
    ERROR_INVALID_PARAMETER == error_code && error("ERROR_INVALID_PARAMETER")
    ERROR_INVALID_TAG == error_code && error("ERROR_INVALID_TAG")
    ERROR_INVALID_LIGHT == error_code && error("ERROR_INVALID_LIGHT")
    ERROR_INVALID_CONTEXT == error_code && error("ERROR_INVALID_CONTEXT")
    ERROR_UNIMPLEMENTED == error_code && error("ERROR_UNIMPLEMENTED")
    ERROR_INVALID_API_VERSION == error_code && error("ERROR_INVALID_API_VERSION")
    ERROR_INTERNAL_ERROR == error_code && error("ERROR_INTERNAL_ERROR")
    ERROR_IO_ERROR == error_code && error("ERROR_IO_ERROR")
    ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE == error_code && error("ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE")
end
""")


julia_types = """
immutable _rpr_image_desc
    image_width::rpr_uint
    image_height::rpr_uint
    image_depth::rpr_uint
    image_row_pitch::rpr_uint
    image_slice_pitch::rpr_uint
end
immutable _rpr_framebuffer_desc
    fb_width::rpr_uint
    fb_height::rpr_uint
end
immutable _rpr_render_statistics
    gpumem_usage::rpr_longlong
end
immutable _rpr_image_format
    num_components::rpr_uint
    typ::rpr_component_type
end
"""
for line in readlines(header)
    if isempty(line)
        println(jw)
        continue
    end
    for (regex, f) in matchers
        m = match(regex, line)
        if m != nothing
            if m.match == "typedef rpr_uint rpr_material_node_input_info;"
                println("dunso")
                println(jw, julia_types) # needs to be manually inserted after this typedef
            end
            f(m, jw)
        end
    end
end
close(jw)

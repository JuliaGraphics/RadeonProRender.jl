using Clang.Generators

cd(@__DIR__)

include_dir = normpath(joinpath(@__DIR__, "RadeonProRenderSDK", "RadeonProRender", "inc"))
# LIBCLANG_HEADERS are those headers to be wrapped.
headers = joinpath.(include_dir, [
    "RadeonProRender_v2.h",
    "RadeonProRender_GL.h",
    "RadeonProRender_VK.h"
]

# wrapper generator options
options = load_options(joinpath(@__DIR__, "rpr.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
push!(args, "-I$include_dir")

ctx = create_context(headers, args, options)

# run generator
build!(ctx, BUILDSTAGE_NO_PRINTING)

function rewrite!(e::Expr)
    if Meta.isexpr(e, :function)
        func_args = e.args[1].args
        last_arg = func_args[end]
        body = e.args[2]
        ccall_expr = body.args[end]
        type_tuple = ccall_expr.args[4]
        new_body = if startswith(string(last_arg), "out_")
            last_type_ptr = type_tuple.args[end]
            @assert Meta.isexpr(last_type_ptr, :curly)
            @assert last_type_ptr.args[1] == :Ptr
            last_type = last_type_ptr.args[2]
            pop!(func_args) # remove from input args
            :($(last_arg) = Ref{$(last_type)}(); check_error($(ccall_expr)); return $(last_arg)[])
        elseif ccall_expr.args[3] == :rpr_status
            :(check_error($(ccall_expr)))
        else
            ccall_expr
        end
        e.args[2] = new_body
    end
    return e
end

function rewrite!(dag::ExprDAG)
    for node in get_nodes(dag)
        for expr in get_exprs(node)
            rewrite!(expr)
        end
    end
end

rewrite!(ctx.dag)

build!(ctx, BUILDSTAGE_PRINTING_ONLY)

using Clang

cd(@__DIR__)

include_dir = normpath(joinpath(@__DIR__, "RadeonProRenderSDK", "RadeonProRender", "inc"))
# LIBCLANG_HEADERS are those headers to be wrapped.
headers = [joinpath(include_dir, "RadeonProRender_v2.h")]

wc = init(; headers=headers, output_file=joinpath(@__DIR__, "api.jl"),
          common_file=joinpath(@__DIR__, "common.jl"), clang_includes=[include_dir],
          clang_args=["-I", include_dir], header_wrapped=(root, current) -> root == current,
          clang_diagnostics=true)

run(wc)

using Tar, Inflate, SHA, Downloads, CodecZlib
rpr_version = v"3.1.2"

url = "https://github.com/JuliaGraphics/RadeonProRender.jl/releases/download/binaries-v$(rpr_version)/hipbin.tar.gz"

# TODO use in a tempdir? Also, fetch specific commit
kernel_folder = joinpath(@__DIR__, "..", "..", "RadeonProRenderSDKKernels") |> normpath

exclude(path) = any(x -> endswith(path, x), [".git", ".gitattributes", "README.md"])
io = IOBuffer()
Tar.create(!exclude, kernel_folder, io)
bin = take!(io)
compressed = transcode(GzipCompressor, bin)

filename = joinpath(@__DIR__, "hipbin.tar.gz")
write(filename, compressed)
sha = bytes2hex(open(sha256, filename))
git_tree_sha1 = Tar.tree_hash(IOBuffer(bin))

Inflate.inflate_gzip(filename)

artifact = """
[hipbin]
git-tree-sha1 = $(repr(git_tree_sha1))

    [[hipbin.download]]
    url = $(repr(url))
    sha256 = $(repr(sha))
"""

write(joinpath(@__DIR__, "..", "Artifacts.toml"), artifact)

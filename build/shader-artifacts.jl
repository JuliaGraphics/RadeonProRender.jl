using Tar, Inflate, SHA, Downloads
url = "https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDKKernels/archive/e6908ad8e6d91170ece814f67cfaae8f24b3daed.tar.gz"

filename = download(url, joinpath(@__DIR__, "shader.tar.gz"))
sha = bytes2hex(open(sha256, filename))
git_tree_sha1 = Tar.tree_hash(IOBuffer(inflate_gzip(filename)))

artifact = """
[hipbin]
git-tree-sha1 = $(repr(git_tree_sha1))

    [[hipbin.download]]
    url = "https://github.com/GPUOpen-LibrariesAndSDKs/RadeonProRenderSDKKernels/archive/e6908ad8e6d91170ece814f67cfaae8f24b3daed.tar.gz"
    sha256 = $(repr(sha))
"""

write(joinpath(@__DIR__, "..", "Artifacts.toml"), artifact)

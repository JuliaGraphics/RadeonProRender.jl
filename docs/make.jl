using RadeonProRender
using Documenter

DocMeta.setdocmeta!(RadeonProRender, :DocTestSetup, :(using RadeonProRender); recursive=true)

makedocs(; modules=[RadeonProRender], authors="Simon Danisch",
         repo="https://github.com/SimonDanisch/RadeonProRender.jl/blob/{commit}{path}#{line}",
         sitename="RadeonProRender.jl",
         format=Documenter.HTML(; prettyurls=get(ENV, "CI", "false") == "true",
                                canonical="https://SimonDanisch.github.io/RadeonProRender.jl", assets=String[]),
         pages=["Home" => "index.md"])

deploydocs(; repo="github.com/SimonDanisch/RadeonProRender.jl")

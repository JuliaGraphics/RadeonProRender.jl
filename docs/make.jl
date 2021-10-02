using FireRender2
using Documenter

DocMeta.setdocmeta!(FireRender2, :DocTestSetup, :(using FireRender2); recursive=true)

makedocs(; modules=[FireRender2], authors="Simon Danisch",
         repo="https://github.com/SimonDanisch/FireRender2.jl/blob/{commit}{path}#{line}",
         sitename="FireRender2.jl",
         format=Documenter.HTML(; prettyurls=get(ENV, "CI", "false") == "true",
                                canonical="https://SimonDanisch.github.io/FireRender2.jl", assets=String[]),
         pages=["Home" => "index.md"])

deploydocs(; repo="github.com/SimonDanisch/FireRender2.jl")

using RadeonProRender
using Documenter

makedocs(;
    modules=[RadeonProRender],
    authors="Simon Danisch",
    sitename="RadeonProRender.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        size_threshold =nothing,
        canonical="https://SimonDanisch.github.io/RadeonProRender.jl",
        assets=String[]
    ),
    pages=["Home" => "index.md"]
)

deploydocs(; repo="github.com/SimonDanisch/RadeonProRender.jl")

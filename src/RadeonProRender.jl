module RadeonProRender

using GeometryBasics
using Colors
using CEnum
using RadeonProRender_jll
using Printf

assetpath(paths...) = normpath(joinpath(@__DIR__, "..", "assets", paths...))

include("LibRPR.jl")

using .RPR

include("highlevel-api.jl")
include("materials.jl")

export set!
export setradiantpower!
export setintensityscale!
export setportal!
export setalbedo!
export setturbidity!
export setscale!
export clear!
export transform!
export layeredshader
export TileIterator
export set_standard_tonemapping!
export setsubdivisions!
export setdisplacementscale!
export lookat!

export Tahoe, Northstar, Hybrid, HybridPro

end

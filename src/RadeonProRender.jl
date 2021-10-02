module RadeonProRender

using GeometryBasics
using Colors
using CEnum

include("LibRPR.jl")

using .RPR
using .RPR: RadeonProRender_v2

include("highlevel-api.jl")
# include("opengl-interop.jl")

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

end

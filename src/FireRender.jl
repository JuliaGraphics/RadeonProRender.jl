module FireRender

using CEnum

include("LibRPR.jl")
using .RPR
using .RPR: RadeonProRender_v2

include("julian_interface.jl")

export set!,
  instance,
  setradiantpower!,
  setimagepath!,
  setimage!,
  setintensityscale!,
  setportal!,
  setalbedo!,
  setturbidity!,
  setscale!,
  getbase,
  clear!,
  transform!,
  layeredshader,
  TileIterator,
  set_standard_tonemapping!,
  setsubdivisions!,
  setdisplacementscale!,
  interactive_context,
  tiledrenderloop,
  lookat!

end

module FireRender

include("c_interface.jl")

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

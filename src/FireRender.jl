module FireRender

include("c_interface.jl")

include("julian_interface.jl")

export set!, 
  instance, 
  setradiantpower!, 
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
  transform!

end
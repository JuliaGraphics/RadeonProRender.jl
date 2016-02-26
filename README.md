# FireRender

Julia wrapper for AMD's [FireRender](http://developer.amd.com/tools-and-sdks/graphics-development/firepro-sdk/amd-firerender-technology/) library.

### Installation
(Windows only for now!)
In the Julia REPL, execute

```Julia
Pkg.clone("https://github.com/JuliaGraphics/FireRender.jl.git")
Pkg.checkout("GLVisualize")
```

# Displaced surface

![cat particles](https://github.com/JuliaGraphics/FireRender.jl/blob/master/docs/surface.png?raw=true)

[video](https://vimeo.com/154175783)
[code](https://github.com/JuliaGraphics/FireRender.jl/blob/master/examples/simple_displace.jl)


# 3D wrapped surface
![surface mesh](https://github.com/JuliaGraphics/FireRender.jl/blob/master/docs/surfmesh.png?raw=true)

[video](https://vimeo.com/154174476)
[code](https://github.com/JuliaGraphics/FireRender.jl/blob/master/examples/surfacemesh.jl)


# Particles
![surface mesh](https://github.com/JuliaGraphics/FireRender.jl/blob/master/docs/carticles.png?raw=true)

[video](https://vimeo.com/154174460)
[code](https://github.com/JuliaGraphics/FireRender.jl/blob/master/examples/instancing.jl)

# Interactivity
(slow, because of my slow hardware)
![surface mesh](https://github.com/JuliaGraphics/FireRender.jl/blob/master/docs/interactive.gif?raw=true)

#TODO

Volumes, wrap more of FireRenders API, integrate seamlessly into GLVisualize

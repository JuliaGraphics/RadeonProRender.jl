using RadeonProRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
using GLWindow
const FR = RadeonProRender
w = glscreen()
# Create OpenCL context using a single GPU, which is the default
context, glframebuffer = interactive_context(w)

# Create a scene
scene = FR.Scene(context)
N = 256
const xrange = linspace(-5.0f0, 5.0f0, N)
const yrange = linspace(-5.0f0, 5.0f0, N)

z = Float32[sin(1.3 * x) * cos(0.9 * y) + cos(0.8 * x) * sin(1.9 * y) + cos(y * 0.2 * x)
            for x in xrange, y in yrange]
mini = minimum(z)
maxi = maximum(z)
const cmap = map(x -> RGBA{U8}(x, 1.0), colormap("Blues"))
to_color(val, mini, maxi) = cmap[floor(Int, (((val - mini) / (maxi - mini)) * (length(cmap) - 1))) + 1]
image = map(z) do height
    return to_color(height, mini, maxi)
end
plane = FR.Shape(context, SimpleRectangle(-5, -5, 10, 10), (N, N))
push!(scene, plane)
const t = Signal(2.0f0 * pi)
matsys = FR.MaterialSystem(context, 0)
reflective = FR.MaterialNode(matsys, FR.MATERIAL_NODE_MICROFACET)
tex = FR.MaterialNode(matsys, FR.MATERIAL_NODE_IMAGE_TEXTURE)
displace = FR.Image(context, z)
color = FR.Image(context, image)
set!(tex, "data", color)
set!(reflective, "color", tex)
set!(plane, reflective)
set!(plane, displace)
setdisplacementscale!(plane, 1.0)
setsubdivisions!(plane, 1)

preserve(map(t) do i
             z = Float32[sin(1.3 * x * i) * cos(0.9 * y * i) +
                         cos(0.8 * x * i) * sin(1.9 * y * i) +
                         cos(y * 0.2 * x * i) for x in xrange, y in yrange]
             mini = minimum(z)
             maxi = maximum(z)
             image = map(z) do height
                 return to_color(height, mini, maxi)
             end
             displace = FR.Image(context, z)
             color = FR.Image(context, image)
             set!(tex, "data", color)
             return set!(plane, displace)
         end)

camera = FR.Camera(context)
lookat!(camera, Vec3f(0, 9.5, 11), Vec3f(0), Vec3f(0, 0, 1))
FR.CameraSetFocusDistance(camera.x, 7.0f0)
FR.CameraSetFStop(camera.x, 1.8f0)

set!(scene, camera)
set!(context, scene)
ibl = FR.EnvironmentLight(context)
imgpath = joinpath("C:\\", "Program Files", "KeyShot6", "bin", "Materials 2k.hdr")
set!(ibl, context, imgpath)
set!(scene, ibl)
pl = FR.PointLight(context);
setradiantpower!(pl, fill(10.0f0^3, 3)...)
transform!(pl, translationmatrix(Vec3f(0, 0, 7)))

push!(scene, pl)

set_standard_tonemapping!(context)

frame = 1
for i in (0.5f0:0.01f0:(pi * 2.0f0))
    push!(t, i)
    yield()
    isopen(w) || break
    clear!(glframebuffer)
    for i in 1:10
        glBindTexture(GL_TEXTURE_2D, 0)
        @time render(context)
        isopen(w) || break
        GLWindow.render_frame(w)
    end
    isopen(w) || break
    try
        screenshot(w; path="test$frame.png")
    catch e
        println(e)
    end
    frame += 1
end

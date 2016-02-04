using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
const FR = FireRender

w = glscreen()
# Create OpenCL context using a single GPU
context, glframebuffer = interactive_context(w)
scene = FR.Scene(context)
set!(context, scene)
camera = FR.Camera(
	context, glframebuffer, 
	PerspectiveCamera(w.inputs, Vec3f0(3), Vec3f0(0))
)
set!(scene, camera)

DN = 512

# Load an obj
cat = FR.Shape(context, load("cat.obj"))
push!(scene, cat)
transform!(cat, translationmatrix(Vec3f0(0,0.5,0)))
# Load an obj
r = SimpleRectangle{Float32}(-5,-5, 10,10)
plane = FR.Shape(context, r, (div(DN,2),div(DN,2)))
push!(scene, plane)

matsys = FR.MaterialSystem(context, 0)
diffuse = FR.MaterialNode(matsys, FR.MATERIAL_NODE_REFLECTION)
reflective = FR.MaterialNode(matsys, FR.MATERIAL_NODE_DIFFUSE)
tex = FR.MaterialNode(matsys, FR.MATERIAL_NODE_IMAGE_TEXTURE)
set!(diffuse, "color", HSVA(181, 0.23, 0.5, 1.0)) # all colors from color package can be used

pirange = linspace(0,4pi,DN)

set!(tex, "data", context, RGBA{U8}[
    RGBA{U8}((sin(x)+1)/2, (cos(x)+1)/2, (cos(x)+1)/4, (cos(x)*sin(x)+1)/2)
    for x=pirange, y=pirange]
)
set!(reflective, "color", tex)

set!(cat, diffuse)
set!(plane, reflective)
set!(plane, context, Float32[(sin(x)*cos(y)+1)/2f0 for x=pirange, y=pirange])
setdisplacementscale!(plane, 1.0)
setsubdivisions!(plane, 1)

ibl = FR.EnvironmentLight(context)
imgpath = joinpath(homedir(), "Desktop", "FRSDK 1.078", "Resources", "Textures", "Apartment.hdr")
set!(ibl, context, imgpath)
set!(scene, ibl)

set_standard_tonemapping!(context, aacellsize=4.0, aasamples=1.0)

tiledrenderloop(w, context, glframebuffer)

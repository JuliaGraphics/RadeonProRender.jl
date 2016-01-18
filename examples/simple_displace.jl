using FireRender, GeometryTypes, GLAbstraction, FileIO, Colors
const FR = FireRender

# Create OpenCL context using a single GPU, which is the default
context = FR.Context()

# Create a scene
scene = FR.Scene(context)

# Load an obj
cat = FR.Shape(context, load("cat.obj"))
push!(scene, cat)
transform!(cat, translationmatrix(Vec3f0(0,0.5,0)))
# Load an obj
plane = FR.Shape(context, SimpleRectangle(-5,-5, 10,10))
push!(scene, plane)


matsys = FR.MaterialSystem(context, 0)
diffuse = FR.MaterialNode(matsys, FR.MATERIAL_NODE_REFLECTION)
reflective = FR.MaterialNode(matsys, FR.MATERIAL_NODE_DIFFUSE)
tex = FR.MaterialNode(matsys, FR.MATERIAL_NODE_IMAGE_TEXTURE)
set!(diffuse, "color", HSVA(181, 0.23, 0.5, 1.0)) # all colors from color package can be used

pirange = linspace(0,4pi,512)
displace = FR.Image(
	context,
	Float32[(sin(x)*cos(y)+1)/2f0 for x=pirange, y=pirange]
)
color = FR.Image(
	context,
	RGBA{U8}[RGBA{U8}((sin(x)+1)/2, (cos(x)+1)/2, (cos(x)+1)/4, (cos(x)*sin(x)+1)/2) for x=pirange, y=pirange]
)
set!(tex, "data", color)
set!(reflective, "color", tex)

set!(cat, diffuse)
set!(plane, reflective)
set!(plane, displace)
setdisplacementscale!(plane, 1.0)
setsubdivisions!(plane, 6)

camera = FR.Camera(context)
lookat(camera, Vec3f0(-3., 3., 3), Vec3f0(0), Vec3f0(0,1,0))
set!(scene, camera)
set!(context, scene)
ibl = FR.EnvironmentLight(context)
imgpath = joinpath(homedir(), "Desktop", "FRSDK 1.078", "Resources", "Textures", "Apartment.hdr")
img = FR.Image(context, imgpath)
set!(ibl, img)
set!(scene, ibl)


fb = FR.FrameBuffer(context, RGBA, (1024,1024))
set!(context, FR.AOV_COLOR, fb)
clear!(fb)

set!(context, "toneMapping.type", FR.TONEMAPPING_OPERATOR_PHOTOLINEAR);
set!(context, "tonemapping.linear.scale", 1f0);
set!(context, "tonemapping.photolinear.sensitivity", 1f0);
set!(context, "tonemapping.photolinear.exposure", 1f0);
set!(context, "tonemapping.photolinear.fstop", 1f0);
set!(context, "tonemapping.reinhard02.prescale", 1f0);
set!(context, "tonemapping.reinhard02.postscale", 1f0);
set!(context, "tonemapping.reinhard02.burn", 1f0);
set!(context, "tonemapping.linear.scale", 1f0);
set!(context, "tonemapping.linear.scale", 1f0);

set!(context, "aacellsize", 4.)
set!(context, "imagefilter.type", FR.FILTER_BLACKMANHARRIS)
set!(context, "aasamples", 4.)
println("rendering")
for i=1:16
	render(context)
end
println("rendered")
FR.save(fb, "test.png")
println("saved")



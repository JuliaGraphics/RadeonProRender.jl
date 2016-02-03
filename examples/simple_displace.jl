using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
using GLWindow
const FR = FireRender
w=glscreen()
# Create OpenCL context using a single GPU, which is the default
context = FR.Context(
	FR.API_VERSION, FR.CONTEXT_OPENCL, 
	FR.CREATION_FLAGS_ENABLE_GPU0 | FR.CREATION_FLAGS_ENABLE_GL_INTEROP
)

# Create a scene
scene = FR.Scene(context)
N = 256
const xrange = linspace(-5f0, 5f0, N)
const yrange = linspace(-5f0, 5f0, N)

z = Float32[sin(1.3*x)*cos(0.9*y)+cos(.8*x)*sin(1.9*y)+cos(y*.2*x) for x in xrange, y in yrange]
mini = minimum(z)
maxi = maximum(z)
const cmap = map(x->RGBA{U8}(x, 1.0), colormap("Blues"))
to_color(val, mini, maxi) = cmap[floor(Int, (((val-mini)/(maxi-mini))*(length(cmap)-1)))+1]
image = map(z) do height
	to_color(height, mini, maxi)
end
plane = FR.Shape(context, SimpleRectangle(-5,-5, 10,10), (N,N))
push!(scene, plane)
const t = Signal(2f0*pi)
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
	z = Float32[sin(1.3*x*i)*cos(0.9*y*i)+cos(.8*x*i)*sin(1.9*y*i)+cos(y*.2*x*i) for x in xrange, y in yrange]
	mini = minimum(z)
	maxi = maximum(z)
	image = map(z) do height
		to_color(height, mini, maxi)
	end
	displace = FR.Image(context, z)
	color = FR.Image(context, image)
	set!(tex, "data", color)
	set!(plane, displace)
end)


camera = FR.Camera(context)
lookat(camera, Vec3f0(0,9.5,11), Vec3f0(0), Vec3f0(0,0,1))
FR.CameraSetFocusDistance(camera.x, 7f0)
FR.CameraSetFStop(camera.x, 1.8f0)

set!(scene, camera)
set!(context, scene)
ibl = FR.EnvironmentLight(context)
imgpath = joinpath("C:\\","Program Files","KeyShot6","bin","Materials 2k.hdr")
img = FR.Image(context, imgpath)
set!(ibl, img)
set!(scene, ibl)
pl = FR.PointLight(context);
FR.PointLightSetRadiantPower3f(pl.x, fill(10f0^3, 3)...)

push!(scene, pl)
transform!(pl, translationmatrix(Vec3f0(0,0,7)))

set!(context, "toneMapping.type", FR.TONEMAPPING_OPERATOR_PHOTOLINEAR);
set!(context, "tonemapping.linear.scale", 1f0);
set!(context, "tonemapping.photolinear.sensitivity", 2.0f0);
set!(context, "tonemapping.photolinear.exposure", 4.5f0);
set!(context, "tonemapping.photolinear.fstop", 1f0);
set!(context, "tonemapping.reinhard02.prescale", 1f0);
set!(context, "tonemapping.reinhard02.postscale", 1f0);
set!(context, "tonemapping.reinhard02.burn", 1f0);
set!(context, "tonemapping.linear.scale", 1f0);
set!(context, "tonemapping.linear.scale", 1f0);

set!(context, "aacellsize", 4.)
set!(context, "imagefilter.type", FR.FILTER_TRIANGLE)
set!(context, "aasamples", 4.)

gl_fb = w.inputs[:framebuffer_size].value
texture = Texture(RGBA{Float16}, (gl_fb...))
view(visualize(texture), method=:fixed_pixel)
g_frame_buffer = FR.FrameBuffer(context, texture)
set!(context, FR.AOV_COLOR, g_frame_buffer)
clear!(g_frame_buffer)

println("rendering")
frame = 1
for i=(0.5f0:0.05f0:(pi*2f0))
	println(i)
	push!(t, i)
	yield()
	isopen(w) || break
	clear!(g_frame_buffer)
	for i=1:10
		glBindTexture(GL_TEXTURE_2D, 0)
		@time render(context)
		isopen(w) || break
		GLWindow.renderloop_inner(w)
	end
	isopen(w) || break
	try
		screenshot(w, path="test$frame.png")
	catch e
		println(e)
	end
	frame += 1
end



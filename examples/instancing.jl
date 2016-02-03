using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
using GLWindow
const FR = FireRender
w=glscreen()

# Create OpenCL context using a single GPU 
context = FR.Context(
	FR.API_VERSION, FR.CONTEXT_OPENCL, 
	FR.CREATION_FLAGS_ENABLE_GPU0 | FR.CREATION_FLAGS_ENABLE_GL_INTEROP
)
#set!(context, "rendermode", FR.RENDER_MODE_DIFFUSE_ALBEDO)

# Create a scene
scene = FR.Scene(context)
cat = FR.Shape(context, load("cat.obj"))

cat = GLNormalMesh(loadasset("cat.obj"))
sphere = GLNormalMesh(Sphere{Float32}(Vec3f0(0), 1f0), 12)

function scale_gen(v0, nv)
	l = length(v0)
	@inbounds for i=1:l
		v0[i] = Vec3f0(1,1,sin((nv*l)/i))/2.1
	end
	v0
end
function color_gen(v0, nv)
	l = length(v0)
	@inbounds for x=1:l
		v0[x] = RGBA{U8}(x/l,(cos(nv)+1)/2,(sin(x/l/3)+1)/2.,1.)
	end
	v0
end
const t 	= Signal(2f0*pi)
position    = sphere.vertices
scale_start = Vec3f0[Vec3f0(1,1,rand()) for i=1:length(position)]

scale 	 = foldp(scale_gen, scale_start, t)
color = foldp(color_gen, color_gen(zeros(RGBA{U8}, length(position)), value(t)), t)

rotation = -sphere.normals

instances = const_lift(GLVisualize.Instances, cat, position, scale, rotation)
matsys = FR.MaterialSystem(context, 0)
diffuse = FR.MaterialNode(matsys, FR.MATERIAL_NODE_DIFFUSE)
primitive = FR.Shape(context, cat)
push!(scene, primitive)
const fr_instances = [(i=FR.Shape(context, primitive); push!(scene, i); i) for elem in 1:(length(position)-1)]
push!(fr_instances, primitive)

const fr_shader = [FR.MaterialNode(matsys, FR.MATERIAL_NODE_REFLECTION) for elem in 1:length(position)]

for (shader, inst) in zip(fr_shader, fr_instances)
	set!(inst, shader)
end
preserve(map(instances) do i
	it = GLVisualize.TransformationIterator(i)
	for (trans, c, inst, shader) in zip(it, value(color), fr_instances, fr_shader)
		transform!(inst, trans)
		set!(shader, "color", c)
	end
end)

camera = FR.Camera(context)
set!(scene, camera)
lookat(camera, Vec3f0(2.6), Vec3f0(0), Vec3f0(0,0,1))
#FR.CameraSetFocusDistance(camera.x, 2.5)
#FR.CameraSetFStop(camera.x, 2.5f0)

set!(context, scene)
ibl = FR.EnvironmentLight(context)
imgpath = joinpath("C:\\","Program Files","KeyShot6","bin","Materials 2k.hdr")
img = FR.Image(context, imgpath)
set!(ibl, img)
set!(scene, ibl)


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
set!(context, "imagefilter.type", FR.FILTER_TRIANGLE)
set!(context, "aasamples", 4.)

# Create camera

gl_fb = w.inputs[:framebuffer_size].value
texture = Texture(RGBA{Float16}, (gl_fb...))
view(visualize(texture), method=:fixed_pixel)
g_frame_buffer = FR.FrameBuffer(context, texture)
set!(context, FR.AOV_COLOR, g_frame_buffer)
clear!(g_frame_buffer)
frame = 1
for i=(pi*2f0):0.01f0:(pi*4.0f0)
	println(i)
	push!(t, i)
	yield()
	isopen(w) || break
	clear!(g_frame_buffer)
	for i=1:12
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

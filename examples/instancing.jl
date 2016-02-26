using FireRender, GeometryTypes, GLAbstraction, GLVisualize
using GLWindow, Colors, ModernGL, FileIO, Reactive
const FR = FireRender

w=glscreen()

# create interactive context, which uses gl interop to display render result
# with opengl
context, glframebuffer = interactive_context(w)

# Create a scene
scene = FR.Scene(context)
set!(context, scene)

# create some geometry
cat    = GLNormalMesh(loadasset("cat.obj"))
sphere = GLNormalMesh(Sphere{Float32}(Vec3f0(0), 1f0), 12)

"""
Generate scales for instances
"""
function scale_gen(v0, nv)
	l = length(v0)
	for i in eachindex(v0)
		v0[i] = Vec3f0(1,1,sin((nv*l)/i))/2.1
	end
	v0
end

"""
Generate color for instances
"""
function color_gen(v0, nv)
	l = length(v0)
	for i in eachindex(v0)
		v0[i] = RGBA{U8}(i/l,(cos(nv)+1)/2,(sin(i/l/3)+1)/2.,1.)
	end
	v0
end

const t 	= Signal(2f0*pi)
position    = sphere.vertices # use sphere vertices as position
scale_start = Vec3f0[Vec3f0(1,1,rand()) for i=1:length(position)]
# create a signal of of changing scales, dependant on t
scale 	    = foldp(scale_gen, scale_start, t)
# create a signal of changing colors
color       = foldp(color_gen, color_gen(zeros(RGBA{U8}, length(position)), value(t)), t)
# use sphere normals as rotation vector
rotation    = -normals(sphere)
# create a signal of instances
instances   = const_lift(GLVisualize.Instances, cat, position, scale, rotation)

# create material system
matsys      = FR.MaterialSystem(context, 0)
diffuse     = FR.MaterialNode(matsys, FR.MATERIAL_NODE_DIFFUSE)

# create firerender shape
primitive   = FR.Shape(context, cat)
# pre allocate instances
const fr_instances = [FR.Shape(context, primitive) for i=1:(length(position)-1)]
push!(scene, primitive)
push!(fr_instances, primitive)
# pre allocate shaders
const fr_shader = [FR.MaterialNode(matsys, FR.MATERIAL_NODE_REFLECTION) for elem in 1:length(position)]

# set shaders and attach instances to scene
for (shader, inst) in zip(fr_shader, fr_instances)
	set!(inst, shader)
    push!(scene, inst)
end

# update scene with the instance signal
preserve(map(instances) do i
	it = GLVisualize.TransformationIterator(i)
	for (trans, c, inst, shader) in zip(it, value(color), fr_instances, fr_shader)
		transform!(inst, trans)
		set!(shader, "color", c)
	end
end)

# create a camera
camera = FR.Camera(context)
set!(scene, camera)

lookat!(camera, Vec3f0(2.6), Vec3f0(0), Vec3f0(0,0,1))


ibl = FR.EnvironmentLight(context)
set!(scene, ibl)
imgpath = joinpath("C:\\","Program Files","KeyShot6","bin","Materials 2k.hdr")
set!(ibl, context, imgpath)

set_standard_tonemapping!(context)


frame = 1
for i=(pi*2f0):0.01f0:(pi*4.0f0)
	push!(t, i) # push new value to t signal
	yield() # yield to actually update the scene
	isopen(w) || break
	clear!(glframebuffer)
	for i=1:2
		glBindTexture(GL_TEXTURE_2D, 0)
		@time render(context) # ray trace context
		isopen(w) || break
		GLWindow.render_frame(w) # display it by rendering glwindow
	end
	isopen(w) || break
	screenshot(w, path="test$frame.png") # save a screenshot
	frame += 1
end

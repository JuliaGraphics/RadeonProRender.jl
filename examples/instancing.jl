using FireRender, GeometryTypes, GLAbstraction, GLVisualize
using GLWindow, Colors, ModernGL, FileIO, Reactive
const FR = FireRender

w=glscreen()

context, glframebuffer = interactive_context(w)

# Create a scene
scene = FR.Scene(context)

cat    = GLNormalMesh(loadasset("cat.obj"))
sphere = GLNormalMesh(Sphere{Float32}(Vec3f0(0), 1f0), 12)

function scale_gen(v0, nv)
	l = length(v0)
	for i in eachindex(v0)
		v0[i] = Vec3f0(1,1,sin((nv*l)/i))/2.1
	end
	v0
end
function color_gen(v0, nv)
	l = length(v0)
	for i in eachindex(v0)
		v0[x] = RGBA{U8}(x/l,(cos(nv)+1)/2,(sin(x/l/3)+1)/2.,1.)
	end
	v0
end

const t 	= Signal(2f0*pi)
position    = sphere.vertices
scale_start = Vec3f0[Vec3f0(1,1,rand()) for i=1:length(position)]
scale 	    = foldp(scale_gen, scale_start, t)
color       = foldp(color_gen, color_gen(zeros(RGBA{U8}, length(position)), value(t)), t)
rotation    = -sphere.normals

instances   = const_lift(GLVisualize.Instances, cat, position, scale, rotation)
matsys      = FR.MaterialSystem(context, 0)
diffuse     = FR.MaterialNode(matsys, FR.MATERIAL_NODE_DIFFUSE)
primitive   = FR.Shape(context, cat)

const fr_instances = [FR.Shape(context, primitive) for i=1:(length(position)-1)]
push!(scene, primitive)
push!(fr_instances, primitive)

const fr_shader = [FR.MaterialNode(matsys, FR.MATERIAL_NODE_REFLECTION) for elem in 1:length(position)]

for (shader, inst) in zip(fr_shader, fr_instances)
	set!(inst, shader)
    push!(scene, inst)
end

preserve(map(instances) do i
	it = GLVisualize.TransformationIterator(i)
	for (trans, c, inst, shader) in zip(it, value(color), fr_instances, fr_shader)
		transform!(inst, trans)
		set!(shader, "color", c)
	end
end)

camera = FR.Camera(context)
lookat!(camera, Vec3f0(2.6), Vec3f0(0), Vec3f0(0,0,1))
set!(scene, camera)

set!(context, scene)

ibl = FR.EnvironmentLight(context)
imgpath = joinpath("C:\\","Program Files","KeyShot6","bin","Materials 2k.hdr")
set!(ibl, imgpath)
set!(scene, ibl)

set_standard_tonemapping!(context)


frame = 1
for i=(pi*2f0):0.01f0:(pi*4.0f0)
	push!(t, i)
	yield()
	isopen(w) || break
	clear!(glframebuffer)
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

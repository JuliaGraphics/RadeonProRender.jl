using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
const FR = FireRender
w=glscreen()

# Create OpenCL context using a single GPU 
context = FR.Context(
	FR.API_VERSION, FR.CONTEXT_OPENCL, 
	FR.CREATION_FLAGS_ENABLE_GPU0 | FR.CREATION_FLAGS_ENABLE_GL_INTEROP
)
#set!(context, "rendermode", FR.RENDER_MODE_WIREFRAME)
DN = 512
# Create a scene
scene = FR.Scene(context)

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
setsubdivisions!(plane, 1)

camera = FR.Camera(context)
set!(scene, camera)
set!(context, scene)
ibl = FR.EnvironmentLight(context)
imgpath = joinpath(homedir(), "Desktop", "FRSDK 1.078", "Resources", "Textures", "Apartment.hdr")
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

set!(context, "aacellsize", 0.)
set!(context, "imagefilter.type", FR.FILTER_TRIANGLE)
set!(context, "aasamples", 1.)

# Create camera
cam = PerspectiveCamera(w.inputs, Vec3f0(2), Vec3f0(0))

gl_fb = w.inputs[:framebuffer_size].value
texture = Texture(RGBA{Float16}, (gl_fb...))
view(visualize(texture), method=:fixed_pixel)
g_frame_buffer = FR.FrameBuffer(context, texture)
set!(context, FR.AOV_COLOR, g_frame_buffer)


preserve(map(droprepeats(cam.eyeposition)) do position
	l,u = cam.lookat.value, cam.up.value
	lookat(camera, position, l, u)
	clear!(g_frame_buffer)
end)

immutable RandomIterator{T}
	iterable::T
end
Base.start(ti::RandomIterator) = rand(1:length(ti.iterable))
Base.next(ti::RandomIterator, state) = ti.iterable[state], rand(1:length(ti.iterable))
Base.done(ti::RandomIterator, state) = false

immutable MiddleSampleIterator{T}
	iterable::T
end
function multiplier(i,j,n1,n2)
	a = abs(mod(i-div(n1,2),n1)-div(n1,2))
	b = abs(mod(j-div(n2,2),n2)-div(n2,2))
	max(a,b)
end
function Base.start(ti::MiddleSampleIterator)
	samplepool = Tuple{Int,Int}[]
	for i=1:size(ti.iterable,1)
		for j=1:size(ti.iterable,2)
			append!(samplepool, fill((i,j), multiplier(i,j,size(ti.iterable)...)))
		end
	end
	samplepool
end
function Base.next(ti::MiddleSampleIterator, state)
	i = rand(1:length(state))
	i2 = state[i]
	filter!(state) do s
		s != i2
	end
	i = sub2ind(size(ti.iterable), i2...)
	ti.iterable[i], state
end
Base.done(ti::MiddleSampleIterator, state) = isempty(state)



immutable TileIterator
	size::Vec{2, Int}
	tile_size::Vec{2, Int}
	lengths::Vec{2, Int}
end

function TileIterator(size, tile_size)
	s, ts = Vec(size), Vec(tile_size)
	lengths = Vec{2, Int}(ceil(Vec{2,Float64}(s) ./ Vec{2,Float64}(ts)))
	TileIterator(s, ts, lengths)
end

Base.size(ti::TileIterator, i) = ti.lengths[i]
Base.size(ti::TileIterator) = ti.lengths._
Base.length(ti::TileIterator) = prod(ti.lengths)

Base.start(ti::TileIterator) = 1
Base.next(ti::TileIterator, state) = ti[state], state+1
Base.done(ti::TileIterator, state) = length(ti) < state


function Base.getindex(ti::TileIterator, i,j)
	ts    = Vec(ti.tile_size)
	xymin = (Vec(i,j)-1) .* ts
	xymax = xymin + ts
	HyperRectangle(xymin, min(xymax, ti.size)-xymin)
end
function Base.getindex(ti::TileIterator, linear_index::Int)
	i,j = ind2sub(size(ti), linear_index)
	ti[i,j]
end


function prepare_gl()
	yield()
	glBindTexture(GL_TEXTURE_2D, 0)
end
function renderloop()
	const ti = TileIterator(size(texture), (256,256))
	s = start(ti)
	while isopen(w)
		prepare_gl()
		if done(ti, s)
			s = start(ti)
		end
		next_tile, s = next(ti, s)
		render(context, next_tile)
		GLWindow.renderloop_inner(w)
	end
end
renderloop()
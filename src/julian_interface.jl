using GeometryTypes, Colors, FixedSizeArrays, GLWindow, GLVisualize
using Reactive, ModernGL
import GLAbstraction: Texture, translationmatrix, scalematrix, lookat, render, std_renderobject, LazyShader
import GLAbstraction: @frag_str, @vert_str
import ModernGL: GL_TEXTURE_2D
import GLVisualize: iter_or_array

import Base: push!, delete!, get

"""
Wraps a FireRender type into a gc registered higher level type.
arguments:
`name`: name of the Julia type
`typ`: type of the FireRender object
`target`: FireRender constructor function
`args`: arguments to constructor function
`super` Julia super type
"""
macro fr_wrapper_type(name, typ, target, args, super)
	argnames = map(args.args) do x
		isa(x, Symbol) ? x : x.args[1]
	end
	esc(quote
		type $name <: $super
			x::$typ
			$name(x::$typ) = new(x)
			function $name($(argnames...))
				x = new()
				x.x = $target($(args.args...))
				finalizer(x, release)
				x
			end
		end
	end)
end

"""
All FireRender types inherit from FireRenderObj
"""
abstract FireRenderObj

@fr_wrapper_type MaterialSystem fr_material_system ContextCreateMaterialSystem (context.x, typ) FireRenderObj
@fr_wrapper_type MaterialNode fr_material_node MaterialSystemCreateNode (matsystem.x, typ) FireRenderObj
@fr_wrapper_type Camera fr_camera ContextCreateCamera (context.x,) FireRenderObj
@fr_wrapper_type Scene fr_scene ContextCreateScene (context.x,) FireRenderObj
@fr_wrapper_type Context fr_context CreateContext (api, accelerator, devices, props, cache_path) FireRenderObj

"""
Shortcut for Context creation. Leaves empty:
`props`     Context properties, reserved for future use
`cache_path`Full path to kernel cache created by FireRender, NULL means to use current folder
"""
function Context(api, accelerator, devices)
	Context(api, accelerator, devices, C_NULL, C_NULL)
end
"""
Empty constructor, defaults to using opencl and the GPU0
"""
function Context()
	Context(API_VERSION, CONTEXT_OPENCL, CREATION_FLAGS_ENABLE_GPU0)
end
"""
Constructor which only uses creation flags and defaults to opencl.
"""
function Context(creation_flags)
	Context(API_VERSION, CONTEXT_OPENCL, creation_flags)
end
"""
Abstract AbstractLight Type
"""
abstract AbstractLight <: FireRenderObj
@fr_wrapper_type EnvironmentLight fr_light ContextCreateEnvironmentLight (context.x,) AbstractLight
@fr_wrapper_type PointLight fr_light ContextCreatePointLight (context.x,) AbstractLight
@fr_wrapper_type DirectionalLight fr_light ContextCreateDirectionalLight (context.x,) AbstractLight
@fr_wrapper_type SkyLight fr_light ContextCreateSkyLight (context.x,) AbstractLight
@fr_wrapper_type SpotLight fr_light ContextCreateSpotLight (context.x,) AbstractLight


type Shape <: FireRenderObj
	x::fr_shape
	function Shape(x::fr_shape)
		inst = new(x)
		finalizer(inst, release)
		inst
	end
end

"""
Default shape constructor which works with every Geometry from the package
GeometryTypes (Meshes and geometry primitives alike).
"""
function Shape(context::Context, mesh::AbstractGeometry, args...)
	m = GLNormalUVMesh(mesh, args...)
	v, n, i, uv = vertices(m), normals(m), faces(m), texturecoordinates(m)
	vraw  = reinterpret(Float32, v, (length(v)*3,))
	nraw  = reinterpret(Float32, n, (length(n)*3,))
	uvraw = reinterpret(Float32, uv, (length(uv)*2,))
	iraw  = reinterpret(eltype(eltype(i)), i, (length(i)*3,))
	iraw  = map(fr_int, iraw)
	m = ContextCreateMesh(context.x,
		vraw, length(v), sizeof(Vec3f0),
		nraw, length(n), sizeof(Vec3f0),
		uvraw,length(uv),sizeof(Vec2f0),
		iraw, sizeof(fr_int),
		iraw, sizeof(fr_int),
		iraw, sizeof(fr_int),
		fill(fr_int(3), length(i)), length(i)
	)
	Shape(m)
end
"""
Creating a shape from a shape is interpreted as creating an instance.
"""
Shape(context::Context, shape::Shape) =
	Shape(ContextCreateInstance(context.x, shape.x))
getbase(shape::Shape) =
	Shape(InstanceGetBaseShape(shape.x))

"""
Create layered shader give two shaders and respective IORs
"""
function layeredshader(matsys, base, top, weight=(0.5, 0.5, 0.5, 1.))
	layered = MaterialNode(matsys, MATERIAL_NODE_BLEND)
	set!(layered, "color0", base)
	# Set shader for top layer
	set!(layered, "color1", top)
	# Set index of refraction for base layer
	set!(layered, "weight", weight...)
	return layered;
end

"""
FrameBuffer wrapper type
"""
type FrameBuffer <: FireRenderObj
	x::fr_framebuffer
end
function FrameBuffer{T}(context::Context, t::Texture{T, 2})
	frame_buffer = ContextCreateFramebufferFromGLTexture2D(context.x, GL_TEXTURE_2D, 0, t.id)
	x = FrameBuffer(frame_buffer)
	finalizer(x, release)
	x
end
function FrameBuffer{C<:Colorant}(context::Context, c::Type{C}, dims::NTuple{2, Int})
	desc = Ref(fr_framebuffer_desc(dims...))
	fmt = fr_image_format(length(c), COMPONENT_TYPE_FLOAT32)
	frame_buffer = ContextCreateFrameBuffer(context.x, fmt, desc)
	x = FrameBuffer(frame_buffer)
	finalizer(x, release)
	x
end

"""
Image wrapper type
"""
type Image <: FireRenderObj
	x::fr_image
end

"""
Automatically generated the correct `fr_image_format` for an array
"""
fr_image_format(a::Array) = fr_image_format(eltype(a))
function fr_image_format{T<:Union{Colorant, AbstractFloat}}(::Type{T})
	fr_image_format(
		T<:AbstractFloat ? 1 : length(T),
		component_type(T)
	)
end
"""
Gets the correct component type for Images from array element types
"""
component_type{T<:Colorant}(x::Type{T}) = component_type(eltype(T))
component_type{T<:Union{UInt8, U8}}(x::Type{T}) = COMPONENT_TYPE_UINT8
component_type{T<:Union{Float16}}(x::Type{T}) = COMPONENT_TYPE_FLOAT16
component_type{T<:Union{Float32}}(x::Type{T}) = COMPONENT_TYPE_FLOAT32

"""
Creates the correct `fr_image_desc` for a given array.
"""
function fr_image_desc{T,N}(image::Array{T, N})
	row_pitch = size(image, 1)*sizeof(T)
	Ref(fr_image_desc(
	    ntuple(i->N<i ? 0 : size(image, i), 3)...,
	    row_pitch, 0
	))
end
"""
Automatically creates an Image from a matrix of colors
"""
function Image{T, N}(context::Context, image::Array{T, N})
	img  = ContextCreateImage(
		context.x, fr_image_format(image),
		fr_image_desc(image), image
	)
	x = Image(img)
	finalizer(x, release)
	x
end
"""
Automatically loads an image from the given `path`
"""
function Image(context::Context, path::AbstractString)
	img  = ContextCreateImageFromFile(
		context.x, utf8(path)
	)
	x = Image(img)
	finalizer(x, release)
	x
end

"""
Sets the radiant power for a given Light
"""
function setradiantpower!{T}(light::AbstractLight, color::Colorant{T, 3})
    c = RGB{Float32}(color)
	setradiantpower!(light, comp1(c), comp2(c), comp3(c))
end
function setradiantpower!(
        light::PointLight,
        r::AbstractFloat, g::AbstractFloat, b::AbstractFloat
    )
    PointLightSetRadiantPower3f(light.x, fr_float(r), fr_float(g), fr_float(b))
end
function setradiantpower!(
        light::SpotLight,
        r::AbstractFloat, g::AbstractFloat, b::AbstractFloat
    )
    SpotLightSetRadiantPower3f(light.x, fr_float(r), fr_float(g), fr_float(b))
end
function setradiantpower!(
        light::DirectionalLight,
        r::AbstractFloat, g::AbstractFloat, b::AbstractFloat
    )
    DirectionalLightSetRadiantPower3f(light.x, fr_float(r), fr_float(g), fr_float(b))
end

"""
Sets the image for an EnvironmentLight
"""
function set!(light::EnvironmentLight, image::Image)
	EnvironmentLightSetImage(light.x, image.x)
end
function set!(light::EnvironmentLight, context::Context, image::Array)
	set!(light, Image(context, image))
end
function set!(light::EnvironmentLight, context::Context, path::AbstractString)
	set!(light, Image(context, path))
end

"""
Sets the intensity scale an EnvironmentLight
"""
function setintensityscale!(light::EnvironmentLight, intensity_scale::AbstractFloat)
	EnvironmentLightSetIntensityScale(light.x, fr_float(intensity_scale))
end

"""
Sets a portal for a Light
"""
function setportal!(light::AbstractLight, portal::AbstractGeometry)
	setportal!(light, Shape(portal))
end
function setportal!(light::EnvironmentLight, portal::Shape)
	EnvironmentLightSetPortal(light.x, portal.x)
end
function setportal!(light::SkyLight, portal::Shape)
	SkyLightSetPortal(light.x, portal.x)
end


"""
Sets the albedo for a SkyLight
"""
setalbedo!(skylight::SkyLight, albedo::AbstractFloat) =
	SkyLightSetAlbedo(skylight.x, fr_float(albedo))

"""
Sets the turbidity for a SkyLight
"""
setturbidity!(skylight::SkyLight, turbidity::AbstractFloat) =
	SkyLightSetTurbidity(skylight.x, fr_float(turbidity.x))

"""
Sets the scale for a SkyLight
"""
setscale!(skylight::SkyLight, scale::AbstractFloat) =
	SkyLightSetScale(skylight.x, fr_float(scale))



release(x::FireRenderObj) = ObjectDelete(x.x)

"""
"""
set!(context::Context, parameter::AbstractString, f::AbstractFloat) =
	ContextSetParameter1f(context.x, ascii(parameter), fr_float(f))
set!(context::Context, parameter::AbstractString, ui::Unsigned) =
	ContextSetParameter1u(context.x, ascii(parameter), fr_uint(ui))
set!(context::Context, aov::Unsigned, fb::FrameBuffer) =
	ContextSetAOV(context.x, fr_aov(aov), fb.x)

function set!(shape::Shape, image::Image)
	ShapeSetDisplacementImage(shape.x, image.x)
end
function set!(shape::Shape, context::Context, image::Array)
	set!(shape, Image(context, image))
end
"""
Sets arbitrary values to FireRender objects
"""
set!(context::Context, framebuffer::FrameBuffer) =
	ContextSetFrameBuffer(context.x, framebuffer.x)

function set!(
		base::MaterialNode, parameter::AbstractString,
		a::AbstractFloat, b::AbstractFloat, c::AbstractFloat, d::AbstractFloat
	)
	MaterialNodeSetInputF(
		base.x, ascii(parameter),
		fr_float(a), fr_float(b), fr_float(c), fr_float(d)
	)
end
function set!{T<:FixedVector{4}}(base::MaterialNode, parameter::AbstractString, f::T)
	set!(base.x, parameter, f...)
end
function set!{T}(base::MaterialNode, parameter::AbstractString, color::Colorant{T, 4})
	c = RGBA{Float32}(color)
	set!(base, parameter, comp1(c), comp2(c), comp3(c), alpha(c))
end
function set!(shape::Shape, material::MaterialNode)
	ShapeSetMaterial(shape.x, material.x)
end
function set!(material::MaterialNode, parameter::AbstractString, material2::MaterialNode)
	MaterialNodeSetInputN(material.x, ascii(parameter), material2.x)
end
function set!(material::MaterialNode, parameter::AbstractString, image::Image)
	MaterialNodeSetInputImageData(material.x, ascii(parameter), image.x)
end
function set!(
        material::MaterialNode, parameter::AbstractString,
        context::Context, image::Array
    )
	set!(material, parameter, Image(context, image))
end
function set!(context::Context, scene::Scene)
	ContextSetScene(context.x, scene.x)
end
function set!(scene::Scene, camera::Camera)
	ContextSetScene(scene.x, camera.x)
end
function set!(scene::Scene, light::EnvironmentLight)
    SceneSetEnvironmentLight(scene.x, light.x)
end
function set!(scene::Scene, camera::Camera)
	SceneSetCamera(scene.x, camera.x)
end


"""
Sets the displacement scale for a shape
"""
function setdisplacementscale!(shape::Shape, scale::AbstractFloat)
	ShapeSetDisplacementScale(shape.x, fr_float(scale))
end
"""
Sets the subdivions for a shape
"""
function setsubdivisions!(shape::Shape, subdivions::Integer)
	ShapeSetSubdivisionFactor(shape.x, fr_uint(subdivions))
end

"""
Transforms firerender objects with a transformation matrix
"""
function transform!(shape::Shape, transform::Mat4f0)
	ShapeSetTransform(shape.x, FALSE, convert(Array, transform))
end
function transform!(light::AbstractLight, transform::Mat4f0)
	LightSetTransform(light.x, FALSE, convert(Array, transform))
end
function transform!(camera::Camera, transform::Mat4f0)
	CameraSetTransform(camera.x, FALSE, convert(Array, transform))
end

"""
creates a transform from a translation, scale, rotation
"""
function transform!(shape::FireRenderObj, translate, scale, rot)
	s = scalematrix(Vec3f0(scale))
	t = translationmatrix(Vec3f0(translate))
	transform!(shape, t*rot*s)
end
function transform!(shape::FireRenderObj, trans_scale_rot::Tuple)
	transform!(shape, trans_scale_rot...)
end

"""
Clears a scene
"""
clear!(scene::Scene) = SceneClear(scene.x)
"""
Clears a framebuffer
"""
clear!(frame_buffer::FrameBuffer) = FrameBufferClear(frame_buffer.x)

"""
Pushes objects to Scene
"""
function push!(scene::Scene, shape::Shape)
	SceneAttachShape(scene.x, shape.x)
end

function push!(scene::Scene, light::AbstractLight)
	SceneAttachLight(scene.x, light.x)
end
function delete!(scene::Scene, light::AbstractLight)
	SceneDetachLight(scene.x, light.x)
end

function delete!(scene::Scene, shape::Shape)
	SceneDetachShape(scene.x, shape.x)
end

"""
Gets the currently attached EnvironmentLight from a scene
"""
function get(scene::Scene, ::Type{EnvironmentLight})
	EnvironmentLight(SceneGetEnvironmentLight(scene::fr_scene))
end
"""
Gets the currently attached Camera from a scene
"""
function get(scene::Scene, ::Type{Camera})
	Camera(SceneGetCamera(scene.x))
end

"""
Sets the lookat of a camera
"""
function lookat!(camera::Camera, position::Vec3, lookatvec::Vec3, upvec::Vec3)
	CameraLookAt(camera.x,
		Vec3f0(position)...,
		Vec3f0(lookatvec)...,
		Vec3f0(upvec)...
	)
end

"""
renders the context
"""
function render(context::Context)
	ContextRender(context.x)
end
"""
Renders a tile of the context
"""
function render(context::Context, tile::HyperRectangle)
	mini, maxi = minimum(tile), maximum(tile)
	ContextRenderTile(
		context.x,
		mini[1], maxi[1],
		mini[2], maxi[2],
	)
end

"""
Saves a picture of the current framebuffer at `path`
"""
function save(fb::FrameBuffer, path::AbstractString)
	FrameBufferSaveToFile(fb.x, utf8(path))
end

#=
@enum(MaterialType,
	Diffuse = 0x1,
	Microfacet = 0x2,
	Refraction = 0x4,
	MicrofacetRefraction = 0x5,
	Transparent = 0x6,
	Emissive = 0x7,
	Fresnel = 0xC,
	Orennayar = 0x18
)


immutable Material{MatType, C, RI, R, Re, B, Ra}
	color::C
	refraction_index::RI
	roughness::R
	reflectance::Re
	bumps::B
	radiance::Ra
end


function Material()
	Materials{Diffuse}(
		RGBA{Float32}(0,0,0,1),
		1.5,
		0.0,
		RGBA{Float32}(0,0,0,1),
		nothing,
		nothing
	)
end
=#


"""
Creates instances from materials and instances
"""
function instance(context::Context, scene::Scene, instances, materials)
	ti = TransformationIterator(instances)
	for (transmat, m) in zip(ti, mat)
		inst = FR.Shape(context, shape)
		transform!(inst, transmat)
		set!(inst, shader)
		push!(scene, inst)
	end
end

#=
Some iterators for tiled rendering
=#

"""
Iterates randomly over an iterable
"""
immutable RandomIterator{T}
	iterable::T
end
Base.start(ti::RandomIterator) = rand(1:length(ti.iterable))
Base.next(ti::RandomIterator, state) = ti.iterable[state], rand(1:length(ti.iterable))
Base.done(ti::RandomIterator, state) = false

"""
Iterates randomly over all elements in an iterable.
The middle has a higher sampling probability.
"""
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


"""
Iterates over all tiles in a Rectangular parent tile.
"""
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

"""
Customizable defaults for the most common tonemapping operations
"""
function set_standard_tonemapping!(context;
        typ=TONEMAPPING_OPERATOR_PHOTOLINEAR,
        photolinear_sensitivity=1f0,
        photolinear_exposure=1f0,
        photolinear_fstop=1f0,
        reinhard02_prescale=1f0,
        reinhard02_postscale=1f0,
        reinhard02_burn=1f0,
        linear_scale=1f0,
        aacellsize = 4.,
        imagefilter_type = FILTER_BLACKMANHARRIS,
        aasamples = 4.,
    )
    set!(context, "toneMapping.type", typ)
    set!(context, "tonemapping.linear.scale", linear_scale)
    set!(context, "tonemapping.photolinear.sensitivity", photolinear_sensitivity)
    set!(context, "tonemapping.photolinear.exposure", photolinear_exposure)
    set!(context, "tonemapping.photolinear.fstop", photolinear_fstop)
    set!(context, "tonemapping.reinhard02.prescale", reinhard02_prescale)
    set!(context, "tonemapping.reinhard02.postscale", reinhard02_postscale)
    set!(context, "tonemapping.reinhard02.burn", reinhard02_burn)

    set!(context, "aacellsize", aacellsize)
    set!(context, "imagefilter.type", imagefilter_type)
    set!(context, "aasamples", aasamples)

end


"""
blocking renderloop that uses tiling
"""
function tiledrenderloop(glwindow, context, framebuffer)
	ti = TileIterator(widths(glwindow), (256,256))
	s = start(ti)
	while isopen(glwindow)
		glBindTexture(GL_TEXTURE_2D, 0)
		if done(ti, s)
			s = start(ti)
		end
		next_tile, s = next(ti, s)
		render(context, next_tile)
		GLWindow.render_frame(glwindow)
	end
end

const tex_frag = frag"""
{{GLSL_VERSION}}
in vec2 o_uv;
out vec4 fragment_color;
out uvec2 fragment_groupid;

uniform sampler2D image;

void main(){
	vec4 color 		 = texture(image, o_uv);
	fragment_color   = color/color.a;
    fragment_groupid = uvec2(0);
}

"""
const tex_vert = vert"""
{{GLSL_VERSION}}

in vec2 vertices;
in vec2 texturecoordinates;

out vec2       o_uv;

void main(){
	o_uv        = texturecoordinates;
	gl_Position = vec4(vertices, 0, 1);
}
"""

"""
A matrix of colors is interpreted as an image
"""
function view_tex{T}(tex::Texture{T,2}, window)
	data = Dict{Symbol, Any}(
	    :image => tex,
	    :primitive => GLUVMesh2D(SimpleRectangle{Float32}(-1f0, -1f0, 2f0,2f0)),
    )
    robj = std_renderobject(data, LazyShader(tex_vert, tex_frag))
    view(robj, window, camera=:nothing)
end


"""
Creates an interactive context with the help of glvisualize to view the texture
"""
function interactive_context(glwindow)
    context = Context(CREATION_FLAGS_ENABLE_GPU0 | CREATION_FLAGS_ENABLE_GL_INTEROP)
    w,h = widths(glwindow)
    texture = Texture(RGBA{Float16}, (w,h))
    view_tex(texture, glwindow)
    g_frame_buffer = FrameBuffer(context, texture)
    set!(context, AOV_COLOR, g_frame_buffer)
    context, g_frame_buffer
end


"""
Creates a camera from a GLAbstraction.Camera
"""
function Camera(context::Context, framebuffer, cam)
    # Create camera
    camera = Camera(context)
    preserve(map(droprepeats(cam.eyeposition)) do position
    	l,u = cam.lookat.value, cam.up.value
    	lookat!(camera, position, l, u)
    	clear!(framebuffer)
    end)

    camera
end

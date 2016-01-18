using GeometryTypes, Colors, FixedSizeArrays
import GLAbstraction: Texture, translationmatrix, scalematrix, lookat, render
import ModernGL: GL_TEXTURE_2D
import GLVisualize: iter_or_array

import Base: push!, delete!, get


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
abstract FireRenderObj
@fr_wrapper_type MaterialSystem fr_material_system ContextCreateMaterialSystem (context.x, typ) FireRenderObj
@fr_wrapper_type MaterialNode fr_material_node MaterialSystemCreateNode (matsystem.x, typ) FireRenderObj
@fr_wrapper_type Camera fr_camera ContextCreateCamera (context.x,) FireRenderObj
@fr_wrapper_type Scene fr_scene ContextCreateScene (context.x,) FireRenderObj
@fr_wrapper_type Context fr_context CreateContext (api, accelerator, devices, props, cache_path) FireRenderObj

function Context(api, accelerator, devices)
	Context(api, accelerator, devices, C_NULL, C_NULL)
end
function Context()
	Context(API_VERSION, CONTEXT_OPENCL, CREATION_FLAGS_ENABLE_GPU0, C_NULL, C_NULL)
end
abstract Light <: FireRenderObj
@fr_wrapper_type EnvironmentLight fr_light ContextCreateEnvironmentLight (context.x,) Light
@fr_wrapper_type PointLight fr_light ContextCreatePointLight (context.x,) Light
@fr_wrapper_type DirectionalLight fr_light ContextCreateDirectionalLight (context.x,) Light
@fr_wrapper_type SkyLight fr_light ContextCreateSkyLight (context.x,) Light


type Shape <: FireRenderObj
	x::fr_shape
	function Shape(x::fr_shape)
		inst = new(x)
		finalizer(inst, release)
		inst
	end
end

function Shape(context::Context, mesh::GeometryPrimitive)
	m = GLNormalUVMesh(mesh)
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
Shape(context::Context, shape::Shape) =
	Shape(ContextCreateInstance(context.x, shape.x))
getbase(shape::Shape) =
	Shape(InstanceGetBaseShape(shape.x))

#= Create layered shader give two shaders and respective IORs
function create_layered_shader(context, base, top, baseior, topior)
    # Create a shader
    layered = Shader(context, SHADER_LAYERED)
    # Set shader for base layer
    set!(layered, "base", base)
    # Set shader for top layer
    set!(layered, "top", top)
    # Set index of refraction for top layer
    set!(layered, "topior", topior)
    return layered
end
=#

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


type Image <: FireRenderObj
	x::fr_image
end

fr_image_format(a::Array) = fr_image_format(eltype(a))
function fr_image_format{T<:Union{Colorant, AbstractFloat}}(::Type{T})
	fr_image_format(
		T<:AbstractFloat ? 1 : length(T),
		component_type(T)
	)
end
component_type{T<:Colorant}(x::Type{T}) = component_type(eltype(T))
component_type{T<:Union{UInt8, U8}}(x::Type{T}) = COMPONENT_TYPE_UINT8
component_type{T<:Union{Float16}}(x::Type{T}) = COMPONENT_TYPE_FLOAT16
component_type{T<:Union{Float32}}(x::Type{T}) = COMPONENT_TYPE_FLOAT32

function fr_image_desc{T,N}(image::Array{T, N})
	row_pitch = size(image, 1)*sizeof(T)
	Ref(fr_image_desc(
	    ntuple(i->N<i? 0 : size(image, i), 3)...,
	    row_pitch, 0
	))
end
function Image{T, N}(context::Context, image::Array{T, N})
	img  = ContextCreateImage(
		context.x, fr_image_format(image), 
		fr_image_desc(image), image
	)
	x = Image(img)
	finalizer(x, release)
	x
end
function Image(context::Context, path::AbstractString)
	img  = ContextCreateImageFromFile(
		context.x, utf8(path)
	)
	x = Image(img)
	finalizer(x, release)
	x
end


setradiantpower!{T}(ligt::DirectionalLight, rgb::Colorant{T, 3}) = 
	setradiantpower!(light, RGB{Float32}(rgb)...)
#setradiantpower!(ligt::DirectionalLight, r, g, b) = 

function set!(light::EnvironmentLight, image::Image)
	EnvironmentLightSetImage(light.x, image.x)
end

setintensityscale!(light::EnvironmentLight, intensity_scale::AbstractFloat) =
	EnvironmentLightSetIntensityScale(light.x, fr_float(intensity_scale))
setportal!(light::EnvironmentLight, portal::Shape) =
	EnvironmentLightSetPortal(light.x, portal.x)

setalbedo!(skylight::SkyLight, albedo::AbstractFloat) =
	SkyLightSetAlbedo(skylight.x, fr_float(albedo))

setturbidity!(skylight::SkyLight, turbidity::AbstractFloat) =
	SkyLightSetTurbidity(skylight.x, fr_float(turbidity.x))

setscale!(skylight::SkyLight, scale::AbstractFloat) =
	SkyLightSetScale(skylight.x, fr_float(scale))

setportal!(light::SkyLight, portal::Shape) =
	SkyLightSetPortal(light.x, portal.x)



release(x::FireRenderObj) = ObjectDelete(x.x)

set!(context::Context, parameter::AbstractString, f::AbstractFloat) =
	ContextSetParameter1f(context.x, ascii(parameter), fr_float(f))
set!(context::Context, parameter::AbstractString, ui::Unsigned) =
	ContextSetParameter1u(context.x, ascii(parameter), fr_uint(ui))
set!(context::Context, aov::Unsigned, fb::FrameBuffer) =
	ContextSetAOV(context.x, fr_aov(aov), fb.x)

function set!(shape::Shape, image::Image)
	ShapeSetDisplacementImage(shape.x, image.x)
end
function setdisplacementscale!(shape::Shape, scale::AbstractFloat)
	ShapeSetDisplacementScale(shape.x, fr_float(scale))
end
function setsubdivisions!(shape::Shape, subdivions::Integer)
	ShapeSetSubdivisionFactor(shape.x, fr_uint(subdivions))
end
export setsubdivisions!, setdisplacementscale!

set!(context::Context, framebuffer::FrameBuffer) =
	ContextSetFrameBuffer(context.x, framebuffer.x)
#set!(base::Shader, parameter::ASCIIString, shader::Shader) =
#	ShaderSetParameterShader(base.x, parameter, shader.x)
#set!(base::Shader, parameter::ASCIIString, f::AbstractFloat) =
#	ShaderSetParameter1f(base.x, parameter, fr_float(f))


function set!(
		base::MaterialNode, parameter::AbstractString, 
		a::AbstractFloat, b::AbstractFloat, c::AbstractFloat, d::AbstractFloat
	)
	MaterialNodeSetInputF(
		base.x, ascii(parameter), 
		fr_float(a), fr_float(b), fr_float(c), fr_float(d)
	)
end
set!{T<:FixedVector{4}}(base::MaterialNode, parameter::AbstractString, f::T) =
	set!(base.x, parameter, f...)
function set!{T}(base::MaterialNode, parameter::AbstractString, c::Colorant{T, 4})
	c = RGBA{Float32}(c)
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


set!(context::Context, scene::Scene) =
	ContextSetScene(context.x, scene.x)
set!(scene::Scene, camera::Camera) =
	ContextSetScene(scene.x, camera.x)

transform!(shape::Shape, transform::Mat4f0) =
	ShapeSetTransform(shape.x, FALSE, convert(Array, transform))


clear!(scene::Scene) = SceneClear(scene.x)
clear!(frame_buffer::FrameBuffer) = FrameBufferClear(frame_buffer.x)

push!(scene::Scene, shape::Shape) =
	SceneAttachShape(scene.x, shape.x)
delete!(scene::Scene, shape::Shape) =
	SceneDetachShape(scene.x, shape.x)

push!(scene::Scene, light::Light) =
	SceneAttachLight(scene.x, light.x)
delete!(scene::Scene, light::Light) =
	SceneDetachLight(scene.x, light.x)


set!(scene::Scene, light::EnvironmentLight) =
	SceneSetEnvironmentLight(scene.x, light.x)

get(scene::Scene, ::Type{EnvironmentLight}) =
	EnvironmentLight(SceneGetEnvironmentLight(scene::fr_scene))

set!(scene::Scene, camera::Camera) =
	SceneSetCamera(scene.x, camera.x)
get!(scene::Scene, ::Type{Camera}) =
	Camera(SceneGetCamera(scene.x))

function lookat(camera::Camera, position::Vec3, lookatvec::Vec3, upvec::Vec3)
	CameraLookAt(camera.x, 
		Vec3f0(position)..., 
		Vec3f0(lookatvec)..., 
		Vec3f0(upvec)...
	)
end

function render(context::Context)
	ContextRender(context.x)
end
function render(context::Context, tile::HyperRectangle)
	mini, maxi = minimum(tile), maximum(tile)
	ContextRenderTile(
		context.x,
		mini[1], maxi[1],
		mini[2], maxi[2],
	) 
end

function save(fb::FrameBuffer, path::AbstractString)
	FrameBufferSaveToFile(fb.x, utf8(path))
end



function instance(context::Context, scene::Scene, shape, scales, positions, rotations, shaders)
	iterator = zip(
		iter_or_array(scales), 
		iter_or_array(positions), 
		iter_or_array(rotations), 
		iter_or_array(shaders)
	)
	for (scale,position,rotation,shader) in iterator
		inst = FR.Shape(context, shape)
		transform!(inst,
			translationmatrix(Vec3f0(position))*
			scalematrix(Vec3f0(scale))
			#rotationmatrix(rotation)*
		)
		set!(inst, shader)
		push!(scene, inst)
	end
end


using GeometryBasics, Colors, GLMakie
using Observables, ModernGL
import GLMakie.GLAbstraction: Texture, render, std_renderobject, LazyShader
import GLMakie.GLAbstraction: @frag_str, @vert_str
import ModernGL: GL_TEXTURE_2D

import GLMakie.Makie: translationmatrix, scalematrix, lookat

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
macro rpr_wrapper_type(name, typ, target, args, super)
    argnames = args.args
    esc(quote
        mutable struct $name <: $super
            x::$typ
            $name(x::$typ) = new(x)
            function $name($(argnames...))
                x = new()
                x.x = $target($(argnames...))
                finalizer(release, x)
                return x
            end
        end
        Base.cconvert(::Type{$typ}, x::$name) = x
        Base.unsafe_convert(::Type{$typ}, x::$name) = x.x
    end)
end

"""
All FireRender types inherit from FireRenderObj
"""
abstract type FireRenderObj end

@rpr_wrapper_type MaterialSystem rpr_material_system rprContextCreateMaterialSystem (context, typ) FireRenderObj
@rpr_wrapper_type MaterialNode rpr_material_node rprMaterialSystemCreateNode (matsystem, typ) FireRenderObj
@rpr_wrapper_type Camera rpr_camera rprContextCreateCamera (context,) FireRenderObj
@rpr_wrapper_type Scene rpr_scene rprContextCreateScene (context,) FireRenderObj
@rpr_wrapper_type Context rpr_context rprCreateContext (api_version, pluginIDs, pluginCount, creation_flags, props, cache_path) FireRenderObj

"""
Shortcut for Context creation. Leaves empty:
`props`     Context properties, reserved for future use
`cache_path`Full path to kernel cache created by FireRender, NULL means to use current folder
"""
function Context(api_version, pluginIDs, creation_flags)
    return Context(api_version, pluginIDs, length(pluginIDs), creation_flags, C_NULL, C_NULL)
end

"""
Empty constructor, defaults to using opencl and the GPU0
"""
function Context()
    tahoe = normpath(joinpath(dirname(RadeonProRender_v2), "Tahoe64.dll"))
    tahoePluginID = rprRegisterPlugin(tahoe)
    @assert(tahoePluginID != -1)
    plugins = [tahoePluginID]
    ctx = Context(RPR_API_VERSION, plugins, RPR_CREATION_FLAGS_ENABLE_GPU0)
    rprContextSetActivePlugin(ctx, plugins[1])
    return ctx
end
"""
Constructor which only uses creation flags and defaults to opencl.
"""
function Context(creation_flags)
    Context(RPR_API_VERSION, RPR_CONTEXT_OPENCL, creation_flags)
end

"""
Abstract AbstractLight Type
"""
abstract type AbstractLight <: FireRenderObj end

@rpr_wrapper_type EnvironmentLight rpr_light rprContextCreateEnvironmentLight (context,) AbstractLight
@rpr_wrapper_type PointLight rpr_light rprContextCreatePointLight (context,) AbstractLight
@rpr_wrapper_type DirectionalLight rpr_light rprContextCreateDirectionalLight (context,) AbstractLight
@rpr_wrapper_type SkyLight rpr_light rprContextCreateSkyLight (context,) AbstractLight
@rpr_wrapper_type SpotLight rpr_light rprContextCreateSpotLight (context,) AbstractLight


mutable struct Shape <: FireRenderObj
    x::rpr_shape
    function Shape(x::rpr_shape)
        inst = new(x)
        finalizer(release, inst)
        inst
    end
end

Base.cconvert(::Type{rpr_shape}, x::Shape) = x
Base.unsafe_convert(::Type{rpr_shape}, x::Shape) = x.x

"""
Default shape constructor which works with every Geometry from the package
GeometryTypes (Meshes and geometry primitives alike).
"""
function Shape(context::Context, mesh::Union{GeometryBasics.Mesh, AbstractGeometry}; kw...)
    m = uv_normal_mesh(mesh; kw...)
    v, n, fs, uv = decompose(Point3f, m), normals(m), faces(m), texturecoordinates(m)
    return Shape(context, v, n, fs, uv)
end

function Shape(context::Context, vertices, normals, faces, uvs)

    vraw  = reinterpret(Float32, decompose(Point3f, vertices))
    nraw  = reinterpret(Float32, decompose(Vec3f, normals))
    uvraw = reinterpret(Float32, map(uv-> Vec2f(1.0 - uv[2], 1.0 - uv[1]), uvs))
    iraw  = reinterpret(rpr_int, decompose(TriangleFace{OffsetInteger{-1, rpr_int}}, faces))

    m = rprContextCreateMesh(context,
        vraw, length(vertices), sizeof(Point3f),
        nraw, length(normals), sizeof(Vec3f),
        uvraw, length(uvs), sizeof(Vec2f),
        iraw, sizeof(rpr_int),
        iraw, sizeof(rpr_int),
        iraw, sizeof(rpr_int),
        fill(rpr_int(3), length(faces)), length(faces)
    )
    return Shape(m)
end


"""
Creating a shape from a shape is interpreted as creating an instance.
"""
Shape(context::Context, shape::Shape) =
    Shape(rprContextCreateInstance(context, shape))


"""
Create layered shader give two shaders and respective IORs
"""
function layeredshader(matsys, base, top, weight=(0.5, 0.5, 0.5, 1.))
    layered = MaterialNode(matsys, RPR_MATERIAL_NODE_BLEND)

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
mutable struct FrameBuffer <: FireRenderObj
    x::rpr_framebuffer
end
Base.cconvert(::Type{rpr_framebuffer}, x::FrameBuffer) = x
Base.unsafe_convert(::Type{rpr_framebuffer}, x::FrameBuffer) = x.x

function FrameBuffer(context::Context, t::Texture{T, 2}) where T
    frame_buffer = ContextCreateFramebufferFromGLTexture2D(context, GL_TEXTURE_2D, 0, t.id)
    x = FrameBuffer(frame_buffer)
    finalizer(release, x)
    return x
end

function FrameBuffer(context::Context, c::Type{C}, dims::NTuple{2, Int}) where {C<:Colorant}
    desc = Ref(RPR.rpr_framebuffer_desc(dims...))
    fmt = RPR.rpr_framebuffer_format(length(c), RPR_COMPONENT_TYPE_FLOAT32)
    frame_buffer = rprContextCreateFrameBuffer(context, fmt, desc)
    x = FrameBuffer(frame_buffer)
    finalizer(release, x)
    x
end

"""
Image wrapper type
"""
mutable struct Image <: FireRenderObj
    x::rpr_image
end
Base.cconvert(::Type{rpr_image}, x::Image) = x
Base.unsafe_convert(::Type{rpr_image}, x::Image) = x.x

"""
Automatically generated the correct `rpr_image_format` for an array
"""
rpr_image_format(a::Array) = rpr_image_format(eltype(a))
function rpr_image_format(::Type{T}) where T<:Union{Colorant, AbstractFloat}
    RPR.rpr_image_format(
        T<:AbstractFloat ? 1 : length(T),
        component_type(T)
    )
end

"""
Gets the correct component type for Images from array element types
"""
component_type(x::Type{T}) where {T<:Colorant} = component_type(eltype(T))
component_type(x::Type{T}) where {T<:Union{UInt8, Colors.N0f8}} = RPR_COMPONENT_TYPE_UINT8
component_type(x::Type{T}) where {T<:Union{Float16}} = RPR_COMPONENT_TYPE_FLOAT16
component_type(x::Type{T}) where {T<:Union{Float32}} = RPR_COMPONENT_TYPE_FLOAT32

"""
Creates the correct `rpr_image_desc` for a given array.
"""
function rpr_image_desc(image::Array{T, N}) where {T, N}
    row_pitch = size(image, 1)*sizeof(T)
    return Ref(RPR.rpr_image_desc(
        ntuple(i->N < i ? 0 : size(image, i), 3)...,
        row_pitch, 0
    ))
end
"""
Automatically creates an Image from a matrix of colors
"""
function Image(context::Context, image::Array{T, N}) where {T, N}
    img  = rprContextCreateImage(
        context, rpr_image_format(image),
        rpr_image_desc(image), image
    )
    x = Image(img)
    finalizer(release, x)
    return x
end

"""
Automatically loads an image from the given `path`
"""
function Image(context::Context, path::AbstractString)
    img = rprContextCreateImageFromFile(context, path)
    x = Image(img)
    finalizer(release, x)
    return x
end

"""
Sets the radiant power for a given Light
"""
function setradiantpower!(light::AbstractLight, color::Colorant{T, 3}) where {T}
    c = RGB{Float32}(color)
    setradiantpower!(light, comp1(c), comp2(c), comp3(c))
end

function setradiantpower!(
        light::PointLight,
        r::Number, g::Number, b::Number
    )
    rprPointLightSetRadiantPower3f(light, rpr_float(r), rpr_float(g), rpr_float(b))
end

function setradiantpower!(
        light::SpotLight,
        r::Number, g::Number, b::Number
    )
    rprSpotLightSetRadiantPower3f(light, rpr_float(r), rpr_float(g), rpr_float(b))
end

function setradiantpower!(
        light::DirectionalLight,
        r::Number, g::Number, b::Number
    )
    rprDirectionalLightSetRadiantPower3f(light, rpr_float(r), rpr_float(g), rpr_float(b))
end

"""
Sets the image for an EnvironmentLight
"""
function set!(light::EnvironmentLight, image::Image)
    rprEnvironmentLightSetImage(light, image)
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
    rprEnvironmentLightSetIntensityScale(light, intensity_scale)
end

"""
Sets a portal for a Light
"""
function setportal!(light::AbstractLight, portal::AbstractGeometry)
    setportal!(light, Shape(portal))
end

function setportal!(light::EnvironmentLight, portal::Shape)
    rprEnvironmentLightSetPortal(light, portal)
end

function setportal!(light::SkyLight, portal::Shape)
    rprSkyLightSetPortal(light, portal)
end

"""
Sets the albedo for a SkyLight
"""
setalbedo!(skylight::SkyLight, albedo::AbstractFloat) =
    rprSkyLightSetAlbedo(skylight.x, albedo)

"""
Sets the turbidity for a SkyLight
"""
setturbidity!(skylight::SkyLight, turbidity::AbstractFloat) =
    rprSkyLightSetTurbidity(skylight.x, turbidity)

"""
Sets the scale for a SkyLight
"""
setscale!(skylight::SkyLight, scale::AbstractFloat) =
    rprSkyLightSetScale(skylight, scale)


# release(x::FireRenderObj) = rprObjectDelete(x)
release(x::FireRenderObj) = Core.println("Deleting: ", string(typeof(x)))

"""
"""
set!(context::Context, parameter::rpr_context_info, f::AbstractFloat) =
    rprContextSetParameterByKey1f(context, parameter, f)

set!(context::Context, parameter::rpr_context_info, ui::Unsigned) =
    rprContextSetParameterByKey1u(context, parameter, ui)

set!(context::Context, aov::rpr_aov, fb::FrameBuffer) =
    rprContextSetAOV(context, aov, fb)

function set!(shape::Shape, image::Image)
    rprShapeSetDisplacementImage(shape, image)
end

function set!(shape::Shape, context::Context, image::Array)
    set!(shape, Image(context, image))
end

"""
Sets arbitrary values to FireRender objects
"""
set!(context::Context, framebuffer::FrameBuffer) = rprContextSetFrameBuffer(context, framebuffer)

function set!(
        base::MaterialNode, parameter::rpr_material_node_input,
        a::Number, b::Number, c::Number, d::Number
    )
    rprMaterialNodeSetInputFByKey(base, parameter, a, b, c, d)
end

function set!(base::MaterialNode, parameter::rpr_material_node_input, ui::Integer)
    rprMaterialNodeSetInputUByKey(base, parameter, ui)
end

rprMaterialNodeSetInputUByKey

function set!(base::MaterialNode, parameter::rpr_material_node_input, f::Vec4)
    set!(base, parameter, f...)
end

function set!(base::MaterialNode, parameter::rpr_material_node_input, color::Colorant)
    c = RGBA{Float32}(color)
    set!(base, parameter, comp1(c), comp2(c), comp3(c), alpha(c))
end

function set!(shape::Shape, material::MaterialNode)
    rprShapeSetMaterial(shape, material)
end

function set!(material::MaterialNode, parameter::rpr_material_node_input, material2::MaterialNode)
    rprMaterialNodeSetInputNByKey(material, parameter, material2)
end

function set!(material::MaterialNode, parameter::rpr_material_node_input, image::Image)
    rprMaterialNodeSetInputImageDataByKey(material, parameter, image)
end

function set!(
        material::MaterialNode, parameter::rpr_material_node_input,
        context::Context, image::Array
    )
    set!(material, parameter, Image(context, image))
end

function set!(context::Context, scene::Scene)
    rprContextSetScene(context, scene)
end

function set!(scene::Scene, light::EnvironmentLight)
    rprSceneSetEnvironmentLight(scene, light)
end

function set!(scene::Scene, camera::Camera)
    rprSceneSetCamera(scene, camera)
end

"""
Sets the displacement scale for a shape
"""
function setdisplacementscale!(shape::Shape, scale::AbstractFloat)
    rprShapeSetDisplacementScale(shape, rpr_float(scale))
end
"""
Sets the subdivions for a shape
"""
function setsubdivisions!(shape::Shape, subdivions::Integer)
    rprShapeSetSubdivisionFactor(shape, rpr_uint(subdivions))
end

"""
Transforms firerender objects with a transformation matrix
"""
function transform!(shape::Shape, transform::Mat4f)
    rprShapeSetTransform(shape, false, convert(Array, transform))
end

function transform!(light::AbstractLight, transform::Mat4f)
    rprLightSetTransform(light, false, convert(Array, transform))
end

function transform!(camera::Camera, transform::Mat4f)
    rprCameraSetTransform(camera, false, convert(Array, transform))
end

"""
creates a transform from a translation, scale, rotation
"""
function transform!(shape::FireRenderObj, translate, scale, rot)
    s = scalematrix(Vec3f(scale))
    t = translationmatrix(Vec3f(translate))
    transform!(shape, t*rot*s)
end

function transform!(shape::FireRenderObj, trans_scale_rot::Tuple)
    transform!(shape, trans_scale_rot...)
end

"""
Clears a scene
"""
clear!(scene::Scene) = rprSceneClear(scene)
"""
Clears a framebuffer
"""
clear!(frame_buffer::FrameBuffer) = rprFrameBufferClear(frame_buffer)

"""
Pushes objects to Scene
"""
function Base.push!(scene::Scene, shape::Shape)
    rprSceneAttachShape(scene, shape)
end

function Base.push!(scene::Scene, light::AbstractLight)
    rprSceneAttachLight(scene, light)
end
function Base.delete!(scene::Scene, light::AbstractLight)
    rprSceneDetachLight(scene, light)
end

function Base.delete!(scene::Scene, shape::Shape)
    rprSceneDetachShape(scene, shape)
end

"""
Gets the currently attached EnvironmentLight from a scene
"""
function Base.get(scene::Scene, ::Type{EnvironmentLight})
    EnvironmentLight(rprSceneGetEnvironmentLight(scene))
end

"""
Gets the currently attached Camera from a scene
"""
function Base.get(scene::Scene, ::Type{Camera})
    Camera(rprSceneGetCamera(scene))
end

"""
Sets the lookat of a camera
"""
function lookat!(camera::Camera, position::Vec3, lookatvec::Vec3, upvec::Vec3)
    rprCameraLookAt(camera, position..., lookatvec..., upvec...)
end

"""
renders the context
"""
function render(context::Context)
    rprContextRender(context)
end

"""
Renders a tile of the context
"""
function render(context::Context, tile::Rect)
    mini, maxi = minimum(tile), maximum(tile)
    return rprContextRenderTile(
        context,
        mini[1], maxi[1],
        mini[2], maxi[2],
    )
end

"""
Saves a picture of the current framebuffer at `path`
"""
function save(fb::FrameBuffer, path::AbstractString)
    rprFrameBufferSaveToFile(fb, path)
end

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
struct RandomIterator{T}
    iterable::T
end

function Base.iterate(ti::RandomIterator, state=rand(1:length(ti.iterable)))
    return (ti.iterable[state], rand(1:length(ti.iterable)))
end

"""
Iterates randomly over all elements in an iterable.
The middle has a higher sampling probability.
"""
struct MiddleSampleIterator{T}
    iterable::T
end

function multiplier(i,j,n1,n2)
    a = abs(mod(i-div(n1,2),n1)-div(n1,2))
    b = abs(mod(j-div(n2,2),n2)-div(n2,2))
    max(a,b)
end

function init_sample_pool(ti)
    samplepool = Tuple{Int,Int}[]
    for i=1:size(ti.iterable,1)
        for j=1:size(ti.iterable,2)
            append!(samplepool, fill((i,j), multiplier(i,j,size(ti.iterable)...)))
        end
    end
    return samplepool
end

function Base.iterate(ti::MiddleSampleIterator, state=init_sample_pool(ti))
    isempty(state) && return nothing
    i = rand(1:length(state))
    i2 = state[i]
    filter!(state) do s
        s != i2
    end
    i = sub2ind(size(ti.iterable), i2...)
    return (ti.iterable[i], state)
end


"""
Iterates over all tiles in a Rectangular parent tile.
"""
struct TileIterator
    size::Vec{2, Int}
    tile_size::Vec{2, Int}
    lengths::Vec{2, Int}
end

function TileIterator(size, tile_size)
    s, ts = Vec(size), Vec(tile_size)
    lengths = Vec{2, Int}(ceil(Vec{2,Float64}(s) ./ Vec{2,Float64}(ts)))
    return TileIterator(s, ts, lengths)
end

Base.size(ti::TileIterator, i) = ti.lengths[i]
Base.size(ti::TileIterator) = ti.lengths._
Base.length(ti::TileIterator) = prod(ti.lengths)

function Base.iterate(ti::TileIterator, state=1)
    length(ti) > state && return nothing
    return ti[state], state+1
end

function Base.getindex(ti::TileIterator, i,j)
    ts = Vec(ti.tile_size)
    xymin = (Vec(i,j)-1) .* ts
    xymax = xymin .+ ts
    Rect(xymin, min(xymax, ti.size) .- xymin)
end

function Base.getindex(ti::TileIterator, linear_index::Int)
    i,j = ind2sub(size(ti), linear_index)
    return ti[i,j]
end

"""
Customizable defaults for the most common tonemapping operations
"""
function set_standard_tonemapping!(context;
        typ=RPR_TONEMAPPING_OPERATOR_PHOTOLINEAR,
        photolinear_sensitivity=1f0,
        photolinear_exposure=1f0,
        photolinear_fstop=1f0,
        reinhard02_prescale=1f0,
        reinhard02_postscale=1f0,
        reinhard02_burn=1f0,
        linear_scale=1f0,
        aacellsize = 4.,
        imagefilter_type = RPR_FILTER_BLACKMANHARRIS,
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
    set!(context, RPR_CONTEXT_IMAGE_FILTER_TYPE, imagefilter_type)
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
function view_tex(tex::Texture{T,2}, window) where {T}
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
    context = Context(RPR_CREATION_FLAGS_ENABLE_GPU0 | RPR_CREATION_FLAGS_ENABLE_GL_INTEROP)
    w,h = widths(glwindow)
    texture = Texture(RGBA{Float16}, (w,h))
    view_tex(texture, glwindow)
    g_frame_buffer = FrameBuffer(context, texture)
    set!(context, RPR_AOV_COLOR, g_frame_buffer)
    context, g_frame_buffer
end

"""
Creates a camera from a GLAbstraction.Camera
"""
function Camera(context::Context, framebuffer, cam)
    # Create camera
    camera = Camera(context)
    map(droprepeats(cam.eyeposition) do position
        l,u = cam.lookat.value, cam.up.value
        lookat!(camera, position, l, u)
        clear!(framebuffer)
    end)

    return camera
end

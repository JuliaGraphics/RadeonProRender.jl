"""
All RadeonProRender types inherit from RPRObject
"""
abstract type RPRObject{PtrType} end

Base.pointer(object::RPRObject) = object.pointer
Base.cconvert(::Type{T}, object::RPRObject{T}) where {T<:Ptr} = object
Base.unsafe_convert(::Type{T}, object::RPRObject{T}) where {T} = pointer(object)
function Base.unsafe_convert(::Type{Ptr{Nothing}}, object::RPRObject{T}) where {T}
    return Base.unsafe_convert(Ptr{Nothing}, pointer(object))
end

function release(object::RPRObject)
    remove_from_context!(object.parent, object)
    if object.pointer != C_NULL
        rprObjectDelete(object)
    end
    object.pointer = C_NULL
    if hasproperty(object, :referenced_memory)
        object.referenced_memory = nothing
    end
    return
end

@enum PluginType Tahoe Northstar Hybrid HybridPro

using Libdl

function plugin_path(plugin::PluginType)
    if plugin == Tahoe
        return RadeonProRender_jll.libTahoe64
    elseif plugin == Northstar
        return RadeonProRender_jll.libNorthstar64
    end
    Sys.isapple() && error("Only Tahoe and Northstar are supported")
    path_base = dirname(RadeonProRender_jll.libNorthstar64)
    # Hybrid isn't currently part of Binarybuilder products, since its missing on Apple
    if plugin == Hybrid
        return joinpath(path_base, "Hybrid.$(Libdl.dlext)")
    elseif plugin == HybridPro
        return joinpath(path_base, "HybridPro.$(Libdl.dlext)")
    end
end


# Aliases for the incredibly long creation flag names
const GPU0 = RPR_CREATION_FLAGS_ENABLE_GPU0
const GPU1 = RPR_CREATION_FLAGS_ENABLE_GPU1
const GPU2 = RPR_CREATION_FLAGS_ENABLE_GPU2
const GPU3 = RPR_CREATION_FLAGS_ENABLE_GPU3
const CPU = RPR_CREATION_FLAGS_ENABLE_CPU
const GL_INTEROP = RPR_CREATION_FLAGS_ENABLE_GL_INTEROP
const GPU4 = RPR_CREATION_FLAGS_ENABLE_GPU4
const GPU5 = RPR_CREATION_FLAGS_ENABLE_GPU5
const GPU6 = RPR_CREATION_FLAGS_ENABLE_GPU6
const GPU7 = RPR_CREATION_FLAGS_ENABLE_GPU7
const METAL = RPR_CREATION_FLAGS_ENABLE_METAL
const GPU8 = RPR_CREATION_FLAGS_ENABLE_GPU8
const GPU9 = RPR_CREATION_FLAGS_ENABLE_GPU9
const GPU10 = RPR_CREATION_FLAGS_ENABLE_GPU10
const GPU11 = RPR_CREATION_FLAGS_ENABLE_GPU11
const GPU12 = RPR_CREATION_FLAGS_ENABLE_GPU12
const GPU13 = RPR_CREATION_FLAGS_ENABLE_GPU13
const GPU14 = RPR_CREATION_FLAGS_ENABLE_GPU14
const GPU15 = RPR_CREATION_FLAGS_ENABLE_GPU15
const HIP = RPR_CREATION_FLAGS_ENABLE_HIP
const OPENCL = RPR_CREATION_FLAGS_ENABLE_OPENCL
const DEBUG = RPR_CREATION_FLAGS_ENABLE_DEBUG


mutable struct Context <: RPRObject{rpr_context}
    pointer::rpr_context
    objects::Base.IdSet{RPRObject}
    plugin::PluginType
    function Context(plugin::PluginType, creation_flags, singleton=true, cache_path=C_NULL)
        id = RPR.rprRegisterPlugin(plugin_path(plugin))
        @assert(id != -1)
        plugin_ids = [id]
        if plugin == Northstar
            hipbin = artifact"hipbin"
            GC.@preserve hipbin begin
                binpath_ptr = convert(Ptr{Cvoid}, UInt64(RPR.RPR_CONTEXT_PRECOMPILED_BINARY_PATH))
                props = rpr_context_properties[binpath_ptr, pointer(hipbin), convert(Ptr{Cvoid}, 0)]
                ctx_ptr = RPR.rprCreateContext(RPR.RPR_API_VERSION, plugin_ids, 1, creation_flags, props,
                                               cache_path)
            end
        else
            # No hip needed here
            ctx_ptr = RPR.rprCreateContext(RPR.RPR_API_VERSION, plugin_ids, 1, creation_flags, C_NULL, cache_path)
        end
        RPR.rprContextSetActivePlugin(ctx_ptr, id)
        ctx = new(ctx_ptr, Base.IdSet{RPRObject}(), plugin)
        if singleton
            if isassigned(ACTIVE_CONTEXT)
                @info("releasing old context")
                release(ACTIVE_CONTEXT[])
            end
            ACTIVE_CONTEXT[] = ctx
        end
        return ctx
    end
end

const ACTIVE_CONTEXT = Base.RefValue{Context}()

get_context(object::RPRObject) = get_context(object.parent)
get_context(context::Context) = context

function add_to_context!(contextlike::RPRObject, object::RPRObject)
    return push!(get_context(contextlike).objects, object)
end

function remove_from_context!(contextlike::RPRObject, object::RPRObject)
    return delete!(get_context(contextlike).objects, object)
end

"""
    Context()
Empty constructor, defaults to using opencl, GPU0 and Tahoe as the rendering plugin.

* `resource::rpr_creation_flags_t = RPR_CREATION_FLAGS_ENABLE_GPU0`
* `plugin::PluginType=Northstar`: can be Tahoe, Northstar or Hybrid or HybridPro. Everything is tested with Northstar, which is a complete rewrite of Tahoe. Hybrid is for real time rendering and only supports Uber material.
* `singleton = true`:  set to true, to only allow one context at the same time. This is useful, to immediately free all old resources when creating a new context, instead of relying on the GC.
"""
function Context(; plugin=Northstar, resource=RPR_CREATION_FLAGS_ENABLE_GPU0, singleton=true)
    return Context(plugin, resource, singleton)
end

"""
Wraps a RadeonProRender type into a gc registered higher level type.
arguments:
`name`: name of the Julia type
`typ`: type of the RadeonProRender object
`target`: RadeonProRender constructor function
`args`: arguments to constructor function
`super` Julia super type
"""
macro rpr_wrapper_type(name, typ, target, args, super)
    argnames = args.args
    parent = argnames[1]
    expr = quote
        mutable struct $name{PT} <: $super{$typ}
            pointer::$typ
            parent::PT
            $name(pointer::$typ, parent::PT) where {PT} = new{PT}(pointer, parent)
            function $name($(argnames...))
                ptr = $target($(argnames...))
                object = new{typeof($parent)}(ptr, $parent)
                add_to_context!($parent, object)
                return object
            end
        end
    end
    return esc(expr)
end

function release(context::Context)
    if context.pointer == C_NULL
        @assert isempty(context.objects)
        return
    end
    scenes = Scene[]
    for object in copy(context.objects)
        if object isa Scene
            push!(scenes, object)
        else
            release(object)
        end
    end
    empty!(context.objects)
    foreach(s -> (rprSceneClear(s); release(s)), scenes)
    empty!(scenes)
    rprContextClearMemory(context)
    rprObjectDelete(context)
    context.pointer = C_NULL
    return
end

@rpr_wrapper_type MaterialSystem rpr_material_system rprContextCreateMaterialSystem (context, typ) RPRObject
@rpr_wrapper_type MaterialNode rpr_material_node rprMaterialSystemCreateNode (matsystem, typ) RPRObject
@rpr_wrapper_type Camera rpr_camera rprContextCreateCamera (context,) RPRObject
@rpr_wrapper_type Scene rpr_scene rprContextCreateScene (context,) RPRObject
@rpr_wrapper_type PostEffect rpr_post_effect rprContextCreatePostEffect (context, type) RPRObject

function set!(pe::PostEffect, param::String, x::Number)
    return rprPostEffectSetParameter1f(pe, param, x)
end

mutable struct VoxelGrid <: RPRObject{rpr_grid}
    pointer::rpr_grid
    parent::Context
    referenced_memory::Any
end

function VoxelGrid(context::Context, nx, ny, nz, grid_values::AbstractArray, grid_indices::AbstractArray)
    grid_ptr = Ref{rpr_grid}()

    grid_indices = convert(Vector{UInt64}, vec(grid_indices))
    valuesf0 = convert(Vector{Float32}, vec(grid_values))

    rprContextCreateGrid(context, grid_ptr, nx, ny, nz, grid_indices, length(grid_indices),
                         RPR.RPR_GRID_INDICES_TOPOLOGY_I_U64, valuesf0, sizeof(valuesf0), 0)
    grid = VoxelGrid(grid_ptr[], context, (valuesf0, grid_indices))
    add_to_context!(context, grid)
    return grid
end

function VoxelGrid(context, values::AbstractArray{<:Number,3})
    indices = UInt64.((1:length(values)) .- 1)
    return VoxelGrid(context, size(values)..., values, indices)
end

mutable struct Curve <: RPRObject{rpr_curve}
    pointer::rpr_curve
    parent::Context
    referenced_memory::Any
end

function Curve(context::Context, control_points::AbstractVector, indices::AbstractVector,
               radius::AbstractVector, uvs::AbstractVector, segments_per_curve::AbstractVector,
               creationFlag_tapered=0)
    curve_ref = Ref{rpr_curve}()
    control_pointsf0 = convert(Vector{Point3f}, control_points)
    indices_i = convert(Vector{RPR.rpr_int}, indices)
    segments_per_curve_i = convert(Vector{RPR.rpr_int}, segments_per_curve)
    uvs_f0 = convert(Vector{Vec2f}, uvs)
    radiusf0 = convert(Vector{Float32}, radius)
    rprContextCreateCurve(context, curve_ref, length(control_pointsf0), control_pointsf0, sizeof(Point3f),
                          length(indices_i), length(segments_per_curve_i), indices_i, radiusf0, uvs_f0,
                          segments_per_curve_i, creationFlag_tapered)
    curve = Curve(curve_ref[], context, (control_pointsf0, indices_i, segments_per_curve_i, uvs_f0, radiusf0))
    add_to_context!(context, curve)
    return curve
end

@rpr_wrapper_type HeteroVolume rpr_hetero_volume rprContextCreateHeteroVolume (context,) RPRObject

function set_albedo_lookup!(volume::HeteroVolume, colors::AbstractVector)
    return RPR.rprHeteroVolumeSetAlbedoLookup(volume, convert(Vector{RGB{Float32}}, colors), length(colors))
end

function set_albedo_grid!(volume::HeteroVolume, albedo::VoxelGrid)
    return RPR.rprHeteroVolumeSetAlbedoGrid(volume, albedo)
end

function set_density_lookup!(volume::HeteroVolume, density::AbstractVector)
    return RPR.rprHeteroVolumeSetDensityLookup(volume, convert(Vector{Vec3f}, density), length(density))
end

function set_density_grid!(volume::HeteroVolume, density::VoxelGrid)
    return RPR.rprHeteroVolumeSetDensityGrid(volume, density)
end

function Base.push!(scene::Scene, volume::HeteroVolume)
    return rprSceneAttachHeteroVolume(scene, volume)
end

mutable struct Shape <: RPRObject{rpr_shape}
    pointer::rpr_shape
    parent::Context
    referenced_arrays::Any
end

function set!(shape::Shape, volume::HeteroVolume)
    return rprShapeSetHeteroVolume(shape, volume)
end

"""
Abstract AbstractLight Type
"""
abstract type AbstractLight{PtrType} <: RPRObject{PtrType} end

@rpr_wrapper_type EnvironmentLight rpr_light rprContextCreateEnvironmentLight (context,) AbstractLight
@rpr_wrapper_type PointLight rpr_light rprContextCreatePointLight (context,) AbstractLight
@rpr_wrapper_type DirectionalLight rpr_light rprContextCreateDirectionalLight (context,) AbstractLight
@rpr_wrapper_type SkyLight rpr_light rprContextCreateSkyLight (context,) AbstractLight
@rpr_wrapper_type SpotLight rpr_light rprContextCreateSpotLight (context,) AbstractLight

"""
Default shape constructor which works with every Geometry from the package
GeometryTypes (Meshes and geometry primitives alike).
"""
function Shape(context::Context, meshlike::GeometryBasics.Mesh; kw...)
    m = uv_normal_mesh(meshlike; kw...)
    return Shape(context, decompose(Point3f, m), decompose_normals(m), faces(m), decompose_uv(m))
end

#=
The yield + nospecialize somehow prevent some stack/memory corruption when run with `--check-bounds=yes`
This is kind of magical and still under investigation.
MWE:
https://gist.github.com/SimonDanisch/475064ae102141554f65e926f3070630
=#
function Shape(context::Context, vertices, normals, faces, uvs)
    @assert length(vertices) == length(normals)
    @assert isnothing(uvs) || (length(vertices) == length(uvs))

    vraw = decompose(Point3f, vertices)
    @assert eltype(vraw) == Point3f

    nraw = decompose(Vec3f, normals)
    @assert eltype(nraw) == Vec3f
    
    if isnothing(uvs)
        uvraw = C_NULL
        uvlength = 0
        uvbytesize = 0
    else
        uvraw = map(uv -> Vec2f(1 - uv[2], 1 - uv[1]), uvs)
        @assert eltype(uvraw) == Vec2f
        uvlength = length(uvs)
        uvbytesize = sizeof(Vec2f)
    end

    f = decompose(TriangleFace{OffsetInteger{-1,rpr_int}}, faces)
    iraw = collect(reinterpret(rpr_int, f))
    facelens = fill(rpr_int(3), length(faces))


    foreach(i -> checkbounds(vertices, i + 1), iraw)
    rpr_mesh = rprContextCreateMesh(context, 
        vraw, length(vertices), sizeof(Point3f), 
        nraw, length(normals), sizeof(Vec3f), 
        uvraw, uvlength, uvbytesize, 
        iraw, sizeof(rpr_int), iraw, sizeof(rpr_int), iraw, sizeof(rpr_int), facelens, length(faces)
    )

    jl_references = (vraw, nraw, uvraw, iraw, facelens)
    shape = Shape(rpr_mesh, context, jl_references)
    add_to_context!(context, shape)
    return shape
end

"""
Creating a shape from a shape is interpreted as creating an instance.
"""
function Shape(context::Context, shape::Shape)
    inst = Shape(rprContextCreateInstance(context, shape), context, nothing)
    add_to_context!(context, inst)
    return inst
end


"""
    VolumeCube(context::Context)

Creates a cube that can be used for rendering a volume!
"""
function VolumeCube(context::Context)
    mesh_props = Vector{UInt32}(undef, 16)
    mesh_props[1] = UInt32(RPR.RPR_MESH_VOLUME_FLAG)
    mesh_props[2] = UInt32(1) # enable the Volume flag for the Mesh
    mesh_props[3] = UInt32(0)
    # Volume shapes don't need any vertices data: the bounds of volume will only be defined by the grid.
    # Also, make sure to enable the RPR_MESH_VOLUME_FLAG
    rpr_mesh = RPR.rprContextCreateMeshEx2(context,
                                           C_NULL, 0, 0,
                                           C_NULL, 0, 0,
                                           C_NULL, 0, 0, 0,
                                           C_NULL, C_NULL, C_NULL, C_NULL, 0,
                                           C_NULL, 0, C_NULL, C_NULL, C_NULL, 0,
                                           mesh_props)
    return Shape(rpr_mesh, context, [])
end

"""
Create layered shader give two shaders and respective IORs
"""
function layeredshader(matsys, base, top, weight=(0.5, 0.5, 0.5, 1.0))
    layered = MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_BLEND)

    set!(layered, RPR.RPR_MATERIAL_INPUT_COLOR0, base)
    # Set shader for top layer
    set!(layered, RPR.RPR_MATERIAL_INPUT_COLOR1, top)
    # Set index of refraction for base layer
    set!(layered, RPR.RPR_MATERIAL_INPUT_WEIGHT, weight...)
    return layered
end

"""
FrameBuffer wrapper type
"""
mutable struct FrameBuffer <: RPRObject{rpr_framebuffer}
    pointer::rpr_framebuffer
    parent::Context
end

function FrameBuffer(context::Context, c::Type{C}, dims::NTuple{2,Int}) where {C<:Colorant}
    desc = Ref(RPR.rpr_framebuffer_desc(dims...))
    fmt = RPR.rpr_framebuffer_format(length(c), RPR_COMPONENT_TYPE_FLOAT32)
    frame_buffer = FrameBuffer(RPR.rprContextCreateFrameBuffer(context, fmt, desc), context)
    add_to_context!(context, frame_buffer)
    return frame_buffer
end

function get_data(framebuffer::FrameBuffer)
    framebuffer_size = Ref{Csize_t}()
    RPR.rprFrameBufferGetInfo(framebuffer, RPR.RPR_FRAMEBUFFER_DATA, 0, C_NULL, framebuffer_size)
    data = zeros(RGBA{Float32}, framebuffer_size[] ÷ sizeof(RGBA{Float32}))
    @assert sizeof(data) == framebuffer_size[]
    RPR.rprFrameBufferGetInfo(framebuffer, RPR.RPR_FRAMEBUFFER_DATA, framebuffer_size[], data, C_NULL)
    return data
end

"""
Image wrapper type
"""
mutable struct Image <: RPRObject{rpr_image}
    pointer::rpr_image
    parent::Context
    referenced_memory::Any
end

"""
Automatically generated the correct `rpr_image_format` for an array
"""
rpr_image_format(a::Array) = rpr_image_format(eltype(a))

function rpr_image_format(::Type{T}) where {T<:Union{Colorant,Number}}
    return RPR.rpr_image_format(T <: Number ? 1 : length(T), component_type(T))
end

"""
Gets the correct component type for Images from array element types
"""
component_type(x::Type{T}) where {T<:Colorant} = component_type(eltype(T))
component_type(x::Type{T}) where {T<:Union{UInt8,Colors.N0f8}} = RPR_COMPONENT_TYPE_UINT8
component_type(x::Type{T}) where {T<:Union{Float16}} = RPR_COMPONENT_TYPE_FLOAT16
component_type(x::Type{T}) where {T<:Union{Float32}} = RPR_COMPONENT_TYPE_FLOAT32

"""
Creates the correct `rpr_image_desc` for a given array.
"""
function rpr_image_desc(image::Array{T,N}) where {T,N}
    row_pitch = size(image, 1) * sizeof(T)
    imsize = N == 1 ? (1, 1, 0) : ntuple(i -> N < i ? 0 : size(image, i), 3)
    return RPR.rpr_image_desc(imsize..., row_pitch, 0)
end

"""
Automatically creates an Image from a matrix of colors
"""
function Image(context::Context, image::Array{T,N}) where {T,N}
    desc_ref = Ref(rpr_image_desc(image))
    img = Image(rprContextCreateImage(context, rpr_image_format(image), desc_ref, image), context,
                (image, desc_ref))
    add_to_context!(context, img)
    return img
end

function Image(context::Context, image::AbstractArray)
    return Image(context, collect(image))
end

"""
Automatically loads an image from the given `path`
"""
function Image(context::Context, path::AbstractString)
    img = Image(rprContextCreateImageFromFile(context, path), context, nothing)
    add_to_context!(context, img)
    return img
end

"""
Sets the radiant power for a given Light
"""
function setradiantpower!(light::AbstractLight, color::Colorant{T,3}) where {T}
    c = RGB{Float32}(color)
    return setradiantpower!(light, comp1(c), comp2(c), comp3(c))
end

function setradiantpower!(light::PointLight, r::Number, g::Number, b::Number)
    return rprPointLightSetRadiantPower3f(light, rpr_float(r), rpr_float(g), rpr_float(b))
end

function setradiantpower!(light::SpotLight, r::Number, g::Number, b::Number)
    return rprSpotLightSetRadiantPower3f(light, rpr_float(r), rpr_float(g), rpr_float(b))
end

function setradiantpower!(light::DirectionalLight, r::Number, g::Number, b::Number)
    return rprDirectionalLightSetRadiantPower3f(light, rpr_float(r), rpr_float(g), rpr_float(b))
end

"""
Sets the image for an EnvironmentLight
"""
function set!(light::EnvironmentLight, image::Image)
    return rprEnvironmentLightSetImage(light, image)
end

function set!(light::EnvironmentLight, context::Context, image::Array)
    return set!(light, Image(context, image))
end

function set!(light::EnvironmentLight, context::Context, path::AbstractString)
    return set!(light, Image(context, path))
end

"""
Sets the intensity scale an EnvironmentLight
"""
function setintensityscale!(light::EnvironmentLight, intensity_scale::Number)
    return rprEnvironmentLightSetIntensityScale(light, intensity_scale)
end

"""
Sets a portal for a Light
"""
function setportal!(light::AbstractLight, portal::AbstractGeometry)
    return setportal!(light, Shape(portal))
end

function setportal!(light::EnvironmentLight, portal::Shape)
    return rprEnvironmentLightSetPortal(light, portal)
end

function setportal!(light::SkyLight, portal::Shape)
    return rprSkyLightSetPortal(light, portal)
end

"""
Sets the albedo for a SkyLight
"""
setalbedo!(skylight::SkyLight, albedo::Number) = rprSkyLightSetAlbedo(skylight.x, albedo)

"""
Sets the turbidity for a SkyLight
"""
setturbidity!(skylight::SkyLight, turbidity::Number) = rprSkyLightSetTurbidity(skylight.x, turbidity)

"""
Sets the scale for a SkyLight
"""
setscale!(skylight::SkyLight, scale::Number) = rprSkyLightSetScale(skylight, scale)

function set!(context::Context, parameter::rpr_context_info, f::AbstractFloat)
    return rprContextSetParameterByKey1f(context, parameter, f)
end

function set!(context::Context, parameter::rpr_context_info, ui::Integer)
    return rprContextSetParameterByKey1u(context, parameter, ui)
end
function set!(context::Context, parameter::rpr_context_info, ui)
    # overload for enums
    return rprContextSetParameterByKey1u(context, parameter, ui)
end

set!(context::Context, aov::rpr_aov, fb::FrameBuffer) = rprContextSetAOV(context, aov, fb)

function set!(shape::Shape, image::Image)
    return rprShapeSetDisplacementImage(shape, image)
end

function set!(shape::Shape, context::Context, image::Array)
    return set!(shape, Image(context, image))
end

"""
Sets arbitrary values to RadeonProRender objects
"""
set!(context::Context, framebuffer::FrameBuffer) = rprContextSetFrameBuffer(context, framebuffer)

function set!(base::MaterialNode, parameter::rpr_material_node_input, a::Number, b::Number, c::Number,
              d::Number)
    return rprMaterialNodeSetInputFByKey(base, parameter, a, b, c, d)
end

function set!(base::MaterialNode, parameter::rpr_material_node_input, ui::Integer)
    return rprMaterialNodeSetInputUByKey(base, parameter, ui)
end

function set!(base::MaterialNode, parameter::rpr_material_node_input, f::Vec4)
    return set!(base, parameter, f...)
end

function set!(base::MaterialNode, parameter::rpr_material_node_input, color::Colorant)
    c = RGBA{Float32}(color)
    return set!(base, parameter, comp1(c), comp2(c), comp3(c), alpha(c))
end

function set!(mat::MaterialNode, parameter::rpr_material_node_input, enum)
    return set!(mat, parameter, UInt(enum))
end

function set!(shape::Shape, material::MaterialNode)
    return rprShapeSetMaterial(shape, material)
end

function set!(shape::Curve, material::MaterialNode)
    return rprCurveSetMaterial(shape, material)
end

function set!(material::MaterialNode, parameter::rpr_material_node_input, material2::MaterialNode)
    return rprMaterialNodeSetInputNByKey(material, parameter, material2)
end

function set!(shape::MaterialNode, parameter::rpr_material_node_input, grid::VoxelGrid)
    return rprMaterialNodeSetInputGridDataByKey(shape, parameter, grid)
end


function set!(material::MaterialNode, parameter::rpr_material_node_input, image::Image)
    return rprMaterialNodeSetInputImageDataByKey(material, parameter, image)
end

function set!(material::MaterialNode, parameter::rpr_material_node_input, context::Context, image::Array)
    return set!(material, parameter, Image(context, image))
end

function set!(context::Context, scene::Scene)
    return rprContextSetScene(context, scene)
end

function set!(scene::Scene, light::EnvironmentLight)
    return rprSceneSetEnvironmentLight(scene, light)
end

function set!(scene::Scene, camera::Camera)
    return rprSceneSetCamera(scene, camera)
end

"""
Sets the displacement scale for a shape
"""
function setdisplacementscale!(shape::Shape, scale::Number)
    return rprShapeSetDisplacementScale(shape, rpr_float(scale))
end

"""
Sets the subdivions for a shape
"""
function setsubdivisions!(shape::Shape, subdivions::Integer)
    return rprShapeSetSubdivisionFactor(shape, rpr_uint(subdivions))
end

"""
Transforms firerender objects with a transformation matrix
"""
function transform!(shape::Shape, transform::AbstractMatrix)
    return rprShapeSetTransform(shape, false, convert(Matrix{Float32}, transform))
end

function transform!(light::AbstractLight, transform::AbstractMatrix)
    return rprLightSetTransform(light, false, convert(Matrix{Float32}, transform))
end

function transform!(camera::Camera, transform::AbstractMatrix)
    return rprCameraSetTransform(camera, false, convert(Matrix{Float32}, transform))
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
    return rprSceneAttachShape(scene, shape)
end

function Base.push!(scene::Scene, curve::Curve)
    return rprSceneAttachCurve(scene, curve)
end

function Base.push!(scene::Scene, light::AbstractLight)
    return rprSceneAttachLight(scene, light)
end

function set!(context::Context, pe::PostEffect)
    return rprContextAttachPostEffect(context, pe)
end

function Base.delete!(scene::Scene, light::AbstractLight)
    return rprSceneDetachLight(scene, light)
end

function Base.delete!(scene::Scene, shape::Shape)
    return rprSceneDetachShape(scene, shape)
end

"""
Gets the currently attached EnvironmentLight from a scene
"""
function Base.get(scene::Scene, ::Type{EnvironmentLight})
    return EnvironmentLight(rprSceneGetEnvironmentLight(scene))
end

"""
Gets the currently attached Camera from a scene
"""
function Base.get(scene::Scene, ::Type{Camera})
    return Camera(rprSceneGetCamera(scene))
end

"""
Sets the lookat of a camera
"""
function lookat!(camera::Camera, position::Vec3, lookatvec::Vec3, upvec::Vec3)
    return rprCameraLookAt(camera, position..., lookatvec..., upvec...)
end

"""
renders the context
"""
function render(context::Context)
    return rprContextRender(context)
end

"""
Renders a tile of the context
"""
function render(context::Context, tile::Rect)
    mini, maxi = minimum(tile), maximum(tile)
    return rprContextRenderTile(context, mini[1], maxi[1], mini[2], maxi[2])
end

"""
Saves a picture of the current framebuffer at `path`
"""
function save(fb::FrameBuffer, path::AbstractString)
    return rprFrameBufferSaveToFile(fb, path)
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

function multiplier(i, j, n1, n2)
    a = abs(mod(i - div(n1, 2), n1) - div(n1, 2))
    b = abs(mod(j - div(n2, 2), n2) - div(n2, 2))
    return max(a, b)
end

function init_sample_pool(ti)
    samplepool = Tuple{Int,Int}[]
    for i in 1:size(ti.iterable, 1)
        for j in 1:size(ti.iterable, 2)
            append!(samplepool, fill((i, j), multiplier(i, j, size(ti.iterable)...)))
        end
    end
    return samplepool
end

function Base.iterate(ti::MiddleSampleIterator, state=init_sample_pool(ti))
    isempty(state) && return nothing
    i = rand(1:length(state))
    i2 = state[i]
    filter!(state) do s
        return s != i2
    end
    i = sub2ind(size(ti.iterable), i2...)
    return (ti.iterable[i], state)
end

"""
Iterates over all tiles in a Rectangular parent tile.
"""
struct TileIterator
    size::Vec{2,Int}
    tile_size::Vec{2,Int}
    lengths::Vec{2,Int}
end

function TileIterator(size, tile_size)
    s, ts = Vec(size), Vec(tile_size)
    lengths = Vec{2,Int}(ceil(Vec{2,Float64}(s) ./ Vec{2,Float64}(ts)))
    return TileIterator(s, ts, lengths)
end

function Base.getindex(ti::TileIterator, i, j)
    ts = Vec(ti.tile_size)
    xymin = (Vec(i, j) .- 1) .* ts
    xymax = xymin .+ ts
    return Rect(xymin, min(xymax, ti.size) .- xymin)
end

function Base.getindex(ti::TileIterator, linear_index::Int)
    i, j = ind2sub(size(ti), linear_index)
    return ti[i, j]
end

Base.size(ti::TileIterator, i) = ti.lengths[i]
Base.size(ti::TileIterator) = (ti.lengths...,)
Base.length(ti::TileIterator) = prod(ti.lengths)

function Base.iterate(ti::TileIterator, state=1)
    length(ti) > state && return nothing
    return ti[state], state + 1
end

"""
Customizable defaults for the most common tonemapping operations
"""
function set_standard_tonemapping!(context; typ=RPR.RPR_TONEMAPPING_OPERATOR_PHOTOLINEAR,
                                   photolinear_sensitivity=0.5f0, photolinear_exposure=0.5f0,
                                   photolinear_fstop=2.0f0, reinhard02_prescale=1.0f0,
                                   reinhard02_postscale=1.0f0, reinhard02_burn=1.0f0, linear_scale=1.0f0,
                                   aacellsize=4.0, imagefilter_type=RPR.RPR_FILTER_BLACKMANHARRIS,
                                   aasamples=4.0)

    if context.plugin != HybridPro
        norm = PostEffect(context, RPR.RPR_POST_EFFECT_NORMALIZATION)
        set!(context, norm)
        tonemap = PostEffect(context, RPR.RPR_POST_EFFECT_TONE_MAP)
        set!(context, tonemap)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_TYPE, typ)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_LINEAR_SCALE, linear_scale)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_PHOTO_LINEAR_SENSITIVITY, photolinear_sensitivity)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_PHOTO_LINEAR_EXPOSURE, photolinear_exposure)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_PHOTO_LINEAR_FSTOP, photolinear_fstop)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_REINHARD02_PRE_SCALE, reinhard02_prescale)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_REINHARD02_POST_SCALE, reinhard02_postscale)
        set!(context, RPR.RPR_CONTEXT_TONE_MAPPING_REINHARD02_BURN, reinhard02_burn)
        set!(context, RPR.RPR_CONTEXT_IMAGE_FILTER_TYPE, imagefilter_type)

        gamma = PostEffect(context, RPR.RPR_POST_EFFECT_GAMMA_CORRECTION)
        set!(context, gamma)
        set!(context, RPR.RPR_CONTEXT_DISPLAY_GAMMA, 1.0)
    end
    # set!(context, "aacellsize", aacellsize)
    # set!(context, "aasamples", aasamples)
    # set!(context, RPR.RPR_CONTEXT_AA_ENABLED, UInt(1))

    # bloom = PostEffect(context, RPR.RPR_POST_EFFECT_BLOOM)
    # set!(context, bloom)
    # set!(bloom, "weight", 1.0f0)
    # set!(bloom, "radius", 0.4f0)
    # set!(bloom, "threshold", 0.2f0)
    return
end

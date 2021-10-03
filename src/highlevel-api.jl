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
    if object.pointer != C_NULL
        rprObjectDelete(object)
    end
    object.pointer = C_NULL
    return
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
    add_to_context = if argnames[1] == :context
        :(push!(context.objects, object))
    else
        :()
    end
    expr = quote
        mutable struct $name <: $super{$typ}
            pointer::$typ
            $name(pointer::$typ) = new(pointer)
            function $name($(argnames...))
                object = new($target($(argnames...)))
                $add_to_context
                return object
            end
        end
    end
    return esc(expr)
end

mutable struct Context <: RPRObject{rpr_context}
    pointer::rpr_context
    objects::Base.IdSet{RPRObject}
    function Context(api_version, pluginIDs, pluginCount, creation_flags, props=C_NULL, cache_path=C_NULL)
        ptr = rprCreateContext(api_version, pluginIDs, pluginCount, creation_flags, props, cache_path)
        ctx = new(ptr, Base.IdSet{RPRObject}())
        finalizer(release, ctx)
        return ctx
    end
end


"""
Shortcut for Context creation. Leaves empty:
`props`     Context properties, reserved for future use
`cache_path`Full path to kernel cache created by RadeonProRender, NULL means to use current folder
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
    return Context(RPR_API_VERSION, RPR_CONTEXT_OPENCL, creation_flags)
end

function release(context::Context)
    if context.pointer == C_NULL
        @assert isempty(context.objects)
        return
    end
    scenes = Scene[]
    for object in context.objects
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
    rprPostEffectSetParameter1f(pe, param, x)
end

mutable struct VoxelGrid <: RPRObject{rpr_grid}
    pointer::rpr_grid
    grid_values::Vector{Float32}
    grid_indices::Vector{UInt64}
end

function VoxelGrid(context::Context, nx, ny, nz, grid_values::AbstractArray, grid_indices::AbstractArray)
    grid_ptr = Ref{rpr_grid}()

    grid_indices = convert(Vector{UInt64}, vec(grid_indices))
    valuesf0 = convert(Vector{Float32}, vec(grid_values))

    rprContextCreateGrid(context, grid_ptr,
        nx, ny, nz,
        grid_indices, length(grid_indices),
        RPR.RPR_GRID_INDICES_TOPOLOGY_I_U64,
        valuesf0, sizeof(valuesf0), 0
    )
    grid = VoxelGrid(grid_ptr[], valuesf0, grid_indices)
    push!(context.objects, grid)
    return grid
end

function VoxelGrid(context, values::AbstractArray{<: Number, 3})
    indices = UInt64.((1:length(values)) .- 1)
    return VoxelGrid(context, size(values)..., values, indices)
end

@rpr_wrapper_type HeteroVolume rpr_hetero_volume rprContextCreateHeteroVolume (context,) RPRObject

function set_albedo_lookup!(volume::HeteroVolume, colors::AbstractVector)
    RPR.rprHeteroVolumeSetAlbedoLookup(volume, convert(Vector{RGB{Float32}}, colors), length(colors))
end

function set_albedo_grid!(volume::HeteroVolume, albedo::VoxelGrid)
    RPR.rprHeteroVolumeSetAlbedoGrid(volume, albedo)
end

function set_density_lookup!(volume::HeteroVolume, density::AbstractVector)
    RPR.rprHeteroVolumeSetDensityLookup(volume, convert(Vector{Vec3f}, density), length(density))
end

function set_density_grid!(volume::HeteroVolume, density::VoxelGrid)
    RPR.rprHeteroVolumeSetDensityGrid(volume, density)
end

function Base.push!(scene::Scene, volume::HeteroVolume)
    rprSceneAttachHeteroVolume(scene, volume)
end

mutable struct Shape <: RPRObject{rpr_shape}
    pointer::rpr_shape
end

function set!(shape::Shape, volume::HeteroVolume)
    rprShapeSetHeteroVolume(shape, volume)
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
function Shape(context::Context, meshlike; kw...)
    m = uv_normal_mesh(meshlike; kw...)
    v, n, fs, uv = decompose(Point3f, m), normals(m), faces(m), texturecoordinates(m)
    return Shape(context, v, n, fs, uv)
end

function Shape(context::Context, vertices, normals, faces, uvs)
    vraw = reinterpret(Float32, decompose(Point3f, vertices))
    nraw = reinterpret(Float32, decompose(Vec3f, normals))
    uvraw = reinterpret(Float32, map(uv -> Vec2f(1.0 - uv[2], 1.0 - uv[1]), uvs))
    iraw = reinterpret(rpr_int, decompose(TriangleFace{OffsetInteger{-1,rpr_int}}, faces))
    rpr_mesh = rprContextCreateMesh(context, vraw, length(vertices), sizeof(Point3f), nraw, length(normals),
                                    sizeof(Vec3f), uvraw, length(uvs), sizeof(Vec2f), iraw, sizeof(rpr_int),
                                    iraw, sizeof(rpr_int), iraw, sizeof(rpr_int),
                                    fill(rpr_int(3), length(faces)), length(faces))
    shape = Shape(rpr_mesh)
    push!(context.objects, shape)
    return shape
end

"""
Creating a shape from a shape is interpreted as creating an instance.
"""
function Shape(context::Context, shape::Shape)
    inst = Shape(rprContextCreateInstance(context, shape))
    push!(context.objects, inst)
    return inst
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
end

function FrameBuffer(context::Context, c::Type{C}, dims::NTuple{2,Int}) where {C<:Colorant}
    desc = Ref(RPR.rpr_framebuffer_desc(dims...))
    fmt = RPR.rpr_framebuffer_format(length(c), RPR_COMPONENT_TYPE_FLOAT32)
    frame_buffer = FrameBuffer(rprContextCreateFrameBuffer(context, fmt, desc))
    push!(context.objects, frame_buffer)
    return frame_buffer
end

"""
Image wrapper type
"""
mutable struct Image <: RPRObject{rpr_image}
    pointer::rpr_image
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
    return RPR.rpr_image_desc(ntuple(i -> N < i ? 0 : size(image, i), 3)..., row_pitch, 0)
end

"""
Automatically creates an Image from a matrix of colors
"""
function Image(context::Context, image::Array{T,N}) where {T,N}
    desc_ref = Ref(rpr_image_desc(image))
    img = Image(rprContextCreateImage(context, rpr_image_format(image), desc_ref, image))
    push!(context.objects, img)
    return img
end

"""
Automatically loads an image from the given `path`
"""
function Image(context::Context, path::AbstractString)
    img = Image(rprContextCreateImageFromFile(context, path))
    push!(context.objects, img)
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

function set!(context::Context, parameter::rpr_context_info, f::Number)
    return rprContextSetParameterByKey1f(context, parameter, f)
end

function set!(context::Context, parameter::rpr_context_info, ui)
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

function set!(shape::Shape, material::MaterialNode)
    return rprShapeSetMaterial(shape, material)
end

function set!(material::MaterialNode, parameter::rpr_material_node_input, material2::MaterialNode)
    return rprMaterialNodeSetInputNByKey(material, parameter, material2)
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
function transform!(shape::Shape, transform::Mat4f)
    return rprShapeSetTransform(shape, false, convert(Array, transform))
end

function transform!(light::AbstractLight, transform::Mat4f)
    return rprLightSetTransform(light, false, convert(Array, transform))
end

function transform!(camera::Camera, transform::Mat4f)
    return rprCameraSetTransform(camera, false, convert(Array, transform))
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
                                   photolinear_fstop=2f0, reinhard02_prescale=1.0f0,
                                   reinhard02_postscale=1.0f0, reinhard02_burn=1.0f0, linear_scale=1.0f0,
                                   aacellsize=4.0, imagefilter_type=RPR.RPR_FILTER_BLACKMANHARRIS, aasamples=4.0)


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
    # set!(context, "aacellsize", aacellsize)
    # set!(context, "aasamples", aasamples)
    # set!(context, RPR.RPR_CONTEXT_AA_ENABLED, UInt(1))

    println("bloomie")
    # bloom = PostEffect(context, RPR.RPR_POST_EFFECT_BLOOM)
    # set!(context, bloom)
    # set!(bloom, "weight", 1.0f0)
    # set!(bloom, "radius", 0.4f0)
    # set!(bloom, "threshold", 0.2f0)
    return

end
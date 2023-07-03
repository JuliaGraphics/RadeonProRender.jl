using RadeonProRender, GeometryBasics, Colors
using Colors
const RPR = RadeonProRender



function setup_scene()
    context = RPR.Context(resource=RPR.RPR_CREATION_FLAGS_ENABLE_GPU1, plugin=RPR.Northstar)
    scene = RPR.Scene(context)
    matsys = RPR.MaterialSystem(context, 0)
    camera = RPR.Camera(context)
    lookat!(camera, Vec3f(8, 0, 5), Vec3f(2, 0, 2), Vec3f(0, 0, 1))
    RPR.rprCameraSetFocalLength(camera, 45.0)
    set!(scene, camera)
    set!(context, scene)
    env_light = RadeonProRender.EnvironmentLight(context)
    image_path = RPR.assetpath("studio026.exr")
    img = RPR.Image(context, image_path)
    set!(env_light, img)
    setintensityscale!(env_light, 1.1)
    push!(scene, env_light)

    light = RPR.PointLight(context)
    transform!(light, Float32[1.0 0.0 0.0 2.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 5.0; 0.0 0.0 0.0 1.0])
    f = 20
    RPR.setradiantpower!(light, 500 / f, 641 / f, 630 / f)
    push!(scene, light)
    context, scene, matsys
end

context, scene, matsys = setup_scene()

vol_cube = RPR.VolumeCube(context)

transform = Float32[4 0 0 0
        0 4 0 0
        0 0 4 0
        0 0 0 1]

transform!(vol_cube, transform)
push!(scene, vol_cube)

r = LinRange(-1, 1, 100)
cube = [(x .^ 2 + y .^ 2 + z .^ 2) for x in r, y in r, z in r]
volume = Float32.(cube .* (cube .> 1.4))

mini, maxi = extrema(volume)
grid = RPR.VoxelGrid(context, (volume .- mini) ./ (maxi - mini))
gridsampler = RPR.GridSamplerMaterial(matsys)
gridsampler.data = grid

ramp = [
    RGB{Float32}(1.f0, 0.f0, 0.f0),
    RGB{Float32}(0.f0, 1.f0, 0.f0),
    RGB{Float32}(0.f0, 0.f0, 1.f0)
]
img = RPR.Image(context, ramp)
gridsampler2 = RPR.GridSamplerMaterial(matsys)
gridsampler2.data = RPR.VoxelGrid(context, volume.*10f0)

rampSampler2 = RPR.ImageTextureMaterial(matsys)
rampSampler2.data = img
rampSampler2.uv = gridsampler2

# for ramp texture, it's better to clamp it to edges.
# set!(rampSampler2, RPR.RPR_MATERIAL_INPUT_WRAP_U, RPR.RPR_IMAGE_WRAP_TYPE_CLAMP_TO_EDGE)
# set!(rampSampler2, RPR.RPR_MATERIAL_INPUT_WRAP_V, RPR.RPR_IMAGE_WRAP_TYPE_CLAMP_TO_EDGE)

volmat = RPR.VolumeMaterial(matsys)
RPR.rprShapeSetVolumeMaterial(vol_cube, volmat.node)

volmat.density = Vec4f(10, 0, 0, 0)
volmat.densitygrid = gridsampler
volmat.color = rampSampler2

function render(context, path)
    fb_size = (800, 600)
    frame_buffer = RPR.FrameBuffer(context, RGBA, fb_size)
    frame_bufferSolved = RPR.FrameBuffer(context, RGBA, fb_size)
    set!(context, RPR.RPR_AOV_COLOR, frame_buffer)
    set_standard_tonemapping!(context)
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 5000)
    @time RPR.render(context)
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, false)
    return RPR.save(frame_bufferSolved, path)
end

path = joinpath(@__DIR__, "test.png")
render(context, path)

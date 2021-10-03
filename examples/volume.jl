using RadeonProRender, GeometryBasics, Colors
const RPR = RadeonProRender

function translationmatrix(t::Vec{3,T}) where {T}
    T0, T1 = zero(T), one(T)
    return Mat{4}(T1, T0, T0, T0, T0, T1, T0, T0, T0, T0, T1, T0, t[1], t[2], t[3], T1)
end

isdefined(Main, :context) && RPR.release(context)

context = RPR.Context()

scene = RPR.Scene(context)
set!(context, scene)

matsys = RPR.MaterialSystem(context, 0)

camera = RPR.Camera(context)
lookat!(camera, Vec3f0(1.5, 0, 1.5), Vec3f0(0), Vec3f0(0, 0, 1))
RPR.rprCameraSetFocalLength(camera, 45.0)
set!(scene, camera)

env_light = RadeonProRender.EnvironmentLight(context)
image_path = joinpath(@__DIR__, "studio026.exr")
img = RPR.Image(context, image_path)
set!(env_light, img)
setintensityscale!(env_light, 1.2)
push!(scene, env_light)

light = RPR.PointLight(context)
transform!(light, translationmatrix(Vec3f0(2, 0, 5)))
f = 1.5
RPR.setradiantpower!(light, 500 / f, 641 / f, 630 / f)
push!(scene, light)


vol_cube = RadeonProRender.Shape(context, Rect3f(Vec3f(0), Vec3f(1)))
push!(scene, vol_cube)

color_lookup = [colorant"red", colorant"yellow", colorant"green"]
convert(Vector{RGB{Float32}}, color_lookup)
density_lookup = [Vec3f.(10:-1:0);]
n = 128
gridvals = Float32[]
indices1 = UInt64[]

for x in 0:(n-1)
    for y in 0:(n-1)
        for z in 0:(n-1)
            v = y / n
            push!(indices1, (x)*(n*n) + (y)*(n)+z)
            push!(gridvals, v)
        end
    end
end
(a, b) = -1, 2
r = range(-3, stop = 3, length = 1000)
z = ((x,y) -> y.^4 - x.^4 + a.*y.^2 + b.*x.^2).(r, r')
me = [cos.(2 .* pi .* sqrt.(x.^2 + y.^2)) .* (4 .* z) for x=r, y=r, z=r]
mini, maxi = extrema(me)
grid = RPR.VoxelGrid(context, (me .- mini) ./ (maxi - mini))
volume1 = RPR.HeteroVolume(context)
RPR.set_albedo_grid!(volume1, grid)
RPR.set_albedo_lookup!(volume1, color_lookup)
RPR.set_density_grid!(volume1, grid)
RPR.set_density_lookup!(volume1, density_lookup)

mat = RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_TRANSPARENT)
set!(mat, RPR.RPR_MATERIAL_INPUT_COLOR, 1.0f0, 1.0f0, 1.0f0, 1.0f0)
RPR.rprSceneAttachHeteroVolume(scene, volume1)
set!(vol_cube, volume1)
set!(vol_cube, mat)

fb_size = (800, 600)
frame_buffer = RPR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = RPR.FrameBuffer(context, RGBA, fb_size)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)
# to avoid dark transparency, we raise recursion
RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_MAX_RECURSION, 10)
# set_standard_tonemapping!(context)

begin
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 1)
    RPR.render(context)
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, true)
    RPR.save(frame_bufferSolved, "test.png")
end

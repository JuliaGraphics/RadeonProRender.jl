using RadeonProRender, MeshIO, FileIO, GeometryBasics, Colors
using Makie
using Colors: N0f8
const RPR = RadeonProRender

loadasset(paths...) = FileIO.load(joinpath(dirname(pathof(Makie)), "..", "assets", paths...))

function trans_matrix(scale::Vec3, rotation::Vec3)
    trans_scale = Makie.transformationmatrix(Vec3f(0), scale)
    rotation = Mat4f(to_rotation(rotation))
    return trans_scale * rotation
end

# Create a scene
context = RPR.Context()
matsys = RPR.MaterialSystem(context, 0)
scene = RPR.Scene(context)
set!(context, scene)
set_standard_tonemapping!(context)

camera = RPR.Camera(context)
lookat!(camera, Vec3f(1.5), Vec3f(0), Vec3f(0, 0, 1))
RPR.rprCameraSetFocalLength(camera, 45.0)
set!(scene, camera)

env_light = RadeonProRender.EnvironmentLight(context)
image_path = joinpath(@__DIR__, "studio026.exr")
img = RPR.Image(context, image_path)
set!(env_light, img)
setintensityscale!(env_light, 1.5)
push!(scene, env_light)

light = RPR.PointLight(context)
transform!(light, Makie.translationmatrix(Vec3f0(2, 2, 4)))
RPR.setradiantpower!(light, 500, 641, 800)
push!(scene, light)


"""
Generate scales for instances
"""
function update_scales!(last_scales, t)
    n = length(last_scales)
    for i in 1:n
        last_scales[i] = Vec3f(1, 1, sin((t * n) / i)) ./ 3.1
    end
    return last_scales
end

"""
Generate color for instances
"""
function update_colors!(last_colors, t)
    l = length(last_colors)
    for i in eachindex(last_colors)
        last_colors[i] = RGBA{N0f8}(i / l, (cos(t) + 1) / 2, (sin(i / l / 3) + 1) / 2.0, 1.0)
    end
    return last_colors
end

# create some geometry
t = 2.0f0 * pi
cat = loadasset("cat.obj")
sphere = Sphere(Point3f(0), 1.0f0)
position = decompose(Point3f, sphere) # use sphere vertices as position
scale_start = Vec3f[Vec3f(1, 1, rand()) for i in 1:length(position)]
# create a signal of changing colors
color = update_colors!(zeros(RGBA{N0f8}, length(position)), t)
# use sphere normals as rotation vector
rotations = -decompose_normals(sphere)

# create material system
diffuse = RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_DIFFUSE)

# create firerender shape
primitive = RPR.Shape(context, cat)
# pre allocate instances
fr_instances = [RPR.Shape(context, primitive) for i in 1:(length(position) - 1)]
push!(fr_instances, primitive)

# pre allocate shaders
fr_shader = [RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_REFLECTION) for elem in 1:length(position)]

# set shaders and attach instances to scene
for (shader, inst) in zip(fr_shader, fr_instances)
    set!(inst, shader)
    push!(scene, inst)
end

# update scene with the instance signal
fb_size = (800, 600)
frame_buffer = RPR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = RPR.FrameBuffer(context, RGBA, fb_size)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)

function render_scene(path, n=5)
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, n)
    RPR.render(context)
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, false)
    RPR.save(frame_bufferSolved, path)
end

for (i, t) in enumerate(LinRange(0, 3.0, 1000))
    color = update_colors!(color, t)
    scale_start = update_scales!(scale_start, t)
    for (scale, rotation, c, inst, shader) in zip(scale_start, rotations, color, fr_instances, fr_shader)
        transform!(inst, trans_matrix(scale, rotation))
        set!(shader, RPR.RPR_MATERIAL_INPUT_COLOR, c)
    end
    path = joinpath(@__DIR__, "instances", "frame$i.png")
    render_scene(path, 5)
end

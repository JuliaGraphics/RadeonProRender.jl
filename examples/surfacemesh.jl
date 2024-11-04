using RadeonProRender, GeometryBasics, Colors
const RPR = RadeonProRender
using Colors: N0f8

# Create a scene
context = RPR.Context()
scene = RPR.Scene(context)
matsys = RPR.MaterialSystem(context, 0)
camera = RPR.Camera(context)
lookat!(camera, Vec3f(3), Vec3f(0), Vec3f(0, 0, 1))
set!(scene, camera)

# create some x,y,z data
function create_mesh(DN = 512, dphi=pi/200.0f0, dtheta=dphi)
    phi = 0.0f0:dphi:(pi + dphi * 1.5f0)
    theta = (0.0f0:dtheta:(2.0f0 * pi + dtheta * 1.5f0))'

    m0 = 4.0f0;
    m1 = 3.0f0;
    m2 = 2.0f0;
    m3 = 3.0f0;
    m4 = 6.0f0;
    m5 = 2.0f0;
    m6 = 6.0f0;
    m7 = 4.0f0;
    a = @. sin(m0 * phi) ^ m1
    b = @. cos(m2 * phi) ^ m3
    c = @. sin(m4 * theta) ^ m5
    d = @. cos(m6 * theta) ^ m7
    r = @. a + b + c + d;

    x = @. r * sin(phi) * cos(theta)
    y = @. r * cos(phi)
    z = @. r * sin(phi) * sin(theta)

    xyz = Point3f[Point3f(x[i, j], y[i, j], z[i, j]) for i in 1:size(x, 1), j in 1:size(x, 2)]
    r = Tessellation(Rect2f((0, 0), (1, 1)), size(x))
    # decomposing a rectangle into uv and triangles is what we need to map the z coordinates on
    # since the xyz data assumes the coordinates to have the same neighouring relations
    # like a grid
    faces = decompose(GLTriangleFace, r)
    uv = decompose_uv(r)
    # with this we can beuild a mesh
    return GeometryBasics.Mesh(meta(vec(xyz), uv=uv), faces), xyz
end

raw_mesh, xyz = create_mesh()
surfacemesh = RPR.Shape(context, raw_mesh)
push!(scene, surfacemesh)

# create layered material
tex = RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_IMAGE_TEXTURE)
base = RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_DIFFUSE)
top = RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_REFLECTION)

# Diffuse color
set!(base, RPR.RPR_MATERIAL_INPUT_COLOR, tex);
set!(base, RPR.RPR_MATERIAL_INPUT_ROUGHNESS, 0.12, 0.0, 0.0, 1.0)
set!(top, RPR.RPR_MATERIAL_INPUT_COLOR, 0.1, 0.3, 0.9, 1.0)

# Create layered shader
layered = RPR.layeredshader(matsys, base, top)

colorim = map(xyz) do xyz
    return RGBA{N0f8}(clamp(abs(xyz[1]), 0, 1), clamp(abs(xyz[2]), 0, 1), clamp(abs(xyz[3]), 0, 1), 1.0)
end

color = RPR.Image(context, colorim)
set!(tex, RPR.RPR_MATERIAL_INPUT_DATA, color)

set!(surfacemesh, layered)
set!(context, scene)

ibl = RPR.EnvironmentLight(context)
image_path = joinpath(@__DIR__, "studio026.exr")
set!(ibl, context, image_path)
set!(scene, ibl)

set_standard_tonemapping!(context)

fb_size = (800, 600)
frame_buffer = RPR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = RPR.FrameBuffer(context, RGBA, fb_size)
frame_buffer_post = RPR.FrameBuffer(context, RGBA, fb_size)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)

begin
    clear!(frame_buffer)
    clear!(frame_buffer_post)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 100)
    RPR.render(context)
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, true)
    RPR.save(frame_bufferSolved, "surface_mesh.png")
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_buffer_post, false)
    RPR.save(frame_buffer_post, "surface_mesh_postprocess.png")
end

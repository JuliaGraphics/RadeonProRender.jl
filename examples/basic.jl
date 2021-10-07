using RadeonProRender, GeometryBasics, Colors
const RPR = RadeonProRender

function translationmatrix(t::Vec{3,T}) where {T}
    T0, T1 = zero(T), one(T)
    return Mat{4}(T1, T0, T0, T0, T0, T1, T0, T0, T0, T0, T1, T0, t[1], t[2], t[3], T1)
end

context = RPR.Context()
scene = RPR.Scene(context)
matsys = RPR.MaterialSystem(context, 0)

camera = RPR.Camera(context)
lookat!(camera, Vec3f(8, 0, 5), Vec3f(2, 0, 2), Vec3f(0, 0, 1))
RPR.rprCameraSetFocalLength(camera, 45.0)
set!(scene, camera)
set!(context, scene)

env_light = RadeonProRender.EnvironmentLight(context)
image_path = joinpath(@__DIR__, "studio026.exr")
img = RPR.Image(context, image_path)
set!(env_light, img)
setintensityscale!(env_light, 1.1)
push!(scene, env_light)

light = RPR.PointLight(context)
transform!(light, translationmatrix(Vec3f(2, 0, 5)))
f = 20
RPR.setradiantpower!(light, 500 / f, 641 / f, 630 / f)
push!(scene, light)

function add_shape!(scene, context, matsys, mesh; material=RPR.RPR_MATERIAL_NODE_DIFFUSE,
                    color=colorant"green", roughness=0.01)
    rpr_mesh = RadeonProRender.Shape(context, mesh)
    push!(scene, rpr_mesh)
    m = RPR.MaterialNode(matsys, material)
    set!(m, RPR.RPR_MATERIAL_INPUT_COLOR, color)
    set!(m, RPR.RPR_MATERIAL_INPUT_ROUGHNESS, roughness, roughness, roughness, roughness)
    set!(rpr_mesh, m)
    return rpr_mesh, m
end

mesh, mat = add_shape!(scene, context, matsys, Rect3f(Vec3f(-10, -10, -1), Vec3f(20, 20, 1));
                       color=colorant"white")
mesh, mat = add_shape!(scene, context, matsys, Rect3f(Vec3f(0, -10, 0), Vec3f(0.1, 20, 5));
                       color=colorant"white")
mesh, mat = add_shape!(scene, context, matsys, Rect3f(Vec3f(0, -2, 0), Vec3f(5, 0.1, 5));
                       color=colorant"white")
mesh, mat = add_shape!(scene, context, matsys, Rect3f(Vec3f(0, 2, 0), Vec3f(5, 0.1, 5));
                       color=colorant"white")

mesh, mat_sphere = add_shape!(scene, context, matsys, Tesselation(Sphere(Point3f(2, 0, 2), 1.0f0), 100);
                              material=RPR.RPR_MATERIAL_NODE_MICROFACET, roughness=0.2, color=colorant"red")

fb_size = (800, 600)
frame_buffer = RPR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = RPR.FrameBuffer(context, RGBA, fb_size)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)

set_standard_tonemapping!(context)

begin
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 100)
    RPR.render(context)
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, false)
    RPR.save(frame_bufferSolved, "test.png")
end

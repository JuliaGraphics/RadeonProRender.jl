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
image_path = RPR.assetpath("studio026.exr")
img = RPR.Image(context, image_path)
set!(env_light, img)
setintensityscale!(env_light, 1.1)
push!(scene, env_light)

light = RPR.PointLight(context)
transform!(light, translationmatrix(Vec3f(2, 0, 5)))
f = 16
RPR.setradiantpower!(light, 700 / f, 641 / f, 630 / f)
push!(scene, light)

function add_shape!(scene, context, matsys, mesh; material=RPR.RPR_MATERIAL_NODE_DIFFUSE,
                    color=colorant"green", roughness=0.01)
    rpr_mesh = RPR.Shape(context, mesh)
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

mesh, mat = add_shape!(scene, context, matsys, Tesselation(Sphere(Point3f(2, 0, 2), 0.95f0), 100);
                       color=colorant"white")
rpr_mesh = RPR.Shape(context, Tesselation(Sphere(Point3f(2, 0, 2), 1.0f0), 100))
push!(scene, rpr_mesh)
material = RPR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_UBERV2)

# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_COLOR, 0.358878, 0.497024 , 1.07771, 1.0)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_WEIGHT, Vec4f(0.0)...)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_ROUGHNESS, Vec4f(0.1)...)

# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_COLOR, 0.01f0, 0.01f0, 0.01f0, 0.01f0)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_WEIGHT, Vec4f(0.01)...)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_TRANSPARENCY, Vec4f(0.99)...)

set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_COLOR, Vec4f(0.358878, 0.497024 , 1.07771, 1.0)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_WEIGHT, Vec4f(0.8)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ROUGHNESS, Vec4f(0.01)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_IOR, Vec4f(1.0)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_COLOR, Vec4f(0.7, 0.6, 0.09, 1.0)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_DISTANCE, Vec4f(3.0)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_CAUSTICS, Vec4f(0.0)...)

# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ROUGHNESS, 0.1f0, 0f0, 0f0, 0f0)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_MODE, Int(RPR.RPR_UBER_MATERIAL_IOR_MODE_PBR))
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_METALNESS, 0.f0, 0f0, 0f0, 0f0)

set!(material, RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_COLOR, 0.358878, 0.497024 , 1.07771, 1.0)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DISTANCE, Vec4f(3)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DIRECTION, Vec4f(0)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_SSS_WEIGHT, Vec4f(1)...)
set!(material, RPR.RPR_MATERIAL_INPUT_UBER_SSS_MULTISCATTER, 1)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_WEIGHT, Vec4f(1.0)...)
# set!(material, RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_COLOR, 0.4, 0.4, 0.5, 0.1)

set!(rpr_mesh, material)

fb_size = (800, 600)
frame_buffer = RPR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = RPR.FrameBuffer(context, RGBA, fb_size)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)

set_standard_tonemapping!(context)

begin
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 200)
    RPR.render(context)
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, false)
    RPR.save(frame_bufferSolved, "test.png")
end

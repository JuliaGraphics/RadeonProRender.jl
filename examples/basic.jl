
using FireRender, GeometryBasics, Colors
using FireRender: translationmatrix

RPR = FireRender.RPR
FR = FireRender


camera = FR.Camera(context)
lookat!(camera, Vec3f0(90, 20, 100), Vec3f0(0), Vec3f0(0,0,1))
RPR.rprCameraSetFocalLength(camera, 75.0)
set!(scene, camera)
set!(context, scene)

env_light = FireRender.EnvironmentLight(context)
image_path = joinpath(@__DIR__, "studio026.exr")
img = FR.Image(context, image_path)
set!(env_light, img)
setintensityscale!(env_light, 0.5)
push!(scene, env_light)

light = FR.PointLight(context)
transform!(light, translationmatrix(Vec3f(0, 30, 2)))
FR.setradiantpower!(light, 500, 641, 824)
push!(scene, light)

sphere = FireRender.Shape(context, Sphere(Point3f0(0), 5f0))
push!(scene, sphere)
matsys = FR.MaterialSystem(context, 0)
diffuse = FR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_MICROFACET_REFRACTION)
set!(diffuse, RPR.RPR_MATERIAL_INPUT_COLOR, RGBA(colorant"yellow", 0.1))
set!(diffuse, RPR.RPR_MATERIAL_INPUT_ROUGHNESS, 0.01, 0.01, 0.01, 0.0)
set!(diffuse, RPR.RPR_MATERIAL_INPUT_IOR, 2, 2, 2, 2)
set!(diffuse, RPR.RPR_MATERIAL_INPUT_CAUSTICS, 1)
# set!(diffuse, RPR.RPR_MATERIAL_INPUT_REFLECTANCE, 0.5, 0.5, 0.5, 0.5)
set!(sphere, diffuse)

fb_size = (800, 600)
frame_buffer = FR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = FR.FrameBuffer(context, RGBA, fb_size)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)

begin
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_RENDER_MODE, RPR.RPR_RENDER_MODE_GLOBAL_ILLUMINATION)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 1)
    for i in 1:200
        FR.render(context)
    end
    RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, true)
    FR.save(frame_bufferSolved, "test.png")
end

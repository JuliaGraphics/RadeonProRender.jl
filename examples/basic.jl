
using FireRender, GeometryBasics, Colors
using FireRender: translationmatrix

RPR = FireRender.RPR
FR = FireRender

context = FR.Context()
scene = FR.Scene(context)

camera = FR.Camera(context)
lookat!(camera, Vec3f0(3), Vec3f0(0), Vec3f0(0,1,0))
# RPR.rprCameraSetFocalLength(camera, 75.0)
set!(scene, camera)
set!(context, scene)

env_light = FireRender.EnvironmentLight(context)
image_path = joinpath(@__DIR__, "fields.hdr")
img = FR.Image(context, image_path)
set!(env_light, img)
push!(scene, env_light)

light = FR.PointLight(context)
transform!(light, translationmatrix(Vec3f(0, 8, 2)))
FR.setradiantpower!(light, 255, 241, 224)
push!(scene, light)

sphere = FireRender.Shape(context, Sphere(Point3f0(0), 1f0))
push!(scene, sphere)
matsys = FR.MaterialSystem(context, 0)
diffuse = FR.MaterialNode(matsys, RPR.RPR_MATERIAL_NODE_MICROFACET)
set!(diffuse, RPR.RPR_MATERIAL_INPUT_COLOR, RGBA{Float32}(1, 0, 0, 1))
set!(sphere, diffuse)

fb_size = (800, 600)
frame_buffer = FR.FrameBuffer(context, RGBA, fb_size)
frame_bufferSolved = FR.FrameBuffer(context, RGBA, fb_size)
clear!(frame_buffer)
set!(context, RPR.RPR_AOV_COLOR, frame_buffer)

# RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_RENDER_MODE, RPR.RPR_RENDER_MODE_NORMAL)
RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_ITERATIONS, 64)

FR.render(context)
RPR.rprContextResolveFrameBuffer(context, frame_buffer, frame_bufferSolved, true)

FR.save(frame_bufferSolved, "test.png")

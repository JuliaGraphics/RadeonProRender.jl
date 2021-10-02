using RadeonProRender, GeometryBasics, Colors, Makie
using ReferenceTests
using Makie: translationmatrix

include("makie.jl")

earth = ReferenceTests.loadasset("earth.png")
m = uv_mesh(Tesselation(Sphere(Point3f(0), 1.0f0), 60))
f, ax, mplot = Makie.mesh(m; color=earth, shading=false)
mplot2 = Makie.mesh!(ax, Sphere(Point3f0(2, 0, 0), 0.1f0); color=:red)
f

context = RPRContext()
scene = FR.Scene(context.context)
set!(context.context, scene)
cam = Makie.cameracontrols(ax.scene)

camera = to_rpr_camera(context, cam)
set!(scene, camera)

# env_light = FR.EnvironmentLight(context.context)
# image_path = joinpath(@__DIR__, "studio026.exr")
# img = FR.Image(context.context, image_path)
# set!(env_light, img)
# setintensityscale!(env_light, 0.5)
# push!(scene, env_light)

light = FR.PointLight(context.context)
transform!(light, translationmatrix(cam.eyeposition[]))
FR.setradiantpower!(light, 300, 300, 300)
push!(scene, light)

rpr_mesh = to_rpr_mesh(context, mplot)
push!(scene, rpr_mesh)

rpr_mesh2 = to_rpr_mesh(context, mplot2)
push!(scene, rpr_mesh2)

fb_size = (800, 600)
ctx = context.context
frame_buffer = FR.FrameBuffer(ctx, RGBA, fb_size)
frame_bufferSolved = FR.FrameBuffer(ctx, RGBA, fb_size)
set!(ctx, RPR.RPR_AOV_COLOR, frame_buffer)

begin
    clear!(frame_buffer)
    RPR.rprContextSetParameterByKey1u(ctx, RPR.RPR_CONTEXT_RENDER_MODE,
                                      RPR.RPR_RENDER_MODE_GLOBAL_ILLUMINATION)
    RPR.rprContextSetParameterByKey1u(ctx, RPR.RPR_CONTEXT_ITERATIONS, 1)
    for i in 1:200
        FR.render(ctx)
    end
    RPR.rprContextResolveFrameBuffer(ctx, frame_buffer, frame_bufferSolved, true)
    FR.save(frame_bufferSolved, "test.png")
end

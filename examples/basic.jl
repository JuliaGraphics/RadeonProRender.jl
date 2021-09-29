
using FireRender, GeometryBasics
RPR = FireRender.RPR
FR = FireRender
context = FireRender.Context()
matsys = FR.MaterialSystem(context, 0)
scene = FR.Scene(context)
camera = FR.Camera(context)
lookat!(camera, Vec3f0(2.6), Vec3f0(0), Vec3f0(0,0,1))
set!(scene, camera)

sphere = FireRender.Shape(context, Sphere(Point3f0(0), 1f0))
ibl = FireRender.EnvironmentLight(context)
set!(scene, ibl)
set_standard_tonemapping!(context)

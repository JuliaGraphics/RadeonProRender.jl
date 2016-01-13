using FireRender, GeometryTypes, GLAbstraction
include("glvisualize_backend.jl")
const FR = FireRender
status = Ref{Cint}(FR.SUCCESS)
# Create OpenCL context using a single GPU 
context = frCreateContext(
	FR.API_VERSION, FR.CONTEXT_OPENCL, 
	FR.CREATION_FLAGS_ENABLE_GPU0 | FR.CREATION_FLAGS_ENABLE_CPU, 
	C_NULL, C_NULL, status
)
# Check if it is created successfully
if status[] != FR.SUCCESS
error("Context creation failed: check your OpenCL runtime and driver versions.")
end
println("Context successfully created.")

# Create a scene
scene = frContextCreateScene(context, status)
@assert(status[] == FR.SUCCESS)


# Create cube mesh
cube = vis(context, AABB(Vec3f0(0), Vec3f0(2)))
# Create plane mesh
plane = vis(context, AABB(Vec3f0(-5,-0.01,-5), Vec3f0(10,0.01,10)))

# Add cube into the scene
s = frSceneAttachShape(scene, cube);
@assert(s == FR.SUCCESS);

# Create a transform: -2 unit along X axis and 1 unit up Y axis
#m = [translationmatrix(Vec3f0(-2, 1, 0))]

# Set the transform 
#s = frShapeSetTransform(cube, FR.TRUE, reinterpret(Float32, m, (16,)));
@assert(s == FR.SUCCESS);

# Add plane into the scene
s = frSceneAttachShape(scene, plane)
@assert(s == FR.SUCCESS);

# Create camera
camera = frContextCreateCamera(context, status);
@assert(status[] == FR.SUCCESS);

# Position camera in world space: 
# Camera position is (0,3,17)
# Camera aimed at (0,0,0)
# Camera up vector is (0,1,0)
s = frCameraLookAt(camera, -6, 6, 6, 0, 0, 0, 0, 1, 0);
@assert(s == FR.SUCCESS);

# Set camera for the scene
s = frSceneSetCamera(scene, camera);
@assert(s == FR.SUCCESS);

# Set scene to render for the context
s = frContextSetScene(context, scene);
@assert(s == FR.SUCCESS);

# Create simple diffuse shader
diffuse = frContextCreateShader(context, FR.SHADER_LAMBERT, status);
@assert(status[] == FR.SUCCESS);

# Set diffuse color parameter to gray
s = frShaderSetParameter4f(diffuse, "kd", 0.7f0, 0.7f0, 0.7f0, 1.f0);
@assert(s == FR.SUCCESS);

# Set shader for cube & plane meshes
s = frShapeSetShader(cube, diffuse);
@assert(s == FR.SUCCESS);

s = frShapeSetShader(plane, diffuse);
@assert(s == FR.SUCCESS);



# Create image-based environment light
ibl = frContextCreateEnvironmentLight(context, status);
assert(status[] == FR.SUCCESS);

# Set an image for the light to take the radiance values from
s = frEnvironmentLightSetImagePath(ibl, joinpath(homedir(),"Desktop", "FRSDK 1.078", "Resources","Textures","Apartment.hdr"))
assert(s == FR.SUCCESS);

# Set IBL as a background for the scene
s = frSceneSetEnvironmentLight(scene, ibl);
assert(s == FR.SUCCESS);


# Create framebuffer to store rendering result
desc = Ref(FR.fr_framebuffer_desc(800, 600))

# 4 component 32-bit float value each
fmt = FR.fr_image_format(4, FR.COMPONENT_TYPE_FLOAT32)
frame_buffer = frContextCreateFrameBuffer(context, fmt, desc, status);
@assert(status[] == FR.SUCCESS);

# Clear framebuffer to black color
frFrameBufferClear(frame_buffer)

# Set framebuffer for the context
s = frContextSetFrameBuffer(context, frame_buffer);
@assert(s == FR.SUCCESS);

# Progressively render an image
for i=1:64
    s = frContextRender(context);
    @assert(s == FR.SUCCESS);
end

println("Rendering finished.")

# Save the result to file
status = frFrameBufferSaveToFile(frame_buffer, "simple_render.png");
@assert(status == FR.SUCCESS);

# Release the stuff we created
frShapeRelease(plane);
frShapeRelease(cube);
frShaderRelease(diffuse);
frSceneRelease(scene);
frCameraRelease(camera);
frFrameBufferRelease(frame_buffer);
frContextRelease(context);
println("doone!")
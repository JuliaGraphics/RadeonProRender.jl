using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO
const FR = FireRender
w,r=glscreen()

# Create OpenCL context using a single GPU 
context = FR.Context(
	FR.API_VERSION, FR.CONTEXT_OPENCL, 
	FR.CREATION_FLAGS_ENABLE_GPU0 | FR.CREATION_FLAGS_ENABLE_GL_INTEROP
)


# Create a scene
scene = FR.Scene(context)

# Create cube mesh
sphere = FR.Shape(context, load("cat.obj"))
push!(scene, sphere)

# Create simple reflection shader
shader = FR.Shader(context, FR.SHADER_LAMBERT)

# Set specular color parameter to yellow
set!(shader, "kd", 0.7, 0.7, 0.0, 1.)
# Set shader for shpere mesh
set!(sphere, shader)


function instanceit(N)
	positions = Array(Point3f0, N)
	shaders   = Array(FR.Shader, N)
	scales 	  = Array(Vec3f0, N)
	rotations = Vec3f0(0)
	for i=1:N
	    # Create a scaling transform
	    positions[i] = Point3f0( 
	    	(i & 7) - 3.5f0,
	    	rand(Float32) - 0.5f0,
	    	(i >> 3) - 3.5f0,
		)
		scales[i] = Vec3f0(rand(0.1:4.0))
	    t = rand(Bool)
	    base = FR.Shader(context, t ? FR.SHADER_LAMBERT : FR.SHADER_DIFFUSE_ORENNAYAR)
	    t = rand(Bool)
	    top = FR.Shader(context, t ? FR.SHADER_REFLECT : FR.SHADER_MICROFACET)
	    # Set shader parameters
	    baseior = 3.f0 * rand(Float32) + 1.3f0;
	    topior  = 3.f0 * rand(Float32) + 1.3f0;
	    # Index of refraction
	    set!(base, "ni", baseior);
	    set!(top, "ni", topior);
	    # Diffuse color
	    set!(base, "kd", rand(Float32), rand(Float32), rand(Float32), 1.f0);
	    # Specular color
	    set!(top, "ks", rand(Float32), rand(Float32), rand(Float32), 1.f0);
	    # Roughness
	    set!(top, "ns", 0.1f0 + rand(Float32) * 0.8f0);

	    # Create layered shader
	    shaders[i] = FR.create_layered_shader(context, base, top, baseior, topior);
	end
	instance(context, scene, sphere, scales, positions, rotations, shaders)
end
instanceit(32)

# Create camera
camera = FR.Camera(context)

cam = w.cameras[:perspective]

# Set camera for the scene
set!(scene, camera);
set!(context, scene);
ibl = FR.EnvironmentLight(context);
setimagepath!(ibl, joinpath(homedir(), "Desktop", "FRSDK 1.078", "Resources", "Textures", "Apartment.hdr"))
set!(scene, ibl);

gl_fb = w.inputs[:framebuffer_size].value
texture = Texture(RGBA{Float16}, (gl_fb...))
view(visualize(texture), method=:fixed_pixel)
g_frame_buffer = FR.FrameBuffer(context, texture)

@async r()
map(cam.eyeposition) do position
	l,u = cam.lookat.value, cam.up.value
	frCameraLookAt(camera.x, position..., l..., u...)
	clear!(g_frame_buffer)
end
while isopen(w)
	glFlush()
	glBindTexture(GL_TEXTURE_2D, 0);
	frContextRender(context.x)
	yield()
end
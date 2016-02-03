using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
using GLWindow
const FR = FireRender
w=glscreen()

# Create OpenCL context using a single GPU
context, g_frame_buffer = FR.Context(
	FR.API_VERSION, FR.CONTEXT_OPENCL,
	FR.CREATION_FLAGS_ENABLE_GPU0 | FR.CREATION_FLAGS_ENABLE_GL_INTEROP
)
#set!(context, "rendermode", FR.RENDER_MODE_WIREFRAME)
DN = 512
# Create a scene
scene = FR.Scene(context)

dphi, dtheta = pi/200.0f0, pi/200.0f0
function mgrid(dim1, dim2)
    X = [i for i in dim1, j in dim2]
    Y = [j for i in dim1, j in dim2]
    return X,Y
end
phi,theta = mgrid(0f0:dphi:(pi+dphi*1.5f0), 0f0:dtheta:(2f0*pi+dtheta*1.5f0));
m0 = 4f0; m1 = 3f0; m2 = 2f0; m3 = 3f0; m4 = 6f0; m5 = 2f0; m6 = 6f0; m7 = 4f0;
a = sin(m0*phi).^m1;
b = cos(m2*phi).^m3;
c = sin(m4*theta).^m5;
d = cos(m6*theta).^m7;
r = a + b + c + d;

const x = r.*sin(phi).*cos(theta);
const y = r.*cos(phi);
const z = r.*sin(phi).*sin(theta);
size_grid = (size(x,1)-1, size(x,2)-1)
xyz = Point3f0[Point3f0(x[i,j],y[i,j],z[i,j]) for i=1:size(x,1), j=1:size(x,2)]
r = SimpleRectangle(0,0,1,1)
faces = decompose(GLTriangle, r, size_grid)
uv = decompose(UV{Float32}, r, size_grid)
mesh = GLUVMesh(Dict{Symbol, Any}(
	:vertices=>vec(xyz), :faces=>faces, :texturecoordinates=>uv
))

surfacemesh = FR.Shape(context, mesh)
push!(scene, surfacemesh)

matsys = FR.MaterialSystem(context, 0)
tex = FR.MaterialNode(matsys, FR.MATERIAL_NODE_IMAGE_TEXTURE)

base = FR.MaterialNode(matsys, FR.MATERIAL_NODE_DIFFUSE)
top = FR.MaterialNode(matsys, FR.MATERIAL_NODE_REFLECTION)
# Set shader parameters
baseior = 1.4
topior = 3.3
# Diffuse color
set!(base, "color", tex);
set!(top, "color", 0.1, 0.3, 0.9, 1.)
set!(top, "roughness", 0.12, 0., 0., 1.);
# Create layered shader
layered = layeredshader(matsys, base, top);

colorim = map(xyz) do xyz
	RGBA{U8}(clamp(abs(xyz[1]), 0,1), clamp(abs(xyz[2]), 0,1), clamp(abs(xyz[3]), 0,1), 1.0)
end
color = FR.Image(context,colorim)
set!(tex, "data", color)

set!(surfacemesh, layered)

camera = FR.Camera(context)
set!(scene, camera)
set!(context, scene)
lookat!(camera, Vec3f0(0,6,4.5), Vec3f0(0), Vec3f0(0,0,1))


ibl = FR.EnvironmentLight(context)
imgpath = joinpath("C:\\","Program Files","KeyShot6","bin","Materials 2k.hdr")
img = FR.Image(context, imgpath)
set!(ibl, img)
set!(scene, ibl)

set!(context, "toneMapping.type", FR.TONEMAPPING_OPERATOR_PHOTOLINEAR);
set!(context, "tonemapping.linear.scale", 1f0);
set!(context, "tonemapping.photolinear.sensitivity", 1f0);
set!(context, "tonemapping.photolinear.exposure", 1f0);
set!(context, "tonemapping.photolinear.fstop", 1f0);
set!(context, "tonemapping.reinhard02.prescale", 1f0);
set!(context, "tonemapping.reinhard02.postscale", 1f0);
set!(context, "tonemapping.reinhard02.burn", 1f0);
set!(context, "tonemapping.linear.scale", 1f0);
set!(context, "tonemapping.linear.scale", 1f0);

set!(context, "aacellsize", 4.)
set!(context, "imagefilter.type", FR.FILTER_BLACKMANHARRIS)
set!(context, "aasamples", 4.)

# Create camera

gl_fb = w.inputs[:framebuffer_size].value
texture = Texture(RGBA{Float16}, (gl_fb...))
view(visualize(texture), method=:fixed_pixel)
g_frame_buffer = FR.FrameBuffer(context, texture)
set!(context, FR.AOV_COLOR, g_frame_buffer)


frame = 1
for i=1f0:360f0
	transform!(surfacemesh, rotationmatrix_z(deg2rad(i)))
	isopen(w) || break
	clear!(g_frame_buffer)
	@time for i=1:20
		glBindTexture(GL_TEXTURE_2D, 0)
		@time render(context)
		isopen(w) || break
		GLWindow.renderloop_inner(w)
	end
	println()
	isopen(w) || break
	try
		screenshot(w, path="test$frame.png")
	catch e
		println(e)
	end
	frame += 1
end

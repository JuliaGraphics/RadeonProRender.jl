using FireRender, GeometryTypes, GLAbstraction, GLVisualize, Colors, ModernGL, FileIO, Reactive
using GLWindow
const FR = FireRender
w=glscreen()

context, g_frame_buffer = interactive_context(w)

# Create a scene
scene = FR.Scene(context)

camera = FR.Camera(
	context, g_frame_buffer, 
	PerspectiveCamera(w.inputs, Vec3f0(3), Vec3f0(0))
)
set!(scene, camera)

DN = 512
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



set!(context, scene)



ibl = FR.EnvironmentLight(context)
imgpath = joinpath("C:\\","Program Files","KeyShot6","bin","Materials 2k.hdr")
img = FR.Image(context, imgpath)
set!(ibl, img)
set!(scene, ibl)

set_standard_tonemapping!(context, aacellsize=4.0, aasamples=1.0)

tiledrenderloop(w, context, g_frame_buffer)


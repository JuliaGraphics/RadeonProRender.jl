const firelib = "FireRender64"
function check_error(error_code)
	error_code == SUCCESS && return
	ERROR_COMPUTE_API_NOT_SUPPORTED == error_code && error("ERROR_COMPUTE_API_NOT_SUPPORTED")
	ERROR_OUT_OF_SYSTEM_MEMORY == error_code && error("ERROR_OUT_OF_SYSTEM_MEMORY")
	ERROR_OUT_OF_VIDEO_MEMORY == error_code && error("ERROR_OUT_OF_VIDEO_MEMORY")
	ERROR_INVALID_LIGHTPATH_EXPR == error_code && error("ERROR_INVALID_LIGHTPATH_EXPR")
	ERROR_INVALID_IMAGE == error_code && error("ERROR_INVALID_IMAGE")
	ERROR_INVALID_AA_METHOD == error_code && error("ERROR_INVALID_AA_METHOD")
	ERROR_UNSUPPORTED_IMAGE_FORMAT == error_code && error("ERROR_UNSUPPORTED_IMAGE_FORMAT")
	ERROR_INVALID_GL_TEXTURE == error_code && error("ERROR_INVALID_GL_TEXTURE")
	ERROR_INVALID_CL_IMAGE == error_code && error("ERROR_INVALID_CL_IMAGE")
	ERROR_INVALID_OBJECT == error_code && error("ERROR_INVALID_OBJECT")
	ERROR_INVALID_PARAMETER == error_code && error("ERROR_INVALID_PARAMETER")
	ERROR_INVALID_TAG == error_code && error("ERROR_INVALID_TAG")
	ERROR_INVALID_LIGHT == error_code && error("ERROR_INVALID_LIGHT")
	ERROR_INVALID_CONTEXT == error_code && error("ERROR_INVALID_CONTEXT")
	ERROR_UNIMPLEMENTED == error_code && error("ERROR_UNIMPLEMENTED")
	ERROR_INVALID_API_VERSION == error_code && error("ERROR_INVALID_API_VERSION")
	ERROR_INTERNAL_ERROR == error_code && error("ERROR_INTERNAL_ERROR")
	ERROR_IO_ERROR == error_code && error("ERROR_IO_ERROR")
	ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE == error_code && error("ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE")
end

#****************************************************************************\
#
#  Module Name    FireRender.h
#  Project        FireRender Engine
#
#  Description    Fire Render Interface header
#
#  Copyright 2015 Advanced Micro Devices, Inc.
#
#  All rights reserved.  This notice is intended as a precaution against
#  inadvertent publication and does not imply publication or any waiver
#  of confidentiality.  The year included in the foregoing notice is the
#  year of creation of the work.
#  @author Dmitry Kozlov (dmitry.kozlov@amd.com)
#  @author Takahiro Harada (takahiro.harada@amd.com)
#  @bug No known bugs.
#
#****************************************************************************/
const API_VERSION = 0x010000090
const API_ENTRY = 
# fr_status 
const SUCCESS                                       = 0
const ERROR_COMPUTE_API_NOT_SUPPORTED              = -1
const ERROR_OUT_OF_SYSTEM_MEMORY                   = -2
const ERROR_OUT_OF_VIDEO_MEMORY                    = -3
const ERROR_INVALID_LIGHTPATH_EXPR                 = -5
const ERROR_INVALID_IMAGE                          = -6
const ERROR_INVALID_AA_METHOD                      = -7
const ERROR_UNSUPPORTED_IMAGE_FORMAT               = -8
const ERROR_INVALID_GL_TEXTURE                     = -9
const ERROR_INVALID_CL_IMAGE                       = -10
const ERROR_INVALID_OBJECT                         = -11
const ERROR_INVALID_PARAMETER                      = -12
const ERROR_INVALID_TAG                            = -13
const ERROR_INVALID_LIGHT                          = -14
const ERROR_INVALID_CONTEXT                        = -15
const ERROR_UNIMPLEMENTED                          = -16
const ERROR_INVALID_API_VERSION                    = -17
const ERROR_INTERNAL_ERROR                         = -18
const ERROR_IO_ERROR                               = -19
const ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE      = -20
# fr_parameter_type 
const PARAMETER_TYPE_FLOAT  = 0x1
const PARAMETER_TYPE_FLOAT2 = 0x2
const PARAMETER_TYPE_FLOAT3 = 0x3
const PARAMETER_TYPE_FLOAT4 = 0x4
const PARAMETER_TYPE_IMAGE  = 0x5
const PARAMETER_TYPE_STRING = 0x6
const PARAMETER_TYPE_SHADER = 0x7
const PARAMETER_TYPE_UINT   = 0x8
# fr_image_type 
const IMAGE_TYPE_1D = 0x1
const IMAGE_TYPE_2D = 0x2
const IMAGE_TYPE_3D = 0x3
# fr_context_type 
const CONTEXT_OPENCL        = 0x1
const CONTEXT_DIRECTCOMPUTE = 0x2
const CONTEXT_REFERENCE     = 0x3
# fr_creation_flags 
const CREATION_FLAGS_ENABLE_GPU0        = (1 << 0)
const CREATION_FLAGS_ENABLE_GPU1        = (1 << 1)
const CREATION_FLAGS_ENABLE_GPU2        = (1 << 2)
const CREATION_FLAGS_ENABLE_GPU3        = (1 << 3)
const CREATION_FLAGS_ENABLE_CPU         = (1 << 4)
const CREATION_FLAGS_ENABLE_GL_INTEROP  = (1 << 5)
# fr_aa_filter 
const FILTER_BOX            = 0x1
const FILTER_TRIANGLE       = 0x2
const FILTER_GAUSSIAN       = 0x3
const FILTER_MITCHELL       = 0x4
const FILTER_LANCZOS        = 0x5
const FILTER_BLACKMANHARRIS = 0x6
# fr_shape_type 
const SHAPE_TYPE_MESH           = 0x1
const SHAPE_TYPE_INSTANCE       = 0x2
# fr_light_type 
const LIGHT_TYPE_POINT       = 0x1
const LIGHT_TYPE_DIRECTIONAL = 0x2
const LIGHT_TYPE_SPOT        = 0x3
const LIGHT_TYPE_ENVIRONMENT = 0x4
const LIGHT_TYPE_SKY         = 0x5
# fr_context_info 
const CONTEXT_COMPUTE_API          = 0x101
const CONTEXT_RENDER_STATUS        = 0x102
const CONTEXT_RENDER_STATISTICS    = 0x103
const CONTEXT_DEVICE_COUNT         = 0x104
const CONTEXT_PARAMETER_COUNT      = 0x10F
# fr_camera_info 
const CAMERA_TRANSFORM       = 0x201
const CAMERA_FSTOP           = 0x202
const CAMERA_APERTURE_BLADES = 0x203
const CAMERA_RESPONSE        = 0x204
const CAMERA_EXPOSURE        = 0x205
const CAMERA_FOCAL_LENGTH    = 0x206
const CAMERA_SENSOR_SIZE     = 0x207
const CAMERA_MODE            = 0x208
const CAMERA_ORTHO_WIDTH     = 0x209
const CAMERA_FOCUS_DISTANCE  = 0x20A
const CAMERA_POSITION        = 0x20B
const CAMERA_LOOKAT          = 0x20C
const CAMERA_UP              = 0x20D
# fr_image_info 
const IMAGE_FORMAT       = 0x301
const IMAGE_DESC         = 0x302
const IMAGE_DATA         = 0x303
# fr_shape_info 
const SHAPE_TYPE            = 0x401
const SHAPE_VIDMEM_USAGE    = 0x402
const SHAPE_TRANSFORM       = 0x403
const SHAPE_MATERIAL        = 0x404
const SHAPE_LINEAR_MOTION   = 0x405
const SHAPE_ANGULAR_MOTION  = 0x406
const SHAPE_VISIBILITY_FLAG = 0x407
const SHAPE_SHADOW_FLAG     = 0x408
const SHAPE_SUBDIVISION_FACTOR = 0x409	
const SHAPE_DISPLACEMENT_SCALE = 0x40A
const SHAPE_DISPLACEMENT_IMAGE = 0x40B
# fr_mesh_info 
const MESH_POLYGON_COUNT   = 0x501
const MESH_VERTEX_COUNT    = 0x502
const MESH_NORMAL_COUNT    = 0x503
const MESH_UV_COUNT        = 0x504
const MESH_VERTEX_ARRAY    = 0x505
const MESH_NORMAL_ARRAY    = 0x506
const MESH_UV_ARRAY        = 0x507
const MESH_VERTEX_INDEX_ARRAY = 0x508
const MESH_NORMAL_INDEX_ARRAY = 0x509
const MESH_UV_INDEX_ARRAY     = 0x50A
const MESH_NUM_VERTICES_ARRAY = 0x50B
# fr_scene_info 
const SCENE_SHAPE_COUNT   = 0x701
const SCENE_LIGHT_COUNT   = 0x702
const SCENE_SHAPE_LIST    = 0x704
const SCENE_LIGHT_LIST    = 0x705
# fr_light_info 
const LIGHT_TYPE         = 0x801
const LIGHT_VIDMEM_USAGE = 0x802
const LIGHT_TRANSFORM    = 0x803
# fr_light_info - point light 
const POINT_LIGHT_RADIANT_POWER = 0x804
# fr_light_info - directional light 
const DIRECTIONAL_LIGHT_RADIANT_POWER = 0x808
# fr_light_info - spot light 
const SPOT_LIGHT_RADIANT_POWER = 0x80B
const SPOT_LIGHT_CONE_SHAPE = 0x80C
# fr_light_info - environment light 
const ENVIRONMENT_LIGHT_IMAGE = 0x80F
const ENVIRONMENT_LIGHT_INTENSITY_SCALE = 0x810
const ENVIRONMENT_LIGHT_PORTAL = 0x811
# fr_light_info - sky light 
const SKY_LIGHT_TURBIDITY = 0x812
const SKY_LIGHT_ALBEDO    = 0x813
const SKY_LIGHT_SCALE     = 0x814
const SKY_LIGHT_PORTAL    = 0x815
# fr_parameter_info 
const PARAMETER_NAME        = 0x1201
const PARAMETER_TYPE        = 0x1202
const PARAMETER_DESCRIPTION = 0x1203
const PARAMETER_VALUE       = 0x1204
# fr_framebuffer_info 
const FRAMEBUFFER_FORMAT       = 0x1301
const FRAMEBUFFER_DESC         = 0x1302
const FRAMEBUFFER_DATA         = 0x1303
# fr_mesh_polygon_info 
const MESH_POLYGON_VERTEX_COUNT = 0x1401
# fr_mesh_polygon_vertex_info 
const MESH_POLYGON_VERTEX_POSITION   = 0x1501
const MESH_POLYGON_VERTEX_NORMAL     = 0x1502
const MESH_POLYGON_VERTEX_TEXCOORD   = 0x1503
# fr_image_format 
# fr_component_type 
const COMPONENT_TYPE_UINT8     = 0x1
const COMPONENT_TYPE_FLOAT16   = 0x2
const COMPONENT_TYPE_FLOAT32   = 0x3
# fr_render_mode 
const RENDER_MODE_GLOBAL_ILLUMINATION              = 0x1
const RENDER_MODE_DIRECT_ILLUMINATION              = 0x2
const RENDER_MODE_DIRECT_ILLUMINATION_NO_SHADOW    = 0x3
const RENDER_MODE_WIREFRAME                        = 0x4
const RENDER_MODE_DIFFUSE_ALBEDO                   = 0x5
const RENDER_MODE_POSITION                         = 0x6
const RENDER_MODE_NORMAL                           = 0x7
const RENDER_MODE_TEXCOORD                         = 0x8
const RENDER_MODE_AMBIENT_OCCLUSION                = 0x9
# fr_camera_mode 
const CAMERA_MODE_PERSPECTIVE              = 0x1
const CAMERA_MODE_ORTHOGRAPHIC             = 0x2
# fr_tonemapping_operator 
const TONEMAPPING_OPERATOR_NONE        = 0x0
const TONEMAPPING_OPERATOR_LINEAR      = 0x1
const TONEMAPPING_OPERATOR_PHOTOLINEAR = 0x2
const TONEMAPPING_OPERATOR_AUTOLINEAR  = 0x3
const TONEMAPPING_OPERATOR_MAXWHITE    = 0x4
const TONEMAPPING_OPERATOR_REINHARD02  = 0x5
# fr_volume_type 
const VOLUME_TYPE_NONE          = 0xFFFF
const VOLUME_TYPE_HOMOGENEOUS   = 0x0
const VOLUME_TYPE_HETEROGENEOUS = 0x1
# fr_material_node_info
const MATERIAL_NODE_TYPE = 0x1101
const MATERIAL_NODE_INPUT_COUNT = 0x1102
# fr_material_node_input_info 
const MATERIAL_NODE_INPUT_NAME = 0x1103
const MATERIAL_NODE_INPUT_DESCRIPTION = 0x1104
const MATERIAL_NODE_INPUT_VALUE = 0x1105
const MATERIAL_NODE_INPUT_TYPE = 0x1106
# fr_material_node_type 
const MATERIAL_NODE_DIFFUSE = 0x1
const MATERIAL_NODE_MICROFACET = 0x2
const MATERIAL_NODE_REFLECTION = 0x3
const MATERIAL_NODE_REFRACTION = 0x4
const MATERIAL_NODE_MICROFACET_REFRACTION = 0x5
const MATERIAL_NODE_TRANSPARENT = 0x6
const MATERIAL_NODE_EMISSIVE = 0x7
const MATERIAL_NODE_WARD = 0x8
const MATERIAL_NODE_ADD = 0x9
const MATERIAL_NODE_BLEND = 0xA
const MATERIAL_NODE_ARITHMETIC = 0xB
const MATERIAL_NODE_FRESNEL = 0xC
const MATERIAL_NODE_NORMAL_MAP = 0xD
const MATERIAL_NODE_IMAGE_TEXTURE = 0xE
const MATERIAL_NODE_NOISE2D_TEXTURE = 0xF
const MATERIAL_NODE_DOT_TEXTURE = 0x10
const MATERIAL_NODE_GRADIENT_TEXTURE = 0x11
const MATERIAL_NODE_CHECKER_TEXTURE = 0x12
const MATERIAL_NODE_CONSTANT_TEXTURE = 0x13
const MATERIAL_NODE_INPUT_LOOKUP = 0x14
const MATERIAL_NODE_STANDARD = 0x15
const MATERIAL_NODE_BLEND_VALUE = 0x16
const MATERIAL_NODE_PASSTHROUGH = 0x17
const MATERIAL_NODE_ORENNAYAR = 0x18
# fr_material_node_arithmetic_operation 
const MATERIAL_NODE_OP_ADD = 0x0
const MATERIAL_NODE_OP_SUB = 0x1
const MATERIAL_NODE_OP_MUL = 0x2
const MATERIAL_NODE_OP_DIV = 0x3
const MATERIAL_NODE_OP_SIN = 0x4
const MATERIAL_NODE_OP_COS = 0x5
const MATERIAL_NODE_OP_TAN = 0x6
const MATERIAL_NODE_OP_SELECT_X = 0x7
const MATERIAL_NODE_OP_SELECT_Y = 0x8
const MATERIAL_NODE_OP_SELECT_Z = 0x9
const MATERIAL_NODE_OP_DOT3 = 0xA
const MATERIAL_NODE_OP_POW  = 0xB
# fr_material_node_lookup_value 
const MATERIAL_NODE_LOOKUP_UV = 0x0
const MATERIAL_NODE_LOOKUP_N  = 0x1
const MATERIAL_NODE_LOOKUP_P  = 0x2
const MATERIAL_NODE_LOOKUP_INVEC = 0x3
const MATERIAL_NODE_LOOKUP_OUTVEC = 0x4
#fr_aov
const AOV_COLOR   = 0x0
const AOV_OPACITY = 0x1
const AOV_UV = 0x3
const AOV_MATERIAL_IDX = 0x4
const AOV_GEOMETRIC_NORMAL = 0x5
const AOV_SHADING_NORMAL = 0x6
const AOV_MAX = 0xF
const MATERIAL_NODE_INPUT_TYPE_FLOAT4 = 0x1
const MATERIAL_NODE_INPUT_TYPE_UINT = 0x2
const MATERIAL_NODE_INPUT_TYPE_NODE = 0x3
# Constants 
const MAX_AA_SAMPLES   = 32
const MAX_AA_GRID_SIZE = 16
# fr_bool 
const FALSE = 0
const TRUE  = 1
# Library types 
# This is going to be moved to fr_platform.h or similar 
typealias fr_char Cchar
typealias fr_uchar Cuchar
typealias fr_int Cint
typealias fr_uint Cuint
typealias fr_long Clong
typealias fr_ulong Culong
typealias fr_short Cshort
typealias fr_ushort Cushort
typealias fr_float Cfloat
typealias fr_double Cdouble
typealias fr_longlong Clonglong
typealias fr_bool Cint
typealias fr_bitfield fr_uint
#                fr_context;
typealias fr_context Ptr{Void}
#                fr_camera;
typealias fr_camera Ptr{Void}
#                fr_shape;
typealias fr_shape Ptr{Void}
#                fr_light;
typealias fr_light Ptr{Void}
#                fr_scene;
typealias fr_scene Ptr{Void}
#                fr_image;
typealias fr_image Ptr{Void}
#                fr_framebuffer;
typealias fr_framebuffer Ptr{Void}
#				 fr_material_system;
typealias fr_material_system Ptr{Void}
#				 fr_material_node;
typealias fr_material_node Ptr{Void}
#                fr_context_properties;
typealias fr_context_properties Ptr{Void}
typealias fr_light_type fr_uint
typealias fr_image_type fr_uint
typealias fr_shape_type fr_uint
typealias fr_context_type fr_uint
typealias fr_creation_flags fr_bitfield
typealias fr_aa_filter fr_uint
typealias fr_context_info fr_uint
typealias fr_camera_info fr_uint
typealias fr_image_info fr_uint
typealias fr_shape_info fr_uint
typealias fr_mesh_info fr_uint
typealias fr_mesh_polygon_info fr_uint
typealias fr_mesh_polygon_vertex_info fr_uint
typealias fr_light_info fr_uint
typealias fr_scene_info fr_uint
typealias fr_parameter_info fr_uint
typealias fr_framebuffer_info fr_uint
typealias fr_channel_order fr_uint
typealias fr_channel_type fr_uint
typealias fr_shape_type fr_uint
typealias fr_light_type fr_uint
typealias fr_parameter_type fr_uint
typealias fr_render_mode fr_uint
typealias fr_component_type fr_uint
typealias fr_camera_mode fr_uint
typealias fr_tonemapping_operator fr_uint
typealias fr_volume_type fr_uint
typealias fr_material_system_type fr_uint
typealias fr_material_node_type fr_uint
typealias fr_material_node_info fr_uint
immutable fr_image_desc
    image_width::fr_uint
    image_height::fr_uint
    image_depth::fr_uint
    image_row_pitch::fr_uint
    image_slice_pitch::fr_uint
end
immutable fr_framebuffer_desc
    fb_width::fr_uint
    fb_height::fr_uint
end
immutable fr_render_statistics
    gpumem_usage::fr_longlong
end
immutable fr_image_format
    num_components::fr_uint
    typ::fr_component_type
end

typealias fr_material_node_input_info fr_uint
typealias fr_aov fr_uint
typealias fr_GLuint Cuint
typealias fr_GLint Cint
typealias fr_GLenum Cuint
typealias fr_gl_object_type fr_uint
typealias fr_gl_texture_info fr_uint
typealias fr_gl_platform_info fr_uint
typealias fr_framebuffer_format fr_image_format
# API functions 
#* @brief Create rendering context
#
#  Rendering context is a root concept encapsulating the render states and responsible
#  for execution control. All the entities in FireRender are created for a particular rendering context.
#  Entities created for some context can't be used with other contexts. Possible error codes for this call are:
#
#     FR_ERROR_COMPUTE_API_NOT_SUPPORTED
#     FR_ERROR_OUT_OF_SYSTEM_MEMORY
#     FR_ERROR_OUT_OF_VIDEO_MEMORY
#     FR_ERROR_INVALID_API_VERSION
#     FR_ERROR_INVALID_PARAMETER
#
#  @param api_version     Api version constant
#	 @param context_type    Determines compute API to use, OPENCL only is supported for now
#  @param creation_flags  Determines multi-gpu or cpu-gpu configuration
#  @param props           Context properties, reserved for future use
#  @param cache_path      Full path to kernel cache created by FireRender, NULL means to use current folder
#  @param out_context		Pointer to context object          
#  @return                FR_SUCCESS in case of success, error code otherwise
#/
# props, const fr_char* cache_path,  fr_context* out_context);
function CreateContext(api_version, context_type, creation_flags, props, cache_path)
	out_context = Array(fr_context, 1);
	is_error = ccall(
		(:frCreateContext, firelib), fr_int, 
		(fr_int, fr_context_type, fr_creation_flags, Ptr{fr_context_properties}, Ptr{fr_char}, fr_context,), 
		api_version, context_type, creation_flags, props, cache_path, out_context
	)
	check_error(is_error)
	out_context[]
end

#* @brief Query information about a context
#
#  The workflow is usually two-step: query with the data == NULL and size = 0 to get the required buffer size in size_ret,
#  then query with size_ret == NULL to fill the buffer with the data.
#   Possible error codes:
#     FR_ERROR_INVALID_PARAMETER
#
#  @param  context         The context to query
#  @param  context_info    The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function ContextGetInfo(context, context_info, size, data, size_ret)
	
	is_error = ccall(
		(:frContextGetInfo, firelib), fr_int, 
		(fr_context, fr_context_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		context, context_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Query information about a context parameter
#
#  The workflow is usually two-step: query with the data == NULL and size = 0 to get the required buffer size in size_ret,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#     FR_ERROR_INVALID_PARAMETER
#
#  @param  context         The context to query
#  @param  param_idx	   The index of the parameter
#  @param  parameter_info  The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function ContextGetParameterInfo(context, param_idx, parameter_info, size, data, size_ret)
	
	is_error = ccall(
		(:frContextGetParameterInfo, firelib), fr_int, 
		(fr_context, Cint, fr_parameter_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		context, param_idx, parameter_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Query the AOV
#
#  @param  context     The context to get a frame buffer from
#  @param  out_fb		Pointer to framebuffer object      
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# out_fb);
function ContextGetAOV(context, aov)
	out_fb = Array(fr_framebuffer, 1);
	is_error = ccall(
		(:frContextGetAOV, firelib), fr_int, 
		(fr_context, fr_aov, fr_framebuffer,), 
		context, aov, out_fb
	)
	check_error(is_error)
	out_fb[]
end

#* @brief Set AOV
#
#  @param  context         The context to set AOV
#  @param  aov				AOV
#  @param  frame_buffer    Frame buffer object to set
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
function ContextSetAOV(context, aov, frame_buffer)
	
	is_error = ccall(
		(:frContextSetAOV, firelib), fr_int, 
		(fr_context, fr_aov, fr_framebuffer,), 
		context, aov, frame_buffer
	)
	check_error(is_error)
	nothing
end

#* @brief Set the scene
#
#  The scene is a collection of objects and lights
#  along with all the data required to shade those. The scene is
#  used by the context to render the image.
#
#  @param  context     The context to set the scene
#  @param  scene       The scene to set
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ContextSetScene(context, scene)
	
	is_error = ccall(
		(:frContextSetScene, firelib), fr_int, 
		(fr_context, fr_scene,), 
		context, scene
	)
	check_error(is_error)
	nothing
end

#* @brief Get the current scene
#
#  The scene is a collection of objects and lights
#  along with all the data required to shade those. The scene is
#  used by the context ro render the image.
#
#  @param  context     The context to get the scene from
#  @param  out_scene   Pointer to scene object
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# out_scene);
function ContextGetScene(arg1)
	out_scene = Array(fr_scene, 1);
	is_error = ccall(
		(:frContextGetScene, firelib), fr_int, 
		(fr_context, fr_scene,), 
		arg1, out_scene
	)
	check_error(is_error)
	out_scene[]
end

#* @brief Set context parameter
#
#  Parameters are used to control rendering modes, global sampling and AA settings, etc
#
#  @param  context                        The context to set the value to
#  @param  name						   Param name, can be:
#  aacellsize                          ft_float
#  aasamples                           ft_float
#  imagefilter.type					   fr_aa_filter
#  imagefilter.box.radius              ft_float
#  imagefilter.gaussian.radius         ft_float
#  imagefilter.triangle.radius         ft_float
#  imagefilter.mitchell.radius         ft_float
#  imagefilter.lanczos.radius          ft_float
#  imagefilter.blackmanharris.radius   ft_float
#  tonemapping.type                    fr_tonemapping_operator
#  tonemapping.linear.scale            ft_float
#  tonemapping.photolinear.sensitivity ft_float
#  tonemapping.photolinear.exposure    ft_float
#  tonemapping.photolinear.fstop       ft_float
#  tonemapping.reinhard02.prescale     ft_float
#  tonemapping.reinhard02.postscale    ft_float
#  tonemapping.reinhard02.burn         ft_float
# @param x,y,z,w						   Parameter value
# @return             FR_SUCCESS in case of success, error code otherwise
#/
# name, fr_uint x);
function ContextSetParameter1u(context, name, x)
	
	is_error = ccall(
		(:frContextSetParameter1u, firelib), fr_int, 
		(fr_context, Ptr{fr_char}, fr_uint,), 
		context, name, x
	)
	check_error(is_error)
	nothing
end

# name, fr_float x);
function ContextSetParameter1f(context, name, x)
	
	is_error = ccall(
		(:frContextSetParameter1f, firelib), fr_int, 
		(fr_context, Ptr{fr_char}, fr_float,), 
		context, name, x
	)
	check_error(is_error)
	nothing
end

# name, fr_float x, fr_float y, fr_float z);
function ContextSetParameter3f(context, name, x, y, z)
	
	is_error = ccall(
		(:frContextSetParameter3f, firelib), fr_int, 
		(fr_context, Ptr{fr_char}, fr_float, fr_float, fr_float,), 
		context, name, x, y, z
	)
	check_error(is_error)
	nothing
end

# name, fr_float x, fr_float y, fr_float z, fr_float w);
function ContextSetParameter4f(context, name, x, y, z, w)
	
	is_error = ccall(
		(:frContextSetParameter4f, firelib), fr_int, 
		(fr_context, Ptr{fr_char}, fr_float, fr_float, fr_float, fr_float,), 
		context, name, x, y, z, w
	)
	check_error(is_error)
	nothing
end

#* @brief Perform evaluation and accumulation of a single sample (or number of AA samples if AA is enabled)
#
#  The call is blocking and the image is ready when returned. The context accumulates the samples in order
#  to progressively refine the image and enable interactive response. So each new call to Render refines the 
#  resultin image with 1 (or num aa samples) color samples. Call frFramebufferClear if you want to start rendering new image
#  instead of refining the previous one.
#
#  Possible error codes:
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_INTERNAL_ERROR
#
#  @param  context     The context object
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ContextRender(context)
	
	is_error = ccall(
		(:frContextRender, firelib), fr_int, 
		(fr_context,), 
		context
	)
	check_error(is_error)
	nothing
end

#* @brief Perform evaluation and accumulation of a single sample (or number of AA samples if AA is enabled) on the part of the image
#
#  The call is blocking and the image is ready when returned. The context accumulates the samples in order
#  to progressively refine the image and enable interactive response. So each new call to Render refines the 
#  resultin image with 1 (or num aa samples) color samples. Call frFramebufferClear if you want to start rendering new image
#  instead of refining the previous one. Possible error codes are:
#
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_INTERNAL_ERROR
#
#  @param  context     The context to use for the rendering
#  @param  xmin        X coordinate of the top left corner of a tile
#  @param  xmax        X coordinate of the bottom right corner of a tile
#  @param  ymin        Y coordinate of the top left corner of a tile
#  @param  ymax        Y coordinate of the bottom right corner of a tile
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ContextRenderTile(context, xmin, xmax, ymin, ymax)
	
	is_error = ccall(
		(:frContextRenderTile, firelib), fr_int, 
		(fr_context, fr_uint, fr_uint, fr_uint, fr_uint,), 
		context, xmin, xmax, ymin, ymax
	)
	check_error(is_error)
	nothing
end

#* @brief Clear all video memory used by the context
#
#  This function should be called after all context objects have been destroyed. 
#  It guarantees that all context memory is freed and returns the context into its initial state.
#  Will be removed later. Possible error codes are:
#
#      FR_ERROR_INTERNAL_ERROR
#
#  @param  context     The context to wipe out
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ContextClearMemory(context)
	
	is_error = ccall(
		(:frContextClearMemory, firelib), fr_int, 
		(fr_context,), 
		context
	)
	check_error(is_error)
	nothing
end

#* @brief Create an image from memory data
#
#  Images are used as HDRI maps or inputs for various shading system nodes.
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_UNSUPPORTED_IMAGE_FORMAT
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  context     The context to create image
#  @param  format      Image format
#  @param  image_desc  Image layout description
#  @param  data        Image data in system memory, can be NULL in which case the memory is allocated
#  @param  out_image   Pointer to image object   
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# image_desc, const void* data, fr_image* out_image);
function ContextCreateImage(context, format, image_desc, data)
	out_image = Array(fr_image, 1);
	is_error = ccall(
		(:frContextCreateImage, firelib), fr_int, 
		(fr_context, fr_image_format, Ptr{fr_image_desc}, Ptr{Void}, fr_image,), 
		context, format, image_desc, data, out_image
	)
	check_error(is_error)
	out_image[]
end

#* @brief Create an image from file
#
#   Images are used as HDRI maps or inputs for various shading system nodes.
#
#  The following image formats are supported:
#      PNG, JPG, TGA, BMP, TIFF, TX(0-mip), HDR, EXR
#
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_UNSUPPORTED_IMAGE_FORMAT
#      FR_ERROR_INVALID_PARAMETER
#      FR_ERROR_IO_ERROR
#
#  @param  context     The context to create image
#  @param  path        NULL terminated path to an image file (can be relative)
#  @param  out_image   Pointer to image object
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# path, fr_image* out_image);
function ContextCreateImageFromFile(context, path)
	out_image = Array(fr_image, 1);
	is_error = ccall(
		(:frContextCreateImageFromFile, firelib), fr_int, 
		(fr_context, Ptr{fr_char}, fr_image,), 
		context, path, out_image
	)
	check_error(is_error)
	out_image[]
end

#* @brief Create a scene
#
#  Scene serves as a container for lights and objects.
#
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  out_scene   Pointer to scene object
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# out_scene);
function ContextCreateScene(context)
	out_scene = Array(fr_scene, 1);
	is_error = ccall(
		(:frContextCreateScene, firelib), fr_int, 
		(fr_context, fr_scene,), 
		context, out_scene
	)
	check_error(is_error)
	out_scene[]
end

#* @brief Create an instance of an object
#
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  context  The context to create an instance for
#  @param  shape    Parent shape for an instance
#  @param  out_instance   Pointer to instance object
#  @return FR_SUCCESS in case of success, error code otherwise
#/
# out_instance);
function ContextCreateInstance(context, shape)
	out_instance = Array(fr_shape, 1);
	is_error = ccall(
		(:frContextCreateInstance, firelib), fr_int, 
		(fr_context, fr_shape, fr_shape,), 
		context, shape, out_instance
	)
	check_error(is_error)
	out_instance[]
end

#* @brief Create a mesh
#
#  FireRender supports mixed meshes consisting of triangles and quads.
#
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  vertices            Pointer to position data (each position is described with 3 fr_float numbers)
#  @param  num_vertices        Number of entries in position array
#  @param  vertex_stride       Number of bytes between the beginnings of two successive position entries
#  @param  normals             Pointer to normal data (each normal is described with 3 fr_float numbers), can be NULL
#  @param  num_normals         Number of entries in normal array
#  @param  normal_stride       Number of bytes between the beginnings of two successive normal entries
#  @param  texcoord            Pointer to texcoord data (each texcoord is described with 2 fr_float numbers), can be NULL
#  @param  num_texcoords       Number of entries in texcoord array
#  @param  texcoord_stride     Number of bytes between the beginnings of two successive texcoord entries
#  @param  vertex_indices      Pointer to an array of vertex indices
#  @param  vidx_stride         Number of bytes between the beginnings of two successive vertex index entries
#  @param  normal_indices      Pointer to an array of normal indices
#  @param  nidx_stride         Number of bytes between the beginnings of two successive normal index entries
#  @param  texcoord_indices    Pointer to an array of texcoord indices
#  @param  tidx_stride         Number of bytes between the beginnings of two successive texcoord index entries
#  @param  num_face_vertices   Pointer to an array of num_faces numbers describing number of vertices for each face (can be 3(triangle) or 4(quad))
#  @param  num_faces           Number of faces in the mesh
#  @param  out_mesh            Pointer to mesh object 
#  @return                     FR_SUCCESS in case of success, error code otherwise
#/
# vertices,  size_t num_vertices,   fr_int vertex_stride,const fr_float* normals,   size_t num_normals,    fr_int normal_stride,const fr_float* texcoords, size_t num_texcoords,  fr_int texcoord_stride,const fr_int*   vertex_indices,   fr_int vidx_stride,const fr_int*   normal_indices,   fr_int nidx_stride,const fr_int*   texcoord_indices, fr_int tidx_stride,const fr_int*   num_face_vertices, size_t num_faces, fr_shape* out_mesh);
function ContextCreateMesh(context, vertices, num_vertices, vertex_stride, normals, num_normals, normal_stride, texcoords, num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces)
	out_mesh = Array(fr_shape, 1);
	is_error = ccall(
		(:frContextCreateMesh, firelib), fr_int, 
		(fr_context, Ptr{fr_float}, Csize_t, fr_int, Ptr{fr_float}, Csize_t, fr_int, Ptr{fr_float}, Csize_t, fr_int, Ptr{fr_int}, fr_int, Ptr{fr_int}, fr_int, Ptr{fr_int}, fr_int, Ptr{fr_int}, Csize_t, fr_shape,), 
		context, vertices, num_vertices, vertex_stride, normals, num_normals, normal_stride, texcoords, num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces, out_mesh
	)
	check_error(is_error)
	out_mesh[]
end

#* @brief Create a camera
#
#  There are several camera types supported by a single fr_camera type.
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  @param  context The context to create a camera for
#  @param  out_camera Pointer to camera object
#  @return FR_SUCCESS in case of success, error code otherwise       
#/
# out_camera);
function ContextCreateCamera(context)
	out_camera = Array(fr_camera, 1);
	is_error = ccall(
		(:frContextCreateCamera, firelib), fr_int, 
		(fr_context, fr_camera,), 
		context, out_camera
	)
	check_error(is_error)
	out_camera[]
end

#* @brief Create framebuffer object
#
#  Framebuffer is used to store final rendering result.
#
#  Possible error codes are:
# 
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  @param  context  The context to create framebuffer
#  @param  format   Framebuffer format
#  @param  fb_desc  Framebuffer layout description
#  @param  status   Pointer to framebuffer object
#  @return          FR_SUCCESS in case of success, error code otherwise
#/
# fb_desc, fr_framebuffer* out_fb);
function ContextCreateFrameBuffer(context, format, fb_desc)
	out_fb = Array(fr_framebuffer, 1);
	is_error = ccall(
		(:frContextCreateFrameBuffer, firelib), fr_int, 
		(fr_context, fr_framebuffer_format, Ptr{fr_framebuffer_desc}, fr_framebuffer,), 
		context, format, fb_desc, out_fb
	)
	check_error(is_error)
	out_fb[]
end

# fr_camera 
#* @brief Query information about a camera
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data.
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  camera      The camera to query
#  @param  camera_info The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function CameraGetInfo(camera, camera_info, size, data, size_ret)
	
	is_error = ccall(
		(:frCameraGetInfo, firelib), fr_int, 
		(fr_camera, fr_camera_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		camera, camera_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Set camera focal length.
#
#  @param  camera  The camera to set focal length
#  @param  flength Focal length in millimeters, default is 35mm
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetFocalLength(camera, flength)
	
	is_error = ccall(
		(:frCameraSetFocalLength, firelib), fr_int, 
		(fr_camera, fr_float,), 
		camera, flength
	)
	check_error(is_error)
	nothing
end

#* @brief Set camera focus distance
#
#  @param  camera  The camera to set focus distance
#  @param  fdist   Focus distance in meters, default is 1m
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetFocusDistance(camera, fdist)
	
	is_error = ccall(
		(:frCameraSetFocusDistance, firelib), fr_int, 
		(fr_camera, fr_float,), 
		camera, fdist
	)
	check_error(is_error)
	nothing
end

#* @brief Set world transform for the camera
#
#  @param  camera      The camera to set transform for
#  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
#  @param  transform   Array of 16 fr_float values (row-major form)
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# transform);
function CameraSetTransform(camera, transpose, transform)
	
	is_error = ccall(
		(:frCameraSetTransform, firelib), fr_int, 
		(fr_camera, fr_bool, Ptr{fr_float},), 
		camera, transpose, transform
	)
	check_error(is_error)
	nothing
end

#* @brief Set sensor size for the camera
#
#  Default sensor size is the one corresponding to full frame 36x24mm sensor
# 
#  @param  camera  The camera to set transform for
#  @param  width   Sensor width in millimeters
#  @param  height  Sensor height in millimeters
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetSensorSize(camera, width, height)
	
	is_error = ccall(
		(:frCameraSetSensorSize, firelib), fr_int, 
		(fr_camera, fr_float, fr_float,), 
		camera, width, height
	)
	check_error(is_error)
	nothing
end

#* @brief Set camera transform in lookat form
#
#  @param  camera  The camera to set transform for
#  @param  posx    X component of the position
#  @param  posy    Y component of the position
#  @param  posz    Z component of the position
#  @param  atx     X component of the center point
#  @param  aty     Y component of the center point
#  @param  atz     Z component of the center point
#  @param  upx     X component of the up vector
#  @param  upy     Y component of the up vector
#  @param  upz     Z component of the up vector
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraLookAt(camera, posx, posy, posz, atx, aty, atz, upx, upy, upz)
	
	is_error = ccall(
		(:frCameraLookAt, firelib), fr_int, 
		(fr_camera, fr_float, fr_float, fr_float, fr_float, fr_float, fr_float, fr_float, fr_float, fr_float,), 
		camera, posx, posy, posz, atx, aty, atz, upx, upy, upz
	)
	check_error(is_error)
	nothing
end

#* @brief Set f-stop for the camera
#
#  @param  camera  The camera to set f-stop for
#  @param  fstop   f-stop value in mm^-1, default is FLT_MAX
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetFStop(camera, fstop)
	
	is_error = ccall(
		(:frCameraSetFStop, firelib), fr_int, 
		(fr_camera, fr_float,), 
		camera, fstop
	)
	check_error(is_error)
	nothing
end

#* @brief Set the number of aperture blades
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  camera      The camera to set aperture blades for
#  @param  num_blades  Number of aperture blades 4 to 32
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetApertureBlades(camera, num_blades)
	
	is_error = ccall(
		(:frCameraSetApertureBlades, firelib), fr_int, 
		(fr_camera, fr_uint,), 
		camera, num_blades
	)
	check_error(is_error)
	nothing
end

#* @brief Set the exposure of a camera
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  camera    The camera to set aperture blades for
#  @param  exposure  Exposure value 0.0 - 1.0
#  @return           FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetExposure(camera, exposure)
	
	is_error = ccall(
		(:frCameraSetExposure, firelib), fr_int, 
		(fr_camera, fr_float,), 
		camera, exposure
	)
	check_error(is_error)
	nothing
end

#* @brief Set camera mode
#
#  Camera modes include:
#      FR_CAMERA_MODE_PERSPECTIVE
#      FR_CAMERA_MODE_ORTHOGRAPHIC
# 
#  @param  camera  The camera to set mode for
#  @param  mode    Camera mode, default is FR_CAMERA_MODE_PERSPECTIVE
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetMode(camera, mode)
	
	is_error = ccall(
		(:frCameraSetMode, firelib), fr_int, 
		(fr_camera, fr_camera_mode,), 
		camera, mode
	)
	check_error(is_error)
	nothing
end

#* @brief Set orthographic view volume width
#
#  @param  camera  The camera to set volume width for
#  @param  width   View volume width in meters, default is 1 meter
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function CameraSetOrthoWidth(camera, width)
	
	is_error = ccall(
		(:frCameraSetOrthoWidth, firelib), fr_int, 
		(fr_camera, fr_float,), 
		camera, width
	)
	check_error(is_error)
	nothing
end

# fr_image
#* @brief Query information about an image
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  image       An image object to query
#  @param  image_info  The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function ImageGetInfo(image, image_info, size, data, size_ret)
	
	is_error = ccall(
		(:frImageGetInfo, firelib), fr_int, 
		(fr_image, fr_image_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		image, image_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

# fr_shape 
#* @brief Set shape world transform
#
#
#  @param  shape       The shape to set transform for
#  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
#  @param  transform   Array of 16 fr_float values (row-major form)
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# transform);
function ShapeSetTransform(shape, transpose, transform)
	
	is_error = ccall(
		(:frShapeSetTransform, firelib), fr_int, 
		(fr_shape, fr_bool, Ptr{fr_float},), 
		shape, transpose, transform
	)
	check_error(is_error)
	nothing
end

#* @brief Set shape subdivision 
#
#
#  @param  shape       The shape to set subdivision for
#  @param  factor	   Number of subdivision steps to do
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetSubdivisionFactor(shape, factor)
	
	is_error = ccall(
		(:frShapeSetSubdivisionFactor, firelib), fr_int, 
		(fr_shape, fr_uint,), 
		shape, factor
	)
	check_error(is_error)
	nothing
end

#* @brief Set displacement scale
#
#
#  @param  shape       The shape to set subdivision for
#  @param  scale	   The amount of displacement applied
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetDisplacementScale(shape, scale)
	
	is_error = ccall(
		(:frShapeSetDisplacementScale, firelib), fr_int, 
		(fr_shape, fr_float,), 
		shape, scale
	)
	check_error(is_error)
	nothing
end

#* @brief Set displacement texture
#
#
#  @param  shape       The shape to set subdivision for
#  @param  image 	   Displacement texture (scalar displacement, only x component is used)
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetDisplacementImage(shape, image)
	
	is_error = ccall(
		(:frShapeSetDisplacementImage, firelib), fr_int, 
		(fr_shape, fr_image,), 
		shape, image
	)
	check_error(is_error)
	nothing
end

# fr_shape 
#* @brief Set shape material
#
#/
function ShapeSetMaterial(shape, node)
	
	is_error = ccall(
		(:frShapeSetMaterial, firelib), fr_int, 
		(fr_shape, fr_material_node,), 
		shape, node
	)
	check_error(is_error)
	nothing
end

#* @brief Set shape linear motion
#
#  @param  shape       The shape to set linear motion for
#  @param  x           X component of a motion vector
#  @param  y           Y component of a motion vector
#  @param  z           Z component of a motion vector
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetLinearMotion(shape, x, y, z)
	
	is_error = ccall(
		(:frShapeSetLinearMotion, firelib), fr_int, 
		(fr_shape, fr_float, fr_float, fr_float,), 
		shape, x, y, z
	)
	check_error(is_error)
	nothing
end

#* @brief Set angular linear motion
#
#  @param  shape       The shape to set linear motion for
#  @param  x           X component of the rotation axis
#  @param  y           Y component of the rotation axis
#  @param  z           Z component of the rotation axis
#  @param  w           W rotation angle in radians
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetAngularMotion(shape, x, y, z, w)
	
	is_error = ccall(
		(:frShapeSetAngularMotion, firelib), fr_int, 
		(fr_shape, fr_float, fr_float, fr_float, fr_float,), 
		shape, x, y, z, w
	)
	check_error(is_error)
	nothing
end

#* @brief Set visibility flag
#
#  @param  shape       The shape to set visibility for
#  @param  visible     Determines if the shape is visible or not
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetVisibilityFlag(shape, visible)
	
	is_error = ccall(
		(:frShapeSetVisibilityFlag, firelib), fr_int, 
		(fr_shape, fr_bool,), 
		shape, visible
	)
	check_error(is_error)
	nothing
end

#* @brief Set shadow flag
#
#  @param  shape       The shape to set shadow flag for
#  @param  visible     Determines if the shape casts shadow
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetShadowFlag(shape, casts_shadow)
	
	is_error = ccall(
		(:frShapeSetShadowFlag, firelib), fr_int, 
		(fr_shape, fr_bool,), 
		shape, casts_shadow
	)
	check_error(is_error)
	nothing
end

#* @brief Set light world transform
#
#
#  @param  light       The light to set transform for
#  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
#  @param  transform   Array of 16 fr_float values (row-major form)
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# transform);
function LightSetTransform(light, transpose, transform)
	
	is_error = ccall(
		(:frLightSetTransform, firelib), fr_int, 
		(fr_light, fr_bool, Ptr{fr_float},), 
		light, transpose, transform
	)
	check_error(is_error)
	nothing
end

#* @brief Query information about a shape
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  shape           The shape object to query
#  @param  material_info   The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
#, size_t* );
function ShapeGetInfo(arg1, arg2, arg3, arg4, arg5)
	
	is_error = ccall(
		(:frShapeGetInfo, firelib), fr_int, 
		(fr_shape, fr_shape_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		arg1, arg2, arg3, arg4, arg5
	)
	check_error(is_error)
	nothing
end

# fr_shape - mesh 
#* @brief Query information about a mesh
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  shape       The mesh to query
#  @param  mesh_info   The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function MeshGetInfo(mesh, mesh_info, size, data, size_ret)
	
	is_error = ccall(
		(:frMeshGetInfo, firelib), fr_int, 
		(fr_shape, fr_mesh_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		mesh, mesh_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Query information about a mesh polygon
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  mesh        The mesh to query
#  @param  polygon_index The index of a polygon
#  @param  polygon_info The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function MeshPolygonGetInfo(mesh, polygon_index, polygon_info, size, data, size_ret)
	
	is_error = ccall(
		(:frMeshPolygonGetInfo, firelib), fr_int, 
		(fr_shape, Csize_t, fr_mesh_polygon_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		mesh, polygon_index, polygon_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Query information about a mesh polygon vertex
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  mesh        The mesh to query
#  @param  polygon_index The index of a polygon
#  @param  vertex_index The index of vertex
#  @param  polygon_vertex_info The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function MeshPolygonVertexGetInfo(mesh, polygon_index, vertex_index, polygon_info, size, data, size_ret)
	
	is_error = ccall(
		(:frMeshPolygonVertexGetInfo, firelib), fr_int, 
		(fr_shape, Csize_t, Csize_t, fr_mesh_polygon_vertex_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		mesh, polygon_index, vertex_index, polygon_info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Set mesh vertex attribute
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  mesh            The mesh to query
#  @param  polygon_index   The index of a polygon
#  @param  vertex_index    The index of vertex
#  @param  polygon_vertex_info The type of info to set
#  @param  x               X component of an attribute
#  @param  y               Y component of an attribute
#  @param  z               Z component of an attribute
#  @return FR_SUCCESS in case of success, error code otherwise
#/
function MeshPolygonVertexSetAttribute3f(mesh, polygon_index, vertex_index, polygon_vertex_info, x, y, z)
	
	is_error = ccall(
		(:frMeshPolygonVertexSetAttribute3f, firelib), fr_int, 
		(fr_shape, Csize_t, Csize_t, fr_mesh_polygon_vertex_info, fr_float, fr_float, fr_float,), 
		mesh, polygon_index, vertex_index, polygon_vertex_info, x, y, z
	)
	check_error(is_error)
	nothing
end

# fr_shape - instance 
#* @brief Get the parent shape for an instance
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  shape    The shape to get a parent shape from
#  @param  status   FR_SUCCESS in case of success, error code otherwise
#  @return          Shape object
#/
# out_shape);
function InstanceGetBaseShape(shape)
	out_shape = Array(fr_shape, 1);
	is_error = ccall(
		(:frInstanceGetBaseShape, firelib), fr_int, 
		(fr_shape, fr_shape,), 
		shape, out_shape
	)
	check_error(is_error)
	out_shape[]
end

# fr_light - point 
#* @brief Create point light
#
#  Create analytic point light represented by a point in space.
#  Possible error codes:
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  FR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_light);
function ContextCreatePointLight(context)
	out_light = Array(fr_light, 1);
	is_error = ccall(
		(:frContextCreatePointLight, firelib), fr_int, 
		(fr_context, fr_light,), 
		context, out_light
	)
	check_error(is_error)
	out_light[]
end

#* @brief Set radiant power of a point light source
#
#  @param  r       R component of a radiant power vector
#  @param  g       G component of a radiant power vector
#  @param  b       B component of a radiant power vector
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function PointLightSetRadiantPower3f(light, r, g, b)
	
	is_error = ccall(
		(:frPointLightSetRadiantPower3f, firelib), fr_int, 
		(fr_light, fr_float, fr_float, fr_float,), 
		light, r, g, b
	)
	check_error(is_error)
	nothing
end

# fr_light - spot 
#* @brief Create spot light
#
#  Create analytic spot light
#
#  Possible error codes:
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  FR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# light);
function ContextCreateSpotLight(context, light)
	
	is_error = ccall(
		(:frContextCreateSpotLight, firelib), fr_int, 
		(fr_context, Ptr{fr_light},), 
		context, light
	)
	check_error(is_error)
	nothing
end

#* @brief Set radiant power of a spot light source
#
#  @param  r R component of a radiant power vector
#  @param  g G component of a radiant power vector
#  @param  b B component of a radiant power vector
#  @return   FR_SUCCESS in case of success, error code otherwise
#/
function SpotLightSetRadiantPower3f(light, r, g, b)
	
	is_error = ccall(
		(:frSpotLightSetRadiantPower3f, firelib), fr_int, 
		(fr_light, fr_float, fr_float, fr_float,), 
		light, r, g, b
	)
	check_error(is_error)
	nothing
end

#* @brief Set cone shape for a spot light
#
# Spot light produces smooth penumbra in a region between inner and outer circles, 
# the area inside the inner cicrle receives full power while the area outside the
# outer one is fully in shadow.
#
#  @param  iangle Inner angle of a cone in radians
#  @param  oangle Outer angle of a coner in radians, should be greater that or equal to inner angle
#  @return status FR_SUCCESS in case of success, error code otherwise
#/
function SpotLightSetConeShape(light, iangle, oangle)
	
	is_error = ccall(
		(:frSpotLightSetConeShape, firelib), fr_int, 
		(fr_light, fr_float, fr_float,), 
		light, iangle, oangle
	)
	check_error(is_error)
	nothing
end

# fr_light - directional 
#* @brief Create directional light
#
#  Create analytic directional light.
#  Possible error codes:
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  FR_SUCCESS in case of success, error code otherwise
#  @return light id of a newly created light
#/
# out_light);
function ContextCreateDirectionalLight(context)
	out_light = Array(fr_light, 1);
	is_error = ccall(
		(:frContextCreateDirectionalLight, firelib), fr_int, 
		(fr_context, fr_light,), 
		context, out_light
	)
	check_error(is_error)
	out_light[]
end

#* @brief Set radiant power of a directional light source
#
#  @param  r R component of a radiant power vector
#  @param  g G component of a radiant power vector
#  @param  b B component of a radiant power vector
#  @return   FR_SUCCESS in case of success, error code otherwise
#/
function DirectionalLightSetRadiantPower3f(light, r, g, b)
	
	is_error = ccall(
		(:frDirectionalLightSetRadiantPower3f, firelib), fr_int, 
		(fr_light, fr_float, fr_float, fr_float,), 
		light, r, g, b
	)
	check_error(is_error)
	nothing
end

# fr_light - environment 
#* @brief Create an environment light
#
#  Environment light is a light based on lightprobe.
#  Possible error codes:
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  FR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_light);
function ContextCreateEnvironmentLight(context)
	out_light = Array(fr_light, 1);
	is_error = ccall(
		(:frContextCreateEnvironmentLight, firelib), fr_int, 
		(fr_context, fr_light,), 
		context, out_light
	)
	check_error(is_error)
	out_light[]
end

#* @brief Flush image caches
#
#/
function ContextFlushImageCache(context)
	
	is_error = ccall(
		(:frContextFlushImageCache, firelib), fr_int, 
		(fr_context,), 
		context
	)
	check_error(is_error)
	nothing
end

#* @brief Set image for an environment light
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#      FR_ERROR_UNSUPPORTED_IMAGE_FORMAT
#
#  @param  env_light Environment light
#  @param  image     Image object to set
#  @return           FR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightSetImage(env_light, image)
	
	is_error = ccall(
		(:frEnvironmentLightSetImage, firelib), fr_int, 
		(fr_light, fr_image,), 
		env_light, image
	)
	check_error(is_error)
	nothing
end

#* @brief Set intensity scale or an env light
#
#  @param  env_light       Environment light
#  @param  intensity_scale Intensity scale
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightSetIntensityScale(env_light, intensity_scale)
	
	is_error = ccall(
		(:frEnvironmentLightSetIntensityScale, firelib), fr_int, 
		(fr_light, fr_float,), 
		env_light, intensity_scale
	)
	check_error(is_error)
	nothing
end

#* @brief Set portal for envronment light to accelerate convergence of indoor scenes
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  env_light Environment light
#  @param  portal    Portal mesh, might have multiple components
#  @return           FR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightSetPortal(env_light, portal)
	
	is_error = ccall(
		(:frEnvironmentLightSetPortal, firelib), fr_int, 
		(fr_light, fr_shape,), 
		env_light, portal
	)
	check_error(is_error)
	nothing
end

# fr_light - sky 
#* @brief Create sky light
#
#  Analytical sky model
#  Possible error codes:
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  FR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_light);
function ContextCreateSkyLight(context)
	out_light = Array(fr_light, 1);
	is_error = ccall(
		(:frContextCreateSkyLight, firelib), fr_int, 
		(fr_context, fr_light,), 
		context, out_light
	)
	check_error(is_error)
	out_light[]
end

#* @brief Set turbidity of a sky light
#
#  @param  skylight        Sky light
#  @param  turbidity       Turbidity value
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetTurbidity(skylight, turbidity)
	
	is_error = ccall(
		(:frSkyLightSetTurbidity, firelib), fr_int, 
		(fr_light, fr_float,), 
		skylight, turbidity
	)
	check_error(is_error)
	nothing
end

#* @brief Set albedo of a sky light
#
#  @param  skylight        Sky light
#  @param  albedo          Albedo value
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetAlbedo(skylight, albedo)
	
	is_error = ccall(
		(:frSkyLightSetAlbedo, firelib), fr_int, 
		(fr_light, fr_float,), 
		skylight, albedo
	)
	check_error(is_error)
	nothing
end

#* @brief Set scale of a sky light
#
#  @param  skylight        Sky light
#  @param  scale           Scale value
#  @return                 FR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetScale(skylight, scale)
	
	is_error = ccall(
		(:frSkyLightSetScale, firelib), fr_int, 
		(fr_light, fr_float,), 
		skylight, scale
	)
	check_error(is_error)
	nothing
end

#* @brief Set portal for sky light to accelerate convergence of indoor scenes
#
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  skylight  Sky light
#  @param  portal    Portal mesh, might have multiple components
#  @return           FR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetPortal(skylight, portal)
	
	is_error = ccall(
		(:frSkyLightSetPortal, firelib), fr_int, 
		(fr_light, fr_shape,), 
		skylight, portal
	)
	check_error(is_error)
	nothing
end

# fr_light 
#* @brief Query information about a light
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  light    The light to query
#  @param  light_info The type of info to query
#  @param  size     The size of the buffer pointed by data
#  @param  data     The buffer to store queried info
#  @param  size_ret Returns the size in bytes of the data being queried
#  @return          FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function LightGetInfo(light, info, size, data, size_ret)
	
	is_error = ccall(
		(:frLightGetInfo, firelib), fr_int, 
		(fr_light, fr_light_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		light, info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

# fr_scene 
#* @brief Remove all objects from a scene
#
#  A scene is essentially a collection of shapes, lights and volume regions.
#
#  @param  scene   The scene to clear
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function SceneClear(scene)
	
	is_error = ccall(
		(:frSceneClear, firelib), fr_int, 
		(fr_scene,), 
		scene
	)
	check_error(is_error)
	nothing
end

#* @brief Attach a shape to the scene
#
#  A scene is essentially a collection of shapes, lights and volume regions.
#
#  @param  scene  The scene to attach
#  @param  shape  The shape to attach
#  @return        FR_SUCCESS in case of success, error code otherwise
#/
function SceneAttachShape(scene, shape)
	
	is_error = ccall(
		(:frSceneAttachShape, firelib), fr_int, 
		(fr_scene, fr_shape,), 
		scene, shape
	)
	check_error(is_error)
	nothing
end

#* @brief Detach a shape from the scene
#
#  A scene is essentially a collection of shapes, lights and volume regions.
#
#  @param  scene   The scene to dettach from
#  @return         FR_SUCCESS in case of success, error code otherwise
#/
function SceneDetachShape(scene, shape)
	
	is_error = ccall(
		(:frSceneDetachShape, firelib), fr_int, 
		(fr_scene, fr_shape,), 
		scene, shape
	)
	check_error(is_error)
	nothing
end

#* @brief Attach a light to the scene
#
#  A scene is essentially a collection of shapes, lights and volume regions
#
#  @param  scene  The scene to attach
#  @param  light  The light to attach
#  @return        FR_SUCCESS in case of success, error code otherwise
#/
function SceneAttachLight(scene, light)
	
	is_error = ccall(
		(:frSceneAttachLight, firelib), fr_int, 
		(fr_scene, fr_light,), 
		scene, light
	)
	check_error(is_error)
	nothing
end

#* @brief Detach a light from the scene
#
#  A scene is essentially a collection of shapes, lights and volume regions
#
#  @param  scene  The scene to dettach from
#  @param  light  The light to detach
#  @return        FR_SUCCESS in case of success, error code otherwise
#/
function SceneDetachLight(scene, light)
	
	is_error = ccall(
		(:frSceneDetachLight, firelib), fr_int, 
		(fr_scene, fr_light,), 
		scene, light
	)
	check_error(is_error)
	nothing
end

#* @brief Query information about a scene
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  scene    The scene to query
#  @param  info     The type of info to query
#  @param  size     The size of the buffer pointed by data
#  @param  data     The buffer to store queried info
#  @param  size_ret Returns the size in bytes of the data being queried
#  @return          FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function SceneGetInfo(scene, info, size, data, size_ret)
	
	is_error = ccall(
		(:frSceneGetInfo, firelib), fr_int, 
		(fr_scene, fr_scene_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		scene, info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Set environment light for the scene
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  scene  The scene to set background for
#  @param  light  Environment light
#  @return        FR_SUCCESS in case of success, error code otherwise
#/
function SceneSetEnvironmentLight(scene, light)
	
	is_error = ccall(
		(:frSceneSetEnvironmentLight, firelib), fr_int, 
		(fr_scene, fr_light,), 
		scene, light
	)
	check_error(is_error)
	nothing
end

#* @brief Get environment light for the scene
#
#  @param  scene  The scene to get background for
#  @param  status FR_SUCCESS in case of success, error code otherwise
#  @return        Environment light object
#/
# out_light);
function SceneGetEnvironmentLight(scene)
	out_light = Array(fr_light, 1);
	is_error = ccall(
		(:frSceneGetEnvironmentLight, firelib), fr_int, 
		(fr_scene, fr_light,), 
		scene, out_light
	)
	check_error(is_error)
	out_light[]
end

#* @brief Set background light for the scene which does not affect the scene lighting,
#    but gets shown as a background image
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  scene  The scene to set background for
#  @param  light  Background light
#  @return        FR_SUCCESS in case of success, error code otherwise
#/
function SceneSetBackground(scene, light)
	
	is_error = ccall(
		(:frSceneSetBackground, firelib), fr_int, 
		(fr_scene, fr_light,), 
		scene, light
	)
	check_error(is_error)
	nothing
end

#* @brief Get background light
#
#  @param  scene  The scene to get background for
#  @param  status FR_SUCCESS in case of success, error code otherwise
#  @return        Environment light object
#/
# out_light);
function SceneGetBackground(scene)
	out_light = Array(fr_light, 1);
	is_error = ccall(
		(:frSceneGetBackground, firelib), fr_int, 
		(fr_scene, fr_light,), 
		scene, out_light
	)
	check_error(is_error)
	out_light[]
end

#* @brief Set camera for the scene
#
#  This is the main camera which for rays generation for the scene.
#
#  @param  scene  The scene to set camera for
#  @param  camera Camera
#  @return        FR_SUCCESS in case of success, error code otherwise
#/
function SceneSetCamera(scene, camera)
	
	is_error = ccall(
		(:frSceneSetCamera, firelib), fr_int, 
		(fr_scene, fr_camera,), 
		scene, camera
	)
	check_error(is_error)
	nothing
end

#* @brief Get camera for the scene
#
#  @param  scene  The scene to get camera for
#  @param  status FR_SUCCESS in case of success, error code otherwise
#  @return camera id for the camera if any, NULL otherwise
#/
# out_camera);
function SceneGetCamera(scene)
	out_camera = Array(fr_camera, 1);
	is_error = ccall(
		(:frSceneGetCamera, firelib), fr_int, 
		(fr_scene, fr_camera,), 
		scene, out_camera
	)
	check_error(is_error)
	out_camera[]
end

# fr_framebuffer
#* @brief Query information about a framebuffer
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      FR_ERROR_INVALID_PARAMETER
#
#  @param  framebuffer  Framebuffer object to query
#  @param  info         The type of info to query
#  @param  size         The size of the buffer pointed by data
#  @param  data         The buffer to store queried info
#  @param  size_ret     Returns the size in bytes of the data being queried
#  @return              FR_SUCCESS in case of success, error code otherwise
#/
# data, size_t* size_ret);
function FrameBufferGetInfo(framebuffer, info, size, data, size_ret)
	
	is_error = ccall(
		(:frFrameBufferGetInfo, firelib), fr_int, 
		(fr_framebuffer, fr_framebuffer_info, Csize_t, Ptr{Void}, Ptr{Csize_t},), 
		framebuffer, info, size, data, size_ret
	)
	check_error(is_error)
	nothing
end

#* @brief Clear contents of a framebuffer to zero
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  The call is blocking and the image is ready when returned
#
#  @param  frame_buffer  Framebuffer to clear
#  @return              FR_SUCCESS in case of success, error code otherwise
#/
function FrameBufferClear(frame_buffer)
	
	is_error = ccall(
		(:frFrameBufferClear, firelib), fr_int, 
		(fr_framebuffer,), 
		frame_buffer
	)
	check_error(is_error)
	nothing
end

# TEMPORARY STUFF
#* @brief Save frame buffer to file
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  @param  frame_buffer Frame buffer to save
#  @param  path         Path to file
#  @return              FR_SUCCESS in case of success, error code otherwise
#/
# file_path);
function FrameBufferSaveToFile(frame_buffer, file_path)
	
	is_error = ccall(
		(:frFrameBufferSaveToFile, firelib), fr_int, 
		(fr_framebuffer, Ptr{fr_char},), 
		frame_buffer, file_path
	)
	check_error(is_error)
	nothing
end

#* @brief Resolve framebuffer
#
#   Resolve applies AA filters and tonemapping operators to the framebuffer data 
#   
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#/
function ContextResolveFrameBuffer(context, src_frame_buffer, dst_frame_buffer)
	
	is_error = ccall(
		(:frContextResolveFrameBuffer, firelib), fr_int, 
		(fr_context, fr_framebuffer, fr_framebuffer,), 
		context, src_frame_buffer, dst_frame_buffer
	)
	check_error(is_error)
	nothing
end

#* @brief Create material system
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# out_matsys);
function ContextCreateMaterialSystem(in_context, typ)
	out_matsys = Array(fr_material_system, 1);
	is_error = ccall(
		(:frContextCreateMaterialSystem, firelib), fr_int, 
		(fr_context, fr_material_system_type, fr_material_system,), 
		in_context, typ, out_matsys
	)
	check_error(is_error)
	out_matsys[]
end

#* @brief Create material node
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# out_node);
function MaterialSystemCreateNode(in_matsys, in_type)
	out_node = Array(fr_material_node, 1);
	is_error = ccall(
		(:frMaterialSystemCreateNode, firelib), fr_int, 
		(fr_material_system, fr_material_node_type, fr_material_node,), 
		in_matsys, in_type, out_node
	)
	check_error(is_error)
	out_node[]
end

#* @brief Connect nodes
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, fr_material_node in_input_node);
function MaterialNodeSetInputN(in_node, in_input, in_input_node)
	
	is_error = ccall(
		(:frMaterialNodeSetInputN, firelib), fr_int, 
		(fr_material_node, Ptr{fr_char}, fr_material_node,), 
		in_node, in_input, in_input_node
	)
	check_error(is_error)
	nothing
end

#* @brief Set float input value
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, fr_float in_value_x, fr_float in_value_y, fr_float in_value_z, fr_float in_value_w);
function MaterialNodeSetInputF(in_node, in_input, in_value_x, in_value_y, in_value_z, in_value_w)
	
	is_error = ccall(
		(:frMaterialNodeSetInputF, firelib), fr_int, 
		(fr_material_node, Ptr{fr_char}, fr_float, fr_float, fr_float, fr_float,), 
		in_node, in_input, in_value_x, in_value_y, in_value_z, in_value_w
	)
	check_error(is_error)
	nothing
end

#* @brief Set uint input value
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, fr_uint in_value);
function MaterialNodeSetInputU(in_node, in_input, in_value)
	
	is_error = ccall(
		(:frMaterialNodeSetInputU, firelib), fr_int, 
		(fr_material_node, Ptr{fr_char}, fr_uint,), 
		in_node, in_input, in_value
	)
	check_error(is_error)
	nothing
end

#* @brief Set image input value 
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, fr_image image);
function MaterialNodeSetInputImageData(in_node, in_input, image)
	
	is_error = ccall(
		(:frMaterialNodeSetInputImageData, firelib), fr_int, 
		(fr_material_node, Ptr{fr_char}, fr_image,), 
		in_node, in_input, image
	)
	check_error(is_error)
	nothing
end

# in_data, size_t* out_size);
function MaterialNodeGetInfo(in_node, in_info, in_size, in_data)
	out_size = Array(Csize_t, 1);
	is_error = ccall(
		(:frMaterialNodeGetInfo, firelib), fr_int, 
		(fr_material_node, fr_material_node_info, Csize_t, Ptr{Void}, Csize_t,), 
		in_node, in_info, in_size, in_data, out_size
	)
	check_error(is_error)
	out_size[]
end

# in_data, size_t* out_size);
function MaterialNodeGetInputInfo(in_node, in_input_idx, in_info, in_size, in_data)
	out_size = Array(Csize_t, 1);
	is_error = ccall(
		(:frMaterialNodeGetInputInfo, firelib), fr_int, 
		(fr_material_node, fr_int, fr_material_node_input_info, Csize_t, Ptr{Void}, Csize_t,), 
		in_node, in_input_idx, in_info, in_size, in_data, out_size
	)
	check_error(is_error)
	out_size[]
end

#* @brief Delete object
#
#   Possible error codes:
#      FR_ERROR_OUT_OF_SYSTEM_MEMORY
#      FR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# obj);
function ObjectDelete(obj)
	
	is_error = ccall(
		(:frObjectDelete, firelib), fr_int, 
		(Ptr{Void},), 
		obj
	)
	check_error(is_error)
	nothing
end

# out_fb);
function ContextCreateFramebufferFromGLTexture2D(context, target, miplevel, texture)
	out_fb = Array(fr_framebuffer, 1);
	is_error = ccall(
		(:frContextCreateFramebufferFromGLTexture2D, firelib), fr_int, 
		(fr_context, fr_GLenum, fr_GLint, fr_GLuint, fr_framebuffer,), 
		context, target, miplevel, texture, out_fb
	)
	check_error(is_error)
	out_fb[]
end

# __FRCONTEXT_H  

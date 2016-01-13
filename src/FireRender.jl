module FireRender

const API_VERSION = 0x010000078
const SUCCESS                                      = 0
const ERROR_COMPUTE_API_NOT_SUPPORTED             = -1
const ERROR_OUT_OF_SYSTEM_MEMORY                  = -2
const ERROR_OUT_OF_VIDEO_MEMORY                   = -3
const ERROR_INVALID_LIGHTPATH_EXPR                = -5
const ERROR_INVALID_IMAGE                         = -6
const ERROR_INVALID_AA_METHOD                     = -7
const ERROR_UNSUPPORTED_IMAGE_FORMAT              = -8
const ERROR_INVALID_GL_TEXTURE                    = -9
const ERROR_INVALID_CL_IMAGE                      = -10
const ERROR_INVALID_OBJECT                        = -11
const ERROR_INVALID_PARAMETER                     = -12
const ERROR_INVALID_TAG                           = -13
const ERROR_INVALID_LIGHT                         = -14
const ERROR_INVALID_CONTEXT                       = -15
const ERROR_UNIMPLEMENTED                         = -16
const ERROR_INVALID_API_VERSION                   = -17
const ERROR_INTERNAL_ERROR                        = -18
const ERROR_IO_ERROR                              = -19
const ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE     = -20

#= fr_parameter_type =#
const PARAMETER_TYPE_FLOAT = 0x1
const PARAMETER_TYPE_FLOAT2= 0x2
const PARAMETER_TYPE_FLOAT3= 0x3
const PARAMETER_TYPE_FLOAT4= 0x4
const PARAMETER_TYPE_IMAGE = 0x5
const PARAMETER_TYPE_STRING= 0x6
const PARAMETER_TYPE_SHADER= 0x7
const PARAMETER_TYPE_UINT  = 0x8

#= fr_image_type =#
const IMAGE_TYPE_1D= 0x1
const IMAGE_TYPE_2D= 0x2
const IMAGE_TYPE_3D= 0x3

#= fr_context_type =#
const CONTEXT_OPENCL       = 0x1
const CONTEXT_DIRECTCOMPUTE= 0x2
const CONTEXT_REFERENCE    = 0x3

#= fr_creation_flags =#
const CREATION_FLAGS_ENABLE_GPU0        = (1 << 0)
const CREATION_FLAGS_ENABLE_GPU1        = (1 << 1)
const CREATION_FLAGS_ENABLE_GPU2        = (1 << 2)
const CREATION_FLAGS_ENABLE_GPU3        = (1 << 3)
const CREATION_FLAGS_ENABLE_CPU         = (1 << 4)
const CREATION_FLAGS_ENABLE_GL_INTEROP  = (1 << 5)

#= fr_render_status =#
const RENDER_WORKING= 0x1
const RENDER_PAUSED = 0x2
const RENDER_STANDBY= 0x3

#= fr_color_space =#
const COLOR_SPACE_RGB = 0x1
const COLOR_SPACE_LAB = 0x2
const COLOR_SPACE_HSV = 0x3
const COLOR_SPACE_CMYK= 0x4

#= fr_aa_filter =#
const FILTER_BOX           = 0x1
const FILTER_TRIANGLE      = 0x2
const FILTER_GAUSSIAN      = 0x3
const FILTER_MITCHELL      = 0x4
const FILTER_LANCZOS       = 0x5
const FILTER_BLACKMANHARRIS= 0x6

#= fr_shape_type =#
const SHAPE_TYPE_MESH          = 0x1
const SHAPE_TYPE_INSTANCE      = 0x2

#= fr_light_type =#
const LIGHT_TYPE_POINT      = 0x1
const LIGHT_TYPE_DIRECTIONAL= 0x2
const LIGHT_TYPE_SPOT       = 0x3
const LIGHT_TYPE_ENVIRONMENT= 0x4
const LIGHT_TYPE_SKY        = 0x5


#= fr_context_info =#
const CONTEXT_COMPUTE_API         = 0x101
const CONTEXT_RENDER_STATUS       = 0x102
const CONTEXT_RENDER_STATISTICS   = 0x103
const CONTEXT_DEVICE_COUNT        = 0x104
#const CONTEXT_AA_FILTER           = 0x105
#const CONTEXT_AA_SAMPLE_COUNT     = 0x106
#const CONTEXT_GAMMA_RAMP          = 0x107
#const CONTEXT_PERFORMANCE_FACTOR  = 0x108
#const CONTEXT_RENDER_MODE         = 0x109
#const CONTEXT_OUTPUT_FLIP_MODE    = 0x10A
#const CONTEXT_AA_GRID_SIZE        = 0x10B
#const CONTEXT_TONEMAPPING_OPERATOR= 0x10C
#const CONTEXT_AA_FILTER_RADIUS    = 0x10D
const CONTEXT_PARAMETER_COUNT     = 0x10F

#= fr_camera_info =#
const CAMERA_TRANSFORM      = 0x201
const CAMERA_FSTOP          = 0x202
const CAMERA_APERTURE_BLADES= 0x203
const CAMERA_RESPONSE       = 0x204
const CAMERA_EXPOSURE       = 0x205
const CAMERA_FOCAL_LENGTH   = 0x206
const CAMERA_SENSOR_SIZE    = 0x207
const CAMERA_MODE           = 0x208
const CAMERA_ORTHO_WIDTH    = 0x209
const CAMERA_FOCUS_DISTANCE = 0x20A
const CAMERA_POSITION       = 0x20B
const CAMERA_LOOKAT         = 0x20C
const CAMERA_UP             = 0x20D

#= fr_image_info =#
const IMAGE_FORMAT      = 0x301
const IMAGE_DESC        = 0x302
const IMAGE_DATA        = 0x303

#= fr_shape_info =#
const SHAPE_TYPE           = 0x401
const SHAPE_VIDMEM_USAGE   = 0x402
const SHAPE_TRANSFORM      = 0x403
const SHAPE_SHADER         = 0x404
const SHAPE_LINEAR_MOTION  = 0x405
const SHAPE_ANGULAR_MOTION = 0x406
const SHAPE_VISIBILITY_FLAG= 0x407
const SHAPE_SHADOW_FLAG    = 0x408

#= fr_mesh_info =#
const MESH_POLYGON_COUNT  = 0x501
const MESH_VERTEX_COUNT   = 0x502
const MESH_NORMAL_COUNT   = 0x503
const MESH_UV_COUNT       = 0x504
const MESH_VERTEX_ARRAY   = 0x505
const MESH_NORMAL_ARRAY   = 0x506
const MESH_UV_ARRAY       = 0x507
const MESH_VERTEX_INDEX_ARRAY= 0x508
const MESH_NORMAL_INDEX_ARRAY= 0x509
const MESH_UV_INDEX_ARRAY    = 0x50A
const MESH_NUM_VERTICES_ARRAY= 0x50B


#= fr_scene_info =#
const SCENE_SHAPE_COUNT  = 0x701
const SCENE_LIGHT_COUNT  = 0x702
const SCENE_TEXTURE_COUNT= 0x703
const SCENE_SHAPE_LIST   = 0x704
const SCENE_LIGHT_LIST   = 0x705
const SCENE_TEXTURE_LIST = 0x706

#= fr_light_info =#
const LIGHT_TYPE        = 0x801
const LIGHT_VIDMEM_USAGE= 0x802
const LIGHT_TRANSFORM   = 0x803

#= fr_light_info - point light =#
const POINT_LIGHT_RADIANT_POWER= 0x804

#= fr_light_info - directional light =#
const DIRECTIONAL_LIGHT_RADIANT_POWER= 0x808

#= fr_light_info - spot light =#
const SPOT_LIGHT_RADIANT_POWER= 0x80B
const SPOT_LIGHT_CONE_SHAPE= 0x80C

#= fr_light_info - environment light =#
const ENVIRONMENT_LIGHT_IMAGE= 0x80F
const ENVIRONMENT_LIGHT_INTENSITY_SCALE= 0x810
const ENVIRONMENT_LIGHT_PORTAL= 0x811

#= fr_light_info - sky light =#
const SKY_LIGHT_TURBIDITY= 0x812
const SKY_LIGHT_ALBEDO   = 0x813
const SKY_LIGHT_SCALE    = 0x814
const SKY_LIGHT_PORTAL   = 0x815

#= fr_shader_info =#
const SHADER_NAME           = 0x1101
const SHADER_DESCRIPTION    = 0x1102
const SHADER_PARAMETER_COUNT= 0x1103
const SHADER_TYPE           = 0x1104

#= fr_parameter_info =#
const PARAMETER_NAME       = 0x1201
const PARAMETER_TYPE       = 0x1202
const PARAMETER_DESCRIPTION= 0x1203
const PARAMETER_VALUE      = 0x1204

#= fr_framebuffer_info =#
const FRAMEBUFFER_FORMAT      = 0x1301
const FRAMEBUFFER_DESC        = 0x1302
const FRAMEBUFFER_DATA        = 0x1303

#= fr_mesh_polygon_info =#
const MESH_POLYGON_VERTEX_COUNT= 0x1401

#= fr_mesh_polygon_vertex_info =#
const MESH_POLYGON_VERTEX_POSITION  = 0x1501
const MESH_POLYGON_VERTEX_NORMAL    = 0x1502
const MESH_POLYGON_VERTEX_TEXCOORD  = 0x1503

#= fr_shader_type =#
const SHADER_DEFAULT          = 0x0
const SHADER_LAMBERT          = 0x1
const SHADER_MICROFACET       = 0x2
const SHADER_REFLECT          = 0x3
const SHADER_REFRACT          = 0x4
const SHADER_EMISSIVE         = 0x5
const SHADER_LAYERED          = 0x6
#const SHADER_FUR              = 0x7
const SHADER_DIFFUSE_ORENNAYAR= 0x8
const SHADER_TRANSPARENT      = 0x9
const SHADER_OSL              = 0xa
const SHADER_INCANDESCENSE    = 0xb
const SHADER_STANDARD         = 0xc

#= fr_image_format =#
#= fr_framebuffer_format =#
#const FORMAT_RGBA32_F         = 0x1
#const FORMAT_RGBA16_F         = 0x2
#const FORMAT_RGBA8_U          = 0x3

#= fr_component_type =#
const COMPONENT_TYPE_UINT8    = 0x1
const COMPONENT_TYPE_FLOAT16  = 0x2
const COMPONENT_TYPE_FLOAT32  = 0x3

#= fr_render_mode =#
const RENDER_MODE_GLOBAL_ILLUMINATION             = 0x1
const RENDER_MODE_DIRECT_ILLUMINATION             = 0x2
const RENDER_MODE_DIRECT_ILLUMINATION_NO_SHADOW   = 0x3
const RENDER_MODE_WIREFRAME                       = 0x4
const RENDER_MODE_DIFFUSE_ALBEDO                  = 0x5
const RENDER_MODE_POSITION                        = 0x6
const RENDER_MODE_NORMAL                          = 0x7
const RENDER_MODE_TEXCOORD                        = 0x8
const RENDER_MODE_AMBIENT_OCCLUSION               = 0x9

#= fr_camera_mode =#
const CAMERA_MODE_PERSPECTIVE             = 0x1
const CAMERA_MODE_ORTHOGRAPHIC            = 0x2

#= fr_tonemapping_operator =#
const TONEMAPPING_OPERATOR_NONE       = 0x0
const TONEMAPPING_OPERATOR_LINEAR     = 0x1
const TONEMAPPING_OPERATOR_PHOTOLINEAR= 0x2
const TONEMAPPING_OPERATOR_AUTOLINEAR = 0x3
const TONEMAPPING_OPERATOR_MAXWHITE   = 0x4
const TONEMAPPING_OPERATOR_REINHARD02 = 0x5

#= fr_volume_type =#
const VOLUME_TYPE_NONE         = 0xFFFF
const VOLUME_TYPE_HOMOGENEOUS  = 0x0
const VOLUME_TYPE_HETEROGENEOUS= 0x1


#= Constants =#
const MAX_AA_SAMPLES  = 32
const MAX_AA_GRID_SIZE= 16

#= fr_bool =#
const FALSE = 0
const TRUE  = 1

#= Library types =#
#= This is going to be moved to fr_platform.h or similar =#
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
typealias fr_context Ptr{Void}
typealias fr_camera Ptr{Void}
typealias fr_shape Ptr{Void}
typealias fr_light Ptr{Void}
typealias fr_scene Ptr{Void}
typealias fr_image Ptr{Void}
typealias fr_framebuffer Ptr{Void}
typealias fr_shader Ptr{Void}

typealias fr_context_properties Ptr{Void}
typealias fr_light_type fr_uint
typealias fr_image_type fr_uint
typealias fr_shape_type fr_uint
typealias fr_context_type fr_uint
typealias fr_creation_flags fr_bitfield
typealias fr_render_status fr_uint
typealias fr_color_space fr_uint
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
typealias fr_shader_info fr_uint
typealias fr_parameter_info fr_uint
typealias fr_framebuffer_info fr_uint
typealias fr_channel_order fr_uint
typealias fr_channel_type fr_uint
typealias fr_category_id fr_uint
typealias fr_shape_type fr_uint
typealias fr_light_type fr_uint
typealias fr_distance_attenuation_type fr_uint
typealias fr_shader_type fr_uint
typealias fr_parameter_type fr_uint
typealias fr_render_mode fr_uint
typealias fr_component_type fr_uint
typealias fr_camera_mode fr_uint
typealias fr_tonemapping_operator fr_uint
typealias fr_volume_type fr_uint


typealias fr_GLuint Cuint
typealias fr_GLint Cint;
typealias fr_GLenum Cuint;

typealias fr_gl_object_type fr_uint
typealias fr_gl_texture_info fr_uint
typealias fr_gl_platform_info fr_uint


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

typealias fr_framebuffer_format fr_image_format

const lib = "FireRender64"

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
macro fr_fun(returntype, fr_func)
	func_name = fr_func.args[1]
	func_args = fr_func.args[2:end]
	arg_names   = map(arg->arg.args[1], func_args)
    input_types = map(arg->arg.args[2], func_args)
    if func_args[end] == :(status::Ptr{fr_int})
    	pre_call = :(status = Ref{Cint}(SUCCESS))
    	post_call = :(check_error(status[]))
    	arg_names_call = arg_names[1:end-1]
    else
    	pre_call = :()
    	post_call = :(check_error(result))
    	arg_names_call = arg_names
    end

    func_name_sym   = Expr(:quote, func_name)
	expr = quote
		function $func_name($(arg_names_call...))
			$pre_call
			result = ccall(($func_name_sym, lib), $returntype, ($(input_types...),), $(arg_names...))
			$post_call
			result
		end
		$(Expr(:export, :($func_name)))
	end
	esc(expr)
end

#= API functions =#
#=* @brief Create rendering context
  *
  *  Rendering context is a root concept encapsulating the render states and responsible
  *  for execution control. All the entities in FireRender are created for a particular rendering context.
  *  Entities created for some context can't be used with other contexts. Possible error codes for this call are:
  *
  *     ERROR_COMPUTE_API_NOT_SUPPORTED
  *     ERROR_OUT_OF_SYSTEM_MEMORY
  *     ERROR_OUT_OF_VIDEO_MEMORY
  *     ERROR_INVALID_API_VERSION
  *     ERROR_INVALID_PARAMETER
  *
  *  @param context_type    Determines compute API use::to, OPENCL only is supported for now
  *  @param creation_flags  Determines multi-gpu or cpu-gpu configuration
  *  @param props           properties::Context, reserved for future use
  *  @param cache_path      Full path to kernel cache created FireRender::by, NULL means to use current folder
  *  @param status          SUCCESS in case success::of, error code otherwise
  *  @return                Context object
=#
@fr_fun fr_context  frCreateContext(api_version::fr_int, context_type::fr_context_type, creation_flags::fr_creation_flags, props::Ptr{fr_context_properties}, cache_path::Ptr{fr_char},  status::Ptr{fr_int})

#=* @brief Increment reference counter for a context
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  context     The context to increment the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#

@fr_fun fr_int  frContextRetain(context::fr_context)
#=* @brief Decrement reference counter for a context
 *
 *  Object lifetime management function decrementing internal reference counter.
 *  In case the reference counter equals to 0 after the decrement the object is destroyed.
 *
 *  @param  context     The context to decrement the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextRelease(context::fr_context)

#=* @brief Query information about a context
 *
 *  The workflow is usually two-step: query with the data == NULL and size = 0 to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  context         The context to query
 *  @param  context_info    The type of info to query
 *  @param  size            The size of the buffer pointed by data
 *  @param  data            The buffer to store queried info
 *  @param  size_ret        Returns the size in bytes of the data being queried
 *  @return                 SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextGetInfo(context::fr_context, context_info::fr_context_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Query information about a context
*
*  The workflow is usually two-step: query with the data == NULL and size = 0 to get the required size::buffer,
*  then query with size_ret == NULL to fill the buffer with the data
*   Possible error codes:
*     ERROR_INVALID_PARAMETER
*
*  @param  context         The context to query
*  @param  param_idx	   The index of the parameter
*  @param  parameter_info  The type of info to query
*  @param  size            The size of the buffer pointed by data
*  @param  data            The buffer to store queried info
*  @param  size_ret        Returns the size in bytes of the data being queried
*  @return                 SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int  frContextGetParameterInfo(context::fr_context, param_idx::Cint, parameter_info::fr_parameter_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Get the frame buffer
 *
 *  @param  context     The context to get a frame buffer from
 *  @param  status      SUCCESS in case success::of, error code otherwise
 *  @return             Frame buffer object
 =#
@fr_fun fr_framebuffer  frContextGetFrameBuffer(context::fr_context, status::Ptr{fr_int})

#=* @brief Set the frame buffer
 *
 *  @param  context         The context to set the frame buffer to
 *  @param  frame_buffer    Frame buffer object to set
 *  @return                 SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextSetFrameBuffer(context::fr_context, frame_buffer::fr_framebuffer)

#=* @brief Set the scene
 *
 *  The scene is a collection objects::of, lights, volume regions
 *  along with all the data required to shade those. The scene is
 *  used by the context ro render the image.
 *
 *  @param  context     The context to set the scene to
 *  @param  scene       The scene to set
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextSetScene(context::fr_context, scene::fr_scene)

#=* @brief Get the current scene
 *
 *  The scene is a collection objects::of, lights, volume regions
 *  along with all the data required to shade those. The scene is
 *  used by the context ro render the image.
 *
 *  @param  context     The context to get the scene from
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
#@fr_fun fr_scene  frContextGetScene(fr_context, Ptr{fr_int})

#=* @brief Set parameter
 *
 *  @param  context                             The context to set the value to
 *  @param  aacellsize                          ft_float
 *  @param  aasamples                           ft_float

 *  @param  imagefilter.type					fr_aa_filter
            imagefilter.box.radius              ft_float
            imagefilter.gaussian.radius         ft_float
            imagefilter.triangle.radius          ft_float
            imagefilter.mitchell.radius         ft_float
            imagefilter.lanczos.radius          ft_float
            imagefilter.blackmanharris.radius   ft_float

 *  @param  tonemapping.type                    fr_tonemapping_operator
            tonemapping.linear.scale            ft_float
            tonemapping.photolinear.sensitivity ft_float
            tonemapping.photolinear.exposure    ft_float
            tonemapping.photolinear.fstop       ft_float
            tonemapping.reinhard02.prescale     ft_float
            tonemapping.reinhard02.postscale    ft_float
            tonemapping.reinhard02.burn         ft_float

 *  @return             SUCCESS in case success::of, error code otherwise
 =#

@fr_fun fr_int  frContextSetParameter1u(context::fr_context, name::Ptr{fr_char}, x::fr_uint)
@fr_fun fr_int  frContextSetParameter1f(context::fr_context, name::Ptr{fr_char}, x::fr_float)
@fr_fun fr_int  frContextSetParameter3f(context::fr_context, name::Ptr{fr_char}, x::fr_float, y::fr_float, z::fr_float)
@fr_fun fr_int  frContextSetParameter4f(context::fr_context, name::Ptr{fr_char}, x::fr_float, y::fr_float, z::fr_float, w::fr_float)




#=* @brief Perform evaluation and accumulation of a single sample (or number of AA samples if AA enabled::is)
 *
 *  The call is blocking and the image is ready when returned. The context accumulates the samples in order
 *  to progressively refine the image and enable interactive response. So each new call to Render refines the
 *  resultin image with 1 (or num samples::aa) color samples. Call frFramebufferClear if you want to start rendering new image
 *  instead of refining the previous one.
 *
 *  Possible error codes:
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_INTERNAL_ERROR
 *
 *  @param  context     The context object
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextRender(context::fr_context)

#=* @brief Perform evaluation and accumulation of a single sample (or number of AA samples if AA enabled::is) on the part of the image
 *
 *  The call is blocking and the image is ready when returned. The context accumulates the samples in order
 *  to progressively refine the image and enable interactive response. So each new call to Render refines the
 *  resultin image with 1 (or num samples::aa) color samples. Call frFramebufferClear if you want to start rendering new image
 *  instead of refining the previous one. Possible error codes are:
 *
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_INTERNAL_ERROR
 *
 *  @param  context     The context to use for the rendering
 *  @param  xmin        X coordinate of the top left corner of a tile
 *  @param  xmax        X coordinate of the bottom right corner of a tile
 *  @param  ymin        Y coordinate of the top left corner of a tile
 *  @param  ymax        Y coordinate of the bottom right corner of a tile
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextRenderTile(context::fr_context, xmin::fr_uint, xmax::fr_uint, ymin::fr_uint, ymax::fr_uint)

#=* @brief Clear all video memory used by the context
 *
 *  This function should be called after all context objects have been destroyed.
 *  It guarantees that all context memory is freed and returns the context into its initial state.
 *  Will be removed later. Possible error codes are:
 *
 *      ERROR_INTERNAL_ERROR
 *
 *  @param  context     The context to increment the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frContextClearMemory(context::fr_context)

#=* @brief Create an image from memory data
 *
 *  Images are used as a texturing source or emission map for an environment map.
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_UNSUPPORTED_IMAGE_FORMAT
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  context     The context to create image
 *  @param  format      Image format
 *  @param  image_desc  Image layout description
 *  @param  data        Image data in memory::system, can be NULL in which case the memory is allocated
 *  @param  status      SUCCESS in case success::of, error code otherwise
 *  @return             Image object
 =#
@fr_fun fr_image  frContextCreateImage(context::fr_context, format::fr_image_format, image_desc::Ptr{fr_image_desc}, data::Ptr{Void}, status::Ptr{Cint})

#=* @brief Create an image from file
 *
 *  Images are used as a source::texturing, render target of emission map for environment light.
 *
 *  The following image formats are supported:
 *      PNG, JPG, TGA, BMP, TIFF, TX(0-mip), HDR, EXR
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_UNSUPPORTED_IMAGE_FORMAT
 *      ERROR_INVALID_PARAMETER
 *      ERROR_IO_ERROR
 *
 *  @param  context     The context to create image
 *  @param  path        NULL terminated path to an image file (can relative::be)
 *  @param  status      SUCCESS in case success::of, error code otherwise
 *  @return             Image object
 =#
@fr_fun fr_image  frContextCreateImageFromFile(context::fr_context, path::Ptr{fr_char}, status::Ptr{Cint})

#=* @brief Create a scene
 *
 *  Scene serves as a container lights::for, shapes and camera
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *
 *  @param  status      SUCCESS in case success::of, error code otherwise
 *  @return             Scene object
 =#
@fr_fun fr_scene      frContextCreateScene(context::fr_context, status::Ptr{fr_int})

#=* @brief Create an instance of an object
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  context  The context to create an instance for
 *  @param  shape    Parent shape for an instance
 *  @param  status   SUCCESS in case success::of, error code otherwise
 *  @return shape object
 =#
@fr_fun fr_shape      frContextCreateInstance(context::fr_context, shape::fr_shape, status::Ptr{fr_int})

#=* @brief Create a mesh
 *
 *  FireRender supports mixed meshes consisting of triangles and quads
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  vertices            Pointer to position data (each position is described with 3 numbers::fr_float)
 *  @param  num_vertices        Number of entries in position array
 *  @param  vertex_stride       Number of bytes between the beginnings of two successive position entries
 *  @param  normals             Pointer to normal data (each normal is described with 3 numbers::fr_float), can be NULL
 *  @param  num_normals         Number of entries in normal array
 *  @param  normal_stride       Number of bytes between the beginnings of two successive normal entries
 *  @param  texcoord            Pointer to texcoord data (each texcoord is described with 2 numbers::fr_float), can be NULL
 *  @param  num_texcoords       Number of entries in texcoord array
 *  @param  texcoord_stride     Number of bytes between the beginnings of two successive texcoord entries
 *  @param  vertex_indices      Pointer to an array of vertex indices
 *  @param  vidx_stride         Number of bytes between the beginnings of two successive vertex index entries
 *  @param  normal_indices      Pointer to an array of normal indices
 *  @param  nidx_stride         Number of bytes between the beginnings of two successive normal index entries
 *  @param  texcoord_indices    Pointer to an array of texcoord indices
 *  @param  tidx_stride         Number of bytes between the beginnings of two successive texcoord index entries
 *  @param  num_face_vertices   Pointer to an array of num_faces numbers describing number of vertices for each face (can be 3(triangle) or 4(quad))
 *  @param  num_faces           Number of faces in the mesh
 *  @param  status              SUCCESS in case of success, error code otherwise
 *  @return                     Shape object
 =#
@fr_fun fr_shape      frContextCreateMesh(context::fr_context, vertices::Ptr{fr_float},  num_vertices::Csize_t,   vertex_stride::fr_int,
                                                                          normals::Ptr{fr_float},   num_normals::Csize_t,    normal_stride::fr_int,
                                                                          texcoords::Ptr{fr_float}, num_texcoords::Csize_t,  texcoord_stride::fr_int,
                                                                          vertex_indices::Ptr{fr_int},   vidx_stride::fr_int,
                                                                          normal_indices::Ptr{fr_int},   nidx_stride::fr_int,
                                                                          texcoord_indices::Ptr{fr_int}, tidx_stride::fr_int,
                                                                          num_face_vertices::Ptr{fr_int}, num_faces::Csize_t,
                                                                          status::Ptr{fr_int})


#=* @brief Create a camera
 *
 *  There are several camera types supported by a single fr_camera type.
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *
 *  @param  context The context to create a camera for
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Camera object
 =#
@fr_fun fr_camera   frContextCreateCamera(context::fr_context, status::Ptr{fr_int})

#=* @brief Create framebuffer object
 *
 *  Framebuffer is used to store final rendering result.
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *
 *  @param  context  The context to create framebuffer
 *  @param  format   Framebuffer format
 *  @param  fb_desc  Framebuffer layout description
 *  @param  status   SUCCESS in case success::of, error code otherwise
 *  @return          Framebuffer object
 =#
@fr_fun fr_framebuffer  frContextCreateFrameBuffer(context::fr_context, format::fr_framebuffer_format, fb_desc::Ptr{fr_framebuffer_desc}, status::Ptr{Cint})

@fr_fun fr_framebuffer frContextCreateFramebufferFromGLTexture2D(
	context  ::fr_context,
	target   ::fr_GLenum,
	miplevel ::fr_GLint,
	texture  ::fr_GLuint,
	status   ::Ptr{fr_int}
)


#=* @brief Create a shader
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  context The context to create a shader for
 *  @param  type    The type of a shader
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Shader object
 =#
@fr_fun fr_shader   frContextCreateShader(context::fr_context, typ::fr_shader_type, status::Ptr{fr_int})

#=* @brief Create an OSL shader from file
 *
 *  NOT SUPPORTED IN THIS API VERSION: returns ERROR_UNIMPLEMENTED
 *
 *  @param  context The context to create a material library for
 *  @param  path    NULL terminated full path to shader source code
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Shader object
 =#
@fr_fun fr_shader   frContextCreateShaderFromFile(context::fr_context, path::Ptr{fr_char}, status::Ptr{fr_int})


#=* @brief Create empty heterogeneous volume of a given resolution and data type
 *
 *  Possible error codes are:
 *
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *
 *  @param  context The context to create a volume for
 *  @param  type    The type of a volume
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Volume object
 =#
#@fr_fun fr_shader   frContextCreateVolume(context::fr_context, typ::fr_shader_type, status::Ptr{fr_int})


#=* @brief Query information about a shader
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data.

 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader   The shader to query
 *  @param  info     The type of info to query
 *  @param  size     The size of the buffer pointed by data
 *  @param  data     The buffer to store queried info
 *  @param  size_ret Returns the size in bytes of the data being queried
 *  @return          SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderGetInfo(shader::fr_shader, info::fr_shader_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Increment reference counter for a shader
 *
 *  Object lifetime management function incrementing internal reference counter.
 *
 *  @param  shader  The shader to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderRetain(shader::fr_shader)

#=* @brief Decrement reference counter for a shader
 *
 *  Object lifetime management function decrementing internal reference counter.
 *  In case the reference counter equals to 0 after the decrement the object is destroyed.
 *
 *  @param  shader  The shader to decrement the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderRelease(shader::fr_shader)


#=* @brief Query information about a shader parameter
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data.
 *
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader      The shader to query
 *  @param  parameter   The shader parameter to query
 *  @param  info        The type of info to query
 *  @param  size        The size of the buffer pointed by data
 *  @param  data        The buffer to store queried info
 *  @param  size_ret    Returns the size in bytes of the data being queried
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderGetParameterInfo(shader::fr_shader, param_idx::Csize_t, info::fr_parameter_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Set material parameter float value
 *
 *  The shader can have several parameters which are set from user code.
 *
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value     The value to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter1f(shader::fr_shader, parameter::Ptr{fr_char}, value::fr_float)

#=* @brief Set material parameter float2 value
 *
 *  The shader can have several parameters which are set from user code.
 *
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader  The shader
 *  @param  parameter The shader parameter to set
 *  @param  value1    The value to set for the first component of a float2 vector
 *  @param  value2    The value to set for the second component of a float2 vector
 *  @return SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter2f(shader::fr_shader, parameter::Ptr{fr_char}, value1::fr_float, value2::fr_float)

#=* @brief Set shader parameter float3 value
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value1    The value to set for the first component of a float3 vector
 *  @param  value2    The value to set for the second component of a float3 vector
 *  @param  value3    The value to set for the third component of a float3 vector
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter3f(shader::fr_shader, parameter::Ptr{fr_char}, value1::fr_float, value2::fr_float, value3::fr_float)

#=* @brief Set shader parameter float4 value
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value1    The value to set for the first component of a float4 vector
 *  @param  value2    The value to set for the second component of a float4 vector
 *  @param  value3    The value to set for the third component of a float4 vector
 *  @param  value4    The value to set for the fourth component of a float4 vector
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter4f(shader::fr_shader, parameter::Ptr{fr_char}, value1::fr_float, value2::fr_float, value3::fr_float, value4::fr_float)

#=* @brief Set shader parameter float value
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value     The pointer to a single float value to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter1fv(shader::fr_shader, parameter::Ptr{fr_char}, value::Ptr{fr_float})

#=* @brief Set shader parameter float2 value
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value     The pointer to an array of two float values to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter2fv(shader::fr_shader, parameter::Ptr{fr_char}, value::Ptr{fr_float})

#=* @brief Set shader parameter float3 value
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value     The pointer to an array of three float values to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter3fv(shader::fr_shader, parameter::Ptr{fr_char}, value::Ptr{fr_float})

#=* @brief Set shader parameter float4 value
 *
 *  The shader can have several parameters which are set from user code.
 *
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  value     The pointer to a four float values to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameter4fv(shader::fr_shader, parameter::Ptr{fr_char}, value::Ptr{fr_float})

#=* @brief Set image shader parameter
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  image     Image object to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameterImage(shader::fr_shader, parameter::Ptr{fr_char}, image::fr_image)

#=* @brief Set shader as a shader parameter
 *
 *  The layered shaders can refer to other shaders as their parameters. This call is valid for layered shaders only.
 *   Possible error codes:
 *     ERROR_INVALID_PARAMETER
 *
 *  @param  shader    The shader
 *  @param  parameter The shader parameter to set
 *  @param  shader    Shader object to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameterShader(shader::fr_shader, parameter::Ptr{fr_char}, shader_param::fr_shader)

#=* @brief Set image path shader parameter
 *
 *  The shader can have several parameters which are set from user code.
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_UNSUPPORTED_IMAGE_FORMAT
 *      ERROR_IO_ERROR
 *
 *  @param  shader      The shader
 *  @param  parameter   The shader parameter to set
 *  @param  image_path  Full or relative path to the image
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int          frShaderSetParameterImagePath(shader::fr_shader, parameter::Ptr{fr_char}, image_path::Ptr{fr_char})

#= fr_camera =#
#=* @brief Query information about a camera
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data.
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  camera      The camera to query
 *  @param  camera_info The type of info to query
 *  @param  size        The size of the buffer pointed by data
 *  @param  data        The buffer to store queried info
 *  @param  size_ret    Returns the size in bytes of the data being queried
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraGetInfo(camera::fr_camera, camera_info::fr_camera_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Increment reference counter for a camera
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  camera  The camera to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraRetain(camera::fr_camera)

#=* @brief Decrement reference counter for a camera
 *
 *  Object lifetime management function decrementing internal reference counter.
 *  In case the reference counter equals to 0 after the decrement the object is destroyed.
 *
 *  @param  camera  The camera to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraRelease(camera::fr_camera)

#=* @brief Set camera focal length.
 *
 *  @param  camera  The camera to set focal length
 *  @param  flength Focal length millimeters::in, default is 35mm
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetFocalLength(camera::fr_camera, flength::fr_float)

#=* @brief Set camera focus distance
 *
 *  @param  camera  The camera to set focus distance
 *  @param  fdist   Focus distance meters::in, default is 1m
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetFocusDistance(camera::fr_camera, fdist::fr_float)

#=* @brief Set world transform for the camera
 *
 *  @param  camera      The camera to set transform for
 *  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
 *  @param  transform   Array of 16 values::fr_float (row-major form)
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int frCameraSetTransform(camera::fr_camera, transpose::fr_bool, transform::Ptr{fr_float})

@fr_fun fr_int frCameraSetSensorSize(camera::fr_camera, width::fr_float, height::fr_float)
#=* @brief Set camera transform in lookat form
 *
 *  @param  camera  The camera to set transform for
 *  @param  posx    X component of the position
 *  @param  posy    Y component of the position
 *  @param  posz    Z component of the position
 *  @param  atx     X component of the center point
 *  @param  aty     Y component of the center point
 *  @param  atz     Z component of the center point
 *  @param  upx     X component of the up vector
 *  @param  upy     Y component of the up vector
 *  @param  upz     Z component of the up vector
 *  @return         FR_SUCCESS in case of success, error code otherwise
=#
@fr_fun fr_int frCameraLookAt(camera::fr_camera,      posx::fr_float,    posy::fr_float,    posz::fr_float,
                                                                    atx::fr_float,    aty::fr_float,    atz::fr_float,
                                                                    upx::fr_float,    upy::fr_float,    upz::fr_float)


#=* @brief Set f-stop for the camera
 *
 *  @param  camera  The camera to set f-stop for
 *  @param  fstop   f-stop value in mm^-1, default is FLT_MAX
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetFStop(camera::fr_camera, fstop::fr_float)

#=* @brief Set the number of aperture blades
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  camera      The camera to set aperture blades for
 *  @param  num_blades  Number of aperture blades 4 to 32
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetApertureBlades(camera::fr_camera, num_blades::fr_uint)

#=* @brief Set the exposure of a camera
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  camera    The camera to set aperture blades for
 *  @param  exposure  Exposure value 0.0 - 1.0
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetExposure(camera::fr_camera, exposure::fr_float)

#=* @brief Set camera mode
 *
 *  Camera modes include:
 *      CAMERA_MODE_PERSPECTIVE
 *      CAMERA_MODE_ORTHOGRAPHIC
 *
 *  @param  camera  The camera to set mode for
 *  @param  mode    mode::Camera, default is CAMERA_MODE_PERSPECTIVE
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetMode(camera::fr_camera, mode::fr_camera_mode)

#=* @brief Set orthographic view volume width
 *
 *  @param  camera  The camera to set volume width for
 *  @param  width   View volume width meters::in, default is 1 meter
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frCameraSetOrthoWidth(camera::fr_camera, width::fr_float)

#= fr_image=#
#=* @brief Query information about an image
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  image       An image object to query
 *  @param  image_info  The type of info to query
 *  @param  size        The size of the buffer pointed by data
 *  @param  data        The buffer to store queried info
 *  @param  size_ret    Returns the size in bytes of the data being queried
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frImageGetInfo(image::fr_image, image_info::fr_image_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Increment reference counter for an image
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  image       An image to increment the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frImageRetain(image::fr_image)

#=* @brief Decrement reference counter for an image
 *
 *  Object lifetime management function decrementing internal reference counter
 *
 *  @param  image       An image to decrement the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frImageRelease(image::fr_image)

#= fr_shape =#
#=* @brief Set shape world transform
 *
 *
 *  @param  shape       The shape to set transform for
 *  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
 *  @param  transform   Array of 16 values::fr_float (row-major form)
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeSetTransform(shape::fr_shape, transpose::fr_bool, transform::Ptr{fr_float})


#=* @brief Set shape linear motion
 *
 *  @param  shape       The shape to set linear motion for
 *  @param  x           X component of a motion vector
 *  @param  y           Y component of a motion vector
 *  @param  z           Z component of a motion vector
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeSetLinearMotion(shape::fr_shape, x::fr_float, y::fr_float, z::fr_float)


#=* @brief Set angular linear motion
 *
 *  @param  shape       The shape to set linear motion for
 *  @param  x           X component of the rotation axis
 *  @param  y           Y component of the rotation axis
 *  @param  z           Z component of the rotation axis
 *  @param  w           W rotation angle in radians
 *  @return             SUCCESS in case success::of, error code otherwise
 =#

@fr_fun fr_int        frShapeSetAngularMotion(shape::fr_shape, x::fr_float, y::fr_float, z::fr_float, w::fr_float)


#=* @brief Set visibility flag
 *
 *  @param  shape       The shape to set linear motion for
 *  @param  visible     Determines if the shape is visible or not
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeSetVisibilityFlag(shape::fr_shape, visible::fr_bool)

#=* @brief Set shadow flag
*
*  @param  shape       The shape to set linear motion for
*  @param  visible     Determines if the shape casts shadow
*  @return             SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int        frShapeSetShadowFlag(shape::fr_shape, casts_shadow::fr_bool)


#=* @brief Set light world transform
 *
 *
 *  @param  light       The light to set transform for
 *  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
 *  @param  transform   Array of 16 values::fr_float (row-major form)
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frLightSetTransform(light::fr_light, transpose::fr_bool, transform::Ptr{fr_float})



#=* @brief Set shader for a shape (every polygon of a mesh if a shape represents mesh::a)
 *
 *
 *  @param  shape   The shape to set shader for
 *  @param  shader  Shader to set
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeSetShader(shape::fr_shape, shader::fr_shader)


#=* @brief Query information about a shape
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  shape           The shape object to query
 *  @param  material_info   The type of info to query
 *  @param  size            The size of the buffer pointed by data
 *  @param  data            The buffer to store queried info
 *  @param  size_ret        Returns the size in bytes of the data being queried
 *  @return                 SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeGetInfo(shape::fr_shape, material::fr_shape_info, s::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Increment reference counter for a shape
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  shape   A shape to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeRetain(shape::fr_shape)

#=* @brief Decrement reference counter for a shape
 *
 *  Object lifetime management function decrementing internal reference counter
 *
 *  @param  shape   A shape to decrement the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frShapeRelease(shape::fr_shape)

#= fr_shape - mesh =#
#=* @brief Query information about a mesh
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  shape       The mesh to query
 *  @param  mesh_info   The type of info to query
 *  @param  size        The size of the buffer pointed by data
 *  @param  data        The buffer to store queried info
 *  @param  size_ret    Returns the size in bytes of the data being queried
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frMeshGetInfo(mesh::fr_shape, mesh_info::fr_mesh_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Query information about a mesh polygon
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  mesh        The mesh to query
 *  @param  polygon_index The index of a polygon
 *  @param  polygon_info The type of info to query
 *  @param  size        The size of the buffer pointed by data
 *  @param  data        The buffer to store queried info
 *  @param  size_ret    Returns the size in bytes of the data being queried
 *  @return             SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frMeshPolygonGetInfo(mesh::fr_shape, polygon_index::Csize_t, polygon_info::fr_mesh_polygon_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Query information about a mesh polygon vertex
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  mesh        The mesh to query
 *  @param  polygon_index The index of a polygon
 *  @param  vertex_index The index of vertex
 *  @param  polygon_vertex_info The type of info to query
 *  @param  size            The size of the buffer pointed by data
 *  @param  data            The buffer to store queried info
 *  @param  size_ret        Returns the size in bytes of the data being queried
 *  @return                 SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frMeshPolygonVertexGetInfo(mesh::fr_shape, polygon_index::Csize_t, vertex_index::Csize_t, polygon_info::fr_mesh_polygon_vertex_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})


#=* @brief Set mesh vertex attribute
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  mesh            The mesh to query
 *  @param  polygon_index   The index of a polygon
 *  @param  vertex_index    The index of vertex
 *  @param  polygon_vertex_info The type of info to set
 *  @param  x               X component of an attribute
 *  @param  y               Y component of an attribute
 *  @param  z               Z component of an attribute
 *  @return SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frMeshPolygonVertexSetAttribute3f(mesh::fr_shape, polygon_index::Csize_t, vertex_index::Csize_t, polygon_vertex_info::fr_mesh_polygon_vertex_info, x::fr_float, y::fr_float, z::fr_float)


#= fr_shape - instance =#
#=* @brief Get the parent shape for an instance
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  shape    The shape to get a parent shape from
 *  @param  status   SUCCESS in case success::of, error code otherwise
 *  @return          Shape object
 =#
@fr_fun fr_shape      frInstanceGetBaseShape(shape::fr_shape, status::Ptr{fr_int})

#= fr_light - point =#
#=* @brief Create point light
 *
 *  Create analytic point light represented by a point in space.
  *  Possible error codes:
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *
 *  @param  context The context to create a light for
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Light object
 =#
@fr_fun fr_light    frContextCreatePointLight(context::fr_context, status::Ptr{fr_int})

#=* @brief Set radiant power of a point light source
 *
 *  @param  r       R component of a radiant power vector
 *  @param  g       G component of a radiant power vector
 *  @param  b       B component of a radiant power vector
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frPointLightSetRadiantPower3f(light::fr_light, r::fr_float, g::fr_float, b::fr_float)

#= fr_light - spot =#
#=* @brief Create spot light
 *
 *  Create analytic spot light
 *
 *  Possible error codes:
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *
 *  @param  context The context to create a light for
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Light object
 =#
@fr_fun fr_light    frContextCreateSpotLight(context::fr_context, status::Ptr{fr_int})

#=* @brief Set radiant power of a spot light source
 *
 *  @param  r R component of a radiant power vector
 *  @param  g G component of a radiant power vector
 *  @param  b B component of a radiant power vector
 *  @return   SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frSpotLightSetRadiantPower3f(light::fr_light, r::fr_float, g::fr_float, b::fr_float)

#=* @brief Set cone shape for a spot light
 *
 * Spot light produces smooth penumbra in a region between inner and circles::outer,
 * the area inside the inner cicrle receives full power while the area outside the
 * outer one is fully in shadow.
 *
 *  @param  iangle Inner angle of a cone in radians
 *  @param  oangle Outer angle of a coner radians::in, should be greater that or equal to inner angle
 *  @return status SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frSpotLightSetConeShape(light::fr_light, iangle::fr_float, oangle::fr_float)

#= fr_light - directional =#
#=* @brief Create directional light
 *
 *  Create analytic directional light.
 *  Possible error codes:
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *
 *  @param  context The context to create a light for
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return light id of a newly created light
 =#
@fr_fun fr_light    frContextCreateDirectionalLight(context::fr_context, status::Ptr{fr_int})

#=* @brief Set radiant power of a directional light source
 *
 *  @param  r R component of a radiant power vector
 *  @param  g G component of a radiant power vector
 *  @param  b B component of a radiant power vector
 *  @return   SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frDirectionalLightSetRadiantPower3f(light::fr_light, r::fr_float, g::fr_float, b::fr_float)

#= fr_light - environment =#
#=* @brief Create an environment light
 *
 *  Environment light is a light based on lightprobe.
 *  Possible error codes:
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *
 *  @param  context The context to create a light for
 *  @param  status  SUCCESS in case success::of, error code otherwise
 *  @return         Light object
 =#
@fr_fun fr_light    frContextCreateEnvironmentLight(context::fr_context, status::Ptr{fr_int})

#=* @brief Set image path for an environment light
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *      ERROR_UNSUPPORTED_IMAGE_FORMAT
 *      ERROR_IO_ERROR
 *
 *  @param  env_light Environment light
 *  @param  full_path Path to an .hdr or .exr file with env image
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frEnvironmentLightSetImagePath(env_light::fr_light, full_path::Ptr{fr_char})

#=* @brief Set image for an environment light
 *
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *      ERROR_UNSUPPORTED_IMAGE_FORMAT
 *
 *  @param  env_light Environment light
 *  @param  image     Image object to set
 *  @return           SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frEnvironmentLightSetImage(env_light::fr_light, image::fr_image)

#=* @brief Set intensity scale or an env light
 *
 *  @param  env_light       Environment light
 *  @param  intensity_scale Intensity scale
 *  @return                 SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int      frEnvironmentLightSetIntensityScale(env_light::fr_light, intensity_scale::fr_float)

#=* @brief Set portal for envronment light to accelerate convergence of indoor scenes
*
*   Possible error codes:
*      ERROR_INVALID_PARAMETER
*
*  @param  env_light Environment light
*  @param  portal    mesh::Portal, might have multiple components
*  @return           SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int      frEnvironmentLightSetPortal(env_light::fr_light, portal::fr_shape)


#= fr_light - sky =#
#=* @brief Create sky light
*
*  Analytical sky model
*  Possible error codes:
*      ERROR_OUT_OF_VIDEO_MEMORY
*      ERROR_OUT_OF_SYSTEM_MEMORY
*
*  @param  context The context to create a light for
*  @param  status  SUCCESS in case success::of, error code otherwise
*  @return         Light object
=#
@fr_fun fr_light    frContextCreateSkyLight(context::fr_context, status::Ptr{fr_int})

#=* @brief Set turbidity of a sky light
*
*  @param  skylight        Sky light
*  @param  turbidity       Turbidity value
*  @return                 SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int      frSkyLightSetTurbidity(skylight::fr_light, turbidity::fr_float)

#=* @brief Set albedo of a sky light
*
*  @param  skylight        Sky light
*  @param  albedo          Albedo value
*  @return                 SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int      frSkyLightSetAlbedo(skylight::fr_light, albedo::fr_float)


#=* @brief Set scale of a sky light
*
*  @param  skylight        Sky light
*  @param  scale           Scale value
*  @return                 SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int      frSkyLightSetScale(skylight::fr_light, scale::fr_float)

#=* @brief Set portal for sky light to accelerate convergence of indoor scenes
*
*   Possible error codes:
*      ERROR_INVALID_PARAMETER
*
*  @param  skylight  Sky light
*  @param  portal    mesh::Portal, might have multiple components
*  @return           SUCCESS in case success::of, error code otherwise
=#
@fr_fun fr_int      frSkyLightSetPortal(skylight::fr_light, portal::fr_shape)

#= fr_light =#
#=* @brief Query information about a light
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  light    The light to query
 *  @param  light_info The type of info to query
 *  @param  size     The size of the buffer pointed by data
 *  @param  data     The buffer to store queried info
 *  @param  size_ret Returns the size in bytes of the data being queried
 *  @return          SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frLightGetInfo(light::fr_light, info::fr_light_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Increment reference counter for a light
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  light   A light to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frLightRetain(light::fr_light)

#=* @brief Decrement reference counter for a light
 *
 *  Object lifetime management function decrementing internal reference counter
 *
 *  @param  light   A light to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frLightRelease(light::fr_light)

#= fr_scene =#

#=* @brief Remove all objects from a scene
 *
 *  A scene is essentially a collection shapes::of, lights and volume regions.
 *
 *  @param  scene   The scene to clear
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneClear(scene::fr_scene)

#=* @brief Attach a shape to the scene
 *
 *  A scene is essentially a collection shapes::of, lights and volume regions.
 *
 *  @param  scene  The scene to attach
 *  @param  shape  The shape to attach
 *  @return        SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneAttachShape(scene::fr_scene, shape::fr_shape)

#=* @brief Detach a shape from the scene
 *
 *  A scene is essentially a collection shapes::of, lights and volume regions.
 *
 *  @param  scene   The scene to dettach from
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneDetachShape(scene::fr_scene, shape::fr_shape)

#=* @brief Attach a light to the scene
 *
 *  A scene is essentially a collection shapes::of, lights and volume regions
 *
 *  @param  scene  The scene to attach
 *  @param  light  The light to attach
 *  @return        SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneAttachLight(scene::fr_scene, light::fr_light)

#=* @brief Detach a light from the scene
 *
 *  A scene is essentially a collection shapes::of, lights and volume regions
 *
 *  @param  scene  The scene to dettach from
 *  @param  light  The light to detach
 *  @return        SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneDetachLight(scene::fr_scene, light::fr_light)

#=* @brief Query information about a scene
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  scene    The scene to query
 *  @param  info     The type of info to query
 *  @param  size     The size of the buffer pointed by data
 *  @param  data     The buffer to store queried info
 *  @param  size_ret Returns the size in bytes of the data being queried
 *  @return          SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneGetInfo(scene::fr_scene, info::fr_scene_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})

#=* @brief Set environment light for the scene
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  scene  The scene to set background for
 *  @param  light  Environment light
 *  @return        SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int       frSceneSetEnvironmentLight(scene::fr_scene, light::fr_light)

#=* @brief Get environment light for the scene
 *
 *  @param  scene  The scene to get background for
 *  @param  status SUCCESS in case success::of, error code otherwise
 *  @return        Environment light object
 =#
@fr_fun fr_light    frSceneGetEnvironmentLight(scene::fr_scene, status::Ptr{fr_int})

#=* @brief Set camera for the scene
 *
 *  This is the main camera which for rays generation for the scene.
 *
 *  @param  scene  The scene to set camera for
 *  @param  camera Camera
 *  @return        SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneSetCamera(scene::fr_scene, camera::fr_camera)

#=* @brief Get camera for the scene
 *
 *  @param  scene  The scene to get camera for
 *  @param  status SUCCESS in case success::of, error code otherwise
 *  @return camera id for the camera any::if, NULL otherwise
 =#
@fr_fun fr_camera     frSceneGetCamera(scene::fr_scene, status::Ptr{fr_int})

#=* @brief Increment reference counter for a scene
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  scene   A scene to increment the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneRetain(scene::fr_scene)

#=* @brief Decrement reference counter for a scene
 *
 *  Object lifetime management function decrementing internal reference counter
 *
 *  @param  scene   A scene to decrement the reference for
 *  @return         SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frSceneRelease(scene::fr_scene)

#= fr_framebuffer=#
#=* @brief Query information about a framebuffer
 *
 *  The workflow is usually two-step: query with the data == NULL to get the required size::buffer,
 *  then query with size_ret == NULL to fill the buffer with the data
 *   Possible error codes:
 *      ERROR_INVALID_PARAMETER
 *
 *  @param  framebuffer  Framebuffer object to query
 *  @param  info         The type of info to query
 *  @param  size         The size of the buffer pointed by data
 *  @param  data         The buffer to store queried info
 *  @param  size_ret     Returns the size in bytes of the data being queried
 *  @return              SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frFrameBufferGetInfo(framebuffer::fr_framebuffer, info::fr_framebuffer_info, size::Csize_t, data::Ptr{Void}, size_ret::Ptr{Csize_t})


#=* @brief Increment reference counter for a framebuffer
 *
 *  Object lifetime management function increasing internal reference counter
 *
 *  @param  framebuffer A scene to increment the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#

@fr_fun fr_int        frFrameBufferRetain(framebuffer::fr_framebuffer)

#=* @brief Decrement reference counter for a framebuffer
 *
 *  Object lifetime management function decrementing internal reference counter
 *
 *  @param  framebuffer A scene to decrement the reference for
 *  @return             SUCCESS in case success::of, error code otherwise
 =#

@fr_fun fr_int        frFrameBufferRelease(framebuffer::fr_framebuffer)

#=* @brief Clear contents of a framebuffer to zero
 *
 *   Possible error codes:
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *
 *  The call is blocking and the image is ready when returned
 *
 *  @param  frame_buffer  Framebuffer to clear
 *  @return              SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int        frFrameBufferClear(frame_buffer::fr_framebuffer)

# TEMPORARY STUFF
#=* @brief Save frame buffer to file
 *
 *   Possible error codes:
 *      ERROR_OUT_OF_SYSTEM_MEMORY
 *      ERROR_OUT_OF_VIDEO_MEMORY
 *
 *  @param  frame_buffer Frame buffer to save
 *  @param  path         Path to file
 *  @return              SUCCESS in case success::of, error code otherwise
 =#
@fr_fun fr_int  frFrameBufferSaveToFile(frame_buffer::fr_framebuffer, file_path::Ptr{fr_char})

@fr_fun fr_int frContextResolveFrameBuffer(context::fr_context, src_frame_buffer::fr_framebuffer, dst_frame_buffer::fr_framebuffer)


using GeometryTypes, Colors, FixedSizeArrays
import GLAbstraction: Texture, translationmatrix, scalematrix, rotationmatrix, lookat
import ModernGL: GL_TEXTURE_2D

import Base: push!, delete!, get
export set!, 
	instance, 
	setradiantpower!, 
	setradiantpower!, 
	setimagepath!, 
	setimage!, 
	setintensityscale!, 
	setportal!, 
	setalbedo!, 
	setturbidity!, 
	setscale!,
	getbase,
	clear!,
	transform!

macro fr_wrapper_type(name, typ, target, args, super)
	argnames = map(args.args) do x
		isa(x, Symbol) ? x : x.args[1]
	end
	esc(quote
		type $name <: $super
			x::$typ
			$name(x::$typ) = new(x)
			function $name($(argnames...))
				x = new()
				x.x = $target($(args.args...))
				finalizer(x, release)
				x
			end
		end
	end)
end

@fr_wrapper_type Shader fr_shader frContextCreateShader (context.x, typ) Any
@fr_wrapper_type Camera fr_camera frContextCreateCamera (context.x,) Any
@fr_wrapper_type Scene fr_scene frContextCreateScene (context.x,) Any
@fr_wrapper_type Context fr_context frCreateContext (api, accelerator, devices, props, cache_path) Any

Context(api, accelerator, devices) = 
	Context(api, accelerator, devices, C_NULL, C_NULL)

abstract Light
@fr_wrapper_type EnvironmentLight fr_light frContextCreateEnvironmentLight (context.x,) Light
@fr_wrapper_type PointLight fr_light frContextCreatePointLight (context.x,) Light
@fr_wrapper_type DirectionalLight fr_light frContextCreateDirectionalLight (context.x,) Light
@fr_wrapper_type SkyLight fr_light frContextCreateSkyLight (context.x,) Light


type Shape
	x::fr_shape
	function Shape(x::fr_shape)
		inst = new(x)
		finalizer(inst, release)
		inst
	end
end

function Shape(context::Context, mesh::GeometryPrimitive)
	m = GLNormalUVMesh(mesh)
	v, n, i, uv = vertices(m), normals(m), faces(m), texturecoordinates(m)
	vraw  = reinterpret(Float32, v, (length(v)*3,))
	nraw  = reinterpret(Float32, n, (length(n)*3,))
	uvraw = reinterpret(Float32, uv, (length(uv)*2,))
	iraw  = reinterpret(eltype(eltype(i)), i, (length(i)*3,))
	iraw  = map(fr_int, iraw)
	m = frContextCreateMesh(context.x,
		vraw, length(v), sizeof(Vec3f0),
		nraw, length(n), sizeof(Vec3f0),
		uvraw,length(uv),sizeof(Vec2f0),
		iraw, sizeof(fr_int),
		iraw, sizeof(fr_int),
		iraw, sizeof(fr_int),
		fill(fr_int(3), length(i)), length(i)
	)
	Shape(m)
end
Shape(context::Context, shape::Shape) =
	Shape(frContextCreateInstance(context.x, shape.x))
getbase(shape::Shape) =
	Shape(frInstanceGetBaseShape(shape.x))

# Create layered shader give two shaders and respective IORs
function create_layered_shader(context, base, top, baseior, topior)
    # Create a shader
    layered = Shader(context, SHADER_LAYERED)
    # Set shader for base layer
    set!(layered, "base", base)
    # Set shader for top layer
    set!(layered, "top", top)
    # Set index of refraction for top layer
    set!(layered, "topior", topior)
    return layered
end


type FrameBuffer 
	x::fr_framebuffer
end
function FrameBuffer{T}(context::Context, t::Texture{T, 2})
	frame_buffer = frContextCreateFramebufferFromGLTexture2D(context.x, GL_TEXTURE_2D, 0, t.id)
	x = FrameBuffer(frame_buffer)
	# Set framebuffer
	set!(context, x)
	finalizer(x, release)
	x
end
function FrameBuffer(context::Context, c::Colorant, dims::NTuple{2, Int})
	desc = Ref(fr_framebuffer_desc(dims...))
	fmt = fr_image_format(length(c), COMPONENT_TYPE_FLOAT32)
	frame_buffer = frContextCreateFrameBuffer(context.x, fmt, desc)
	x = FrameBuffer(frame_buffer)
	# Set framebuffer
	set!(context, x)
	finalizer(x, release)
	x
end


type Image 
	x::fr_image
end

fr_image_format{T<:Colorant}(::Type{T}) = fr_image_format(
	length(T),
	eltype(T)
)
fr_image_desc{T,N}(image::Array{T, N}) = Ref(fr_image_desc(
    ntuple(i->N<i? 0 : size(image, i), 3)...,
    0,0
))

function Image{T<:RGBA, N}(context::Context, image::Array{T, N})
	desc = Ref(fr_framebuffer_desc(dims...))
	img  = frContextCreateImage(
		context.x, fr_image_format(image), 
		fr_image_desc(image), image
	)
	x = Image(img)
	finalizer(x, release)
	x
end


setradiantpower!{T}(ligt::DirectionalLight, rgb::Colorant{T, 3}) = 
	setradiantpower!(light, RGB{Float32}(rgb)...)
setradiantpower!(ligt::DirectionalLight, r, g, b) =
	frDirectionalLightSetRadiantPower3f(light.x, fr_float(r), fr_float(g), fr_float(b))
setimagepath!(light::EnvironmentLight, full_path::AbstractString) =
	frEnvironmentLightSetImagePath(light.x, ascii(full_path))
setimage!{C <: Colorant}(light::EnvironmentLight, image::Matrix{C}) =
	frEnvironmentLightSetImagePath(light.x, image)
setintensityscale!(light::EnvironmentLight, intensity_scale::AbstractFloat) =
	frEnvironmentLightSetIntensityScale(light.x, fr_float(intensity_scale))
setportal!(light::EnvironmentLight, portal::Shape) =
	frEnvironmentLightSetPortal(light.x, portal.x)

setalbedo!(skylight::SkyLight, albedo::AbstractFloat) =
	frSkyLightSetAlbedo(skylight.x, fr_float(albedo))

setturbidity!(skylight::SkyLight, turbidity::AbstractFloat) =
	frSkyLightSetTurbidity(skylight.x, fr_float(turbidity.x))

setscale!(skylight::SkyLight, scale::AbstractFloat) =
	frSkyLightSetScale(skylight.x, fr_float(scale))

setportal!(light::SkyLight, portal::Shape) =
	frSkyLightSetPortal(light.x, portal.x)



release(x::Shape) 		= frShapeRelease(x.x)
release(x::Shader) 		= frShaderRelease(x.x)
release(x::Scene) 		= frSceneRelease(x.x)
release(x::Camera) 		= frCameraRelease(x.x)
release(x::FrameBuffer) = frFrameBufferRelease(x.x)
release(x::Context) 	= frContextRelease(x.x)
release(x::Light) 		= frLightRelease(x.x)


set!(shape::Shape, shader::Shader) =
	frShapeSetShader(shape.x, shader.x)

set!(shader::Shader, parameter::AbstractString, image::Image) =
	frShaderSetParameterImage(shader.x, ascii(parameter), image.x)


set!(context::Context, framebuffer::FrameBuffer) =
	frContextSetFrameBuffer(context.x, framebuffer.x)
set!(base::Shader, parameter::ASCIIString, shader::Shader) =
	frShaderSetParameterShader(base.x, parameter, shader.x)
set!(base::Shader, parameter::ASCIIString, f::AbstractFloat) =
	frShaderSetParameter1f(base.x, parameter, fr_float(f))
set!(base::Shader, parameter::ASCIIString, a::AbstractFloat, b::AbstractFloat, c::AbstractFloat, d::AbstractFloat) =
	frShaderSetParameter4f(base.x, parameter, fr_float(a), fr_float(b), fr_float(c), fr_float(d))
set!{T<:FixedVector{4}}(base::Shader, parameter::ASCIIString, f::T) =
	set!(base.x, parameter, f...)
function set!{T}(base::Shader, parameter::ASCIIString, c::Colorant{T, 4})
	c = RGBA{Float32}(c)
	set!(base, parameter, comp1(c), comp2(c), comp3(c), alpha(c))
end
set!(context::Context, scene::Scene) =
	frContextSetScene(context.x, scene.x)
set!(scene::Scene, camera::Camera) =
	frContextSetScene(scene.x, camera.x)

transform!(shape::Shape, transform::Mat4f0) =
	frShapeSetTransform(shape.x, FALSE, convert(Array, transform))


clear!(scene::Scene) = frSceneClear(scene.x)
clear!(frame_buffer::FrameBuffer) = frFrameBufferClear(frame_buffer.x)

push!(scene::Scene, shape::Shape) =
	frSceneAttachShape(scene.x, shape.x)
delete!(scene::Scene, shape::Shape) =
	frSceneDetachShape(scene.x, shape.x)

push!(scene::Scene, light::Light) =
	frSceneAttachLight(scene.x, light.x)
delete!(scene::Scene, light::Light) =
	frSceneDetachLight(scene.x, light.x)


set!(scene::Scene, light::EnvironmentLight) =
	frSceneSetEnvironmentLight(scene.x, light.x)

get(scene::Scene, ::Type{EnvironmentLight}) =
	EnvironmentLight(frSceneGetEnvironmentLight(scene::fr_scene))

set!(scene::Scene, camera::Camera) =
	frSceneSetCamera(scene.x, camera.x)
get!(scene::Scene, ::Type{Camera}) =
	Camera(frSceneGetCamera(scene.x))

lookat(camera::Camera, position::Vec3, lookatvec::Vec3, upvec::Vec3) = frCameraLookAt(camera.x, 
	Vec3f0(position)..., 
	Vec3f0(lookatvec)..., 
	Vec3f0(upvec)...
)



end # module

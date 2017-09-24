cd(homedir()*"/3dstuff/RadeonProRender-Baikal/Bin/Debug/x64/")
const firelib = homedir()*"/3dstuff/RadeonProRender-Baikal/Bin/Debug/x64/libRpr64D.so"

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

const API_VERSION = 0x010000252

# rpr_status
const SUCCESS = 0
const ERROR_COMPUTE_API_NOT_SUPPORTED = -1
const ERROR_OUT_OF_SYSTEM_MEMORY = -2
const ERROR_OUT_OF_VIDEO_MEMORY = -3
const ERROR_INVALID_LIGHTPATH_EXPR = -5
const ERROR_INVALID_IMAGE = -6
const ERROR_INVALID_AA_METHOD = -7
const ERROR_UNSUPPORTED_IMAGE_FORMAT = -8
const ERROR_INVALID_GL_TEXTURE = -9
const ERROR_INVALID_CL_IMAGE = -10
const ERROR_INVALID_OBJECT = -11
const ERROR_INVALID_PARAMETER = -12
const ERROR_INVALID_TAG = -13
const ERROR_INVALID_LIGHT = -14
const ERROR_INVALID_CONTEXT = -15
const ERROR_UNIMPLEMENTED = -16
const ERROR_INVALID_API_VERSION = -17
const ERROR_INTERNAL_ERROR = -18
const ERROR_IO_ERROR = -19
const ERROR_UNSUPPORTED_SHADER_PARAMETER_TYPE = -20
const ERROR_MATERIAL_STACK_OVERFLOW = -21
const ERROR_INVALID_PARAMETER_TYPE = -22
const ERROR_UNSUPPORTED = -23
const ERROR_OPENCL_OUT_OF_HOST_MEMORY = -24

# rpr_parameter_type
const PARAMETER_TYPE_FLOAT = 0x1
const PARAMETER_TYPE_FLOAT2 = 0x2
const PARAMETER_TYPE_FLOAT3 = 0x3
const PARAMETER_TYPE_FLOAT4 = 0x4
const PARAMETER_TYPE_IMAGE = 0x5
const PARAMETER_TYPE_STRING = 0x6
const PARAMETER_TYPE_SHADER = 0x7
const PARAMETER_TYPE_UINT = 0x8

# rpr_image_type
const IMAGE_TYPE_1D = 0x1
const IMAGE_TYPE_2D = 0x2
const IMAGE_TYPE_3D = 0x3

# rpr_context_type
const CONTEXT_OPENCL = (1 << 0)
const CONTEXT_DIRECTCOMPUTE = (1 << 1)
const CONTEXT_REFERENCE = (1 << 2)
const CONTEXT_OPENGL = (1 << 3)
const CONTEXT_METAL = (1 << 4)

# rpr_creation_flags
const CREATION_FLAGS_ENABLE_GPU0 = (1 << 0)
const CREATION_FLAGS_ENABLE_GPU1 = (1 << 1)
const CREATION_FLAGS_ENABLE_GPU2 = (1 << 2)
const CREATION_FLAGS_ENABLE_GPU3 = (1 << 3)
const CREATION_FLAGS_ENABLE_CPU = (1 << 4)
const CREATION_FLAGS_ENABLE_GL_INTEROP = (1 << 5)
const CREATION_FLAGS_ENABLE_GPU4 = (1 << 6)
const CREATION_FLAGS_ENABLE_GPU5 = (1 << 7)
const CREATION_FLAGS_ENABLE_GPU6 = (1 << 8)
const CREATION_FLAGS_ENABLE_GPU7 = (1 << 9)

# rpr_aa_filter
const FILTER_BOX = 0x1
const FILTER_TRIANGLE = 0x2
const FILTER_GAUSSIAN = 0x3
const FILTER_MITCHELL = 0x4
const FILTER_LANCZOS = 0x5
const FILTER_BLACKMANHARRIS = 0x6

# rpr_shape_type
const SHAPE_TYPE_MESH = 0x1
const SHAPE_TYPE_INSTANCE = 0x2

# rpr_light_type
const LIGHT_TYPE_POINT = 0x1
const LIGHT_TYPE_DIRECTIONAL = 0x2
const LIGHT_TYPE_SPOT = 0x3
const LIGHT_TYPE_ENVIRONMENT = 0x4
const LIGHT_TYPE_SKY = 0x5
const LIGHT_TYPE_IES = 0x6

# rpr_object_info
const OBJECT_NAME = 0x777777

# rpr_context_info
const CONTEXT_CREATION_FLAGS = 0x102
const CONTEXT_CACHE_PATH = 0x103
const CONTEXT_RENDER_STATUS = 0x104
const CONTEXT_RENDER_STATISTICS = 0x105
const CONTEXT_DEVICE_COUNT = 0x106
const CONTEXT_PARAMETER_COUNT = 0x107
const CONTEXT_ACTIVE_PLUGIN = 0x108
const CONTEXT_SCENE = 0x109
const CONTEXT_AA_CELL_SIZE = 0x10A
const CONTEXT_AA_SAMPLES = 0x10B
const CONTEXT_IMAGE_FILTER_TYPE = 0x10C
const CONTEXT_IMAGE_FILTER_BOX_RADIUS = 0x10D
const CONTEXT_IMAGE_FILTER_GAUSSIAN_RADIUS = 0x10E
const CONTEXT_IMAGE_FILTER_TRIANGLE_RADIUS = 0x10F
const CONTEXT_IMAGE_FILTER_MITCHELL_RADIUS = 0x110
const CONTEXT_IMAGE_FILTER_LANCZOS_RADIUS = 0x111
const CONTEXT_IMAGE_FILTER_BLACKMANHARRIS_RADIUS = 0x112
const CONTEXT_TONE_MAPPING_TYPE = 0x113
const CONTEXT_TONE_MAPPING_LINEAR_SCALE = 0x114
const CONTEXT_TONE_MAPPING_PHOTO_LINEAR_SENSITIVITY = 0x115
const CONTEXT_TONE_MAPPING_PHOTO_LINEAR_EXPOSURE = 0x116
const CONTEXT_TONE_MAPPING_PHOTO_LINEAR_FSTOP = 0x117
const CONTEXT_TONE_MAPPING_REINHARD02_PRE_SCALE = 0x118
const CONTEXT_TONE_MAPPING_REINHARD02_POST_SCALE = 0x119
const CONTEXT_TONE_MAPPING_REINHARD02_BURN = 0x11A
const CONTEXT_MAX_RECURSION = 0x11B
const CONTEXT_RAY_CAST_EPISLON = 0x11C
const CONTEXT_RADIANCE_CLAMP = 0x11D
const CONTEXT_X_FLIP = 0x11E
const CONTEXT_Y_FLIP = 0x11F
const CONTEXT_TEXTURE_GAMMA = 0x120
const CONTEXT_PDF_THRESHOLD = 0x121
const CONTEXT_RENDER_MODE = 0x122
const CONTEXT_ROUGHNESS_CAP = 0x123
const CONTEXT_DISPLAY_GAMMA = 0x124
const CONTEXT_MATERIAL_STACK_SIZE = 0x125
const CONTEXT_CLIPPING_PLANE = 0x126
const CONTEXT_GPU0_NAME = 0x127
const CONTEXT_GPU1_NAME = 0x128
const CONTEXT_GPU2_NAME = 0x129
const CONTEXT_GPU3_NAME = 0x12A
const CONTEXT_CPU_NAME = 0x12B
const CONTEXT_GPU4_NAME = 0x12C
const CONTEXT_GPU5_NAME = 0x12D
const CONTEXT_GPU6_NAME = 0x12E
const CONTEXT_GPU7_NAME = 0x12F
const CONTEXT_TONE_MAPPING_EXPONENTIAL_INTENSITY = 0x130
const CONTEXT_FRAMECOUNT = 0x131

# last of the RPR_CONTEXT_*
const CONTEXT_MAX = 0x132

# rpr_camera_info
const CAMERA_TRANSFORM = 0x201
const CAMERA_FSTOP = 0x202
const CAMERA_APERTURE_BLADES = 0x203
const CAMERA_RESPONSE = 0x204
const CAMERA_EXPOSURE = 0x205
const CAMERA_FOCAL_LENGTH = 0x206
const CAMERA_SENSOR_SIZE = 0x207
const CAMERA_MODE = 0x208
const CAMERA_ORTHO_WIDTH = 0x209
const CAMERA_ORTHO_HEIGHT = 0x20A
const CAMERA_FOCUS_DISTANCE = 0x20B
const CAMERA_POSITION = 0x20C
const CAMERA_LOOKAT = 0x20D
const CAMERA_UP = 0x20E
const CAMERA_FOCAL_TILT = 0x20F
const CAMERA_LENS_SHIFT = 0x210
const CAMERA_IPD = 0x211

# rpr_image_info
const IMAGE_FORMAT = 0x301
const IMAGE_DESC = 0x302
const IMAGE_DATA = 0x303
const IMAGE_DATA_SIZEBYTE = 0x304
const IMAGE_WRAP = 0x305

# rpr_shape_info
const SHAPE_TYPE = 0x401
const SHAPE_VIDMEM_USAGE = 0x402
const SHAPE_TRANSFORM = 0x403
const SHAPE_MATERIAL = 0x404
const SHAPE_LINEAR_MOTION = 0x405
const SHAPE_ANGULAR_MOTION = 0x406
const SHAPE_VISIBILITY_FLAG = 0x407
const SHAPE_SHADOW_FLAG = 0x408
const SHAPE_SUBDIVISION_FACTOR = 0x409
const SHAPE_DISPLACEMENT_SCALE = 0x40A
const SHAPE_DISPLACEMENT_IMAGE = 0x40B
const SHAPE_VISIBILITY_PRIMARY_ONLY_FLAG = 0x40C
const SHAPE_VISIBILITY_IN_SPECULAR_FLAG = 0x40D
const SHAPE_SHADOW_CATCHER_FLAG = 0x40E
const SHAPE_VOLUME_MATERIAL = 0x40F
const SHAPE_OBJECT_GROUP_ID = 0x410
const SHAPE_SUBDIVISION_CREASEWEIGHT = 0x411
const SHAPE_SUBDIVISION_BOUNDARYINTEROP = 0x412
const SHAPE_MATERIAL_OVERRIDE = 0x413

# rpr_mesh_info
const MESH_POLYGON_COUNT = 0x501
const MESH_VERTEX_COUNT = 0x502
const MESH_NORMAL_COUNT = 0x503
const MESH_UV_COUNT = 0x504
const MESH_VERTEX_ARRAY = 0x505
const MESH_NORMAL_ARRAY = 0x506
const MESH_UV_ARRAY = 0x507
const MESH_VERTEX_INDEX_ARRAY = 0x508
const MESH_NORMAL_INDEX_ARRAY = 0x509
const MESH_UV_INDEX_ARRAY = 0x50A
const MESH_VERTEX_STRIDE = 0x50C
const MESH_NORMAL_STRIDE = 0x50D
const MESH_UV_STRIDE = 0x50E
const MESH_VERTEX_INDEX_STRIDE = 0x50F
const MESH_NORMAL_INDEX_STRIDE = 0x510
const MESH_UV_INDEX_STRIDE = 0x511
const MESH_NUM_FACE_VERTICES_ARRAY = 0x512
const MESH_UV2_COUNT = 0x513
const MESH_UV2_ARRAY = 0x514
const MESH_UV2_INDEX_ARRAY = 0x515
const MESH_UV2_STRIDE = 0x516
const MESH_UV2_INDEX_STRIDE = 0x517

# rpr_scene_info
const SCENE_SHAPE_COUNT = 0x701
const SCENE_LIGHT_COUNT = 0x702
const SCENE_SHAPE_LIST = 0x704
const SCENE_LIGHT_LIST = 0x705
const SCENE_CAMERA = 0x706
const SCENE_BACKGROUND_IMAGE = 0x708
const SCENE_ENVIRONMENT_OVERRIDE_REFLECTION = 0x709
const SCENE_ENVIRONMENT_OVERRIDE_REFRACTION = 0x70A
const SCENE_ENVIRONMENT_OVERRIDE_TRANSPARENCY = 0x70B
const SCENE_ENVIRONMENT_OVERRIDE_BACKGROUND = 0x70C
const SCENE_AXIS_ALIGNED_BOUNDING_BOX = 0x70D

# rpr_light_info
const LIGHT_TYPE = 0x801
const LIGHT_TRANSFORM = 0x803

# rpr_light_info - point light
const POINT_LIGHT_RADIANT_POWER = 0x804

# rpr_light_info - directional light
const DIRECTIONAL_LIGHT_RADIANT_POWER = 0x808
const DIRECTIONAL_LIGHT_SHADOW_SOFTNESS = 0x809

# rpr_light_info - spot light
const SPOT_LIGHT_RADIANT_POWER = 0x80B
const SPOT_LIGHT_CONE_SHAPE = 0x80C

# rpr_light_info - environment light
const ENVIRONMENT_LIGHT_IMAGE = 0x80F
const ENVIRONMENT_LIGHT_INTENSITY_SCALE = 0x810
const ENVIRONMENT_LIGHT_PORTAL_LIST = 0x818
const ENVIRONMENT_LIGHT_PORTAL_COUNT = 0x819

# rpr_light_info - sky light
const SKY_LIGHT_TURBIDITY = 0x812
const SKY_LIGHT_ALBEDO = 0x813
const SKY_LIGHT_SCALE = 0x814
const SKY_LIGHT_PORTAL_LIST = 0x820
const SKY_LIGHT_PORTAL_COUNT = 0x821

# rpr_light_info - IES light
const IES_LIGHT_RADIANT_POWER = 0x816
const IES_LIGHT_IMAGE_DESC = 0x817

# rpr_parameter_info
const PARAMETER_NAME = 0x1201
const PARAMETER_NAME_STRING = 0x1202
const PARAMETER_TYPE = 0x1203
const PARAMETER_DESCRIPTION = 0x1204
const PARAMETER_VALUE = 0x1205

# rpr_framebuffer_info
const FRAMEBUFFER_FORMAT = 0x1301
const FRAMEBUFFER_DESC = 0x1302
const FRAMEBUFFER_DATA = 0x1303
const FRAMEBUFFER_GL_TARGET = 0x1304
const FRAMEBUFFER_GL_MIPLEVEL = 0x1305
const FRAMEBUFFER_GL_TEXTURE = 0x1306

# rpr_mesh_polygon_info
const MESH_POLYGON_VERTEX_COUNT = 0x1401

# rpr_mesh_polygon_vertex_info
const MESH_POLYGON_VERTEX_POSITION = 0x1501
const MESH_POLYGON_VERTEX_NORMAL = 0x1502
const MESH_POLYGON_VERTEX_TEXCOORD = 0x1503

# rpr_instance_info
const INSTANCE_PARENT_SHAPE = 0x1601

# rpr_image_format
# rpr_component_type
const COMPONENT_TYPE_UINT8 = 0x1
const COMPONENT_TYPE_FLOAT16 = 0x2
const COMPONENT_TYPE_FLOAT32 = 0x3

# rpr_render_mode
const RENDER_MODE_GLOBAL_ILLUMINATION = 0x1
const RENDER_MODE_DIRECT_ILLUMINATION = 0x2
const RENDER_MODE_DIRECT_ILLUMINATION_NO_SHADOW = 0x3
const RENDER_MODE_WIREFRAME = 0x4
const RENDER_MODE_MATERIAL_INDEX = 0x5
const RENDER_MODE_POSITION = 0x6
const RENDER_MODE_NORMAL = 0x7
const RENDER_MODE_TEXCOORD = 0x8
const RENDER_MODE_AMBIENT_OCCLUSION = 0x9

# rpr_camera_mode
const CAMERA_MODE_PERSPECTIVE = 0x1
const CAMERA_MODE_ORTHOGRAPHIC = 0x2
const CAMERA_MODE_LATITUDE_LONGITUDE_360 = 0x3
const CAMERA_MODE_LATITUDE_LONGITUDE_STEREO = 0x4
const CAMERA_MODE_CUBEMAP = 0x5
const CAMERA_MODE_CUBEMAP_STEREO = 0x6

# rpr_tonemapping_operator
const TONEMAPPING_OPERATOR_NONE = 0x0
const TONEMAPPING_OPERATOR_LINEAR = 0x1
const TONEMAPPING_OPERATOR_PHOTOLINEAR = 0x2
const TONEMAPPING_OPERATOR_AUTOLINEAR = 0x3
const TONEMAPPING_OPERATOR_MAXWHITE = 0x4
const TONEMAPPING_OPERATOR_REINHARD02 = 0x5
const TONEMAPPING_OPERATOR_EXPONENTIAL = 0x6

# rpr_volume_type
const VOLUME_TYPE_NONE = 0xFFFF
const VOLUME_TYPE_HOMOGENEOUS = 0x0
const VOLUME_TYPE_HETEROGENEOUS = 0x1

# rpr_material_node_info
const MATERIAL_NODE_TYPE = 0x1101
const MATERIAL_NODE_SYSTEM = 0x1102
const MATERIAL_NODE_INPUT_COUNT = 0x1103

# rpr_material_node_input_info
const MATERIAL_NODE_INPUT_NAME = 0x1103
const MATERIAL_NODE_INPUT_NAME_STRING = 0x1104
const MATERIAL_NODE_INPUT_DESCRIPTION = 0x1105
const MATERIAL_NODE_INPUT_VALUE = 0x1106
const MATERIAL_NODE_INPUT_TYPE = 0x1107

# rpr_material_node_type
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
const MATERIAL_NODE_FRESNEL_SCHLICK = 0x19
const MATERIAL_NODE_DIFFUSE_REFRACTION = 0x1B
const MATERIAL_NODE_BUMP_MAP = 0x1C
const MATERIAL_NODE_VOLUME = 0x1D

# rpr_material_node_input
const MATERIAL_INPUT_COLOR = 0x0
const MATERIAL_INPUT_COLOR0 = 0x1
const MATERIAL_INPUT_COLOR1 = 0x2
const MATERIAL_INPUT_NORMAL = 0x3
const MATERIAL_INPUT_UV = 0x4
const MATERIAL_INPUT_DATA = 0x5
const MATERIAL_INPUT_ROUGHNESS = 0x6
const MATERIAL_INPUT_IOR = 0x7
const MATERIAL_INPUT_ROUGHNESS_X = 0x8
const MATERIAL_INPUT_ROUGHNESS_Y = 0x9
const MATERIAL_INPUT_ROTATION = 0xA
const MATERIAL_INPUT_WEIGHT = 0xB
const MATERIAL_INPUT_OP = 0xC
const MATERIAL_INPUT_INVEC = 0xD
const MATERIAL_INPUT_UV_SCALE = 0xE
const MATERIAL_INPUT_VALUE = 0xF
const MATERIAL_INPUT_REFLECTANCE = 0x10
const MATERIAL_INPUT_SCALE = 0x11
const MATERIAL_INPUT_SCATTERING = 0x12
const MATERIAL_INPUT_ABSORBTION = 0x13
const MATERIAL_INPUT_EMISSION = 0x14
const MATERIAL_INPUT_G = 0x15
const MATERIAL_INPUT_MULTISCATTER = 0x16
const MATERIAL_INPUT_COLOR2 = 0x17
const MATERIAL_INPUT_COLOR3 = 0x18
const MATERIAL_INPUT_MAX = 0x19

const MATERIAL_STANDARD_INPUT_DIFFUSE_COLOR = 0x112
const MATERIAL_STANDARD_INPUT_DIFFUSE_NORMAL = 0x113
const MATERIAL_STANDARD_INPUT_GLOSSY_COLOR = 0x114
const MATERIAL_STANDARD_INPUT_GLOSSY_NORMAL = 0x115
const MATERIAL_STANDARD_INPUT_GLOSSY_ROUGHNESS_X = 0x116
const MATERIAL_STANDARD_INPUT_CLEARCOAT_COLOR = 0x117
const MATERIAL_STANDARD_INPUT_CLEARCOAT_NORMAL = 0x118
const MATERIAL_STANDARD_INPUT_REFRACTION_COLOR = 0x119
const MATERIAL_STANDARD_INPUT_REFRACTION_NORMAL = 0x11A
const MATERIAL_STANDARD_INPUT_REFRACTION_IOR = 0x11C
const MATERIAL_STANDARD_INPUT_DIFFUSE_TO_REFRACTION_WEIGHT = 0x11D
const MATERIAL_STANDARD_INPUT_GLOSSY_TO_DIFFUSE_WEIGHT = 0x11E
const MATERIAL_STANDARD_INPUT_CLEARCOAT_TO_GLOSSY_WEIGHT = 0x11F
const MATERIAL_STANDARD_INPUT_TRANSPARENCY = 0x120
const MATERIAL_STANDARD_INPUT_TRANSPARENCY_COLOR = 0x121
const MATERIAL_STANDARD_INPUT_REFRACTION_ROUGHNESS = 0x122
const MATERIAL_STANDARD_INPUT_GLOSSY_ROUGHNESS_Y = 0x123
const MATERIAL_INPUT_RASTER_METALLIC = 0x901
const MATERIAL_INPUT_RASTER_ROUGHNESS = 0x902
const MATERIAL_INPUT_RASTER_SUBSURFACE = 0x903
const MATERIAL_INPUT_RASTER_ANISOTROPIC = 0x904
const MATERIAL_INPUT_RASTER_SPECULAR = 0x905
const MATERIAL_INPUT_RASTER_SPECULARTINT = 0x906
const MATERIAL_INPUT_RASTER_SHEEN = 0x907
const MATERIAL_INPUT_RASTER_SHEENTINT = 0x908
const MATERIAL_INPUT_RASTER_CLEARCOAT = 0x90A
const MATERIAL_INPUT_RASTER_CLEARCOATGLOSS = 0x90B
const MATERIAL_INPUT_RASTER_COLOR = 0x90C
const MATERIAL_INPUT_RASTER_NORMAL = 0x90D

# rpr_material_node_arithmetic_operation
const MATERIAL_NODE_OP_ADD = 0x00
const MATERIAL_NODE_OP_SUB = 0x01
const MATERIAL_NODE_OP_MUL = 0x02
const MATERIAL_NODE_OP_DIV = 0x03
const MATERIAL_NODE_OP_SIN = 0x04
const MATERIAL_NODE_OP_COS = 0x05
const MATERIAL_NODE_OP_TAN = 0x06
const MATERIAL_NODE_OP_SELECT_X = 0x07
const MATERIAL_NODE_OP_SELECT_Y = 0x08
const MATERIAL_NODE_OP_SELECT_Z = 0x09
const MATERIAL_NODE_OP_SELECT_W = 0x0A
const MATERIAL_NODE_OP_COMBINE = 0x0B
const MATERIAL_NODE_OP_DOT3 = 0x0C
const MATERIAL_NODE_OP_DOT4 = 0x0D
const MATERIAL_NODE_OP_CROSS3 = 0x0E
const MATERIAL_NODE_OP_LENGTH3 = 0x0F
const MATERIAL_NODE_OP_NORMALIZE3 = 0x10
const MATERIAL_NODE_OP_POW = 0x11
const MATERIAL_NODE_OP_ACOS = 0x12
const MATERIAL_NODE_OP_ASIN = 0x13
const MATERIAL_NODE_OP_ATAN = 0x14
const MATERIAL_NODE_OP_AVERAGE_XYZ = 0x15
const MATERIAL_NODE_OP_AVERAGE = 0x16
const MATERIAL_NODE_OP_MIN = 0x17
const MATERIAL_NODE_OP_MAX = 0x18
const MATERIAL_NODE_OP_FLOOR = 0x19
const MATERIAL_NODE_OP_MOD = 0x1A
const MATERIAL_NODE_OP_ABS = 0x1B
const MATERIAL_NODE_OP_SHUFFLE_YZWX = 0x1C
const MATERIAL_NODE_OP_SHUFFLE_ZWXY = 0x1D
const MATERIAL_NODE_OP_SHUFFLE_WXYZ = 0x1E
const MATERIAL_NODE_OP_MAT_MUL = 0x1F

# rpr_material_node_lookup_value
const MATERIAL_NODE_LOOKUP_UV = 0x0
const MATERIAL_NODE_LOOKUP_N = 0x1
const MATERIAL_NODE_LOOKUP_P = 0x2
const MATERIAL_NODE_LOOKUP_INVEC = 0x3
const MATERIAL_NODE_LOOKUP_OUTVEC = 0x4
const MATERIAL_NODE_LOOKUP_UV1 = 0x5

# rpr_post_effect_info
const POST_EFFECT_TYPE = 0x0
const POST_EFFECT_PARAMETER_COUNT = 0x1

# rpr_post_effect_type - white balance
const POST_EFFECT_WHITE_BALANCE_COLOR_SPACE = 0x1
const POST_EFFECT_WHITE_BALANCE_COLOR_TEMPERATURE = 0x2

# rpr_post_effect_type - simple tonemap
const POST_EFFECT_SIMPLE_TONEMAP_EXPOSURE = 0x1
const POST_EFFECT_SIMPLE_TONEMAP_CONTRAST = 0x2

#rpr_aov
const AOV_COLOR = 0x0
const AOV_OPACITY = 0x1
const AOV_WORLD_COORDINATE = 0x2
const AOV_UV = 0x3
const AOV_MATERIAL_IDX = 0x4
const AOV_GEOMETRIC_NORMAL = 0x5
const AOV_SHADING_NORMAL = 0x6
const AOV_DEPTH = 0x7
const AOV_OBJECT_ID = 0x8
const AOV_OBJECT_GROUP_ID = 0x9
const AOV_MAX = 0xa

#rpr_post_effect_type
const POST_EFFECT_TONE_MAP = 0x0
const POST_EFFECT_WHITE_BALANCE = 0x1
const POST_EFFECT_SIMPLE_TONEMAP = 0x2
const POST_EFFECT_NORMALIZATION = 0x3
const POST_EFFECT_GAMMA_CORRECTION = 0x4

#rpr_color_space
const COLOR_SPACE_SRGB = 0x1
const COLOR_SPACE_ADOBE_RGB = 0x2
const COLOR_SPACE_REC2020 = 0x3
const COLOR_SPACE_DCIP3 = 0x4

# rpr_material_node_type
const MATERIAL_NODE_INPUT_TYPE_FLOAT4 = 0x1
const MATERIAL_NODE_INPUT_TYPE_UINT = 0x2
const MATERIAL_NODE_INPUT_TYPE_NODE = 0x3
const MATERIAL_NODE_INPUT_TYPE_IMAGE = 0x4

# Additional Raster context properties ("raster.shadows.filter")
const RASTER_SHADOWS_FILTER_NONE = 0x90E
const RASTER_SHADOWS_FILTER_PCF = 0x90F
const RASTER_SHADOWS_FILTER_PCSS = 0x910

# Additional Raster context properties ("raster.shadows.sampling")
const RASTER_SHADOWS_SAMPLING_BILINEAR = 0x911
const RASTER_SHADOWS_SAMPLING_HAMMERSLEY = 0x912
const RASTER_SHADOWS_SAMPLING_MULTIJITTERED = 0x913

# rpr_subdiv_boundary_interfop_type
const SUBDIV_BOUNDARY_INTERFOP_TYPE_EDGE_AND_CORNER = 0x1
const SUBDIV_BOUNDARY_INTERFOP_TYPE_EDGE_ONLY = 0x2

# rpr_image_wrap_type
const IMAGE_WRAP_TYPE_REPEAT = 0x1
const IMAGE_WRAP_TYPE_MIRRORED_REPEAT = 0x2
const IMAGE_WRAP_TYPE_CLAMP_TO_EDGE = 0x3
const IMAGE_WRAP_TYPE_CLAMP_TO_BORDER = 0x4

# Constants
const MAX_AA_SAMPLES = 32
const MAX_AA_GRID_SIZE = 16

# rpr_bool
const FALSE = 0
const TRUE = 1

# Library types
# This is going to be moved to rpr_platform.h or similar
const rpr_char = Cchar
const rpr_uchar = Cuchar
const rpr_int = Cint
const rpr_uint = Cuint
const rpr_long = Int64
const rpr_ulong = UInt64
const rpr_short = Cshort
const rpr_ushort = Cushort
const rpr_float = Cfloat
const rpr_double = Cdouble
const rpr_longlong = Int64
const rpr_bool = Cint
const rpr_bitfield = rpr_uint
# rpr_context;
const rpr_context = Ptr{Void}
# rpr_camera;
const rpr_camera = Ptr{Void}
# rpr_shape;
const rpr_shape = Ptr{Void}
# rpr_light;
const rpr_light = Ptr{Void}
# rpr_scene;
const rpr_scene = Ptr{Void}
# rpr_image;
const rpr_image = Ptr{Void}
# rpr_framebuffer;
const rpr_framebuffer = Ptr{Void}
# rpr_material_system;
const rpr_material_system = Ptr{Void}
# rpr_material_node;
const rpr_material_node = Ptr{Void}
# rpr_post_effect;
const rpr_post_effect = Ptr{Void}
# rpr_context_properties;
const rpr_context_properties = Ptr{Void}
const rpr_light_type = rpr_uint
const rpr_image_type = rpr_uint
const rpr_shape_type = rpr_uint
const rpr_context_type = rpr_uint
const rpr_creation_flags = rpr_bitfield
const rpr_aa_filter = rpr_uint
const rpr_context_info = rpr_uint
const rpr_camera_info = rpr_uint
const rpr_image_info = rpr_uint
const rpr_shape_info = rpr_uint
const rpr_mesh_info = rpr_uint
const rpr_mesh_polygon_info = rpr_uint
const rpr_mesh_polygon_vertex_info = rpr_uint
const rpr_light_info = rpr_uint
const rpr_scene_info = rpr_uint
const rpr_parameter_info = rpr_uint
const rpr_framebuffer_info = rpr_uint
const rpr_channel_order = rpr_uint
const rpr_channel_type = rpr_uint
const rpr_parameter_type = rpr_uint
const rpr_render_mode = rpr_uint
const rpr_component_type = rpr_uint
const rpr_camera_mode = rpr_uint
const rpr_tonemapping_operator = rpr_uint
const rpr_volume_type = rpr_uint
const rpr_material_system_type = rpr_uint
const rpr_material_node_type = rpr_uint
const rpr_material_node_input = rpr_uint
const rpr_material_node_info = rpr_uint
immutable _rpr_image_desc
    image_width::rpr_uint
    image_height::rpr_uint
    image_depth::rpr_uint
    image_row_pitch::rpr_uint
    image_slice_pitch::rpr_uint
end
immutable _rpr_framebuffer_desc
    fb_width::rpr_uint
    fb_height::rpr_uint
end
immutable _rpr_render_statistics
    gpumem_usage::rpr_longlong
end
immutable _rpr_image_format
    num_components::rpr_uint
    typ::rpr_component_type
end

const rpr_material_node_input_info = rpr_uint
const rpr_aov = rpr_uint
const rpr_post_effect_type = rpr_uint
const rpr_post_effect_info = rpr_uint
const rpr_color_space = rpr_uint
const rpr_environment_override = rpr_uint
const rpr_subdiv_boundary_interfop_type = rpr_uint
const rpr_material_node_lookup_value = rpr_uint
const rpr_image_wrap_type = rpr_uint


const rpr_image_desc = _rpr_image_desc


const rpr_framebuffer_desc = _rpr_framebuffer_desc


const rpr_render_statistics = _rpr_render_statistics


const rpr_image_format = _rpr_image_format

# data;
# filename;

#const rpr_ies_image_desc = _rpr_ies_image_desc
const rpr_framebuffer_format = rpr_image_format

# API functions
#* @brief Register rendering plugin
#
#  <Description>
#
#  @param path     Path of plugin to load
#  @return         unique identifier of plugin, -1 otherwise
#/
# path);
function RegisterPlugin(path)

    is_error = ccall(
        (:rprRegisterPlugin, firelib), rpr_int,
        (Ptr{rpr_char},),
        path
    )
    check_error(is_error)
    nothing
end


#* @brief Create rendering context
#
#  Rendering context is a root concept encapsulating the render states and responsible
#  for execution control. All the entities in FireRender are created for a particular rendering context.
#  Entities created for some context can't be used with other contexts. Possible error codes for this call are:
#
#     RPR_ERROR_COMPUTE_API_NOT_SUPPORTED
#     RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#     RPR_ERROR_OUT_OF_VIDEO_MEMORY
#     RPR_ERROR_INVALID_API_VERSION
#     RPR_ERROR_INVALID_PARAMETER
#
#  @param api_version     Api version constant
#	 @param context_type    Determines compute API to use, OPENCL only is supported for now
#  @param creation_flags  Determines multi-gpu or cpu-gpu configuration
#  @param props           Context properties, reserved for future use
#  @param cache_path      Full path to kernel cache created by FireRender, NULL means to use current folder
#  @param out_context		Pointer to context object
#  @return                RPR_SUCCESS in case of success, error code otherwise
#/
# pluginIDs, size_t pluginCount, rpr_creation_flags creation_flags, rpr_context_properties const * props, rpr_char const * cache_path, rpr_context * out_context);
function CreateContext(api_version, pluginIDs, pluginCount, creation_flags, props, cache_path)
    out_context = Array(rpr_context, 1);
    is_error = ccall(
        (:rprCreateContext, firelib), rpr_int,
        (rpr_int, Ptr{rpr_int}, Csize_t, rpr_creation_flags, Ptr{rpr_context_properties}, Ptr{rpr_char}, rpr_context,),
        api_version, pluginIDs, pluginCount, creation_flags, props, cache_path, out_context
    )
    check_error(is_error)
    out_context[]
end


#* @breif Set active context plugin
#
#/
function ContextSetActivePlugin(context, pluginID)

    is_error = ccall(
        (:rprContextSetActivePlugin, firelib), rpr_int,
        (rpr_context, rpr_int,),
        context, pluginID
    )
    check_error(is_error)
    nothing
end


#* @brief Query information about a context
#
#  The workflow is usually two-step: query with the data == NULL and size = 0 to get the required buffer size in size_ret,
#  then query with size_ret == NULL to fill the buffer with the data.
#   Possible error codes:
#     RPR_ERROR_INVALID_PARAMETER
#
#  @param  context         The context to query
#  @param  context_info    The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function ContextGetInfo(context, context_info, size, data, size_ret)

    is_error = ccall(
        (:rprContextGetInfo, firelib), rpr_int,
        (rpr_context, rpr_context_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
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
#     RPR_ERROR_INVALID_PARAMETER
#
#  @param  context         The context to query
#  @param  param_idx	   The index of the parameter
#  @param  parameter_info  The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function ContextGetParameterInfo(context, param_idx, parameter_info, size, data, size_ret)

    is_error = ccall(
        (:rprContextGetParameterInfo, firelib), rpr_int,
        (rpr_context, Cint, rpr_parameter_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        context, param_idx, parameter_info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


#* @brief Query the AOV
#
#  @param  context     The context to get a frame buffer from
#  @param  out_fb		Pointer to framebuffer object
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# out_fb);
function ContextGetAOV(context, aov)
    out_fb = Array(rpr_framebuffer, 1);
    is_error = ccall(
        (:rprContextGetAOV, firelib), rpr_int,
        (rpr_context, rpr_aov, rpr_framebuffer,),
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
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
function ContextSetAOV(context, aov, frame_buffer)

    is_error = ccall(
        (:rprContextSetAOV, firelib), rpr_int,
        (rpr_context, rpr_aov, rpr_framebuffer,),
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
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ContextSetScene(context, scene)

    is_error = ccall(
        (:rprContextSetScene, firelib), rpr_int,
        (rpr_context, rpr_scene,),
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
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# out_scene);
function ContextGetScene(arg0)
    out_scene = Array(rpr_scene, 1);
    is_error = ccall(
        (:rprContextGetScene, firelib), rpr_int,
        (rpr_context, rpr_scene,),
        arg0, out_scene
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

#  imagefilter.type					   rpr_aa_filter
#  imagefilter.box.radius              ft_float
#  imagefilter.gaussian.radius         ft_float
#  imagefilter.triangle.radius         ft_float
#  imagefilter.mitchell.radius         ft_float
#  imagefilter.lanczos.radius          ft_float
#  imagefilter.blackmanharris.radius   ft_float

#  tonemapping.type                    rpr_tonemapping_operator
#  tonemapping.linear.scale            ft_float
#  tonemapping.photolinear.sensitivity ft_float
#  tonemapping.photolinear.exposure    ft_float
#  tonemapping.photolinear.fstop       ft_float
#  tonemapping.reinhard02.prescale     ft_float
#  tonemapping.reinhard02.postscale    ft_float
#  tonemapping.reinhard02.burn         ft_float

# @param x,y,z,w						   Parameter value

# @return             RPR_SUCCESS in case of success, error code otherwise
#/
# name, rpr_uint x);
function ContextSetParameter1u(context, name, x)

    is_error = ccall(
        (:rprContextSetParameter1u, firelib), rpr_int,
        (rpr_context, Ptr{rpr_char}, rpr_uint,),
        context, name, x
    )
    check_error(is_error)
    nothing
end

# name, rpr_float x);
function ContextSetParameter1f(context, name, x)

    is_error = ccall(
        (:rprContextSetParameter1f, firelib), rpr_int,
        (rpr_context, Ptr{rpr_char}, rpr_float,),
        context, name, x
    )
    check_error(is_error)
    nothing
end

# name, rpr_float x, rpr_float y, rpr_float z);
function ContextSetParameter3f(context, name, x, y, z)

    is_error = ccall(
        (:rprContextSetParameter3f, firelib), rpr_int,
        (rpr_context, Ptr{rpr_char}, rpr_float, rpr_float, rpr_float,),
        context, name, x, y, z
    )
    check_error(is_error)
    nothing
end

# name, rpr_float x, rpr_float y, rpr_float z, rpr_float w);
function ContextSetParameter4f(context, name, x, y, z, w)

    is_error = ccall(
        (:rprContextSetParameter4f, firelib), rpr_int,
        (rpr_context, Ptr{rpr_char}, rpr_float, rpr_float, rpr_float, rpr_float,),
        context, name, x, y, z, w
    )
    check_error(is_error)
    nothing
end

# name, rpr_char const * value);
function ContextSetParameterString(context, name, value)

    is_error = ccall(
        (:rprContextSetParameterString, firelib), rpr_int,
        (rpr_context, Ptr{rpr_char}, Ptr{rpr_char},),
        context, name, value
    )
    check_error(is_error)
    nothing
end


#* @brief Perform evaluation and accumulation of a single sample (or number of AA samples if AA is enabled)
#
#  The call is blocking and the image is ready when returned. The context accumulates the samples in order
#  to progressively refine the image and enable interactive response. So each new call to Render refines the
#  resultin image with 1 (or num aa samples) color samples. Call rprFramebufferClear if you want to start rendering new image
#  instead of refining the previous one.
#
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_INTERNAL_ERROR
#      RPR_ERROR_MATERIAL_STACK_OVERFLOW
#
#  if you have the RPR_ERROR_MATERIAL_STACK_OVERFLOW error, you have created a shader graph with too many nodes.
#  you can check the nodes limit with rprContextGetInfo(,RPR_CONTEXT_MATERIAL_STACK_SIZE,)
#
#  @param  context     The context object
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ContextRender(context)

    is_error = ccall(
        (:rprContextRender, firelib), rpr_int,
        (rpr_context,),
        context
    )
    check_error(is_error)
    nothing
end


#* @brief Perform evaluation and accumulation of a single sample (or number of AA samples if AA is enabled) on the part of the image
#
#  The call is blocking and the image is ready when returned. The context accumulates the samples in order
#  to progressively refine the image and enable interactive response. So each new call to Render refines the
#  resultin image with 1 (or num aa samples) color samples. Call rprFramebufferClear if you want to start rendering new image
#  instead of refining the previous one. Possible error codes are:
#
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_INTERNAL_ERROR
#
#  @param  context     The context to use for the rendering
#  @param  xmin        X coordinate of the top left corner of a tile
#  @param  xmax        X coordinate of the bottom right corner of a tile
#  @param  ymin        Y coordinate of the top left corner of a tile
#  @param  ymax        Y coordinate of the bottom right corner of a tile
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ContextRenderTile(context, xmin, xmax, ymin, ymax)

    is_error = ccall(
        (:rprContextRenderTile, firelib), rpr_int,
        (rpr_context, rpr_uint, rpr_uint, rpr_uint, rpr_uint,),
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
#      RPR_ERROR_INTERNAL_ERROR
#
#  @param  context     The context to wipe out
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ContextClearMemory(context)

    is_error = ccall(
        (:rprContextClearMemory, firelib), rpr_int,
        (rpr_context,),
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
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_UNSUPPORTED_IMAGE_FORMAT
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  context     The context to create image
#  @param  format      Image format
#  @param  image_desc  Image layout description
#  @param  data        Image data in system memory, can be NULL in which case the memory is allocated
#  @param  out_image   Pointer to image object
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# image_desc, void const * data, rpr_image * out_image);
function ContextCreateImage(context, format, image_desc, data)
    out_image = Array(rpr_image, 1);
    is_error = ccall(
        (:rprContextCreateImage, firelib), rpr_int,
        (rpr_context, rpr_image_format, Ptr{rpr_image_desc}, Ptr{Void}, rpr_image,),
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
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_UNSUPPORTED_IMAGE_FORMAT
#      RPR_ERROR_INVALID_PARAMETER
#      RPR_ERROR_IO_ERROR
#
#  @param  context     The context to create image
#  @param  path        NULL terminated path to an image file (can be relative)
#  @param  out_image   Pointer to image object
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# path, rpr_image * out_image);
function ContextCreateImageFromFile(context, path)
    out_image = Array(rpr_image, 1);
    is_error = ccall(
        (:rprContextCreateImageFromFile, firelib), rpr_int,
        (rpr_context, Ptr{rpr_char}, rpr_image,),
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
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  out_scene   Pointer to scene object
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# out_scene);
function ContextCreateScene(context)
    out_scene = Array(rpr_scene, 1);
    is_error = ccall(
        (:rprContextCreateScene, firelib), rpr_int,
        (rpr_context, rpr_scene,),
        context, out_scene
    )
    check_error(is_error)
    out_scene[]
end


#* @brief Create an instance of an object
#
#  Possible error codes are:
#
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  context  The context to create an instance for
#  @param  shape    Parent shape for an instance
#  @param  out_instance   Pointer to instance object
#  @return RPR_SUCCESS in case of success, error code otherwise
#/
# out_instance);
function ContextCreateInstance(context, shape)
    out_instance = Array(rpr_shape, 1);
    is_error = ccall(
        (:rprContextCreateInstance, firelib), rpr_int,
        (rpr_context, rpr_shape, rpr_shape,),
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
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  vertices            Pointer to position data (each position is described with 3 rpr_float numbers)
#  @param  num_vertices        Number of entries in position array
#  @param  vertex_stride       Number of bytes between the beginnings of two successive position entries
#  @param  normals             Pointer to normal data (each normal is described with 3 rpr_float numbers), can be NULL
#  @param  num_normals         Number of entries in normal array
#  @param  normal_stride       Number of bytes between the beginnings of two successive normal entries
#  @param  texcoord            Pointer to texcoord data (each texcoord is described with 2 rpr_float numbers), can be NULL
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
#  @return                     RPR_SUCCESS in case of success, error code otherwise
#/
# vertices, size_t num_vertices, rpr_int vertex_stride, rpr_float const * normals, size_t num_normals, rpr_int normal_stride, rpr_float const * texcoords, size_t num_texcoords, rpr_int texcoord_stride, rpr_int const * vertex_indices, rpr_int vidx_stride, rpr_int const * normal_indices, rpr_int nidx_stride, rpr_int const * texcoord_indices, rpr_int tidx_stride, rpr_int const * num_face_vertices, size_t num_faces, rpr_shape * out_mesh);
function ContextCreateMesh(context, vertices, num_vertices, vertex_stride, normals, num_normals, normal_stride, texcoords, num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces)
    out_mesh = Array(rpr_shape, 1);
    is_error = ccall(
        (:rprContextCreateMesh, firelib), rpr_int,
        (rpr_context, Ptr{rpr_float}, Csize_t, rpr_int, Ptr{rpr_float}, Csize_t, rpr_int, Ptr{rpr_float}, Csize_t, rpr_int, Ptr{rpr_int}, rpr_int, Ptr{rpr_int}, rpr_int, Ptr{rpr_int}, rpr_int, Ptr{rpr_int}, Csize_t, rpr_shape,),
        context, vertices, num_vertices, vertex_stride, normals, num_normals, normal_stride, texcoords, num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces, out_mesh
    )
    check_error(is_error)
    out_mesh[]
end


#  @brief Create a mesh
#
#  @return                     RPR_SUCCESS in case of success, error code otherwise
#/
# vertices, size_t num_vertices, rpr_int vertex_stride, rpr_float const * normals, size_t num_normals, rpr_int normal_stride, rpr_int const * perVertexFlag, size_t num_perVertexFlags, rpr_int perVertexFlag_stride, rpr_int numberOfTexCoordLayers, rpr_float const ** texcoords, size_t * num_texcoords, rpr_int * texcoord_stride, rpr_int const * vertex_indices, rpr_int vidx_stride, rpr_int const * normal_indices, rpr_int nidx_stride, rpr_int const ** texcoord_indices, rpr_int * tidx_stride, rpr_int const * num_face_vertices, size_t num_faces, rpr_shape * out_mesh);
function ContextCreateMeshEx(context, vertices, num_vertices, vertex_stride, normals, num_normals, normal_stride, perVertexFlag, num_perVertexFlags, perVertexFlag_stride, numberOfTexCoordLayers, texcoords, num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces)
    out_mesh = Array(rpr_shape, 1);
    is_error = ccall(
        (:rprContextCreateMeshEx, firelib), rpr_int,
        (rpr_context, Ptr{rpr_float}, Csize_t, rpr_int, Ptr{rpr_float}, Csize_t, rpr_int, Ptr{rpr_int}, Csize_t, rpr_int, rpr_int, Ptr{rpr_float}, Ptr{Csize_t}, Ptr{rpr_int}, Ptr{rpr_int}, rpr_int, Ptr{rpr_int}, rpr_int, Ptr{rpr_int}, Ptr{rpr_int}, Ptr{rpr_int}, Csize_t, rpr_shape,),
        context, vertices, num_vertices, vertex_stride, normals, num_normals, normal_stride, perVertexFlag, num_perVertexFlags, perVertexFlag_stride, numberOfTexCoordLayers, texcoords, num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces, out_mesh
    )
    check_error(is_error)
    out_mesh[]
end


#* @brief Create a camera
#
#  There are several camera types supported by a single rpr_camera type.
#  Possible error codes are:
#
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  @param  context The context to create a camera for
#  @param  out_camera Pointer to camera object
#  @return RPR_SUCCESS in case of success, error code otherwise
#/
# out_camera);
function ContextCreateCamera(context)
    out_camera = Array(rpr_camera, 1);
    is_error = ccall(
        (:rprContextCreateCamera, firelib), rpr_int,
        (rpr_context, rpr_camera,),
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
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  @param  context  The context to create framebuffer
#  @param  format   Framebuffer format
#  @param  fb_desc  Framebuffer layout description
#  @param  status   Pointer to framebuffer object
#  @return          RPR_SUCCESS in case of success, error code otherwise
#/
# fb_desc, rpr_framebuffer * out_fb);
function ContextCreateFrameBuffer(context, format, fb_desc)
    out_fb = Array(rpr_framebuffer, 1);
    is_error = ccall(
        (:rprContextCreateFrameBuffer, firelib), rpr_int,
        (rpr_context, rpr_framebuffer_format, Ptr{rpr_framebuffer_desc}, rpr_framebuffer,),
        context, format, fb_desc, out_fb
    )
    check_error(is_error)
    out_fb[]
end


# rpr_camera
#* @brief Query information about a camera
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data.
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  camera      The camera to query
#  @param  camera_info The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function CameraGetInfo(camera, camera_info, size, data, size_ret)

    is_error = ccall(
        (:rprCameraGetInfo, firelib), rpr_int,
        (rpr_camera, rpr_camera_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        camera, camera_info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


#* @brief Set camera focal length.
#
#  @param  camera  The camera to set focal length
#  @param  flength Focal length in millimeters, default is 35mm
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetFocalLength(camera, flength)

    is_error = ccall(
        (:rprCameraSetFocalLength, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, flength
    )
    check_error(is_error)
    nothing
end


#* @brief Set camera focus distance
#
#  @param  camera  The camera to set focus distance
#  @param  fdist   Focus distance in meters, default is 1m
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetFocusDistance(camera, fdist)

    is_error = ccall(
        (:rprCameraSetFocusDistance, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, fdist
    )
    check_error(is_error)
    nothing
end


#* @brief Set world transform for the camera
#
#  @param  camera      The camera to set transform for
#  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
#  @param  transform   Array of 16 rpr_float values (row-major form)
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# transform);
function CameraSetTransform(camera, transpose, transform)

    is_error = ccall(
        (:rprCameraSetTransform, firelib), rpr_int,
        (rpr_camera, rpr_bool, Ptr{rpr_float},),
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
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetSensorSize(camera, width, height)

    is_error = ccall(
        (:rprCameraSetSensorSize, firelib), rpr_int,
        (rpr_camera, rpr_float, rpr_float,),
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
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraLookAt(camera, posx, posy, posz, atx, aty, atz, upx, upy, upz)

    is_error = ccall(
        (:rprCameraLookAt, firelib), rpr_int,
        (rpr_camera, rpr_float, rpr_float, rpr_float, rpr_float, rpr_float, rpr_float, rpr_float, rpr_float, rpr_float,),
        camera, posx, posy, posz, atx, aty, atz, upx, upy, upz
    )
    check_error(is_error)
    nothing
end


#* @brief Set f-stop for the camera
#
#  @param  camera  The camera to set f-stop for
#  @param  fstop   f-stop value in mm^-1, default is FLT_MAX
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetFStop(camera, fstop)

    is_error = ccall(
        (:rprCameraSetFStop, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, fstop
    )
    check_error(is_error)
    nothing
end


#* @brief Set the number of aperture blades
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  camera      The camera to set aperture blades for
#  @param  num_blades  Number of aperture blades 4 to 32
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetApertureBlades(camera, num_blades)

    is_error = ccall(
        (:rprCameraSetApertureBlades, firelib), rpr_int,
        (rpr_camera, rpr_uint,),
        camera, num_blades
    )
    check_error(is_error)
    nothing
end


#* @brief Set the exposure of a camera
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  camera    The camera to set aperture blades for
#  @param  exposure  Exposure value 0.0 - 1.0
#  @return           RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetExposure(camera, exposure)

    is_error = ccall(
        (:rprCameraSetExposure, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, exposure
    )
    check_error(is_error)
    nothing
end


#* @brief Set camera mode
#
#  Camera modes include:
#      RPR_CAMERA_MODE_PERSPECTIVE
#      RPR_CAMERA_MODE_ORTHOGRAPHIC
#      RPR_CAMERA_MODE_LATITUDE_LONGITUDE_360
#      RPR_CAMERA_MODE_LATITUDE_LONGITUDE_STEREO
#      RPR_CAMERA_MODE_CUBEMAP
#      RPR_CAMERA_MODE_CUBEMAP_STEREO
#
#  @param  camera  The camera to set mode for
#  @param  mode    Camera mode, default is RPR_CAMERA_MODE_PERSPECTIVE
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetMode(camera, mode)

    is_error = ccall(
        (:rprCameraSetMode, firelib), rpr_int,
        (rpr_camera, rpr_camera_mode,),
        camera, mode
    )
    check_error(is_error)
    nothing
end


#* @brief Set orthographic view volume width
#
#  @param  camera  The camera to set volume width for
#  @param  width   View volume width in meters, default is 1 meter
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetOrthoWidth(camera, width)

    is_error = ccall(
        (:rprCameraSetOrthoWidth, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, width
    )
    check_error(is_error)
    nothing
end

function CameraSetFocalTilt(camera, tilt)

    is_error = ccall(
        (:rprCameraSetFocalTilt, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, tilt
    )
    check_error(is_error)
    nothing
end

function CameraSetIPD(camera, ipd)

    is_error = ccall(
        (:rprCameraSetIPD, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, ipd
    )
    check_error(is_error)
    nothing
end

function CameraSetLensShift(camera, shiftx, shifty)

    is_error = ccall(
        (:rprCameraSetLensShift, firelib), rpr_int,
        (rpr_camera, rpr_float, rpr_float,),
        camera, shiftx, shifty
    )
    check_error(is_error)
    nothing
end


#* @brief Set orthographic view volume height
#
#  @param  camera  The camera to set volume height for
#  @param  width   View volume height in meters, default is 1 meter
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function CameraSetOrthoHeight(camera, height)

    is_error = ccall(
        (:rprCameraSetOrthoHeight, firelib), rpr_int,
        (rpr_camera, rpr_float,),
        camera, height
    )
    check_error(is_error)
    nothing
end


# rpr_image
#* @brief Query information about an image
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  image       An image object to query
#  @param  image_info  The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function ImageGetInfo(image, image_info, size, data, size_ret)

    is_error = ccall(
        (:rprImageGetInfo, firelib), rpr_int,
        (rpr_image, rpr_image_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        image, image_info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


#* @brief
#
#
#  @param  image       The image to set wrap for
#  @param  type
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ImageSetWrap(image, typ)

    is_error = ccall(
        (:rprImageSetWrap, firelib), rpr_int,
        (rpr_image, rpr_image_wrap_type,),
        image, typ
    )
    check_error(is_error)
    nothing
end


# rpr_shape
#* @brief Set shape world transform
#
#
#  @param  shape       The shape to set transform for
#  @param  transpose   Determines whether the basis vectors are in columns(false) or in rows(true) of the matrix
#  @param  transform   Array of 16 rpr_float values (row-major form)
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# transform);
function ShapeSetTransform(shape, transpose, transform)

    is_error = ccall(
        (:rprShapeSetTransform, firelib), rpr_int,
        (rpr_shape, rpr_bool, Ptr{rpr_float},),
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
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetSubdivisionFactor(shape, factor)

    is_error = ccall(
        (:rprShapeSetSubdivisionFactor, firelib), rpr_int,
        (rpr_shape, rpr_uint,),
        shape, factor
    )
    check_error(is_error)
    nothing
end


#* @brief
#
#
#  @param  shape       The shape to set subdivision for
#  @param  factor
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetSubdivisionCreaseWeight(shape, factor)

    is_error = ccall(
        (:rprShapeSetSubdivisionCreaseWeight, firelib), rpr_int,
        (rpr_shape, rpr_float,),
        shape, factor
    )
    check_error(is_error)
    nothing
end


#* @brief
#
#
#  @param  shape       The shape to set subdivision for
#  @param  type
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetSubdivisionBoundaryInterop(shape, typ)

    is_error = ccall(
        (:rprShapeSetSubdivisionBoundaryInterop, firelib), rpr_int,
        (rpr_shape, rpr_subdiv_boundary_interfop_type,),
        shape, typ
    )
    check_error(is_error)
    nothing
end


#* @brief Set displacement scale
#
#
#  @param  shape       The shape to set subdivision for
#  @param  scale	   The amount of displacement applied
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetDisplacementScale(shape, minscale, maxscale)

    is_error = ccall(
        (:rprShapeSetDisplacementScale, firelib), rpr_int,
        (rpr_shape, rpr_float, rpr_float,),
        shape, minscale, maxscale
    )
    check_error(is_error)
    nothing
end


#* @brief Set object group ID (mainly for debugging).
#
#
#  @param  shape          The shape to set
#  @param  objectGroupID  The ID
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetObjectGroupID(shape, objectGroupID)

    is_error = ccall(
        (:rprShapeSetObjectGroupID, firelib), rpr_int,
        (rpr_shape, rpr_uint,),
        shape, objectGroupID
    )
    check_error(is_error)
    nothing
end


#* @brief Set displacement texture
#
#
#  @param  shape       The shape to set subdivision for
#  @param  image 	   Displacement texture (scalar displacement, only x component is used)
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetDisplacementImage(shape, image)

    is_error = ccall(
        (:rprShapeSetDisplacementImage, firelib), rpr_int,
        (rpr_shape, rpr_image,),
        shape, image
    )
    check_error(is_error)
    nothing
end


# rpr_shape
#* @brief Set shape material
#
#/
function ShapeSetMaterial(shape, node)

    is_error = ccall(
        (:rprShapeSetMaterial, firelib), rpr_int,
        (rpr_shape, rpr_material_node,),
        shape, node
    )
    check_error(is_error)
    nothing
end


#* @brief Set shape material override
#
#/
function ShapeSetMaterialOverride(shape, node)

    is_error = ccall(
        (:rprShapeSetMaterialOverride, firelib), rpr_int,
        (rpr_shape, rpr_material_node,),
        shape, node
    )
    check_error(is_error)
    nothing
end


#* @brief Set shape volume material
#
#/
function ShapeSetVolumeMaterial(shape, node)

    is_error = ccall(
        (:rprShapeSetVolumeMaterial, firelib), rpr_int,
        (rpr_shape, rpr_material_node,),
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
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetLinearMotion(shape, x, y, z)

    is_error = ccall(
        (:rprShapeSetLinearMotion, firelib), rpr_int,
        (rpr_shape, rpr_float, rpr_float, rpr_float,),
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
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetAngularMotion(shape, x, y, z, w)

    is_error = ccall(
        (:rprShapeSetAngularMotion, firelib), rpr_int,
        (rpr_shape, rpr_float, rpr_float, rpr_float, rpr_float,),
        shape, x, y, z, w
    )
    check_error(is_error)
    nothing
end


#* @brief Set visibility flag
#
#  @param  shape       The shape to set visibility for
#  @param  visible     Determines if the shape is visible or not
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetVisibility(shape, visible)

    is_error = ccall(
        (:rprShapeSetVisibility, firelib), rpr_int,
        (rpr_shape, rpr_bool,),
        shape, visible
    )
    check_error(is_error)
    nothing
end


#* @brief Set visibility flag for primary rays
#
#  @param  shape       The shape to set visibility for
#  @param  visible     Determines if the shape is visible or not
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetVisibilityPrimaryOnly(shape, visible)

    is_error = ccall(
        (:rprShapeSetVisibilityPrimaryOnly, firelib), rpr_int,
        (rpr_shape, rpr_bool,),
        shape, visible
    )
    check_error(is_error)
    nothing
end


#* @brief Set visibility flag for specular refleacted\refracted rays
#
#  @param  shape       The shape to set visibility for
#  @param  visible     Determines if the shape is visible or not
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetVisibilityInSpecular(shape, visible)

    is_error = ccall(
        (:rprShapeSetVisibilityInSpecular, firelib), rpr_int,
        (rpr_shape, rpr_bool,),
        shape, visible
    )
    check_error(is_error)
    nothing
end


#* @brief Set shadow catcher flag
#
#  @param  shape         The shape to set shadow catcher flag for
#  @param  shadowCatcher Determines if the shape behaves as shadow catcher
#  @return               RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetShadowCatcher(shape, shadowCatcher)

    is_error = ccall(
        (:rprShapeSetShadowCatcher, firelib), rpr_int,
        (rpr_shape, rpr_bool,),
        shape, shadowCatcher
    )
    check_error(is_error)
    nothing
end


#* @brief Set shadow flag
#
#  @param  shape       The shape to set shadow flag for
#  @param  visible     Determines if the shape casts shadow
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
function ShapeSetShadow(shape, casts_shadow)

    is_error = ccall(
        (:rprShapeSetShadow, firelib), rpr_int,
        (rpr_shape, rpr_bool,),
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
#  @param  transform   Array of 16 rpr_float values (row-major form)
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# transform);
function LightSetTransform(light, transpose, transform)

    is_error = ccall(
        (:rprLightSetTransform, firelib), rpr_int,
        (rpr_light, rpr_bool, Ptr{rpr_float},),
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
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  shape           The shape object to query
#  @param  material_info   The type of info to query
#  @param  size            The size of the buffer pointed by data
#  @param  data            The buffer to store queried info
#  @param  size_ret        Returns the size in bytes of the data being queried
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
# arg3, size_t * arg4);
function ShapeGetInfo(arg0, arg1, arg2, arg3, arg4)

    is_error = ccall(
        (:rprShapeGetInfo, firelib), rpr_int,
        (rpr_shape, rpr_shape_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        arg0, arg1, arg2, arg3, arg4
    )
    check_error(is_error)
    nothing
end


# rpr_shape - mesh
#* @brief Query information about a mesh
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  shape       The mesh to query
#  @param  mesh_info   The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function MeshGetInfo(mesh, mesh_info, size, data, size_ret)

    is_error = ccall(
        (:rprMeshGetInfo, firelib), rpr_int,
        (rpr_shape, rpr_mesh_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
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
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  mesh        The mesh to query
#  @param  polygon_index The index of a polygon
#  @param  polygon_info The type of info to query
#  @param  size        The size of the buffer pointed by data
#  @param  data        The buffer to store queried info
#  @param  size_ret    Returns the size in bytes of the data being queried
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function MeshPolygonGetInfo(mesh, polygon_index, polygon_info, size, data, size_ret)

    is_error = ccall(
        (:rprMeshPolygonGetInfo, firelib), rpr_int,
        (rpr_shape, Csize_t, rpr_mesh_polygon_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        mesh, polygon_index, polygon_info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


#* @brief Get the parent shape for an instance
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  shape    The shape to get a parent shape from
#  @param  status   RPR_SUCCESS in case of success, error code otherwise
#  @return          Shape object
#/
# out_shape);
function InstanceGetBaseShape(shape)
    out_shape = Array(rpr_shape, 1);
    is_error = ccall(
        (:rprInstanceGetBaseShape, firelib), rpr_int,
        (rpr_shape, rpr_shape,),
        shape, out_shape
    )
    check_error(is_error)
    out_shape[]
end


# rpr_light - point
#* @brief Create point light
#
#  Create analytic point light represented by a point in space.
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_light);
function ContextCreatePointLight(context)
    out_light = Array(rpr_light, 1);
    is_error = ccall(
        (:rprContextCreatePointLight, firelib), rpr_int,
        (rpr_context, rpr_light,),
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
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function PointLightSetRadiantPower3f(light, r, g, b)

    is_error = ccall(
        (:rprPointLightSetRadiantPower3f, firelib), rpr_int,
        (rpr_light, rpr_float, rpr_float, rpr_float,),
        light, r, g, b
    )
    check_error(is_error)
    nothing
end


# rpr_light - spot
#* @brief Create spot light
#
#  Create analytic spot light
#
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# light);
function ContextCreateSpotLight(context, light)

    is_error = ccall(
        (:rprContextCreateSpotLight, firelib), rpr_int,
        (rpr_context, Ptr{rpr_light},),
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
#  @return   RPR_SUCCESS in case of success, error code otherwise
#/
function SpotLightSetRadiantPower3f(light, r, g, b)

    is_error = ccall(
        (:rprSpotLightSetRadiantPower3f, firelib), rpr_int,
        (rpr_light, rpr_float, rpr_float, rpr_float,),
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
#  @return status RPR_SUCCESS in case of success, error code otherwise
#/
function SpotLightSetConeShape(light, iangle, oangle)

    is_error = ccall(
        (:rprSpotLightSetConeShape, firelib), rpr_int,
        (rpr_light, rpr_float, rpr_float,),
        light, iangle, oangle
    )
    check_error(is_error)
    nothing
end


# rpr_light - directional
#* @brief Create directional light
#
#  Create analytic directional light.
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return light id of a newly created light
#/
# out_light);
function ContextCreateDirectionalLight(context)
    out_light = Array(rpr_light, 1);
    is_error = ccall(
        (:rprContextCreateDirectionalLight, firelib), rpr_int,
        (rpr_context, rpr_light,),
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
#  @return   RPR_SUCCESS in case of success, error code otherwise
#/
function DirectionalLightSetRadiantPower3f(light, r, g, b)

    is_error = ccall(
        (:rprDirectionalLightSetRadiantPower3f, firelib), rpr_int,
        (rpr_light, rpr_float, rpr_float, rpr_float,),
        light, r, g, b
    )
    check_error(is_error)
    nothing
end


#* @brief Set softness of shadow produced by the light
#
#  @param  coeff value between [0;1]. 0.0 is sharp
#  @return   RPR_SUCCESS in case of success, error code otherwise
#/
function DirectionalLightSetShadowSoftness(light, coeff)

    is_error = ccall(
        (:rprDirectionalLightSetShadowSoftness, firelib), rpr_int,
        (rpr_light, rpr_float,),
        light, coeff
    )
    check_error(is_error)
    nothing
end


# rpr_light - environment
#* @brief Create an environment light
#
#  Environment light is a light based on lightprobe.
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_light);
function ContextCreateEnvironmentLight(context)
    out_light = Array(rpr_light, 1);
    is_error = ccall(
        (:rprContextCreateEnvironmentLight, firelib), rpr_int,
        (rpr_context, rpr_light,),
        context, out_light
    )
    check_error(is_error)
    out_light[]
end


#* @brief Set image for an environment light
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#      RPR_ERROR_UNSUPPORTED_IMAGE_FORMAT
#
#  @param  env_light Environment light
#  @param  image     Image object to set
#  @return           RPR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightSetImage(env_light, image)

    is_error = ccall(
        (:rprEnvironmentLightSetImage, firelib), rpr_int,
        (rpr_light, rpr_image,),
        env_light, image
    )
    check_error(is_error)
    nothing
end


#* @brief Set intensity scale or an env light
#
#  @param  env_light       Environment light
#  @param  intensity_scale Intensity scale
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightSetIntensityScale(env_light, intensity_scale)

    is_error = ccall(
        (:rprEnvironmentLightSetIntensityScale, firelib), rpr_int,
        (rpr_light, rpr_float,),
        env_light, intensity_scale
    )
    check_error(is_error)
    nothing
end


#* @brief Set portal for environment light to accelerate convergence of indoor scenes
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  env_light Environment light
#  @param  portal    Portal mesh, might have multiple components
#  @return           RPR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightAttachPortal(env_light, portal)

    is_error = ccall(
        (:rprEnvironmentLightAttachPortal, firelib), rpr_int,
        (rpr_light, rpr_shape,),
        env_light, portal
    )
    check_error(is_error)
    nothing
end


#* @brief Remove portal for environment light.
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  env_light Environment light
#  @param  portal    Portal mesh, that have been added to light.
#  @return           RPR_SUCCESS in case of success, error code otherwise
#/
function EnvironmentLightDetachPortal(env_light, portal)

    is_error = ccall(
        (:rprEnvironmentLightDetachPortal, firelib), rpr_int,
        (rpr_light, rpr_shape,),
        env_light, portal
    )
    check_error(is_error)
    nothing
end


# rpr_light - sky
#* @brief Create sky light
#
#  Analytical sky model
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_light);
function ContextCreateSkyLight(context)
    out_light = Array(rpr_light, 1);
    is_error = ccall(
        (:rprContextCreateSkyLight, firelib), rpr_int,
        (rpr_context, rpr_light,),
        context, out_light
    )
    check_error(is_error)
    out_light[]
end


#* @brief Set turbidity of a sky light
#
#  @param  skylight        Sky light
#  @param  turbidity       Turbidity value
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetTurbidity(skylight, turbidity)

    is_error = ccall(
        (:rprSkyLightSetTurbidity, firelib), rpr_int,
        (rpr_light, rpr_float,),
        skylight, turbidity
    )
    check_error(is_error)
    nothing
end


#* @brief Set albedo of a sky light
#
#  @param  skylight        Sky light
#  @param  albedo          Albedo value
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetAlbedo(skylight, albedo)

    is_error = ccall(
        (:rprSkyLightSetAlbedo, firelib), rpr_int,
        (rpr_light, rpr_float,),
        skylight, albedo
    )
    check_error(is_error)
    nothing
end


#* @brief Set scale of a sky light
#
#  @param  skylight        Sky light
#  @param  scale           Scale value
#  @return                 RPR_SUCCESS in case of success, error code otherwise
#/
function SkyLightSetScale(skylight, scale)

    is_error = ccall(
        (:rprSkyLightSetScale, firelib), rpr_int,
        (rpr_light, rpr_float,),
        skylight, scale
    )
    check_error(is_error)
    nothing
end


#* @brief Set portal for sky light to accelerate convergence of indoor scenes
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  skylight  Sky light
#  @param  portal    Portal mesh, might have multiple components
#  @return           RPR_SUCCESS in case of success, error code otherwise
#/
function SkyLightAttachPortal(skylight, portal)

    is_error = ccall(
        (:rprSkyLightAttachPortal, firelib), rpr_int,
        (rpr_light, rpr_shape,),
        skylight, portal
    )
    check_error(is_error)
    nothing
end


#* @brief Remove portal for Sky light.
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  env_light Sky light
#  @param  portal    Portal mesh, that have been added to light.
#  @return           RPR_SUCCESS in case of success, error code otherwise
#/
function SkyLightDetachPortal(skylight, portal)

    is_error = ccall(
        (:rprSkyLightDetachPortal, firelib), rpr_int,
        (rpr_light, rpr_shape,),
        skylight, portal
    )
    check_error(is_error)
    nothing
end


#* @brief Create IES light
#
#  Create IES light
#
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# light);
function ContextCreateIESLight(context, light)

    is_error = ccall(
        (:rprContextCreateIESLight, firelib), rpr_int,
        (rpr_context, Ptr{rpr_light},),
        context, light
    )
    check_error(is_error)
    nothing
end


#* @brief Set radiant power of a IES light source
#
#  @param  r R component of a radiant power vector
#  @param  g G component of a radiant power vector
#  @param  b B component of a radiant power vector
#  @return   RPR_SUCCESS in case of success, error code otherwise
#/
function IESLightSetRadiantPower3f(light, r, g, b)

    is_error = ccall(
        (:rprIESLightSetRadiantPower3f, firelib), rpr_int,
        (rpr_light, rpr_float, rpr_float, rpr_float,),
        light, r, g, b
    )
    check_error(is_error)
    nothing
end


#* @brief Set image for an IES light
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#      RPR_ERROR_UNSUPPORTED_IMAGE_FORMAT : If the format of the IES file is not supported by Radeon ProRender.
#      RPR_ERROR_IO_ERROR : If the IES image path file doesn't exist.
#
#  @param  env_light     Environment light
#  @param  imagePath     Image path to set
#  @param  nx			  resolution X of the IES image
#  @param  ny            resolution Y of the IES image
#  @return               RPR_SUCCESS in case of success, error code otherwise
#/
# imagePath, rpr_int nx, rpr_int ny);
function IESLightSetImageFromFile(env_light, imagePath, nx, ny)

    is_error = ccall(
        (:rprIESLightSetImageFromFile, firelib), rpr_int,
        (rpr_light, Ptr{rpr_char}, rpr_int, rpr_int,),
        env_light, imagePath, nx, ny
    )
    check_error(is_error)
    nothing
end


#* @brief Set image for an IES light
#
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#      RPR_ERROR_UNSUPPORTED_IMAGE_FORMAT : If the format of the IES data is not supported by Radeon ProRender.
#
#  @param  env_light     Environment light
#  @param  iesData       Image data string defining the IES. null terminated string. IES format.
#  @param  nx			  resolution X of the IES image
#  @param  ny            resolution Y of the IES image
#  @return               RPR_SUCCESS in case of success, error code otherwise
#/
# iesData, rpr_int nx, rpr_int ny);
function IESLightSetImageFromIESdata(env_light, iesData, nx, ny)

    is_error = ccall(
        (:rprIESLightSetImageFromIESdata, firelib), rpr_int,
        (rpr_light, Ptr{rpr_char}, rpr_int, rpr_int,),
        env_light, iesData, nx, ny
    )
    check_error(is_error)
    nothing
end


# rpr_light
#* @brief Query information about a light
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  light    The light to query
#  @param  light_info The type of info to query
#  @param  size     The size of the buffer pointed by data
#  @param  data     The buffer to store queried info
#  @param  size_ret Returns the size in bytes of the data being queried
#  @return          RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function LightGetInfo(light, info, size, data, size_ret)

    is_error = ccall(
        (:rprLightGetInfo, firelib), rpr_int,
        (rpr_light, rpr_light_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        light, info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


# rpr_scene
#* @brief Remove all objects from a scene
#
#  A scene is essentially a collection of shapes, lights and volume regions.
#
#  @param  scene   The scene to clear
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function SceneClear(scene)

    is_error = ccall(
        (:rprSceneClear, firelib), rpr_int,
        (rpr_scene,),
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
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
function SceneAttachShape(scene, shape)

    is_error = ccall(
        (:rprSceneAttachShape, firelib), rpr_int,
        (rpr_scene, rpr_shape,),
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
#  @return         RPR_SUCCESS in case of success, error code otherwise
#/
function SceneDetachShape(scene, shape)

    is_error = ccall(
        (:rprSceneDetachShape, firelib), rpr_int,
        (rpr_scene, rpr_shape,),
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
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
function SceneAttachLight(scene, light)

    is_error = ccall(
        (:rprSceneAttachLight, firelib), rpr_int,
        (rpr_scene, rpr_light,),
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
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
function SceneDetachLight(scene, light)

    is_error = ccall(
        (:rprSceneDetachLight, firelib), rpr_int,
        (rpr_scene, rpr_light,),
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
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  scene    The scene to query
#  @param  info     The type of info to query
#  @param  size     The size of the buffer pointed by data
#  @param  data     The buffer to store queried info
#  @param  size_ret Returns the size in bytes of the data being queried
#  @return          RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function SceneGetInfo(scene, info, size, data, size_ret)

    is_error = ccall(
        (:rprSceneGetInfo, firelib), rpr_int,
        (rpr_scene, rpr_scene_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        scene, info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


#* @brief Get background override light
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  scene       The scene to set background for
#  @param  overrride   overrride type
#  @param  out_light   light returned
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
# out_light);
function SceneGetEnvironmentOverride(scene, overrride)
    out_light = Array(rpr_light, 1);
    is_error = ccall(
        (:rprSceneGetEnvironmentOverride, firelib), rpr_int,
        (rpr_scene, rpr_environment_override, rpr_light,),
        scene, overrride, out_light
    )
    check_error(is_error)
    out_light[]
end


#* @brief Set background light for the scene which does not affect the scene lighting,
#    but gets shown as a background image
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  scene  The scene to set background for
#  @param  light  Background light
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
function SceneSetEnvironmentOverride(scene, overrride, light)

    is_error = ccall(
        (:rprSceneSetEnvironmentOverride, firelib), rpr_int,
        (rpr_scene, rpr_environment_override, rpr_light,),
        scene, overrride, light
    )
    check_error(is_error)
    nothing
end


#* @brief Set background image for the scene which does not affect the scene lighting,
#    it is shown as view-independent rectangular background
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  scene  The scene to set background for
#  @param  image  Background image
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
function SceneSetBackgroundImage(scene, image)

    is_error = ccall(
        (:rprSceneSetBackgroundImage, firelib), rpr_int,
        (rpr_scene, rpr_image,),
        scene, image
    )
    check_error(is_error)
    nothing
end


#* @brief Get background image
#
#  @param  scene  The scene to get background image from
#  @param  status RPR_SUCCESS in case of success, error code otherwise
#  @return        Image object
#/
# out_image);
function SceneGetBackgroundImage(scene)
    out_image = Array(rpr_image, 1);
    is_error = ccall(
        (:rprSceneGetBackgroundImage, firelib), rpr_int,
        (rpr_scene, rpr_image,),
        scene, out_image
    )
    check_error(is_error)
    out_image[]
end


#* @brief Set camera for the scene
#
#  This is the main camera which for rays generation for the scene.
#
#  @param  scene  The scene to set camera for
#  @param  camera Camera
#  @return        RPR_SUCCESS in case of success, error code otherwise
#/
function SceneSetCamera(scene, camera)

    is_error = ccall(
        (:rprSceneSetCamera, firelib), rpr_int,
        (rpr_scene, rpr_camera,),
        scene, camera
    )
    check_error(is_error)
    nothing
end


#* @brief Get camera for the scene
#
#  @param  scene  The scene to get camera for
#  @param  status RPR_SUCCESS in case of success, error code otherwise
#  @return camera id for the camera if any, NULL otherwise
#/
# out_camera);
function SceneGetCamera(scene)
    out_camera = Array(rpr_camera, 1);
    is_error = ccall(
        (:rprSceneGetCamera, firelib), rpr_int,
        (rpr_scene, rpr_camera,),
        scene, out_camera
    )
    check_error(is_error)
    out_camera[]
end


# rpr_framebuffer
#* @brief Query information about a framebuffer
#
#  The workflow is usually two-step: query with the data == NULL to get the required buffer size,
#  then query with size_ret == NULL to fill the buffer with the data
#   Possible error codes:
#      RPR_ERROR_INVALID_PARAMETER
#
#  @param  framebuffer  Framebuffer object to query
#  @param  info         The type of info to query
#  @param  size         The size of the buffer pointed by data
#  @param  data         The buffer to store queried info
#  @param  size_ret     Returns the size in bytes of the data being queried
#  @return              RPR_SUCCESS in case of success, error code otherwise
#/
# data, size_t * size_ret);
function FrameBufferGetInfo(framebuffer, info, size, data, size_ret)

    is_error = ccall(
        (:rprFrameBufferGetInfo, firelib), rpr_int,
        (rpr_framebuffer, rpr_framebuffer_info, Csize_t, Ptr{Void}, Ptr{Csize_t},),
        framebuffer, info, size, data, size_ret
    )
    check_error(is_error)
    nothing
end


#* @brief Clear contents of a framebuffer to zero
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  The call is blocking and the image is ready when returned
#
#  @param  frame_buffer  Framebuffer to clear
#  @return              RPR_SUCCESS in case of success, error code otherwise
#/
function FrameBufferClear(frame_buffer)

    is_error = ccall(
        (:rprFrameBufferClear, firelib), rpr_int,
        (rpr_framebuffer,),
        frame_buffer
    )
    check_error(is_error)
    nothing
end


#* @brief Save frame buffer to file
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#  @param  frame_buffer Frame buffer to save
#  @param  path         Path to file
#  @return              RPR_SUCCESS in case of success, error code otherwise
#/
# file_path);
function FrameBufferSaveToFile(frame_buffer, file_path)

    is_error = ccall(
        (:rprFrameBufferSaveToFile, firelib), rpr_int,
        (rpr_framebuffer, Ptr{rpr_char},),
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
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#/
function ContextResolveFrameBuffer(context, src_frame_buffer, dst_frame_buffer, normalizeOnly)

    is_error = ccall(
        (:rprContextResolveFrameBuffer, firelib), rpr_int,
        (rpr_context, rpr_framebuffer, rpr_framebuffer, rpr_bool,),
        context, src_frame_buffer, dst_frame_buffer, normalizeOnly
    )
    check_error(is_error)
    nothing
end


#* @brief Create material system
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# out_matsys);
function ContextCreateMaterialSystem(in_context, typ)
    out_matsys = Array(rpr_material_system, 1);
    is_error = ccall(
        (:rprContextCreateMaterialSystem, firelib), rpr_int,
        (rpr_context, rpr_material_system_type, rpr_material_system,),
        in_context, typ, out_matsys
    )
    check_error(is_error)
    out_matsys[]
end


#* @brief Create material node
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# out_node);
function MaterialSystemCreateNode(in_matsys, in_type)
    out_node = Array(rpr_material_node, 1);
    is_error = ccall(
        (:rprMaterialSystemCreateNode, firelib), rpr_int,
        (rpr_material_system, rpr_material_node_type, rpr_material_node,),
        in_matsys, in_type, out_node
    )
    check_error(is_error)
    out_node[]
end


#* @brief Connect nodes
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, rpr_material_node in_input_node);
function MaterialNodeSetInputN(in_node, in_input, in_input_node)

    is_error = ccall(
        (:rprMaterialNodeSetInputN, firelib), rpr_int,
        (rpr_material_node, Ptr{rpr_char}, rpr_material_node,),
        in_node, in_input, in_input_node
    )
    check_error(is_error)
    nothing
end


#* @brief Set float input value
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, rpr_float in_value_x, rpr_float in_value_y, rpr_float in_value_z, rpr_float in_value_w);
function MaterialNodeSetInputF(in_node, in_input, in_value_x, in_value_y, in_value_z, in_value_w)

    is_error = ccall(
        (:rprMaterialNodeSetInputF, firelib), rpr_int,
        (rpr_material_node, Ptr{rpr_char}, rpr_float, rpr_float, rpr_float, rpr_float,),
        in_node, in_input, in_value_x, in_value_y, in_value_z, in_value_w
    )
    check_error(is_error)
    nothing
end


#* @brief Set uint input value
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, rpr_uint in_value);
function MaterialNodeSetInputU(in_node, in_input, in_value)

    is_error = ccall(
        (:rprMaterialNodeSetInputU, firelib), rpr_int,
        (rpr_material_node, Ptr{rpr_char}, rpr_uint,),
        in_node, in_input, in_value
    )
    check_error(is_error)
    nothing
end


#* @brief Set image input value
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# in_input, rpr_image image);
function MaterialNodeSetInputImageData(in_node, in_input, image)

    is_error = ccall(
        (:rprMaterialNodeSetInputImageData, firelib), rpr_int,
        (rpr_material_node, Ptr{rpr_char}, rpr_image,),
        in_node, in_input, image
    )
    check_error(is_error)
    nothing
end

# in_data, size_t * out_size);
function MaterialNodeGetInfo(in_node, in_info, in_size, in_data)
    out_size = Array(Csize_t, 1);
    is_error = ccall(
        (:rprMaterialNodeGetInfo, firelib), rpr_int,
        (rpr_material_node, rpr_material_node_info, Csize_t, Ptr{Void}, Csize_t,),
        in_node, in_info, in_size, in_data, out_size
    )
    check_error(is_error)
    out_size[]
end

# in_data, size_t * out_size);
function MaterialNodeGetInputInfo(in_node, in_input_idx, in_info, in_size, in_data)
    out_size = Array(Csize_t, 1);
    is_error = ccall(
        (:rprMaterialNodeGetInputInfo, firelib), rpr_int,
        (rpr_material_node, rpr_int, rpr_material_node_input_info, Csize_t, Ptr{Void}, Csize_t,),
        in_node, in_input_idx, in_info, in_size, in_data, out_size
    )
    check_error(is_error)
    out_size[]
end


#* @brief Delete object
#
#  rprObjectDelete(obj) deletes 'obj' from memory.
#  User has to make sure that 'obj' will not be used anymore after this call.
#
#   Possible error codes:
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#
#/
# obj);
function ObjectDelete(obj)

    is_error = ccall(
        (:rprObjectDelete, firelib), rpr_int,
        (Ptr{Void},),
        obj
    )
    check_error(is_error)
    nothing
end


#* @brief Set material node name
#
#
#  @param  node        Node to set the name for
#  @param  name       NULL terminated string name
#  @return             RPR_SUCCESS in case of success, error code otherwise
#/
# node, rpr_char const * name);
function ObjectSetName(node, name)

    is_error = ccall(
        (:rprObjectSetName, firelib), rpr_int,
        (Ptr{Void}, Ptr{rpr_char},),
        node, name
    )
    check_error(is_error)
    nothing
end


# rpr_post_effect
#* @brief Create post effect
#
#  Create analytic point light represented by a point in space.
#  Possible error codes:
#      RPR_ERROR_OUT_OF_VIDEO_MEMORY
#      RPR_ERROR_OUT_OF_SYSTEM_MEMORY
#
#  @param  context The context to create a light for
#  @param  status  RPR_SUCCESS in case of success, error code otherwise
#  @return         Light object
#/
# out_effect);
function ContextCreatePostEffect(context, typ)
    out_effect = Array(rpr_post_effect, 1);
    is_error = ccall(
        (:rprContextCreatePostEffect, firelib), rpr_int,
        (rpr_context, rpr_post_effect_type, rpr_post_effect,),
        context, typ, out_effect
    )
    check_error(is_error)
    out_effect[]
end

function ContextAttachPostEffect(context, effect)

    is_error = ccall(
        (:rprContextAttachPostEffect, firelib), rpr_int,
        (rpr_context, rpr_post_effect,),
        context, effect
    )
    check_error(is_error)
    nothing
end

function ContextDetachPostEffect(context, effect)

    is_error = ccall(
        (:rprContextDetachPostEffect, firelib), rpr_int,
        (rpr_context, rpr_post_effect,),
        context, effect
    )
    check_error(is_error)
    nothing
end

# name, rpr_uint x);
function PostEffectSetParameter1u(effect, name, x)

    is_error = ccall(
        (:rprPostEffectSetParameter1u, firelib), rpr_int,
        (rpr_post_effect, Ptr{rpr_char}, rpr_uint,),
        effect, name, x
    )
    check_error(is_error)
    nothing
end

# name, rpr_float x);
function PostEffectSetParameter1f(effect, name, x)

    is_error = ccall(
        (:rprPostEffectSetParameter1f, firelib), rpr_int,
        (rpr_post_effect, Ptr{rpr_char}, rpr_float,),
        effect, name, x
    )
    check_error(is_error)
    nothing
end

# name, rpr_float x, rpr_float y, rpr_float z);
function PostEffectSetParameter3f(effect, name, x, y, z)

    is_error = ccall(
        (:rprPostEffectSetParameter3f, firelib), rpr_int,
        (rpr_post_effect, Ptr{rpr_char}, rpr_float, rpr_float, rpr_float,),
        effect, name, x, y, z
    )
    check_error(is_error)
    nothing
end

# name, rpr_float x, rpr_float y, rpr_float z, rpr_float w);
function PostEffectSetParameter4f(effect, name, x, y, z, w)

    is_error = ccall(
        (:rprPostEffectSetParameter4f, firelib), rpr_int,
        (rpr_post_effect, Ptr{rpr_char}, rpr_float, rpr_float, rpr_float, rpr_float,),
        effect, name, x, y, z, w
    )
    check_error(is_error)
    nothing
end

#**************compatibility part**************
const fr_char = rpr_char
const fr_uchar = rpr_uchar
const fr_int = rpr_int
const fr_uint = rpr_uint
const fr_long = rpr_long
const fr_ulong = rpr_ulong
const fr_short = rpr_short
const fr_ushort = rpr_ushort
const fr_float = rpr_float
const fr_double = rpr_double
const fr_longlong = rpr_longlong
const fr_bool = rpr_bool
const fr_bitfield = rpr_bitfield
const fr_context = rpr_context
const fr_camera = rpr_camera
const fr_shape = rpr_shape
const fr_light = rpr_light
const fr_scene = rpr_scene
const fr_image = rpr_image
const fr_framebuffer = rpr_framebuffer
const fr_material_system = rpr_material_system
const fr_material_node = rpr_material_node
const fr_post_effect = rpr_post_effect
const fr_context_properties = rpr_context_properties
const fr_light_type = rpr_light_type
const fr_image_type = rpr_image_type
const fr_shape_type = rpr_shape_type
const fr_context_type = rpr_context_type
const fr_creation_flags = rpr_creation_flags
const fr_aa_filter = rpr_aa_filter
const fr_context_info = rpr_context_info
const fr_camera_info = rpr_camera_info
const fr_image_info = rpr_image_info
const fr_shape_info = rpr_shape_info
const fr_mesh_info = rpr_mesh_info
const fr_mesh_polygon_info = rpr_mesh_polygon_info
const fr_mesh_polygon_vertex_info = rpr_mesh_polygon_vertex_info
const fr_light_info = rpr_light_info
const fr_scene_info = rpr_scene_info
const fr_parameter_info = rpr_parameter_info
const fr_framebuffer_info = rpr_framebuffer_info
const fr_channel_order = rpr_channel_order
const fr_channel_type = rpr_channel_type
const fr_parameter_type = rpr_parameter_type
const fr_render_mode = rpr_render_mode
const fr_component_type = rpr_component_type
const fr_camera_mode = rpr_camera_mode
const fr_tonemapping_operator = rpr_tonemapping_operator
const fr_volume_type = rpr_volume_type
const fr_material_system_type = rpr_material_system_type
const fr_material_node_type = rpr_material_node_type
const fr_material_node_input = rpr_material_node_input
const fr_material_node_info = rpr_material_node_info
const fr_material_node_input_info = rpr_material_node_input_info
const fr_aov = rpr_aov
const fr_post_effect_type = rpr_post_effect_type
const fr_post_effect_info = rpr_post_effect_info
const fr_color_space = rpr_color_space
const fr_environment_override = rpr_environment_override
const fr_subdiv_boundary_interfop_type = rpr_subdiv_boundary_interfop_type
const fr_material_node_lookup_value = rpr_material_node_lookup_value
const fr_image_wrap_type = rpr_image_wrap_type
const _fr_image_desc = _rpr_image_desc
const fr_image_desc = rpr_image_desc
const _fr_framebuffer_desc = _rpr_framebuffer_desc
const fr_framebuffer_desc = rpr_framebuffer_desc
const _fr_render_statistics = _rpr_render_statistics
const fr_render_statistics = rpr_render_statistics
const _fr_image_format = _rpr_image_format
const fr_image_format = rpr_image_format
#const _fr_ies_image_desc = _rpr_ies_image_desc
#const fr_ies_image_desc = rpr_ies_image_desc
const fr_framebuffer_format = rpr_framebuffer_format
# path);
# pluginIDs, size_t pluginCount, fr_creation_flags creation_flags, fr_context_properties const * props, fr_char const * cache_path, fr_context * out_context);
# data, size_t * size_ret);
# data, size_t * size_ret);
# out_fb);
# out_scene);
# name, fr_uint x);
# name, fr_float x);
# name, fr_float x, fr_float y, fr_float z);
# name, fr_float x, fr_float y, fr_float z, fr_float w);
# name, fr_char const * value);
# image_desc, void const * data, fr_image * out_image);
# path, fr_image * out_image);
# out_scene);
# out_instance);
# vertices, size_t num_vertices, fr_int vertex_stride, fr_float const * normals, size_t num_normals, fr_int normal_stride, fr_float const * texcoords, size_t num_texcoords, fr_int texcoord_stride, fr_int const * vertex_indices, fr_int vidx_stride, fr_int const * normal_indices, fr_int nidx_stride, fr_int const * texcoord_indices, fr_int tidx_stride, fr_int const * num_face_vertices, size_t num_faces, fr_shape * out_mesh);
# vertices, size_t num_vertices, fr_int vertex_stride, fr_float const * normals, size_t num_normals, fr_int normal_stride, fr_int const * perVertexFlag, size_t num_perVertexFlags, fr_int perVertexFlag_stride, fr_int numberOfTexCoordLayers, fr_float const ** texcoords, size_t * num_texcoords, fr_int * texcoord_stride, fr_int const * vertex_indices, fr_int vidx_stride, fr_int const * normal_indices, fr_int nidx_stride, fr_int const ** texcoord_indices, fr_int * tidx_stride, fr_int const * num_face_vertices, size_t num_faces, fr_shape * out_mesh);
# out_camera);
# fb_desc, fr_framebuffer * out_fb);
# data, size_t * size_ret);
# transform);
# data, size_t * size_ret);
# transform);
# transform);
# arg3, size_t * arg4);
# data, size_t * size_ret);
# data, size_t * size_ret);
# out_shape);
# out_light);
# light);
# out_light);
# out_light);
# out_light);
# light);
# imagePath, fr_int nx, fr_int ny);
# iesData, fr_int nx, fr_int ny);
# data, size_t * size_ret);
# data, size_t * size_ret);
# out_light);
# out_image);
# out_camera);
# data, size_t * size_ret);
# file_path);
# out_matsys);
# out_node);
# in_input, fr_material_node in_input_node);
# in_input, fr_float in_value_x, fr_float in_value_y, fr_float in_value_z, fr_float in_value_w);
# in_input, fr_uint in_value);
# in_input, fr_image image);
# in_data, size_t * out_size);
# in_data, size_t * out_size);
# obj);
# node, fr_char const * name);
# out_effect);
# name, fr_uint x);
# name, fr_float x);
# name, fr_float x, fr_float y, fr_float z);
# name, fr_float x, fr_float y, fr_float z, fr_float w);


#__RADEONPRORENDER_H

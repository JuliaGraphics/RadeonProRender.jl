abstract type RPRMaterial end

struct Material{Typ} <: RPRMaterial
    node::MaterialNode
end

const ALL_MATERIALS = [
    :Diffuse => RPR.RPR_MATERIAL_NODE_DIFFUSE,
    :Microfacet => RPR.RPR_MATERIAL_NODE_MICROFACET,
    :Reflection => RPR.RPR_MATERIAL_NODE_REFLECTION,
    :Refraction => RPR.RPR_MATERIAL_NODE_REFRACTION,
    :MicrofacetRefraction => RPR.RPR_MATERIAL_NODE_MICROFACET_REFRACTION,
    :Transparent => RPR.RPR_MATERIAL_NODE_TRANSPARENT,
    :Emissive => RPR.RPR_MATERIAL_NODE_EMISSIVE,
    :Ward => RPR.RPR_MATERIAL_NODE_WARD,
    :Add => RPR.RPR_MATERIAL_NODE_ADD,
    :Blend => RPR.RPR_MATERIAL_NODE_BLEND,
    :Arithmetic => RPR.RPR_MATERIAL_NODE_ARITHMETIC,
    :Fresnel => RPR.RPR_MATERIAL_NODE_FRESNEL,
    :NormalMap => RPR.RPR_MATERIAL_NODE_NORMAL_MAP,
    :ImageTexture => RPR.RPR_MATERIAL_NODE_IMAGE_TEXTURE,
    :Noise2dTexture => RPR.RPR_MATERIAL_NODE_NOISE2D_TEXTURE,
    :DotTexture => RPR.RPR_MATERIAL_NODE_DOT_TEXTURE,
    :GradientTexture => RPR.RPR_MATERIAL_NODE_GRADIENT_TEXTURE,
    :CheckerTexture => RPR.RPR_MATERIAL_NODE_CHECKER_TEXTURE,
    :ConstantTexture => RPR.RPR_MATERIAL_NODE_CONSTANT_TEXTURE,
    :InputLookup => RPR.RPR_MATERIAL_NODE_INPUT_LOOKUP,
    :BlendValue => RPR.RPR_MATERIAL_NODE_BLEND_VALUE,
    :Passthrough => RPR.RPR_MATERIAL_NODE_PASSTHROUGH,
    :Orennayar => RPR.RPR_MATERIAL_NODE_ORENNAYAR,
    :FresnelSchlick => RPR.RPR_MATERIAL_NODE_FRESNEL_SCHLICK,
    :DiffuseRefraction => RPR.RPR_MATERIAL_NODE_DIFFUSE_REFRACTION,
    :BumpMap => RPR.RPR_MATERIAL_NODE_BUMP_MAP,
    :Volume => RPR.RPR_MATERIAL_NODE_VOLUME,
    :MicrofacetAnisotropicReflection => RPR.RPR_MATERIAL_NODE_MICROFACET_ANISOTROPIC_REFLECTION,
    :MicrofacetAnisotropicRefraction => RPR.RPR_MATERIAL_NODE_MICROFACET_ANISOTROPIC_REFRACTION,
    :Twosided => RPR.RPR_MATERIAL_NODE_TWOSIDED,
    :UvProcedural => RPR.RPR_MATERIAL_NODE_UV_PROCEDURAL,
    :MicrofacetBeckmann => RPR.RPR_MATERIAL_NODE_MICROFACET_BECKMANN,
    :Phong => RPR.RPR_MATERIAL_NODE_PHONG,
    :BufferSampler => RPR.RPR_MATERIAL_NODE_BUFFER_SAMPLER,
    :UvTriplanar => RPR.RPR_MATERIAL_NODE_UV_TRIPLANAR,
    :AoMap => RPR.RPR_MATERIAL_NODE_AO_MAP,
    :UserTexture_0 => RPR.RPR_MATERIAL_NODE_USER_TEXTURE_0,
    :UserTexture_1 => RPR.RPR_MATERIAL_NODE_USER_TEXTURE_1,
    :UserTexture_2 => RPR.RPR_MATERIAL_NODE_USER_TEXTURE_2,
    :UserTexture_3 => RPR.RPR_MATERIAL_NODE_USER_TEXTURE_3,
    :Uber => RPR.RPR_MATERIAL_NODE_UBERV2,
    :Transform => RPR.RPR_MATERIAL_NODE_TRANSFORM,
    :RgbToHsv => RPR.RPR_MATERIAL_NODE_RGB_TO_HSV,
    :HsvToRgb => RPR.RPR_MATERIAL_NODE_HSV_TO_RGB,
    :UserTexture => RPR.RPR_MATERIAL_NODE_USER_TEXTURE,
    :ToonClosure => RPR.RPR_MATERIAL_NODE_TOON_CLOSURE,
    :ToonRamp => RPR.RPR_MATERIAL_NODE_TOON_RAMP,
    :VoronoiTexture => RPR.RPR_MATERIAL_NODE_VORONOI_TEXTURE,
    :GridSampler => RPR.RPR_MATERIAL_NODE_GRID_SAMPLER,
    :Blackbody => RPR.RPR_MATERIAL_NODE_BLACKBODY,
    :MatxDiffuseBrdf => RPR.RPR_MATERIAL_NODE_MATX_DIFFUSE_BRDF,
    :MatxDielectricBrdf => RPR.RPR_MATERIAL_NODE_MATX_DIELECTRIC_BRDF,
    :MatxGeneralizedSchlickBrdf => RPR.RPR_MATERIAL_NODE_MATX_GENERALIZED_SCHLICK_BRDF,
    :MatxNoise3d => RPR.RPR_MATERIAL_NODE_MATX_NOISE3D,
    :MatxTangent => RPR.RPR_MATERIAL_NODE_MATX_TANGENT,
    :MatxNormal => RPR.RPR_MATERIAL_NODE_MATX_NORMAL,
    :MatxPosition => RPR.RPR_MATERIAL_NODE_MATX_POSITION,
    :MatxRoughnessAnisotropy => RPR.RPR_MATERIAL_NODE_MATX_ROUGHNESS_ANISOTROPY,
    :MatxRotate3d => RPR.RPR_MATERIAL_NODE_MATX_ROTATE3D,
    :MatxNormalize => RPR.RPR_MATERIAL_NODE_MATX_NORMALIZE,
    :MatxIfgreater => RPR.RPR_MATERIAL_NODE_MATX_IFGREATER,
    :MatxSheenBrdf => RPR.RPR_MATERIAL_NODE_MATX_SHEEN_BRDF,
    :MatxDiffuseBtdf => RPR.RPR_MATERIAL_NODE_MATX_DIFFUSE_BTDF,
    :MatxConvert => RPR.RPR_MATERIAL_NODE_MATX_CONVERT,
    :MatxSubsurfaceBrdf => RPR.RPR_MATERIAL_NODE_MATX_SUBSURFACE_BRDF,
    :MatxDielectricBtdf => RPR.RPR_MATERIAL_NODE_MATX_DIELECTRIC_BTDF,
    :MatxConductorBrdf => RPR.RPR_MATERIAL_NODE_MATX_CONDUCTOR_BRDF,
    :MatxFresnel => RPR.RPR_MATERIAL_NODE_MATX_FRESNEL,
    :MatxLuminance => RPR.RPR_MATERIAL_NODE_MATX_LUMINANCE,
    :MatxFractal3d => RPR.RPR_MATERIAL_NODE_MATX_FRACTAL3D,
    :MatxMix => RPR.RPR_MATERIAL_NODE_MATX_MIX,
    :Matx => RPR.RPR_MATERIAL_NODE_MATX
]

for (name, enum) in ALL_MATERIALS
    @eval const $(Symbol(name, :Material)) = Material{$(enum)}
end

function (::Type{Material{Typ}})(matsys::MaterialSystem) where Typ
    return Material{Typ}(MaterialNode(matsys, Typ))
end

function Base.setproperty!(material::T, field::Symbol, value::Vec4) where T <: Material
    set!(material.node, field2enum(T, field), value...)
end

function Base.setproperty!(material::T, field::Symbol, value::Vec3) where T <: Material
    set!(material.node, field2enum(T, field), value..., 0.0)
end

function Base.setproperty!(material::T, field::Symbol, value) where T <: Material
    set!(material.node, field2enum(T, field), value)
end

function Base.setproperty!(material::T, field::Symbol, c::Color3) where T <: Material
    set!(material.node, field2enum(T, field), red(c), green(c), blue(c), 0.0)
end

function Base.setproperty!(material::T, field::Symbol, value::Nothing) where T <: Material
    # TODO, can you actually unset a material property?
end

function field2enum(::Type{T}, field::Symbol) where T
    info = material_info(T)
    if haskey(info, field)
        return getfield(info, field)
    else
        error("Material $(T) doesn't have the property $(field)")
    end
end

function Base.propertynames(m::T) where T <: Material
    info = material_info(T)
    return propertynames(info)
end

function material_info(::Type{UberMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_COLOR,
        diffuse_weight = RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_WEIGHT,
        diffuse_roughness = RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_ROUGHNESS,
        diffuse_normal = RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_NORMAL,

        reflection_color = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_COLOR,
        reflection_weight = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_WEIGHT,
        reflection_roughness = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ROUGHNESS,
        reflection_anisotropy = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ANISOTROPY,
        reflection_anisotropy_rotation = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ANISOTROPY_ROTATION,
        reflection_mode = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_MODE,
        reflection_ior = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_IOR,
        reflection_metalness = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_METALNESS,
        reflection_normal = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_NORMAL,
        reflection_dielectric_reflectance = RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_DIELECTRIC_REFLECTANCE,

        refraction_color = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_COLOR,
        refraction_weight = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_WEIGHT,
        refraction_roughness = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ROUGHNESS,
        refraction_ior = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_IOR,
        refraction_normal = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_NORMAL,
        refraction_thin_surface = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_THIN_SURFACE,
        refraction_absorption_color = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_COLOR,
        refraction_absorption_distance = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_DISTANCE,
        refraction_caustics = RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_CAUSTICS,

        coating_color = RPR.RPR_MATERIAL_INPUT_UBER_COATING_COLOR,
        coating_weight = RPR.RPR_MATERIAL_INPUT_UBER_COATING_WEIGHT,
        coating_roughness = RPR.RPR_MATERIAL_INPUT_UBER_COATING_ROUGHNESS,
        coating_mode = RPR.RPR_MATERIAL_INPUT_UBER_COATING_MODE,
        coating_ior = RPR.RPR_MATERIAL_INPUT_UBER_COATING_IOR,
        coating_metalness = RPR.RPR_MATERIAL_INPUT_UBER_COATING_METALNESS,
        coating_normal = RPR.RPR_MATERIAL_INPUT_UBER_COATING_NORMAL,
        coating_transmission_color = RPR.RPR_MATERIAL_INPUT_UBER_COATING_TRANSMISSION_COLOR,
        coating_thickness = RPR.RPR_MATERIAL_INPUT_UBER_COATING_THICKNESS,

        sheen = RPR.RPR_MATERIAL_INPUT_UBER_SHEEN,
        sheen_tint = RPR.RPR_MATERIAL_INPUT_UBER_SHEEN_TINT,
        sheen_weight = RPR.RPR_MATERIAL_INPUT_UBER_SHEEN_WEIGHT,
        emission_color = RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_COLOR,
        emission_weight = RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_WEIGHT,
        emission_mode = RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_MODE,
        transparency = RPR.RPR_MATERIAL_INPUT_UBER_TRANSPARENCY,

        sss_scatter_color = RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_COLOR,
        sss_scatter_distance = RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DISTANCE,
        sss_scatter_direction = RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DIRECTION,
        sss_weight = RPR.RPR_MATERIAL_INPUT_UBER_SSS_WEIGHT,
        sss_multiscatter = RPR.RPR_MATERIAL_INPUT_UBER_SSS_MULTISCATTER,
        backscatter_weight = RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_WEIGHT,
        backscatter_color = RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_COLOR,
        fresnel_schlick_approximation = RPR.RPR_MATERIAL_INPUT_UBER_FRESNEL_SCHLICK_APPROXIMATION,
    )
end

function material_info(::Type{DiffuseMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_COLOR,
        normal = RPR.RPR_MATERIAL_INPUT_NORMAL,
        roughness = RPR.RPR_MATERIAL_INPUT_ROUGHNESS,
    )
end

function material_info(::Type{DiffuseRefractionMaterial})
    return material_info(DiffuseMaterial)
end


function material_info(::Type{BumpMapMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_COLOR,
        scale = RPR.RPR_MATERIAL_INPUT_SCALE
    )
end

function material_info(::Type{VolumeMaterial})
    return (
        scattering = RPR.RPR_MATERIAL_INPUT_SCATTERING,
        absorption = RPR.RPR_MATERIAL_INPUT_ABSORBTION,
        emission = RPR.RPR_MATERIAL_INPUT_EMISSION,
        scatter_direction = RPR.RPR_MATERIAL_INPUT_G,
        multiscatter = RPR.RPR_MATERIAL_INPUT_MULTISCATTER,
    )
end

function material_info(::Type{MicrofacetAnisotropicReflectionMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_COLOR,
        normal = RPR.RPR_MATERIAL_INPUT_NORMAL,
        ior = RPR.RPR_MATERIAL_INPUT_IOR,
        roughness = RPR.RPR_MATERIAL_INPUT_ROUGHNESS,
        anisotropic = RPR.RPR_MATERIAL_INPUT_ANISOTROPIC,
        rotation = RPR.RPR_MATERIAL_INPUT_ROTATION,
    )
end

function material_info(::Type{BlendMaterial})
    return (
        color1 = RPR.RPR_MATERIAL_INPUT_COLOR0,
        color2 = RPR.RPR_MATERIAL_INPUT_COLOR1,
        weight = RPR.RPR_MATERIAL_INPUT_WEIGHT,
        transmission_color = RPR.RPR_MATERIAL_INPUT_TRANSMISSION_COLOR,
        thickness = RPR.RPR_MATERIAL_INPUT_THICKNESS,
    )
end

function material_info(::Type{MicrofacetAnisotropicRefractionMaterial})
    return material_info(MicrofacetAnisotropicReflectionMaterial)
end

function material_info(::Type{MicrofacetMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_COLOR,
        normal = RPR.RPR_MATERIAL_INPUT_NORMAL,
        ior = RPR.RPR_MATERIAL_INPUT_IOR,
        roughness = RPR.RPR_MATERIAL_INPUT_ROUGHNESS
    )
end

function material_info(::Type{TwosidedMaterial})
    return (
        frontface = RPR.RPR_MATERIAL_INPUT_FRONTFACE,
        backface = RPR.RPR_MATERIAL_INPUT_BACKFACE,
    )
end

function material_info(::Type{EmissiveMaterial})
    return (color = RPR.RPR_MATERIAL_INPUT_COLOR,)
end

function material_info(::Type{RefractionMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_COLOR,
        normal = RPR.RPR_MATERIAL_INPUT_NORMAL,
        ior = RPR.RPR_MATERIAL_INPUT_IOR,
        caustics = RPR.RPR_MATERIAL_INPUT_CAUSTICS
    )
end

function material_info(::Type{ReflectionMaterial})
    return (
        color = RPR.RPR_MATERIAL_INPUT_COLOR,
        normal = RPR.RPR_MATERIAL_INPUT_NORMAL,
    )
end

function material_field_info()
    f01 = (Float32, (0, 1))
    Dict(
        RPR.RPR_MATERIAL_INPUT_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_COLOR0 => Material,
        RPR.RPR_MATERIAL_INPUT_COLOR1 => Material,
        RPR.RPR_MATERIAL_INPUT_NORMAL => Vec3,
        RPR.RPR_MATERIAL_INPUT_UV => Vec2,
        RPR.RPR_MATERIAL_INPUT_DATA => Image,
        RPR.RPR_MATERIAL_INPUT_ROUGHNESS => f01,
        RPR.RPR_MATERIAL_INPUT_IOR => (Float32, (1,5)),
        RPR.RPR_MATERIAL_INPUT_ROUGHNESS_X => f01,
        RPR.RPR_MATERIAL_INPUT_ROUGHNESS_Y => f01,
        RPR.RPR_MATERIAL_INPUT_ROTATION => f01,
        RPR.RPR_MATERIAL_INPUT_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_OP => RPR.rpr_material_node_arithmetic_operation,
        # RPR.RPR_MATERIAL_INPUT_INVEC => ,
        # RPR.RPR_MATERIAL_INPUT_UV_SCALE => ,
        # RPR.RPR_MATERIAL_INPUT_VALUE => ,
        RPR.RPR_MATERIAL_INPUT_REFLECTANCE => f01,
        RPR.RPR_MATERIAL_INPUT_SCALE => f01,
        RPR.RPR_MATERIAL_INPUT_SCATTERING => RGBA,
        RPR.RPR_MATERIAL_INPUT_ABSORBTION => RGBA,
        RPR.RPR_MATERIAL_INPUT_EMISSION => RGBA,
        RPR.RPR_MATERIAL_INPUT_G => (Float32, (-1, 1)), #	Forward or back scattering.
        RPR.RPR_MATERIAL_INPUT_MULTISCATTER => Bool,

        RPR.RPR_MATERIAL_INPUT_COLOR2 => RGBA,
        RPR.RPR_MATERIAL_INPUT_COLOR3 => RGBA,
        RPR.RPR_MATERIAL_INPUT_ANISOTROPIC => (Float32, (-1, 1)), # amount forwards/backward
        RPR.RPR_MATERIAL_INPUT_FRONTFACE => Material,
        RPR.RPR_MATERIAL_INPUT_BACKFACE => Material,
        # RPR.RPR_MATERIAL_INPUT_ORIGIN => ,
        # RPR.RPR_MATERIAL_INPUT_ZAXIS => ,
        # RPR.RPR_MATERIAL_INPUT_XAXIS => ,
        # RPR.RPR_MATERIAL_INPUT_THRESHOLD => ,
        # RPR.RPR_MATERIAL_INPUT_OFFSET => ,
        # RPR.RPR_MATERIAL_INPUT_UV_TYPE => ,
        # RPR.RPR_MATERIAL_INPUT_RADIUS => ,
        # RPR.RPR_MATERIAL_INPUT_SIDE => ,
        RPR.RPR_MATERIAL_INPUT_CAUSTICS => Bool,
        RPR.RPR_MATERIAL_INPUT_TRANSMISSION_COLOR => RGBA,
        RPR.RPR_MATERIAL_INPUT_THICKNESS => f01,
        # RPR.RPR_MATERIAL_INPUT_0 => ,
        # RPR.RPR_MATERIAL_INPUT_1 => ,
        # RPR.RPR_MATERIAL_INPUT_2 => ,
        # RPR.RPR_MATERIAL_INPUT_3 => ,
        # RPR.RPR_MATERIAL_INPUT_4 => ,
        RPR.RPR_MATERIAL_INPUT_SCHLICK_APPROXIMATION => Float32,
        # RPR.RPR_MATERIAL_INPUT_APPLYSURFACE => ,
        # RPR.RPR_MATERIAL_INPUT_TANGENT => ,
        # RPR.RPR_MATERIAL_INPUT_DISTRIBUTION => ,
        # RPR.RPR_MATERIAL_INPUT_BASE => ,
        # RPR.RPR_MATERIAL_INPUT_TINT => ,
        # RPR.RPR_MATERIAL_INPUT_EXPONENT => ,
        # RPR.RPR_MATERIAL_INPUT_AMPLITUDE => ,
        # RPR.RPR_MATERIAL_INPUT_PIVOT => ,
        # RPR.RPR_MATERIAL_INPUT_POSITION => ,
        # RPR.RPR_MATERIAL_INPUT_AMOUNT => ,
        # RPR.RPR_MATERIAL_INPUT_AXIS => ,
        # RPR.RPR_MATERIAL_INPUT_LUMACOEFF => ,
        # RPR.RPR_MATERIAL_INPUT_REFLECTIVITY => ,
        # RPR.RPR_MATERIAL_INPUT_EDGE_COLOR => ,
        # RPR.RPR_MATERIAL_INPUT_VIEW_DIRECTION => ,
        # RPR.RPR_MATERIAL_INPUT_INTERIOR => ,
        # RPR.RPR_MATERIAL_INPUT_OCTAVES => ,
        # RPR.RPR_MATERIAL_INPUT_LACUNARITY => ,
        # RPR.RPR_MATERIAL_INPUT_DIMINISH => ,
        # RPR.RPR_MATERIAL_INPUT_WRAP_U => ,
        # RPR.RPR_MATERIAL_INPUT_WRAP_V => ,
        # RPR.RPR_MATERIAL_INPUT_WRAP_W => ,
        # RPR.RPR_MATERIAL_INPUT_5 => ,
        # RPR.RPR_MATERIAL_INPUT_6 => ,
        # RPR.RPR_MATERIAL_INPUT_7 => ,
        # RPR.RPR_MATERIAL_INPUT_8 => ,
        # RPR.RPR_MATERIAL_INPUT_9 => ,
        # RPR.RPR_MATERIAL_INPUT_10 => ,
        # RPR.RPR_MATERIAL_INPUT_11 => ,
        # RPR.RPR_MATERIAL_INPUT_12 => ,
        # RPR.RPR_MATERIAL_INPUT_13 => ,
        # RPR.RPR_MATERIAL_INPUT_14 => ,
        # RPR.RPR_MATERIAL_INPUT_15 => ,
        # RPR.RPR_MATERIAL_INPUT_DIFFUSE_RAMP => ,
        # RPR.RPR_MATERIAL_INPUT_SHADOW => ,
        # RPR.RPR_MATERIAL_INPUT_MID => ,
        # RPR.RPR_MATERIAL_INPUT_HIGHLIGHT => ,
        # RPR.RPR_MATERIAL_INPUT_POSITION1 => ,
        # RPR.RPR_MATERIAL_INPUT_POSITION2 => ,
        # RPR.RPR_MATERIAL_INPUT_RANGE1 => ,
        # RPR.RPR_MATERIAL_INPUT_RANGE2 => ,
        # RPR.RPR_MATERIAL_INPUT_INTERPOLATION => ,
        # RPR.RPR_MATERIAL_INPUT_RANDOMNESS => ,
        # RPR.RPR_MATERIAL_INPUT_DIMENSION => ,
        # RPR.RPR_MATERIAL_INPUT_OUTTYPE => ,
        # RPR.RPR_MATERIAL_INPUT_DENSITY => ,
        # RPR.RPR_MATERIAL_INPUT_DENSITYGRID => ,
        # RPR.RPR_MATERIAL_INPUT_DISPLACEMENT => ,
        # RPR.RPR_MATERIAL_INPUT_TEMPERATURE => ,
        # RPR.RPR_MATERIAL_INPUT_KELVIN => ,
        RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_WEIGHT => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_ROUGHNESS => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_NORMAL => Vec3f,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ROUGHNESS => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ANISOTROPY => (Float32, (-1, 1)),
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ANISOTROPY_ROTATION => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_MODE => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_IOR => (Float32, (1, 5)),
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_METALNESS => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_NORMAL => Vec3f,
        RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_DIELECTRIC_REFLECTANCE => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ROUGHNESS => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_IOR => (Float32, (1, 5)),
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_NORMAL => Vec3f,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_THIN_SURFACE => Bool,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_DISTANCE => Float32, # soft 0-10
        RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_CAUSTICS => Bool,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_ROUGHNESS => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_MODE => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_IOR => (Float32, (1, 5)),
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_METALNESS => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_NORMAL => Vec3f,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_TRANSMISSION_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_COATING_THICKNESS => Float32, # soft 0-10
        RPR.RPR_MATERIAL_INPUT_UBER_SHEEN => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_SHEEN_TINT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_SHEEN_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_MODE => Bool,
        RPR.RPR_MATERIAL_INPUT_UBER_TRANSPARENCY => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_COLOR => RGB,
        RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DISTANCE => Vec3f, # soft 0-10
        RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DIRECTION => (Float32, (-1, 1)),
        RPR.RPR_MATERIAL_INPUT_UBER_SSS_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_SSS_MULTISCATTER => Bool,
        RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_WEIGHT => f01,
        RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_COLOR => RGB,
        # RPR.RPR_MATERIAL_INPUT_ADDRESS => ,
        # RPR.RPR_MATERIAL_INPUT_TYPE => ,
        # RPR.RPR_MATERIAL_INPUT_UBER_FRESNEL_SCHLICK_APPROXIMATION => ,
    )
end

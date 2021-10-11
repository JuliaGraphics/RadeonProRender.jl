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
    try
        set!(material.node, field2enum(T, field), value...)
    catch e
        error("Can't set field $(field) with $(value)")
    end
end

function Base.setproperty!(material::T, field::Symbol, value::Vec3) where T <: Material
    try
        set!(material.node, field2enum(T, field), value..., 0.0)
    catch e
        error("Can't set field $(field) with $(value)")
    end
end

function Base.setproperty!(material::T, field::Symbol, value) where T <: Material
    try
        set!(material.node, field2enum(T, field), value)
    catch e
        error("Can't set field $(field) with $(value)")
    end
end

function Base.setproperty!(material::T, field::Symbol, c::Color3) where T <: Material
    set!(material.node, field2enum(T, field), red(c), green(c), blue(c), 0.0)
end

function Base.setproperty!(material::T, field::Symbol, value::Nothing) where T <: Material
    # TODO, can you actually unset a material property?
end

function field2enum(::Type{UberMaterial}, field::Symbol)

    field === :diffuse_color && return RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_COLOR
    field === :diffuse_weight && return RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_WEIGHT
    field === :diffuse_roughness && return RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_ROUGHNESS
    field === :diffuse_normal && return RPR.RPR_MATERIAL_INPUT_UBER_DIFFUSE_NORMAL

    field === :reflection_color && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_COLOR
    field === :reflection_weight && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_WEIGHT
    field === :reflection_roughness && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ROUGHNESS
    field === :reflection_anisotropy && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ANISOTROPY
    field === :reflection_anisotropy_rotation && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_ANISOTROPY_ROTATION
    field === :reflection_mode && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_MODE
    field === :reflection_ior && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_IOR
    field === :reflection_metalness && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_METALNESS
    field === :reflection_normal && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_NORMAL
    field === :reflection_dielectric_reflectance && return RPR.RPR_MATERIAL_INPUT_UBER_REFLECTION_DIELECTRIC_REFLECTANCE

    field === :refraction_color && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_COLOR
    field === :refraction_weight && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_WEIGHT
    field === :refraction_roughness && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ROUGHNESS
    field === :refraction_ior && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_IOR
    field === :refraction_normal && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_NORMAL
    field === :refraction_thin_surface && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_THIN_SURFACE
    field === :refraction_absorption_color && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_COLOR
    field === :refraction_absorption_distance && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_ABSORPTION_DISTANCE
    field === :refraction_caustics && return RPR.RPR_MATERIAL_INPUT_UBER_REFRACTION_CAUSTICS

    field === :coating_color && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_COLOR
    field === :coating_weight && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_WEIGHT
    field === :coating_roughness && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_ROUGHNESS
    field === :coating_mode && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_MODE
    field === :coating_ior && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_IOR
    field === :coating_metalness && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_METALNESS
    field === :coating_normal && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_NORMAL
    field === :coating_transmission_color && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_TRANSMISSION_COLOR
    field === :coating_thickness && return RPR.RPR_MATERIAL_INPUT_UBER_COATING_THICKNESS

    field === :sheen && return RPR.RPR_MATERIAL_INPUT_UBER_SHEEN
    field === :sheen_tint && return RPR.RPR_MATERIAL_INPUT_UBER_SHEEN_TINT
    field === :sheen_weight && return RPR.RPR_MATERIAL_INPUT_UBER_SHEEN_WEIGHT
    field === :emission_color && return RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_COLOR
    field === :emission_weight && return RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_WEIGHT
    field === :emission_mode && return RPR.RPR_MATERIAL_INPUT_UBER_EMISSION_MODE
    field === :transparency && return RPR.RPR_MATERIAL_INPUT_UBER_TRANSPARENCY

    field === :sss_scatter_color && return RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_COLOR
    field === :sss_scatter_distance && return RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DISTANCE
    field === :sss_scatter_direction && return RPR.RPR_MATERIAL_INPUT_UBER_SSS_SCATTER_DIRECTION
    field === :sss_weight && return RPR.RPR_MATERIAL_INPUT_UBER_SSS_WEIGHT
    field === :sss_multiscatter && return RPR.RPR_MATERIAL_INPUT_UBER_SSS_MULTISCATTER
    field === :backscatter_weight && return RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_WEIGHT
    field === :backscatter_color && return RPR.RPR_MATERIAL_INPUT_UBER_BACKSCATTER_COLOR
    field === :fresnel_schlick_approximation && return RPR.RPR_MATERIAL_INPUT_UBER_FRESNEL_SCHLICK_APPROXIMATION
    error("Uber shader doesn't have the property: $(field)")
end

function defaults(::Type{UberMaterial})
    return (
        diffuse_color=RGB(1, 0, 0),
        diffuse_weight=Vec4(0.5),
        diffuse_roughness=Vec4(0.01),
        diffuse_normal=nothing,

        reflection_color=RGB(0, 0, 0),
        reflection_weight=Vec4(0),
        reflection_roughness=Vec4(0),
        reflection_anisotropy=Vec4(0),
        reflection_anisotropy_rotation=Vec4(0),
        reflection_mode=Vec4(0),
        reflection_ior=Vec4(0),
        reflection_metalness=Vec4(0),
        reflection_normal=nothing,
        # reflection_dielectric_reflectance=false,

        refraction_color=RGB(0, 0, 0),
        refraction_weight=Vec4(0),
        refraction_roughness=Vec4(0),
        refraction_ior=Vec4(0),
        refraction_normal=nothing,
        refraction_thin_surface=false,
        refraction_absorption_color=RGB(0, 0, 0),
        refraction_absorption_distance=Vec4(0),
        refraction_caustics=Vec4(0),

        coating_color=RGB(0, 0, 0),
        coating_weight=Vec4(0),
        coating_roughness=Vec4(0),
        coating_mode=Vec4(0),
        coating_ior=Vec4(0),
        coating_metalness=Vec4(0),
        coating_normal=nothing,
        coating_transmission_color=Vec4(0),
        coating_thickness=Vec4(0),

        sheen=Vec4(0),
        sheen_tint=Vec4(0),
        sheen_weight=Vec4(0),
        emission_color=Vec4(0),
        emission_weight=Vec4(0),
        emission_mode=Vec4(0),
        transparency=Vec4(0),

        sss_scatter_color=RGB(0, 0, 0),
        sss_scatter_distance=Vec4(0),
        sss_scatter_direction=Vec4(0),
        sss_weight=Vec4(0),
        sss_multiscatter=false,
        backscatter_weight=Vec4(0),
        backscatter_color=RGB(0, 0, 0),
        fresnel_schlick_approximation=Vec4(0),
    )
end

function field2enum(::Type{DiffuseMaterial}, field::Symbol)
    field === :diffuse_color && return RPR.RPR_MATERIAL_INPUT_COLOR
    field === :diffuse_normal && return RPR.RPR_MATERIAL_INPUT_NORMAL
    field === :diffuse_roughness && return RPR.RPR_MATERIAL_INPUT_ROUGHNESS
    error("DiffuseMaterial doesn't have the property: $(field)")
end

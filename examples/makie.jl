using Makie
using RadeonProRender, GeometryBasics, Colors

const RPR = RadeonProRender.RPR
const FR = RadeonProRender

struct RPRContext
    context::FR.Context
    matsys::FR.MaterialSystem
end

function RPRContext()
    context = FR.Context()
    return RPRContext(context, FR.MaterialSystem(context, 0))
end

function to_rpr_camera(context::RPRContext, cam)
    # Create camera
    camera = FR.Camera(context.context)

    map(cam.eyeposition) do position
        l, u = cam.lookat[], cam.upvector[]
        return lookat!(camera, position, l, u)
    end
    map(cam.fov) do fov
        return RPR.rprCameraSetFocalLength(camera, fov)
    end
    # RPR_CAMERA_FSTOP
    # RPR_CAMERA_FOCAL_LENGTH
    # RPR_CAMERA_SENSOR_SIZE
    # RPR_CAMERA_MODE
    # RPR_CAMERA_FOCUS_DISTANCE
    return camera
end

function mesh_material(context, plot)
    ambient = plot.ambient[]
    diffuse = plot.diffuse[]
    specular = plot.specular[]
    shininess = plot.shininess[]

    color = to_color(plot.color[])

    color_signal = if color isa AbstractMatrix{<:Number}
        map(vec2color, plot.color, plot.color_map, plot.colorrange)
    elseif color isa AbstractMatrix{<:Colorant}
        tex = FR.MaterialNode(context.matsys, RPR.RPR_MATERIAL_NODE_IMAGE_TEXTURE)
        map(plot.color) do color
            img = FR.Image(context.context, color)
            set!(tex, RPR.RPR_MATERIAL_INPUT_DATA, img)
            return tex
        end
    elseif color isa Colorant
        map(to_color, plot.color)
    else
        error("Unsupported color type for RadeonProRender backend: $(typeof(color))")
    end

    material = FR.MaterialNode(context.matsys, RPR.RPR_MATERIAL_NODE_PHONG)
    map(color_signal) do color
        return set!(material, RPR.RPR_MATERIAL_INPUT_COLOR, color)
    end

    return material
end

function to_rpr_mesh(context, plot::Makie.Mesh)
    # Potentially per instance attributes
    rpr_mesh = FR.Shape(context.context, to_value(plot[1]))

    material = mesh_material(context, plot)

    set!(rpr_mesh, material)

    return rpr_mesh
end

function draw_atomic(screen::FR.Scene, scene::Scene, x::Surface)
    robj = cached_robj!(screen, scene, x) do gl_attributes
        color = pop!(gl_attributes, :color)
        img = nothing
        # signals not supported for shading yet
        # We automatically insert x[3] into the color channel, so if it's equal we don't need to do anything
        if isa(to_value(color), AbstractMatrix{<:Number}) && to_value(color) !== to_value(x[3])
            img = el32convert(color)
        elseif to_value(color) isa Makie.AbstractPattern
            pattern_img = lift(x -> el32convert(Makie.to_image(x)), color)
            img = ShaderAbstractions.Sampler(pattern_img; x_repeat=:repeat, minfilter=:nearest)
            haskey(gl_attributes, :fetch_pixel) || (gl_attributes[:fetch_pixel] = true)
            gl_attributes[:color_map] = nothing
            gl_attributes[:color] = nothing
            gl_attributes[:color_norm] = nothing
        elseif isa(to_value(color), AbstractMatrix{<:Colorant})
            img = color
            gl_attributes[:color_map] = nothing
            gl_attributes[:color] = nothing
            gl_attributes[:color_norm] = nothing
        end

        gl_attributes[:image] = img
        gl_attributes[:shading] = to_value(get(gl_attributes, :shading, true))

        @assert to_value(x[3]) isa AbstractMatrix
        types = map(v -> typeof(to_value(v)), x[1:2])

        if all(T -> T <: Union{AbstractMatrix,AbstractVector}, types)
            t = Makie.transform_func_obs(scene)
            mat = x[3]
            xypos = map(t, x[1], x[2]) do t, x, y
                x1d = xy_convert(x, size(mat[], 1))
                y1d = xy_convert(y, size(mat[], 2))
                # Only if transform doesn't do anything, we can stay linear in 1/2D
                if Makie.is_identity_transform(t)
                    return (x1d, y1d)
                else
                    matrix = if x1d isa AbstractMatrix && y1d isa AbstractMatrix
                        apply_transform.((t,), Point.(x1d, y1d))
                    else
                        # If we do any transformation, we have to assume things aren't on the grid anymore
                        # so x + y need to become matrices.
                        [apply_transform(t, Point(x, y)) for x in x1d, y in y1d]
                    end
                    return (first.(matrix), last.(matrix))
                end
            end
            xpos = map(first, xypos)
            ypos = map(last, xypos)
            args = map((xpos, ypos, mat)) do arg
                return Texture(el32convert(arg); minfilter=:nearest)
            end
            return visualize(args, Style(:surface), gl_attributes)
        else
            gl_attributes[:ranges] = to_range.(to_value.(x[1:2]))
            z_data = Texture(el32convert(x[3]); minfilter=:nearest)
            return visualize(z_data, Style(:surface), gl_attributes)
        end
    end
    return robj
end

function draw_atomic(screen::FR.Scene, scene::Scene, vol::Volume)
    model = vol[:model]
    x, y, z = vol[1], vol[2], vol[3]
    gl_attributes[:model] = lift(model, x, y, z) do m, xyz...
        mi = minimum.(xyz)
        maxi = maximum.(xyz)
        w = maxi .- mi
        m2 = Mat4f(w[1], 0, 0, 0, 0, w[2], 0, 0, 0, 0, w[3], 0, mi[1], mi[2], mi[3], 1)
        return convert(Mat4f, m) * m2
    end
    return visualize(vol[4], Style(:default), gl_attributes)
end

"""
creates a transform from a translation, scale, rotation
"""
function transform!(shape::RPRObject, translate, scale, rot)
    s = scalematrix(Vec3f(scale))
    t = translationmatrix(Vec3f(translate))
    return transform!(shape, t * rot * s)
end

function transform!(shape::RPRObject, trans_scale_rot::Tuple)
    return transform!(shape, trans_scale_rot...)
end

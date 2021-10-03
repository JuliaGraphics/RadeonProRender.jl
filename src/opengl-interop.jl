import GLMakie.GLAbstraction: Texture, render, std_renderobject, LazyShader
import GLMakie.GLAbstraction: @frag_str, @vert_str
import ModernGL: GL_TEXTURE_2D

function FrameBuffer(context::Context, t::Texture{T,2}) where {T}
    frame_buffer = ContextCreateFramebufferFromGLTexture2D(context, GL_TEXTURE_2D, 0, t.id)
    x = FrameBuffer(frame_buffer)
    finalizer(release, x)
    return x
end

"""
Creates an interactive context with the help of glvisualize to view the texture
"""
function interactive_context(glwindow)
    context = Context(RPR_CREATION_FLAGS_ENABLE_GPU0 | RPR_CREATION_FLAGS_ENABLE_GL_INTEROP)
    w, h = widths(glwindow)
    texture = Texture(RGBA{Float16}, (w, h))
    view_tex(texture, glwindow)
    g_frame_buffer = FrameBuffer(context, texture)
    set!(context, RPR_AOV_COLOR, g_frame_buffer)
    return context, g_frame_buffer
end

"""
blocking renderloop that uses tiling
"""
function tiledrenderloop(glwindow, context, framebuffer)
    ti = TileIterator(widths(glwindow), (256, 256))
    tile_state = iterate(ti)
    while isopen(glwindow)
        glBindTexture(GL_TEXTURE_2D, 0)

        if isnothing(tile_state)
            # reset iterator
            tile_state = iterate(ti)
        end

        render(context, tile_state[1])

        tile_state = iterate(ti, tile_state[2])
        GLWindow.render_frame(glwindow)
    end
end

const tex_frag = frag"""
{{GLSL_VERSION}}
in vec2 o_uv;
out vec4 fragment_color;
out uvec2 fragment_groupid;

uniform sampler2D image;

void main(){
    vec4 color = texture(image, o_uv);
    fragment_color = color/color.a;
    fragment_groupid = uvec2(0);
}
"""

const tex_vert = vert"""
{{GLSL_VERSION}}

in vec2 vertices;
in vec2 texturecoordinates;

out vec2       o_uv;

void main(){
    o_uv        = texturecoordinates;
    gl_Position = vec4(vertices, 0, 1);
}
"""

"""
A matrix of colors is interpreted as an image
"""
function view_tex(tex::Texture{T,2}, window) where {T}
    data = Dict{Symbol,Any}(:image => tex,
                            :primitive => GLUVMesh2D(SimpleRectangle{Float32}(-1.0f0, -1.0f0, 2.0f0, 2.0f0)))
    robj = std_renderobject(data, LazyShader(tex_vert, tex_frag))
    return view(robj, window; camera=:nothing)
end

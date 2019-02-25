function text!(text::String, anchor::T2F; axes=nothing, o...)::Option{PreviewFigure}
    axes = check_axes(axes)
    t = Text2D(text=text, anchor=anchor)
    set_properties!(t; defer_preview=true, o...)
    push!(a.objects, t)
    return _preview()
end

"""
    text

See [`text!`](@ref).
"""
text = text!

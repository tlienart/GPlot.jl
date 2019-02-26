function text!(text::String, anchor::Tuple; axes=nothing, o...)
    axes = check_axes(axes)
    t = Text2D(text=text, anchor=fl(anchor))
    set_properties!(t; defer_preview=true, o...)
    push!(axes.objects, t)
    return preview()
end

"""
    text

See [`text!`](@ref).
"""
text = text!

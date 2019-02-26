# NOTE objects don't have the overwrite property. so with or witout ! they don't
# overwrite the axes they get placed on.

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
text(a...; o...) = text!(a...; o...)

function _line!(anchor::Float64, horiz::Bool; axes=nothing, o...)
    axes = check_axes(axes)
    l = StraightLine2D(anchor=anchor, horiz=horiz)
    set_properties!(l; defer_preview=true, o...)
    push!(axes.objects, l)
    return preview()
end

vline!(anchor::Real; o...) = _line!(fl(anchor), false; o...)
hline!(anchor::Real; o...) = _line!(fl(anchor), true; o...)

vline = vline!
hline = hline!

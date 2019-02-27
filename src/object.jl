# NOTE objects don't have the overwrite property. so with or witout ! they don't
# overwrite the axes they get placed on.

function text(text::String, anchor::Tuple; axes=nothing, o...)
    axes = check_axes(axes)
    t = Text2D(text=text, anchor=fl(anchor))
    set_properties!(t; defer_preview=true, o...)
    push!(axes.objects, t)
    return preview()
end

function _line(anchor::Float64, horiz::Bool; axes=nothing, o...)
    axes = check_axes(axes)
    l = StraightLine2D(anchor=anchor, horiz=horiz)
    set_properties!(l; defer_preview=true, o...)
    push!(axes.objects, l)
    return preview()
end

vline(anchor::Real; o...) = _line(fl(anchor), false; o...)
hline(anchor::Real; o...) = _line(fl(anchor), true; o...)

"""
    line(from, to; options)

Add a line from `from` (in `[x, y]` format) to `to` (same format). For instance
```julia
line([0, 0], [1, 1]; ls="--")
```
"""
line(a::Union{AVR,T2R}, b::Union{AVR,T2R}; o...) = plot!([a[1],b[1]], [a[2],b[2]]; o...)

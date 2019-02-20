function text!(a::Axes2D, text::String, anchor::T2F; o...)::Option{PreviewFigure}
    t = Text2D(text=text, anchor=anchor)
    set_properties!(t; defer_preview=true, o...)
    push!(a.objects, t)
    return _preview()
end
text!(::Nothing, a...; o...) = text!(add_axes2d!(), a...; o...)
text!(t::String, a::T2R; o...) = text!(gca(), t, fl(a); o...)

"""
    text

See [`text!`](@ref).
"""
text = text!

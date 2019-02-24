"""
    apply_textstyle!(g, s)

Internal function to apply the textstyle `s` in a GLE context.
"""
@inline function apply_textstyle!(g::GLE, s::TextStyle, parent_font::String=""; addset=false)
    if !isdef(s.font)
        isempty(parent_font) && return nothing
        s.font = parent_font
    end
    addset         && "\nset"                     |> g
    isdef(s.font)  && "font $(s.font)"            |> g
    isdef(s.hei)   && "hei $(s.hei)"              |> g
    isdef(s.color) && "color $(col2str(s.color))" |> g
    return nothing
end

"""
    apply_linestyle!(g, s)

Internal function to apply the linestyle `s` in a GLE context.
"""
@inline function apply_linestyle!(g::GLE, s::LineStyle; legend=false)
    isanydef(s) || return nothing
    isdef(s.lstyle) && "lstyle $(s.lstyle)"           |> g
    isdef(s.lwidth) && "lwidth $(s.lwidth)"           |> g
    isdef(s.color)  && "color $(col2str(s.color))"    |> g
    legend || isdef(s.smooth) && s.smooth && "smooth" |> g
    return nothing
end

"""
    apply_markerstyle!(g, s)

Internal function to apply the markerstyle `s` in a GLE context.
"""
@inline function apply_markerstyle!(g::GLE, s::MarkerStyle; mcol_flag=false)
    isanydef(s) || return nothing
    if !mcol_flag
        isdef(s.marker) && "marker $(s.marker)" |> g
        isdef(s.msize)  && "msize $(s.msize)"   |> g
        isdef(s.color)  && "color $(col2str(s.color))" |> g
    else
        "marker $(str(s))" |> g
        isdef(s.msize)  && "$(s.msize)" |> g
    end
    return nothing
end

"""
    apply_barstyle!(g, s)

Internal function to apply the barstyle `s` in a GLE context.
"""
@inline function apply_barstyle!(g::GLE, s::BarStyle)
    isanydef(s) || return nothing
    isdef(s.color) && "color $(col2str(s.color))" |> g
    isdef(s.fill)  && "fill $(col2str(s.fill))"   |> g
    return nothing
end

"""
    apply_barstyles_nostack!(g, v)

Internal function to apply the Vector of barstyles `v` in a GLE context when
the bars are not stacked.
"""
@inline function apply_barstyles_nostack!(g::GLE, v::Vector{BarStyle})
    # assumption that if one is defined, all are defined (this is checked
    # with the set_properties!)
    isanydef(v[1]) || return nothing
    isdef(v[1].color) && "color $(svec2str((col2str(s.color) for s ∈ v)))" |> g
    isdef(v[1].fill)  && "fill $(svec2str((col2str(s.fill) for s ∈ v)))"   |> g
    return nothing
end

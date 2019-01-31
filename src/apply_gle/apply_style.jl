function apply_textstyle!(g::GLE, s::TextStyle)
    isanydef(s) || return
    isdef(s.font)  && "font $(s.font)"            |> g
    isdef(s.hei)   && "hei $(s.hei)"              |> g
    isdef(s.color) && "color $(col2str(s.color))" |> g
    return
end

function apply_linestyle!(g::GLE, s::LineStyle)
    isanydef(s) || return
    isdef(s.lstyle) && "lstyle $(s.lstyle)"        |> g
    isdef(s.lwidth) && "lwidth $(s.lwidth)"        |> g
    isdef(s.color)  && "color $(col2str(s.color))" |> g
    isdef(s.smooth) && "smooth"                    |> g # only for dn lines
    return
end

function apply_markerstyle!(g::GLE, s::MarkerStyle)
    isanydef(s) || return
    isdef(s.marker) && "marker $(s.marker)"        |> g
    isdef(s.msize)  && "msize $(s.msize)"          |> g
    isdef(s.color)  && "color $(col2str(s.color))" |> g
    return
end

function apply_barstyle!(g::GLE, s::BarStyle)
    isanydef(s) || return
    isdef(s.color) && "color $(col2str(s.color))" |> g
    isdef(s.fill)  && "fill $(col2str(s.fill))"   |> g
    return
end

# assumption that if one is defined, all are defined (this is checked
# with the set_properties!)
function apply_barstyles_nostack!(g::GLE, v::Vector{BarStyle})
    isanydef(v[1]) || return # silly case...
    isdef(v[1].color) && "color $(svec2str((col2str(s.color) for s ∈ v)))" |> g
    isdef(v[1].fill)  && "fill $(svec2str((col2str(s.fill) for s ∈ v)))"   |> g
end

function apply_textstyle!(g::GLE, ts::TextStyle)
    isdef(ts.font)  && "font $(ts.font)"          |> g
    isdef(ts.hei)   && "hei $(ts.hei)"            |> g
    isdef(ts.color) && "hei $(col2str(ts.color))" |> g
    return g
end


function apply_linestyle!(g::GLE, ls::LineStyle)
    isdef(ls.lstyle) && "lstyle $(ls.lstyle)"        |> g
    isdef(ls.lwidth) && "lwidth $(ls.lwidth)"        |> g
    isdef(ls.color)  && "color $(col2str(ls.color))" |> g
    isdef(ls.smooth) && "smooth"                     |> g # only for dn lines
    return g
end


function apply_markerstyle!(g::GLE, m::MarkerStyle)
    isdef(m.marker) && "marker $(m.marker)" |> g
    isdef(m.msize)  && "msize $(m.msize)"   |> g
    isdef(m.facecolor) && gle_no_support("setting the marker face color.")
    isdef(m.edgecolor) && gle_no_support("setting the marker edge color.")
    return g
end

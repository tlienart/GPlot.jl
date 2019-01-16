function apply_textstyle!(g::GLE, ts::TextStyle, haslatex=false)
    isdef(ts.font)  && "font $(ts.font)"            |> g
    isdef(ts.hei)   && "hei $(ts.hei)"              |> g
    isdef(ts.color) && "color $(col2str(ts.color))" |> g
    return
end

function apply_linestyle!(g::GLE, ls::LineStyle)
    isdef(ls.lstyle) && "lstyle $(ls.lstyle)"        |> g
    isdef(ls.lwidth) && "lwidth $(ls.lwidth)"        |> g
    isdef(ls.color)  && "color $(col2str(ls.color))" |> g
    isdef(ls.smooth) && "smooth"                     |> g # only for dn lines
    return
end

function apply_markerstyle!(g::GLE, m::MarkerStyle)
    isdef(m.marker) && "marker $(m.marker)"        |> g
    isdef(m.msize)  && "msize $(m.msize)"          |> g
    isdef(m.color)  && "color $(col2str(m.color))" |> g
    return
end

function apply_histstyle!(g::GLE, hs::HistStyle)
    isdef(hs.color)  && "color $(col2str(hs.color))" |> g
    isdef(hs.fill)   && "fill $(col2str(hs.fill))"   |> g
    isdef(hs.horiz)  && hs.horiz && "horiz"          |> g
    return
end

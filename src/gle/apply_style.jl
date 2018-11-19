function apply_textstyle!(g::GLE, ts::TextStyle)
    isdef(ts.font)  && "font $(ts.font)"          |> g
    isdef(ts.hei)   && "hei $(ts.hei)"            |> g
    isdef(ts.color) && "hei $(col2str(ts.color))" |> g
    return g
end


function apply_linestyle!(g::GLE, ls::LineStyle)
    isdef(ls.lstyle) && "lstyle $(ls.lstyle)" |> g
    isdef(ls.lwidth) && "lwidth $(ls.lwidth)"        |> g
    isdef(ls.color)  && "color $(col2str(ls.color))" |> g
    isdef(ls.smooth) && "smooth"                     |> g # only for dn lines
    return g
end

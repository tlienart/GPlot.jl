function apply_axis!(g, a)
    apply_ticks!(g, a.ticks)
    isdef(a.title) && apply_title!(g, a.title)
    P1 = any(isdef, (a.off, a.base, a.lwidth, a.grid, a.log, a.min, a.max))
    (P1 || isanydef(a.textstyle)) && begin
        "\n\t$(a.prefix)axis" |> g
        isdef(a.off)    && ifelse(a.off, "off", "")   |> g
        isdef(a.base)   && "base $(a.base)"           |> g
        isdef(a.lwidth) && "lwidth $(a.lwidth)"       |> g
        isdef(a.grid)   && ifelse(a.grid, "grid", "") |> g
        isdef(a.log)    && ifelse(a.log,  "log", "")  |> g
        isdef(a.min)    && "min $(a.min)"             |> g
        isdef(a.max)    && "max $(a.max)"             |> g
        apply_textstyle!(g, a.textstyle)
    end
    "\n\t$(a.prefix)subticks off" |> g
    return
end


function apply_axes!(g, a::Axes2D, figid)
    isdef(a.origin) && "\namove $(a.origin[1]) $(a.origin[2])" |> g
    scale = ifelse(isdef(a.origin), "fullsize", "scale auto")
    "\nbegin graph\n\t$scale"   |> g
    isdef(a.math) && "\n\tmath" |> g
    isdef(a.size) && "\n\tsize $(a.size[1]) $(a.size[2])" |> g
    foreach(a -> apply_axis!(g, a), (a.xaxis, a.x2axis, a.yaxis, a.y2axis))
    isdef(a.title) && apply_title!(g, a.title)
    leg_entries = apply_drawings!(g, a.drawings, a.origin, figid)
    "\nend graph" |> g
    isdef(a.legend) && apply_legend!(g, a.legend, leg_entries)
    return
end


function apply_axes!(g, a::Axes3D, figid)
    throw(NotImplementedError("apply_axes:GLE/3D"))
    return
end

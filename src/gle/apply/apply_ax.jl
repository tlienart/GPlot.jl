function apply_axis!(g::GLE, a::Axis)
    apply_ticks!(g, a.ticks)
    isdef(a.title) && apply_title!(g, a.title)
    any(isdef, (a.off, a.base, a.textstyle, a.lwidth, a.grid, a.log, a.min, a.max)) && begin
        "\n\t$(a.prefix)axis"         |> g
        isdef(a.off)    && ifelse(a.off, "off", "")   |> g
        isdef(a.base)   && "base $(a.base)"           |> g
        isdef(a.lwidth) && "lwidth $(a.lwidth)"       |> g
        isdef(a.grid)   && ifelse(a.grid, "grid", "") |> g
        isdef(a.log)    && ifelse(a.log,  "log", "")  |> g
        isdef(a.min)    && "min $(a.min)"             |> g
        isdef(a.max)    && "max $(a.max)"             |> g
        isdef(a.textstyle) && apply_textstyle!(g, a.textstyle)
    end
    "\n\t$(a.prefix)subticks off" |> g
    return
end


function apply_axes!(g::GLE, a::Axes2D)
    "\nbegin graph\n\tscale auto"               |> g
    isdef(a.math) && "\n\tmath"                 |> g
    isdef(a.size) && "\n\tsize $(a[1]) $(a[2])" |> g
    foreach(a -> apply_axis!(g, a), (a.xaxis, a.x2axis, a.yaxis, a.y2axis))
    isdef(a.title) && apply_title!(g, a.title)
    leg_entries = apply_drawings!(g, a.drawings)
    "\nend graph"                               |> g
    isdef(a.legend) && apply_legend!(g, a.legend, leg_entries)
    return
end


function apply_axes!(g::GLE, a::Axes3D)
    throw(NotImplementedError("apply_axes:GLE/3D"))
    return
end

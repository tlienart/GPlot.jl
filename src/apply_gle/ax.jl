"""
    apply_axis!(g, a)

Internal function to apply an `Axis` object `a` in a GLE context.
"""
function apply_axis!(g::GLE, a::Axis)
    apply_ticks!(g, a.ticks, a.prefix)
    isdef(a.title) && apply_title!(g, a.title, a.prefix)
    P1 = any(isdef, (a.off, a.base, a.lwidth, a.log, a.min, a.max, a.ticks.grid))
    (P1 || isanydef(a.textstyle)) && begin
        "\n\t$(a.prefix)axis" |> g
        isdef(a.off)    && ifelse(a.off, "off", "")  |> g
        isdef(a.base)   && "base $(a.base)"          |> g
        isdef(a.lwidth) && "lwidth $(a.lwidth)"      |> g
        isdef(a.log)    && ifelse(a.log,  "log", "") |> g
        isdef(a.min)    && "min $(a.min)"            |> g
        isdef(a.max)    && "max $(a.max)"            |> g
        isdef(a.ticks.grid) && ifelse(a.ticks.grid, "grid", "") |> g
        apply_textstyle!(g, a.textstyle)
    end
    "\n\t$(a.prefix)subticks off" |> g
    return
end

"""
    apply_axes!(g, a, figid)

Internal function to apply an `Axes2D` object `a` in a GLE context.
The `figid` is useful to keep track of the figure the axes belong to
which is required in the `apply_drawings` subroutine that is called.
"""
function apply_axes!(g, a::Axes2D, figid)
    isdef(a.origin) && "\namove $(a.origin[1]) $(a.origin[2])" |> g
    scale = ifelse(isdef(a.origin), "fullsize", "scale auto")
    "\nbegin graph\n\t$scale"   |> g
    isdef(a.math) && "\n\tmath" |> g
    isdef(a.size) && "\n\tsize $(a.size[1]) $(a.size[2])" |> g
    foreach(a -> apply_axis!(g, a), (a.xaxis, a.x2axis, a.yaxis, a.y2axis))
    isdef(a.title) && apply_title!(g, a.title)
    origid = ifelse(isdef(a.origin), a.origin, (0.,0.))
    leg_entries = apply_drawings!(g, a.drawings, origid, figid)
    "\nend graph" |> g
    isdef(a.legend) && apply_legend!(g, a.legend, leg_entries)
    return
end

apply_axes!(g, a::Axes3D, figid) = throw(NotImplementedError("apply_axes:GLE/3D"))

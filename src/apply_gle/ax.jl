"""
    apply_axis!(g, a)

Internal function to apply an `Axis` object `a` in a GLE context.
"""
@inline function apply_axis!(g::GLE, a::Axis, parent_font::String)
    parent_font = ifelse(isdef(a.textstyle.font), a.textstyle.font, parent_font)
    apply_ticks!(g, a.ticks, a.prefix, parent_font)
    if isdef(a.title)
        apply_title!(g, a.title, a.prefix, parent_font)
    end
    if any(isdef, (a.off, a.base, a.lwidth, a.log, a.min, a.max, a.ticks.grid))
        "\n\t$(a.prefix)axis" |> g
        isdef(a.off)    && ifelse(a.off, "off", "")  |> g
        isdef(a.base)   && "base $(a.base)"          |> g
        isdef(a.lwidth) && "lwidth $(a.lwidth)"      |> g
        isdef(a.log)    && ifelse(a.log,  "log", "") |> g
        isdef(a.min)    && "min $(a.min)"            |> g
        isdef(a.max)    && "max $(a.max)"            |> g
        isdef(a.ticks.grid) && ifelse(a.ticks.grid, "grid", "") |> g
        apply_textstyle!(g, a.textstyle, parent_font)
    end
    "\n\t$(a.prefix)subticks off" |> g
    return nothing
end

"""
    apply_axes!(g, a, figid)

Internal function to apply an `Axes2D` object `a` in a GLE context.
The `figid` is useful to keep track of the figure the axes belong to
which is required in the `apply_drawings` subroutine that is called.
"""
function apply_axes!(g::GLE, a::Axes2D, figid::String)
    isdef(a.origin) && "\namove $(a.origin[1]) $(a.origin[2])" |> g
    scale = ifelse(isdef(a.origin), "fullsize", "scale auto")

    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "\nbegin graph\n\t$scale"   |> g

    # graph >> math mode (crossing axis)
    isdef(a.math) && "\n\tmath" |> g
    # -- size of the axes, see also layout
    isdef(a.size) && "\n\tsize $(a.size[1]) $(a.size[2])" |> g

    # graph >> apply axis (ticks, ...), passing the figure font as parent font (see issue #76)
    parent_font = Figure(figid; _noreset=true).textstyle.font
    for axis in (a.xaxis, a.x2axis, a.yaxis, a.y2axis)
        apply_axis!(g, axis, parent_font)
    end

    # graph >> apply axes title, passing the figure font as parent font
    isdef(a.title) && apply_title!(g, a.title, "", parent_font)

    # graph >> apply drawings
    origid      = ifelse(isdef(a.origin), a.origin, (0.,0.))
    leg_entries = apply_drawings!(g, a.drawings, origid, figid)

    "\nend graph" |> g
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    # apply  legend and other floating objects
    isdef(a.legend)    && apply_legend!(g, a.legend, leg_entries)
    isempty(a.objects) || apply_objects!(g, a.objects)
    return nothing
end

apply_axes!(g::GLE, a::Axes3D, figid::String) =
    throw(NotImplementedError("apply_axes:GLE/3D"))

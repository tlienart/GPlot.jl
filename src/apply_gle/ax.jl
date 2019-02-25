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
    # XXX subticks disabled for now
    "\n\t$(a.prefix)subticks off" |> g
    #
    "\n\t$(a.prefix)axis" |> g
    a.off && ("off" |> g; return nothing)
    a.log && "log"  |> g
    isdef(a.base)   && "base $(a.base)"     |> g
    isdef(a.lwidth) && "lwidth $(a.lwidth)" |> g
    isdef(a.min)    && "min $(a.min)"       |> g
    isdef(a.max)    && "max $(a.max)"       |> g
    a.ticks.grid    && "grid"               |> g
    apply_textstyle!(g, a.textstyle, parent_font)
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
    a.math && "\n\tmath" |> g
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
    isdef(a.legend)    && apply_legend!(g, a.legend, leg_entries, parent_font)
    isempty(a.objects) || apply_objects!(g, a.objects)
    return nothing
end

apply_axes!(g::GLE, a::Axes3D, figid::String) =
    throw(NotImplementedError("apply_axes:GLE/3D"))

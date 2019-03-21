"""
    apply_axis!(g, a)

Internal function to apply an `Axis` object `a` in a GLE context.
"""
function apply_axis!(g::GLE, a::Axis, parent_font::String)
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
function apply_axes!(g::GLE, a::Axes2D, figid::String, axidx::Int)
    a.off && return nothing

    isdef(a.origin) && "\namove $(a.origin[1]) $(a.origin[2])" |> g
    if a.scale != ""
        scale = ifelse(isdef(a.origin), "fullsize", "scale $(a.scale)")
    end

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
    apply_drawings!(g, a.drawings, figid, axidx)

    "\nend graph" |> g
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    # apply  legend and other floating objects
    isdef(a.legend)    && apply_legend!(g, a.legend, parent_font, figid)
    isempty(a.objects) || apply_objects!(g, a.objects, figid)
    return nothing
end

function apply_axes!(g::GLE, a::Axes3D, figid::String, axidx::Int)
# TODO
# -- title
# -- perspective

    a.off && return nothing
    axid = "a3d_$(hash(a))"

    #
    # begin object ax3d_hash
    #   begin surface
    #       size x y
    #       cube xlen 10 ylen 10 zlen 10 lstyle 9 color blue
    #       xaxis ...
    #       xtitle ...
    #       yaxis ...
    #       ytitle ...
    #       zaxis ...
    #       ztitle ...
    #       (surface)
    #   end surface
    #   (objects)
    # end object
    #
    # amove (appropriate location)
    # draw ax3d_hash.cc
    #

    "\nbegin object $axid" |> g
    "\n\tbegin surface"    |> g
    "\n\t\tsize $(a.size[1]) $(a.size[2])" |> g
    # ------------------------------------------
    # CUBE
    "\n\t\tcube"      |> g
    a.nocube && "off" |> g
    "xlen $(a.cubedims[1]) ylen $(a.cubedims[2]) zlen $(a.cubedims[3])"   |> g
    a.nocube || apply_linestyle!(g, a.linestyle)

# TODO should become apply_axis3 or something
    δx = round((a.xaxis.max - a.xaxis.min)/5, digits=1)
    "\n\t\txaxis min $(a.xaxis.min) max $(a.xaxis.max) dticks $δx" |> g
    δy = round((a.yaxis.max - a.yaxis.min)/5, digits=1)
    "\n\t\tyaxis min $(a.yaxis.min) max $(a.yaxis.max) dticks $δy" |> g
    δz = round((a.zaxis.max - a.zaxis.min)/5, digits=1)
    "\n\t\tzaxis min $(a.zaxis.min) max $(a.zaxis.max) dticks $δz" |> g

    # ROTATION
    if isdef(a.rotate)
        "\n\t\trotate $(a.rotation[1]) $(a.rotation[2]) 0" |> g
    else
        "\n\t\trotate 65 20 0" |> g
    end

    # XXX AXIS
    # parent_font = Figure(figid; _noreset=true).textstyle.font
    # for axis in (a.xaxis, a.yaxis, a.zaxis)
    #     apply_axis!(g, axis, parent_font)
    # end

    # SURFACE
    if isempty(a.drawings) || all(d->!isa(d, Surface), a.drawings)
        # NOTE if there is no surface, we MUST add dummy data otherwise ghostscript crashes.
        fd = joinpath(GP_ENV["TMP_PATH"], "$(figid)_dummy.z")
        write(fd, "! nx 2 ny 2 xmin 1 xmax 2 ymin 1 ymax 2\n1 2\n2 2\n")
        "\n\t\tdata \"$fd\""   |> g
        "\n\t\ttop off"        |> g
        "\n\t\tunderneath off" |> g
    end
    surfs = [i for i ∈ 1:length(a.drawings) if a.drawings[i] isa Surface]
    apply_drawings!(g, a.drawings[surfs], figid, axidx)
    # -----------------------------------------
    "\n\tend surface"      |> g
    apply_drawings!(g, a.drawings[setdiff(1:length(a.drawings), surfs)], figid, axidx)
    # OBJECTS
    apply_objects!(g, a.objects, figid)

    "\nend object"         |> g

    if isdef(a.origin)
        # move to center of container
        cx = a.origin[1] + a.size[1]/2
        cy = a.origin[2] + a.size[2]/2
        "\namove $cx $cy" |> g
    else
        # move to center of page
        "\namove pagewidth()/2 pageheight()/2" |> g
    end
    # draw the overall container centered
    "\ndraw $axid.cc" |> g
end

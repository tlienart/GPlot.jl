"""
    apply_objects!(g, objects)

Internal function to apply a vector of `Object` contained in an `Axes` container in a GLE context.
"""
function apply_objects!(g::GLE, objects::Vector{<:Object}, figid::String)
    foreach(o -> apply_object!(g, o, figid), objects)
    return nothing
end

function apply_object!(g::GLE, obj::Text2D, ::String)
    "\ngsave"    |> g
    "\nset just $(obj.position)"                        |> g
    apply_textstyle!(g, obj.textstyle, addset=true)
    "\namove xg($(obj.anchor[1])) yg($(obj.anchor[2]))" |> g
    "\nwrite \"$(obj.text)\""                           |> g
    "\ngrestore" |> g
    return nothing
end

function apply_object!(g::GLE, obj::StraightLine2D, ::String)
    "\ngsave"    |> g
    apply_linestyle!(g, obj.linestyle; addset=true)
    if obj.horiz
        "\namove xg(xgmin) yg($(obj.anchor))" |> g
        "\naline xg(xgmax) yg($(obj.anchor))" |> g
    else
        "\namove xg($(obj.anchor)) yg(ygmin)" |> g
        "\naline xg($(obj.anchor)) yg(ygmax)" |> g
    end
    "\ngrestore" |> g
    return nothing
end

function apply_object!(g::GLE, obj::Box2D, ::String)
    "\ngsave" |> g
    obj.position == "bl" || "\nset just $(obj.position)"      |> g
    apply_linestyle!(g, obj.linestyle; addset=true)
    "\namove xg($(obj.anchor[1])) yg($(obj.anchor[2]))"       |> g
    "\nbox xg($(obj.size[1]))-xg(0) yg($(obj.size[2]))-yg(0)" |> g
    obj.nobox && "nobox"                    |> g
    fs = obj.fillstyle
    isdef(fs) && "fill $(col2str(fs.fill))" |> g
    "\ngrestore" |> g
    return nothing
end

function apply_object!(g::GLE, obj::Colorbar, figid::String)

    add_sub_palette!(Figure(figid; _noreset=true), obj.cmap)

    dx, dy = obj.offset

    width, height = 0.0, 0.0
    if isdef(obj.size)
        width, height = obj.size
    else
        if obj.position ∈ ["left", "right"]
            width, height = "0.25", "abs(yg(ygmax)-yg(ygmin))"
        else
            width, height = "abs(xg(xgmax)-xg(xgmin))", "0.25"
        end
    end

    if obj.position == "right"
        "\namove xg(xgmax)+$dx yg(ygmin)+$dy"             |> g
    elseif obj.position == "left"
        "\namove xg(xgmin)-$dx-0.3-$width yg(ygmin)+$dy"  |> g
    elseif obj.position == "bottom"
        "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> g
    else
        "\namove xg(xgmin)+$dx yg(ygmax)+$dy"             |> g
    end

    "\nbegin box name cmap" |> g
    obj.nobox && "nobox"    |> g

    #
    # colormap "y" 0 1 0 1 1 pixels width height palette palette$
    #
    "\n\tcolormap" |> g
    if obj.position ∈ ["right", "left"]
        "\"y\" 0 1 0 1 1 $(obj.pixels)"     |> g
    else
        "\"x\" 0 1 0 1 $(obj.pixels) 1"     |> g
    end
    "$width $height palette cmap_$(hash(obj.cmap))" |> g
    "\nend box" |> g

    # ticks (not axis elem this time)
    # map the ticks from 0.0 to 1.0
    ticks = collect(obj.ticks.places)
    ticks .-= obj.zmin
    ticks ./= (obj.zmax - obj.zmin) # now ticks on [0.0, 1.0]

    if obj.position == "right"
        for (i, tick) ∈ enumerate(ticks)
            "\namove xg(xgmax)+$dx+$width yg(ygmin)+$dy+$height*$tick" |> g
            # XXX use parameters: length, shift, ticks label
            "\nrline $width/3 0" |> g # draw tick
            "\nrmove $width/3 0" |> g # move a bit more to write the label
            "\nset just lc"      |> g
            "\nwrite $(round(obj.ticks.places[i], digits=1))" |> g
        end
    elseif obj.position == "left"
        "\namove xg(xgmin)-$dx yg(ygmin)+$dy" |> g
        for (i, tick) ∈ enumerate(ticks)
            "\namove xg(xgmin)-$dx-0.3-$width yg(ygmin)+$dy+$height*$tick" |> g
            # XXX use parameters: length, shift, ticks label
            "\nrline -$width/3 0" |> g # draw tick
            "\nrmove -$width/3 0" |> g # move a bit more to write the label
            "\nset just rc"       |> g
            "\nwrite $(round(obj.ticks.places[i], digits=1))" |> g
        end
    elseif obj.position == "bottom"
        "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> g
        for (i, tick) ∈ enumerate(ticks)
            "\namove xg(xgmin)+$dx+$width*$tick yg(ygmin)-$dy-0.3-$height" |> g
            # XXX use parameters: length, shift, ticks label
            "\nrline 0 -$height/3" |> g # draw tick
            "\nrmove 0 -$height/3" |> g # move a bit more to write the label
            "\nset just tc"        |> g
            "\nwrite $(round(obj.ticks.places[i], digits=1))" |> g
        end
    else
        "\namove xg(xgmin)+$dx yg(ygmax)+$dy" |> g
        for (i, tick) ∈ enumerate(ticks)
            "\namove xg(xgmin)+$dx+$width*$tick yg(ygmax)+$dy+$height" |> g
            # XXX use parameters: length, shift, ticks label
            "\nrline 0 $height/3" |> g # draw tick
            "\nrmove 0 $height/3" |> g # move a bit more to write the label
            "\nset just bc"       |> g
            "\nwrite $(round(obj.ticks.places[i], digits=1))" |> g
        end
    end
    return nothing
end

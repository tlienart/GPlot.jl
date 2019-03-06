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
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ? obj.ticks.length : "$width/3"
            "\ngsave"    |> g
            apply_linestyle!(g, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmax)+$dx+$width yg(ygmin)+$dy+$height*$tick" |> g
                "\nrline $tlength 0" |> g # draw tick
            end
            "\ngrestore" |> g
        end
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ? obj.ticks.labels.dist : "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ? obj.ticks.labels.shift : 0
            "\ngsave"    |> g
            apply_textstyle!(g, obj.ticks.labels.textstyle; addset=true)
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = ["$(round(obj.ticks.places[i], digits=1))" for i ∈ 1:length(ticks)]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmax)+$dx+$width yg(ygmin)+$dy+$height*$tick" |> g
                "\nrmove $offset 0"    |> g # move a bit more to write the label
                "\nrmove 0 $shift"     |> g # shift vertical
                "\nset just lc"        |> g # justify center wrt anchor
                "\nwrite $(labels[i])" |> g # write label
            end
            "\ngrestore" |> g
        end
    elseif obj.position == "left"
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ? obj.ticks.length : "$width/3"
            "\ngsave"    |> g
            apply_linestyle!(g, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)-$dx yg(ygmin)+$dy" |> g
                "\nrline -$tlength 0" |> g # draw tick
            end
            "\ngrestore" |> g
        end
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ? obj.ticks.labels.dist : "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ? obj.ticks.labels.shift : 0
            "\ngsave"    |> g
            apply_textstyle!(g, obj.ticks.labels.textstyle; addset=true)
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = ["$(round(obj.ticks.places[i], digits=1))" for i ∈ 1:length(ticks)]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)-$dx yg(ygmin)+$dy" |> g
                "\nrmove -$offset 0"    |> g # move a bit more to write the label
                "\nrmove 0 $shift"      |> g # shift vertical
                "\nset just lc"         |> g # justify center wrt anchor
                "\nwrite $(labels[i])"  |> g # write label
            end
            "\ngrestore" |> g
        end
    elseif obj.position == "bottom"
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ? obj.ticks.length : "$height/3"
            "\ngsave"    |> g
            apply_linestyle!(g, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> g
                "\nrline 0 -$tlength" |> g # draw tick
            end
            "\ngrestore" |> g
        end
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ? obj.ticks.labels.dist : "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ? obj.ticks.labels.shift : 0
            "\ngsave"    |> g
            apply_textstyle!(g, obj.ticks.labels.textstyle; addset=true)
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = ["$(round(obj.ticks.places[i], digits=1))" for i ∈ 1:length(ticks)]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmin)-$dy-0.3-$height" |> g
                "\nrmove 0 -$offset"    |> g # move a bit more to write the label
                "\nrmove $shift 0"      |> g # shift horizontal
                "\nset just lc"         |> g # justify center wrt anchor
                "\nwrite $(labels[i])"  |> g # write label
            end
            "\ngrestore" |> g
        end
    else
        if !(obj.ticks.off)
            tlength = isdef(obj.ticks.length) ? obj.ticks.length : "$height/3"
            "\ngsave"    |> g
            apply_linestyle!(g, obj.ticks.linestyle; nosmooth=true, addset=true)
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmax)+$dy" |> g
                "\nrline 0 $tlength" |> g # draw tick
            end
            "\ngrestore" |> g
        end
        if !(obj.ticks.labels.off)
            offset = isdef(obj.ticks.labels.dist) ? obj.ticks.labels.dist : "$width/3"
            shift  = isdef(obj.ticks.labels.shift) ? obj.ticks.labels.shift : 0
            "\ngsave"    |> g
            apply_textstyle!(g, obj.ticks.labels.textstyle; addset=true)
            # retrieve the labels
            labels = obj.ticks.labels.names
            if isempty(labels)
                labels = ["$(round(obj.ticks.places[i], digits=1))" for i ∈ 1:length(ticks)]
            end
            # write them
            for (i, tick) ∈ enumerate(ticks)
                "\namove xg(xgmin)+$dx yg(ygmax)+$dy" |> g
                "\nrmove 0 $offset"     |> g # move a bit more to write the label
                "\nrmove $shift 0"      |> g # shift horizontal
                "\nset just lc"         |> g # justify center wrt anchor
                "\nwrite $(labels[i])"  |> g # write label
            end
            "\ngrestore" |> g
        end
    end
    return nothing
end

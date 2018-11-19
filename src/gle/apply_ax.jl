function apply_title!(g::GLE, t::Title)
    # [x]title ...
    tt = "title $(t.title)"
    isdef(t.prefix)    && "$(t.prefix)$tt" |> g
    isdef(t.dist)      && "dist $(t.dist)" |> g
    isdef(t.textstyle) && apply_textstyle!(g, t.textstyle)
    return g
end

function apply_tickslabels!(g::GLE, t::TicksLabels)
    # [x]names "names1" ...
    isdef(t.names) && "\n\t$(t.prefix)names $(vec2str(t.names))" |> g
    # [x]labels ...
    any(isdef, (t.off, t.dist, t.textstyle)) && begin
        "\n\t$(t.prefix)labels" |> g
        isdef(t.off)       && ifelse(t.off, "off", "on") |> g
        isdef(t.dist)      && "dist $(t.dist)"           |> g
        isdef(t.textstyle) && apply_textstyle!(g, t.textstyle)
    end
    # [x]axis ...
    any(isdef, (t.angle, t.format)) && begin
        "\n\t$(t.prefix)axis" |> g
        isdef(t.angle)  && "angle $(t.angle)"   |> g
        isdef(t.format) && "format $(t.format)" |> g
        isdef(t.shift)  && "shift $(t.shift)"   |> g
    end
    return g
end

function apply_ticks!(g::GLE, t::Ticks)
    # [x]ticks ...
    any(isdef, (t.off, t.linestyle)) && begin
        "\n\t$(t.prefix)ticks" |> g
        isdef(t.off)       && ifelse(t.off, "off", "") |> g
        isdef(t.length)    && "length $(t.length)"     |> g
        isdef(t.linestyle) && apply_linestyle!(g, t.linestyle)
    end
    # [x]places pos1 pos2 ...
    isdef(t.places) && "\n\t$(t.prefix)places $(vec2str(t.places))" |> g
    # [x]xaxis symticks
    isdef(t.symticks) && "\n\t$(t.prefix)axis symticks" |> g
    return g
end

function apply_axis!(g::GLE, a::Axis)
    apply_ticks!(g, a.ticks)
    apply_tickslabels!(g, a.tickslabels)
    isdef(a.title) && apply_title!(g, a.title)
    any(isdef, (a.off, a.base, a.textstyle, a.lwidth, a.grid, a.log, a.min, a.max)) && begin
        "\n\t$(a.prefix)axis" |> g
        isdef(a.off)    && ifelse(a.off, "off", "")   |> g
        isdef(a.base)   && "base $(a.base)"           |> g
        isdef(a.lwidth) && "lwidth $(a.lwidth)"       |> g
        isdef(a.grid)   && ifelse(a.grid, "grid", "") |> g
        isdef(a.log)    && ifelse(a.log,  "log", "")  |> g
        isdef(a.min)    && "min $(a.min)"             |> g
        isdef(a.max)    && "max $(a.max)"             |> g
        isdef(a.textstyle) && apply_textstyle!(g, a.textstyle)
    end
    return g
end


function apply_axes!(g::GLE, a::Axes2D)
    isdef(a.size) && "\n\tsize $(a[1]) $(a[2])" |> g
    foreach(a -> apply_axis!(g, a), (a.xaxis, a.x2axis, a.yaxis, a.y2axis))
    isdef(a.title) && apply_title!(g, a.title)
    apply_drawings!(g, a.drawings)
    return g
end


function apply_axes!(g::GLE, a::Axes3D)
    throw(NotImplementedError("apply_axes:GLE/3D"))
    return g
end

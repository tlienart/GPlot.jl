function apply_title!(g::GLE, t::Title)
    # [x]title ...
    p = ifelse(isdef(t.prefix), "$(t.prefix)", "")
    "\n\t$(p)title \"$(t.text)\""              |> g
    isdef(t.dist)      && "dist $(t.dist)" |> g
    isdef(t.textstyle) && apply_textstyle!(g, t.textstyle)
    return
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
    return
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
    return
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
    return
end


function apply_axes!(g::GLE, a::Axes2D)
    "\nbegin graph"                             |> g
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


function assemble_figure(f::Figure{GLE})
    g = f.g
    "size $(f.size[1]) $(f.size[2])" |> g
    haslatex = false
    isdef(f.texlabels) && f.texlabels && (haslatex = true)
    haslatex || (isdef(f.texscale) && (haslatex = true))
    "\nset" |> g # line for texstyle, it may be empty if nothing is given
    isdef(f.textstyle) && apply_textstyle!(g, f.textstyle, haslatex)
    "\n" |> g
    haslatex && raw"""
    begin texpreamble
        %\usepackage[T1]{fontenc}
        %\usepackage[default]{sourcesanspro}
        %\usepackage{mathpazo}
        \usepackage{arev}
        \usepackage[T1]{fontenc}
    end texpreamble
    set texlabels 1
    """ |> g
    isdef(f.texscale)  && "\nset texscale $(f.texscale)" |> g

    # XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX
    # XXX DEAL WITH LAYOUT, sandbox below
    # XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX
    apply_axes!(g, f.axes[1])
    # XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX

    # deal with proper dir
    write(joinpath(GP_TMP_PATH, f.id * ".gle"), take!(g))
    return
end

function assemble_figure(f::Figure{Gnuplot})
    throw(NotImplementedError("assemble_figure:Gnuplot"))
end

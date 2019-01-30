function apply_title!(g::GLE, t::Title)
    # [x]title ...
    p = ifelse(isdef(t.prefix), "$(t.prefix)", "")
    "\n\t$(p)title \"$(t.text)\""              |> g
    isdef(t.dist)      && "dist $(t.dist)" |> g
    isdef(t.textstyle) && apply_textstyle!(g, t.textstyle)
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

    isdef(t.labels) && apply_tickslabels!(g, t.labels, t.prefix)
    return
end

function apply_tickslabels!(g::GLE, t::TicksLabels, prefix::String)
    # [x]names "names1" ...
    isdef(t.names) && "\n\t$(prefix)names $(vec2str(t.names))" |> g
    # [x]labels ...
    any(isdef, (t.off, t.dist, t.textstyle)) && begin
        "\n\t$(prefix)labels" |> g
        isdef(t.off)       && ifelse(t.off, "off", "on") |> g
        isdef(t.dist)      && "dist $(t.dist)"           |> g
        isdef(t.textstyle) && apply_textstyle!(g, t.textstyle)
    end
    # [x]axis ...
    any(isdef, (t.angle, t.format)) && begin
        "\n\t$(prefix)axis" |> g
        isdef(t.angle)  && "angle $(t.angle)"   |> g
        isdef(t.format) && "format $(t.format)" |> g
        isdef(t.shift)  && "shift $(t.shift)"   |> g
    end
    return
end

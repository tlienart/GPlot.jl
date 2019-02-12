"""
    apply_title!(g, t, p)

Internal function to apply a `Title` object `t` in a GLE context.
The argument `p` specifies the prefix.
"""
function apply_title!(g::GLE, t::Title, p::String="")
    # [x]title ...
    "\n\t$(p)title \"$(t.text)\""     |> g
    isdef(t.dist) && "dist $(t.dist)" |> g
    apply_textstyle!(g, t.textstyle)
    return
end

function apply_ticks!(g, t)
    # [x]ticks ...
    (isdef(t.off) || isanydef(t.linestyle)) && begin
        "\n\t$(t.prefix)ticks" |> g
        isdef(t.off)    && ifelse(t.off, "off", "") |> g
        isdef(t.length) && "length $(t.length)"     |> g
        apply_linestyle!(g, t.linestyle)
    end
    # [x]places pos1 pos2 ...
    isdef(t.places) && "\n\t$(t.prefix)places $(vec2str(t.places))" |> g
    # [x]xaxis symticks
    isdef(t.symticks) && "\n\t$(t.prefix)axis symticks" |> g
    apply_tickslabels!(g, t.labels, t.prefix)
    return
end

function apply_tickslabels!(g, t, prefix)
    # [x]names "names1" ...
    isdef(t.names) && "\n\t$(prefix)names $(vec2str(t.names))" |> g
    # [x]labels ...
    (any(isdef, (t.off, t.dist)) || isanydef(t.textstyle)) && begin
        "\n\t$(prefix)labels" |> g
        isdef(t.off)  && ifelse(t.off, "off", "") |> g
        isdef(t.dist) && "dist $(t.dist)"         |> g
        apply_textstyle!(g, t.textstyle)
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

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

"""
    apply_ticks!(g, t, p)

Internal function to apply a `Ticks` object `t` in a GLE context for an axis
prefixed by `p`.
"""
function apply_ticks!(g::GLE, t::Ticks, prefix::String)
    # [x]ticks ...
    (isdef(t.off) || isanydef(t.linestyle)) && begin
        "\n\t$(prefix)ticks" |> g
        isdef(t.off)    && ifelse(t.off, "off", "") |> g
        isdef(t.length) && "length $(t.length)"     |> g
        apply_linestyle!(g, t.linestyle)
    end
    # [x]places pos1 pos2 ...
    isdef(t.places) && "\n\t$(prefix)places $(vec2str(t.places))" |> g
    # [x]xaxis symticks
    isdef(t.symticks) && "\n\t$(prefix)axis symticks" |> g
    apply_tickslabels!(g, t.labels, prefix)
    return
end

"""
    apply_tickslabels!(g, t, p)

Internal function to apply a `TicksLabels` object `t` in a GLE context.
The prefix `p` indicates which axis we're on.
"""
function apply_tickslabels!(g::GLE, t::TicksLabels, prefix::String)
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

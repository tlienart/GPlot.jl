"""
    apply_title!(g, t, p, parent_font)

Internal function to apply a `Title` object `t` in a GLE context.
The argument `p` specifies the prefix.
"""
function apply_title!(g::GLE, t::Title, p::String, parent_font::String)
    # [x]title ...
    "\n\t$(p)title \"$(t.text)\""     |> g
    isdef(t.dist) && "dist $(t.dist)" |> g
    apply_textstyle!(g, t.textstyle, parent_font)
    return nothing
end

"""
    apply_ticks!(g, t, p)

Internal function to apply a `Ticks` object `t` in a GLE context for an axis
prefixed by `p`.
"""
function apply_ticks!(g::GLE, t::Ticks, prefix::String, parent_font::String)
    # [x]ticks ...
    "\n\t$(prefix)ticks" |> g
    t.off && ("off"      |> g; return nothing)
    # - style
    isdef(t.length) && "length $(t.length)" |> g
    apply_linestyle!(g, t.linestyle)
    # [x]places pos1 pos2 ...
    isempty(t.places) || "\n\t$(prefix)places $(vec2str(t.places))" |> g
    # [x]xaxis symticks
    t.symticks && "\n\t$(prefix)axis symticks"             |> g
    apply_tickslabels!(g, t.labels, prefix, parent_font)
    return nothing
end

"""
    apply_tickslabels!(g, t, p)

Internal function to apply a `TicksLabels` object `t` in a GLE context.
The prefix `p` indicates which axis we're on.
"""
function apply_tickslabels!(g::GLE, t::TicksLabels, prefix::String, parent_font::String)
    # [x]names "names1" ...
    isempty(t.names) || "\n\t$(prefix)names $(vec2str(t.names))" |> g
    # [x]labels ...
    "\n\t$(prefix)labels"                     |> g
    ifelse(t.off, "off", "")                  |> g
    isdef(t.dist) && "dist $(t.dist)"         |> g
    apply_textstyle!(g, t.textstyle, parent_font)
    # [x]axis ...
    if any(isdef, (t.angle, t.format))
        "\n\t$(prefix)axis" |> g
        isdef(t.angle)  && "angle $(t.angle)"   |> g
        isdef(t.format) && "format $(t.format)" |> g
        isdef(t.shift)  && "shift $(t.shift)"   |> g
    end
    return nothing
end

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
    apply_legend!(g, leg, entries, parent_font)

Internal function to apply a `Legend` object `leg` in a GLE context with entries
`entries` (constructed through the `apply_drawings` process).
"""
function apply_legend!(g::GLE, l::Legend, entries::GLE, parent_font::String)
    l.off && return nothing
    "\ngsave" |> g
    apply_textstyle!(g, l.textstyle, parent_font; addset=true)

    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "\nbegin key"  |> g

    # global commands
    "\n\tcompact"      |> g
    l.nobox && "nobox" |> g
    isdef(l.bgcolor)  && "background $(col2str(l.bgcolor))"        |> g
    isdef(l.margins)  && "margins $(l.margins[1]) $(l.margins[2])" |> g
    sum(l.offset)>0   && "offset $(l.offset[1]) $(l.offset[2])"    |> g
    isdef(l.position) && "\n\tposition $(l.position)"              |> g

    # entries is the key part, it's generated via apply_drawings.
    entries        |> g
    #
    "\nend key"    |> g
    # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    "\ngrestore" |> g
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

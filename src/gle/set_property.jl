function set_lstyle!(::GLE, obj, v)
    ((v isa Int) && (v ≥ 0)) || throw(OptionValueError("lstyle", v))
    obj.linestyle.lstyle = v
    return
end

function set_lwidth!(::GLE, obj, v)
    ((v isa Real) && (v ≥ 0.)) || throw(OptionValueError("lwidth", v))
    obj.linestyle.lwidth = v
    return
end

function set_smooth!(::GLE, obj, v)
    (v isa Bool) || throw(OptionValueError("smooth", v))
    obj.linestyle.smooth = v
    return
end

function set_color!(::GLE, obj, elem, v)
    col = colorant"blue"
    try
        col = parse(Colorant, v)
    catch e
        throw(OptionValueError("color", v))
    end
    setfield!(getfield(obj, elem), :color, col)
    return
end

set_color!(g, e::Union{Line2D, Ticks}, v) =
    set_color!(g, e, :linestyle, v)
set_color!(g, a::Union{Title, TicksLabels, Axis}, v) =
    set_color!(g, a, :textstyle, v)

function set_marker!(::GLE, obj, v)
    obj.markerstyle.marker = get(GLE_MARKERS, v) do
        throw(OptionValueError("marker", v))
    end
    return
end

function set_msize!(::GLE, obj, v)
    ((v isa Real) && (v ≥ 0.)) || throw(OptionValueError("msize", v))
    obj.markerstyle.marker = v
    return
end

function set_mfcol!(::GLE, obj, v)
    gle_no_support("setting the marker face color.")
end

function set_mecol!(::GLE, obj, v)
    gle_no_support("setting the marker edge color.")
end

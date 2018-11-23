function set_color!(::Type{GLE}, obj, elem, v)
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

# --------------------
# TEXTSTYLE
# --------------------

function set_font!(::Type{GLE}, obj, v)
    v isa String || throw(OptionValueError("font", v))
    obj.textstyle.font = get(GLE_FONTS, v) do
        throw(OptionValueError("font", v))
    end
    return
end

function set_hei!(::Type{GLE}, obj, v::T) where T<:Real
    (v ≥ 0.) || throw(OptionValueError("hei", v))
    obj.textstyle.hei = v * PT_TO_CM
    return
end

# --------------------
# LINESTYLE
# --------------------

function set_lstyle!(::Type{GLE}, obj, v)
    if v isa Int
        v ≥ 0 || throw(OptionValueError("lstyle", v))
        obj.linestyle.lstyle = v
    elseif v isa String
        obj.linestyle.lstyle = get(GLE_LSTYLES, v) do
            (v == "none") || throw(OptionValueError("lstyle", v))
            -1
        end
    else
        throw(OptionValueError("lstyle", v))
    end
    return
end

function set_lwidth!(::Type{GLE}, obj, v)
    ((v isa Real) && (v ≥ 0.)) || throw(OptionValueError("lwidth", v))
    obj.linestyle.lwidth = v
    return
end

function set_smooth!(::Type{GLE}, obj, v)
    (v isa Bool) || throw(OptionValueError("smooth", v))
    obj.linestyle.smooth = v
    return
end

# --------------------
# MARKERSTYLE
# --------------------

function set_marker!(::Type{GLE}, obj, v)
    v isa String || throw(OptionValueError("marker", v))
    obj.markerstyle.marker = get(GLE_MARKERS, v) do
        throw(OptionValueError("marker", v))
    end
    return
end

function set_msize!(::Type{GLE}, obj, v)
    ((v isa Real) && (v ≥ 0.)) || throw(OptionValueError("msize", v))
    obj.markerstyle.msize = v
    return
end

set_mcol!(g::Type{GLE}, obj, v) = set_color!(g, obj, :markerstyle, v)

function set_mecol!(::Type{GLE}, obj, v)
    gle_no_support("setting the marker edge color.")
    # TODO, actually could overlay markers of different sizes. Would be easy
    # to do but a bit finicky to adjust so that it doesn't look horrible.
    # potentially the line width should be the lead for how much difference
    # there should be in the markersize.
end

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
    ((v isa Int) && (v ≥ 0)) || throw(OptionValueError("lstyle", v))
    obj.linestyle.lstyle = v
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

function set_mfcol!(::Type{GLE}, obj, v)
    gle_no_support("setting the marker face color.")
end

function set_mecol!(::Type{GLE}, obj, v)
    gle_no_support("setting the marker edge color.")
end

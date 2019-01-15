function set_color!(::Type{GLE}, obj, elem, v; name=:color)
    col = ∅
    try
        col = parse(Colorant, v)
    catch e
        throw(OptionValueError("color", v))
    end
    setfield!(getfield(obj, elem), name, col)
    return
end

set_color!(g, e::Union{Line2D, Ticks}, v) = set_color!(g, e, :linestyle, v)
set_color!(g, e::Hist2D, v) = set_color!(g, e, :histstyle, v)
set_color!(g, e::Union{Title, TicksLabels, Axis}, v) = set_color!(g, e, :textstyle, v)

# --------------------
# TEXT
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
    if obj isa Legend
        obj.hei = v * PT_TO_CM
    else
        obj.textstyle.hei = v * PT_TO_CM
    end
    return
end

# --------------------
# LINE
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


# for drawings, smooth  uses splines instead of straight lines
function set_smooth!(::Type{GLE}, obj, v)
    (v isa Bool) || throw(OptionValueError("smooth", v))
    obj.linestyle.smooth = v
    return
end

# --------------------
# MARKER
# --------------------

# type of marker (e.g. square)
function set_marker!(::Type{GLE}, obj, v)
    v isa String || throw(OptionValueError("marker", v))
    obj.markerstyle.marker = get(GLE_MARKERS, v) do
        throw(OptionValueError("marker", v))
    end
    return
end


# marker size
function set_msize!(::Type{GLE}, obj, v)
    ((v isa Real) && (v ≥ 0.)) || throw(OptionValueError("msize", v))
    obj.markerstyle.msize = v
    return
end


# marker color (if applicable)
set_mcol!(g::Type{GLE}, obj, v) = set_color!(g, obj, :markerstyle, v)


# marker edge color (if applicable)
function set_mecol!(::Type{GLE}, obj, v)
    gle_no_support("setting the marker edge color.")
    # TODO, actually could overlay markers of different sizes. Would be easy
    # to do but a bit finicky to adjust so that it doesn't look horrible.
    # potentially the line width should be the lead for how much difference
    # there should be in the markersize.
end

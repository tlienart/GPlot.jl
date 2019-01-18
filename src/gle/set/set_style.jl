function set_color!(::Type{GLE}, obj, elem::Symbol, v; name=:color)
    col = ∅
    try
        col = parse(Colorant, v)
        if col isa TransparentColor && !(gcf().transparency == true)
            @warn "Transparent colors are only supported when the figure " *
                  "has its transparency property set to 'true'. Ignoring α."
            col = convert(Color, col)
        end
    catch e
        throw(OptionValueError("color", v))
    end
    setfield!(getfield(obj, elem), name, col)
    return
end

set_color!(g, e::Union{Line2D, Ticks}, v) = set_color!(g, e, :linestyle, v)
set_color!(g, e::Hist2D, v) = set_color!(g, e, :barstyle, v)
set_color!(g, e::Fill2D, v) = set_color!(g, e, :fillstyle, v)
set_color!(g, e::Union{Title, TicksLabels, Axis}, v) = set_color!(g, e, :textstyle, v)

function set_alpha!(::Type{GLE}, obj, el::Symbol, v::Real; name=:color)
    if !(gcf().transparency == true)
        @warn "Transparent colors are only supported when the figure " *
              "has its transparency property set to 'true'. Ignoring α."
        return
    end
    (0. <= v <= 1.) || throw(OptionValueError("alpha"), v)
    # retrieve the color, convert it to RGB, create a RGBA object
    c = convert(RGB, getfield(getfield(obj, el), name))
    setfield!(getfield(obj, el), name, RGBA(c.r, c.g, c.b, v))
end

set_alpha!(g, e::Fill2D, v::Real) = set_alpha!(g, e, :fillstyle, v)

# --------------------
# TEXT
# --------------------

function set_font!(::Type{GLE}, obj, v::String)
    obj.textstyle.font = get(GLE_FONTS, v) do
        throw(OptionValueError("font", v))
    end
end


function set_hei!(::Type{GLE}, obj, v::Real)
    (v ≥ 0.) || throw(OptionValueError("hei", v))
    if obj isa Legend
        obj.hei = v * PT_TO_CM
    else
        obj.textstyle.hei = v * PT_TO_CM
    end
end

# --------------------
# LINE
# --------------------

function set_lstyle!(::Type{GLE}, obj, v::Union{Int, String})
    if v isa Int
        v ≥ 0 || throw(OptionValueError("lstyle", v))
        obj.linestyle.lstyle = v
    elseif v isa String
        obj.linestyle.lstyle = get(GLE_LSTYLES, v) do
            (v == "none") || throw(OptionValueError("lstyle", v))
            -1
        end
    end
end


function set_lwidth!(::Type{GLE}, obj, v::Real)
    (v ≥ 0.) || throw(OptionValueError("lwidth", v))
    obj.linestyle.lwidth = v
end


# for drawings, smooth  uses splines instead of straight lines
set_smooth!(::Type{GLE}, obj, v::Bool) = (obj.linestyle.smooth = v)

# --------------------
# MARKER
# --------------------

# type of marker (e.g. square)
function set_marker!(::Type{GLE}, obj, v::String)
    obj.markerstyle.marker = get(GLE_MARKERS, v) do
        throw(OptionValueError("marker", v))
    end
end


# marker size
function set_msize!(::Type{GLE}, obj, v::Real)
    (v ≥ 0.) || throw(OptionValueError("msize", v))
    obj.markerstyle.msize = v
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

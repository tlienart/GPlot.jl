####
#### Color related
####

function set_color!(::TBK, o, elem::Symbol, v; name=:color)
    setfield!(getfield(o, elem), name, try_parse_col(v))
    return o
end

set_color!(g, o::Line2D, v)             = set_color!(g, o, :linestyle, v)
set_color!(g, o::Union{Hist2D}, v)      = set_color!(g, o, :barstyle, v)
set_color!(g, o::Fill2D, v)             = set_color!(g, o, :fillstyle, v)
set_color!(g, o::Union{Title, Axis}, v) = set_color!(g, o, :textstyle, v)
set_color!(g, o::Ticks, v)              = set_color!(g, o.labels, :textstyle, v)

set_tickscolor!(g, o::Ticks, v) = set_color!(g, o, :linestyle, v)

function set_colors!(g::TBK, o::GroupedBar2D, vc; name=:color)
    if vc isa AbstractVector
        @assert length(vc) == size(o.xy, 2)-1 "Number of $(name)s must " *
                               "match the number of bar groups. Given: " *
                               "$(length(vc)), expected: $(size(o.xy, 2)-1)."
        for (i, cᵢ) ∈ enumerate(vc)
            setfield!(o.barstyle[i], name, try_parse_col(cᵢ))
        end
    else
        @assert size(o.xy, 2) == 2 "Only one $name given but expected the " *
                               "number of bar groups ($(size(o.xy, 2)-1))."
        setfield!(o.barstyle[1], name, try_parse_col(vc))
    end
    return o
end

set_fill!(g, o, v) = set_color!(g, o, :barstyle, v; name=:fill)
set_fills!(g, o, v) = set_colors!(g, o, v; name=:fill)

function set_alpha!(::TBK, o, el::Symbol, v::Real; name=:color)
    if !(gcf().transparency == true)
        @warn "Transparent colors are only supported when the figure " *
              "has its transparency property set to 'true'. Ignoring α."
        return o
    end
    (0. <= v <= 1.) || throw(OptionValueError("alpha"), v)
    # retrieve the color, convert it to RGB, create a RGBA object
    c = convert(RGB, getfield(getfield(o, el), name))
    setfield!(getfield(o, el), name, RGBA(c.r, c.g, c.b, v))
    return o
end

set_alpha!(g, o::Fill2D, v::Real) = set_alpha!(g, o, :fillstyle, v)

####
#### Text related
####

function set_font!(::TGLE, o, v::String)
    o.textstyle.font = get(GLE_FONTS, v) do
        throw(OptionValueError("font", v))
    end
end


function set_hei!(::TGLE, o, v::Real)
    (v ≥ 0.) || throw(OptionValueError("hei", v))
    if o isa Legend
        o.hei = v * PT_TO_CM
    else
        o.textstyle.hei = v * PT_TO_CM
    end
    return o
end

####
#### Line related
####

function set_lstyle!(::TGLE, o, v::Union{Int, String})
    if v isa Int
        v ≥ 0 || throw(OptionValueError("lstyle", v))
        o.linestyle.lstyle = v
    elseif v isa String
        o.linestyle.lstyle = get(GLE_LSTYLES, v) do
            (v == "none") || throw(OptionValueError("lstyle", v))
            -1
        end
    end
end


function set_lwidth!(::TBK, o, v::Real)
    (v ≥ 0.) || throw(OptionValueError("lwidth", v))
    o.linestyle.lwidth = v
end


# for drawings, smooth  uses splines instead of straight lines
set_smooth!(::TBK, o, v::Bool) = (o.linestyle.smooth = v)

####
#### Marker related
####

# type of marker (e.g. square)
function set_marker!(::TGLE, o, v::String)
    o.markerstyle.marker = get(GLE_MARKERS, v) do
        throw(OptionValueError("marker", v))
    end
    return o
end

# marker size
function set_msize!(::TBK, o, v::Real)
    (v ≥ 0.) || throw(OptionValueError("msize", v))
    o.markerstyle.msize = v
    return o
end

# marker color (if applicable)
set_mcol!(g::TBK, o, v) = set_color!(g, o, :markerstyle, v)

# marker edge color (if applicable)
function set_mecol!(::TGLE, o, v)
    gle_no_support("setting the marker edge color.")
    # TODO, actually could overlay markers of different sizes. Would be easy
    # to do but a bit finicky to adjust so that it doesn't look horrible.
    # potentially the line width should be the lead for how much difference
    # there should be in the markersize.
end

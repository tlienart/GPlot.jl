####
#### Color related
####

function set_color!(o, elem::Symbol, v; name=:color)
    setfield!(getfield(o, elem), name, try_parse_col(v))
    return o
end

set_color!(o::Scatter2D, v) = set_color!(o, :linestyle, v)
set_color!(o::Hist2D, v) = set_color!(o, :barstyle, v)
set_color!(o::Ticks,  v) = set_color!(o.labels, :textstyle, v)

set_color!(o::Union{Title, Axis}, v) = set_color!(o, :textstyle, v)

function set_color_v!(o::Bar2D, vc; name=:color)
    if vc isa Vector
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

set_fill!(o::Fill2D, v) = set_color!(o, :fillstyle, v)
set_fill!(o::Hist2D, v) = set_color!(o, :barstyle, v; name=:fill)
set_fill_v!(o::Bar2D, v) = set_color_v!(o, v; name=:fill)

function set_alpha!(o, el::Symbol, v::Real; name=:color)
    if !(gcf().transparency == true)
        @warn "Transparent colors are only supported when the figure " *
              "has its transparency property set to 'true'. Ignoring α."
        return o
    end
    (0 <= v <= 1) || throw(OptionValueError("alpha"), v)
    # retrieve the color, convert it to RGB, create a RGBA object
    c = convert(RGB, getfield(getfield(o, el), name))
    setfield!(getfield(o, el), name, RGBA(c.r, c.g, c.b, v))
    return o
end

set_alpha!(o::Fill2D, v::Real) = set_alpha!(o, :fillstyle, v)
set_alpha!(o::Hist2D, v::Real) = set_alpha!(o, :barstyle, v; name=:fill)

####
#### Text related
####

function set_font!(o, v::String)
    @assert get_backend() == GLE "font/only GLE backend supported"
    o.textstyle.font = get(GLE_FONTS, v) do
        throw(OptionValueError("font", v))
    end
    return o
end

function set_hei!(o, v::Real)
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

function set_lstyle!(l::LineStyle, v::Union{Int, String})
    if v isa Int
        v ≥ 0 || throw(OptionValueError("lstyle", v))
        l.lstyle = v
    elseif v isa String
        @assert get_backend() == GLE "lstyle/only GLE backend " *
                                              "supported"
        l.lstyle = get(GLE_LSTYLES, v) do
            (v == "none") || throw(OptionValueError("lstyle", v))
            -1
        end
    end
    return o
end
set_lstyle!(o, v::Union{Int, String}) = set_lstyle!(o.linestyle)

function set_lstyle_v!(o::Scatter2D, v::AbstractVector{Union{Int, String}})
    length(v) == length(o.linestyle) || throw(OptionValueError("lstyle, dimensions don't match"), v)
    for i ∈ 1:length(o.linestyle)
        set_lstyle!(o.linestyle[i], v[i])
    end
    return o
end
set_lstyle_v!(o::Scatter2D, v::Union{Int, String}) = set_lstyle_v!(o, fill(v, length(o.linestyle)))


function set_lwidth!(l::LineStyle, v::Real)
    (v ≥ 0.) || throw(OptionValueError("lwidth", v))
    l.lwidth = v
    return o
end
set_lwidth!(o, v::Real) = set_lwidth!(o.linestyle, v)

function set_lwidth_v!(o::Scatter2D, v::AVR)
    length(v) == length(o.linestyle) || throw(OptionValueError("lwidth, dimensions don't match"), v)
    for i ∈ 1:length(o.linestyle)
        set_lwidth!(o.linestyle[i], v[i])
    end
    return o
end
set_lwidth_v!(o::Scatter2D, v::Real) = set_lwidth_v!(o, fill(v, length(o.linestyle)))

# for drawings, smooth  uses splines instead of straight lines
set_smooth!(o, v::Bool) = (o.linestyle.smooth = v; o)

function set_smooth_v!(o::Scatter2D, v::Vector{Bool})
    length(v) == length(o.linestyle) || throw(OptionValueError("smooth, dimensions don't match"), v)
    for i ∈ 1:length(o.linestyle)
        o.linestyle[i] = v[i]
    end
    return o
end
set_smooth_v!(o::Scatter2D, v::Bool) = set_smooth_v!(o, fill(v, length(o.linestyle)))

####
#### Marker related
####

# type of marker (e.g. square)
function set_marker_v!(o::Scatter2D, v::Vector{String})
    @assert get_backend() == GLE "marker/only GLE backend supported"
    length(v) == length(o.markerstyle) || throw(OptionValueError("marker, dimensions don't match"), v)
    for i ∈ 1:length(o.markerstyle)
        o.markerstyle[i].marker = get(GLE_MARKERS, v[i]) do
            throw(OptionValueError("marker", v[i]))
        end
    end
    return o
end
set_marker_v!(o::Scatter2D, v::String) = set_marker_v!(o, fill(v, length(o.markerstyle)))

# marker size
function set_msize_v!(o::Scatter2D, v::AVR)
    length(v) == length(o.markerstyle) || throw(OptionValueError("msize, dimensions don't match"), v)
    for i ∈ 1:length(o.markerstyle)
        (v[i] ≥ 0.) || throw(OptionValueError("msize", v))
        o.markerstyle[i].msize = v[i]
    end
    return o
end

# marker color (if applicable)
set_mcol_v!(o::Scatter2D, v::Vector{Colorant}) = throw(NotImplementedError("Marker color"))

# marker edge color (if applicable)
function set_mecol_!(o::Scatter2D, v::Vector{Colorant})
    throw(NotImplementedError("Marker edge color"))
    # @assert get_backend() == GLE "marker/only GLE backend " *
    #                                       "supported"
    # GP_ENV["VERBOSE"] && println("🚫  GLE does not support mecol [ignoring]")
    # TODO, actually could overlay markers of different sizes. Would be easy
    # to do but a bit finicky to adjust so that it doesn't look horrible.
    # potentially the line width should be the lead for how much difference
    # there should be in the markersize.
end

####
#### Bar related
####

function set_width!(o::Bar2D, v::Real)
    @assert v > 0 "width must be positive"
    o.width = float(v)
    return o
end

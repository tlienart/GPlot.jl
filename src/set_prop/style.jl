####
#### COLOR:
####  set_color!, set_colors!, set_fill!, set_fills!, set_alpha!
####

"""
    set_color!(obj, field, col)

Internal function to set the color value `col` (after parsing) to `obj.field`.
"""
function set_color!(obj, field::Symbol, col::CandCol; name=:color)
    setfield!(getfield(obj, field), name, try_parse_col(col))
    return obj
end

"""
    set_color!(obj, col)

Internal functions to set the color value `col` (after parsing) to the appropriate
field of object `obj`.
"""
set_color!(obj::Hist2D, col) = set_color!(obj, :barstyle,  col)
set_color!(obj::Ticks, col) = set_color!(obj.labels, :textstyle, col)
set_color!(obj::Union{Title, Axis}, col) = set_color!(obj, :textstyle, col)

"""
    set_fill!(obj, col)

Internal functions to set the fill color value `v` (after parsing) to the appropriate
field of object `o`.
"""
set_fill!(obj::Fill2D, col) = set_color!(obj, :fillstyle, col)
set_fill!(obj::Hist2D, col) = set_color!(obj, :barstyle, col; name=:fill)

"""
    set_colors!(obj, field, cols)

Internal function to set the color values `cols` (after parsing) to `obj.field[i]` where
`i` covers the number of elements (e.g. vector of `LineStyle`).
"""
function set_colors!(obj, field::Symbol, cols::Vector{<:CandCol}; name=:color)
    # check dimensions match
    @assert length(cols) == size(obj.xy, 2)-1 "Number of $(name)s must match the number of " *
                                              "elements. Given: $(length(cols)), expected: " *
                                              "$(size(obj.xy, 2)-1)."
    # assign
    for (i, col) ∈ enumerate(cols)
        setfield!(getfield(obj, field)[i], name, try_parse_col(col))
    end
    return obj
end

"""
    set_colors!(obj, cols)

Internal function to set the color values `cols` (after parsing) to the appropriate fields
of the object `obj`. If a single value is passed, all fields will be assigned to that value.
"""
set_colors!(obj::Scatter2D, cols::Vector; opts...) = set_colors!(obj, :linestyle, cols; opts...)
set_colors!(obj::Bar2D, cols::Vector; opts...) = set_colors!(obj, :barstyle, cols; opts...)
set_colors!(obj::Scatter2D, col::CandCol; opts...) =
    set_colors!(obj, :linestyle, fill(col, length(obj.linestyle)); opts...)
set_colors!(obj::Bar2D, col::CandCol; opts...) =
    set_colors!(obj, :barstyle, fill(col, length(obj.barstyle)); opts...)

"""
    set_fills!(obj, cols)

Internal functions to set the fill color values `cols` (after parsing) to the appropriate
fields of object `o`. If a single value is passed, all fields will be assigned to that value.
"""
set_fills!(obj::Bar2D, cols) = set_colors!(obj, cols; name=:fill)

"""
    set_alpha!(obj, field, α)

Internal function to set the alpha value of `obj.field` to `α`. There must be a color
value available, it will be reinterpreted with the given alpha value.
"""
function set_alpha!(obj, field::Symbol, α::Real; name=:color)
    if !(gcf().transparency == true)
        @warn "Transparent colors are only supported when the figure " *
              "has its transparency property set to 'true'. Ignoring α."
        return obj
    end
    0 ≤ α ≤ 1 || throw(OptionValueError("alpha"), α)
    # retrieve the color, convert it to RGB, create a RGBA object
    col = convert(RGB, getfield(getfield(obj, field), name))
    setfield!(getfield(obj, field), name, RGBA(col.r, col.g, col.b, α))
    return obj
end

"""
    set_alpha!(obj, α)

Internal function to set the alpha value of the appropriate field of `obj` to `α`.
"""
set_alpha!(obj::Fill2D, α::Real) = set_alpha!(obj, :fillstyle, α)
set_alpha!(obj::Hist2D, α::Real) = set_alpha!(obj, :barstyle, α; name=:fill)

####
#### TEXT
####  set_font!, set_hei!
####

"""
    set_font!(obj, font)

Internal function to set the font associated with an object `obj` to the value `font`.
"""
function set_font!(obj, font::String)
    @assert get_backend() == GLE "font // only GLE backend supported"
    font_lc = lowercase(font)
    obj.textstyle.font = get(GLE_FONTS, font_lc) do
        throw(OptionValueError("font", font_lc))
    end
    return obj
end

"""
    set_hei!(obj, font)

Internal function to set the font associated with an object `obj` to the value `font`.
"""
function set_hei!(obj, v::Real)
    0 ≤ v || throw(OptionValueError("hei", v))
    if obj isa Legend
        obj.hei = v * PT_TO_CM
    else
        obj.textstyle.hei = v * PT_TO_CM
    end
    return obj
end

####
#### Line related
####

"""
    set_lstyle!(obj, lstyle)

Internal function to set the line style associated with object `obj`. The style
can be described by `lstyle` being a number or a String representing the pattern.
"""
function set_lstyle!(obj::LineStyle, v::Int)
    0 ≤ v || throw(OptionValueError("lstyle", v))
    obj.lstyle = v
    return obj
end
function set_lstyle!(obj::LineStyle, v::String)
    @assert get_backend() == GLE "lstyle/only GLE backend supported"
    v_lc = lowercase(v)
    obj.lstyle = get(GLE_LSTYLES, v_lc) do
        throw(OptionValueError("lstyle", v_lc))
    end
    return obj
end
set_lstyle!(obj, v) = set_lstyle!(o.linestyle, v)

"""
    set_lwidth!(obj, v)

Internal function to set the line width associated with the relevant field of `obj`.
"""
function set_lwidth!(obj::LineStyle, v::Real)
    (0 ≤ v) || throw(OptionValueError("lwidth", v))
    obj.lwidth = v
    return obj
end
set_lwidth!(obj, v) = set_lwidth!(obj.linestyle, v)

"""
    set_smooth!(obj, v)

Internal function to determine whether to use splines for a field of `obj`.
"""
set_smooth!(obj::LineStyle, v::Bool) = (obj.smooth = v; obj)


for opt ∈ ["lstyle", "lwidth", "smooth"]
    f!  = Symbol("set_" * opt * "!")
    fs! = Symbol("set_" * opt * "s!")
    ex = quote
        function $fs!(obj::Scatter2D, v::Vector)
            if length(v) != length(obj.linestyle)
                throw(OptionValueError($opt * "s // dimensions don't match", v))
            end
            for i ∈ 1:length(obj.linestyle)
                $f!(obj.linestyle[i], v[i])
            end
            return obj
        end
        $fs!(obj::Scatter2D, v) = $fs!(obj, fill(v, length(obj.linestyle)))
    end
    eval(ex)
end

# """
#     set_lstyles!(obj, lstyle)
#
# Internal function to set the line styles associated with the relevant fields of `obj`.
# The style can be described by `lstyle` being a number or a String representing the pattern.
# """
# function set_lstyles!(obj::Scatter2D, v::Vector{<:Union{Int, String}})
#     length(v) == length(obj.linestyle) || throw(OptionValueError("lstyles, dimensions " *
#                                                                  "don't match"), v)
#     for i ∈ 1:length(obj.linestyle)
#         set_lstyle!(obj.linestyle[i], v[i])
#     end
#     return obj
# end
# set_lstyles!(obj::Scatter2D, v::Union{Int, String}) =
#     set_lstyles!(obj, fill(v, length(obj.linestyle)))

# """
#     set_lwidths!(obj, v)
#
# Internal function to set the line widths associated with the relevant fields of `obj`.
# """
# function set_lwidths!(obj::Scatter2D, v::AVR)
#     length(v) == length(obj.linestyle) || throw(OptionValueError("lwidths, dimensions " *
#                                                                  "don't match"), v)
#     for i ∈ 1:length(obj.linestyle)
#         set_lwidth!(obj.linestyle[i], v[i])
#     end
#     return obj
# end
# set_lwidths!(obj::Scatter2D, v::Real) = set_lwidths!(obj, fill(v, length(obj.linestyle)))

# """
#     set_smooths!(obj, v)
#
# Internal function to determine whether to use splines for fields of `obj`.
# """
# function set_smooths!(obj::Scatter2D, v::Vector{Bool})
#     length(v) == length(obj.linestyle) || throw(OptionValueError("smooths, dimensions " *
#                                                                  "don't match"), v)
#     for i ∈ 1:length(obj.linestyle)
#         set_smooth!(obj.linestyle[i], v[i])
#     end
#     return obj
# end
# set_smooths!(obj::Scatter2D, v::Bool) = set_smooths!(obj, fill(v, length(obj.linestyle)))

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
set_msize_v!(o::Scatter2D, v::Real) = set_msize_v!(o, fill(v, length(o.markerstyle)))

# marker color (if applicable)
set_mcol_v!(o::Scatter2D, v::Vector{Colorant}) = throw(NotImplementedError("Marker color"))

# marker edge color (if applicable)
function set_mecol_v!(o::Scatter2D, v::Vector{Colorant})
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

####
#### COLOR:
####  set_color!, set_colors!, set_fill!, set_fills!, set_alpha!
####

"""
    set_color!(obj, col)

Internal functions to set the color value `col` (after parsing) to the appropriate
field of object `obj`.
"""
set_color!(o::Hist2D, c::Color) = (o.barstyle.color = c; o)
set_color!(o::Ticks, c::Color) = (o.labels.textstyle.color = c; o)
set_color!(o::Union{Title, Axis}, c::Color) = (o.textstyle.color = c; o)

"""
    set_fill!(obj, col)

Internal functions to set the fill color value `v` (after parsing) to the appropriate
field of object `obj`.
"""
set_fill!(o::Fill2D, c::Colorant) = (o.fillstyle.fill = c; o)
set_fill!(o::Hist2D, c::Colorant) = (o.barstyle.fill = c; o)

"""
    set_colors!(obj, cols, parent, field)

Internal function to set the color values `cols` (after parsing) to `obj.parent[i].field` where
`i` covers the number of elements (e.g. vector of `LineStyle`).
If a single value is passed, all fields will be assigned to that value.
"""
function set_colors!(o::Union{Bar2D, Scatter2D}, c::Vector{<:Color}, parent::Symbol, field::Symbol)
    # check dimensions match
    if length(c) != size(o.xy, 2)-1
        throw(OptionValueError("colors // dimensions don't match", c))
    end
    # assign
    ex = quote
        for (i, col) ∈ enumerate($c)
            $o.$parent[i].$field = col
        end
    end
    eval(ex)
    return o
end
set_colors!(o::Bar2D, c::Vector{<:Color}) = set_colors!(o, c, :barstyle, :color)
set_colors!(o::Scatter2D, c::Vector{<:Color}) = set_colors!(o, c, :linestyle, :color)
set_colors!(o::Union{Bar2D, Scatter2D}, c::Color) = set_colors!(o, fill(c, size(o.xy, 2)-1))

"""
    set_fills!(obj, cols)

Internal functions to set the fill color values `cols` (after parsing) to the appropriate
fields of object `o`. If a single value is passed, all fields will be assigned to that value.
"""
set_fills!(o::Bar2D, c::Vector{<:Color}) = set_colors!(o, c, :barstyle, :fill)
set_fills!(o::Bar2D, c::Color) = set_colors!(o, fill(c, size(o.xy, 2)-1), :barstyle, :fill)

"""
    set_alpha!(obj, α)

Internal function to set the alpha value of `obj.field` to `α`. There must be a color
value available, it will be reinterpreted with the given alpha value.
"""
function set_alpha!(o::Union{Fill2D, Hist2D}, α::Float64, parent::Symbol)
    α == 1.0 && return o
    ex = quote
        c = convert(RGB, $o.$parent.fill)
        $o.$parent.fill = RGBA(c.r, c.g, c.b, $α)
    end
    eval(ex)
    return o
end
set_alpha!(o::Fill2D, α::Float64) = set_alpha!(o, α, :fillstyle)
set_alpha!(o::Hist2D, α::Float64) = set_alpha!(o, α, :barstyle)

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
    set_hei!(obj, fontsize)

Internal function to set the font associated with an object `obj` to the value `font`.
"""
set_hei!(o::Legend, v::Float64) = (o.hei = v * PT_TO_CM; o)
set_hei!(o, v::Float64) = (o.textstyle.hei = v * PT_TO_CM; o)

####
#### Line related
####

"""
    set_lstyle!(obj, lstyle)

Internal function to set the line style associated with object `obj`. The style
can be described by `lstyle` being a number or a String representing the pattern.
"""
function set_lstyle!(o::LineStyle, v::Int)
    0 < v || throw(OptionValueError("lstyle", v))
    o.lstyle = v
    return o
end
function set_lstyle!(o::LineStyle, v::String)
    @assert get_backend() == GLE "lstyle // only GLE backend supported"
    v_lc = lowercase(v)
    o.lstyle = get(GLE_LSTYLES, v_lc) do
        throw(OptionValueError("lstyle", v_lc))
    end
    return o
end
set_lstyle!(o::Ticks, v::String) = set_lstyle!(o.linestyle, v)

"""
    set_lwidth!(obj, v)

Internal function to set the line width associated with the relevant field of `obj`.
"""
set_lwidth!(o::Union{LineStyle, Axis}, v::Float64) = (o.lwidth = v; o)
set_lwidth!(o::Ticks, v::Float64) = set_lwidth!(o.linestyle, v)

"""
    set_smooth!(obj, v)

Internal function to determine whether to use splines for a field of `obj`.
"""
set_smooth!(o::LineStyle, v::Bool) = (o.smooth = v; o)

####
#### Marker related
####

"""
    set_marker!(obj, marker)

Internal function to set the marker associated with object `obj`. The style
can be described by `marker` being a String describing the pattern.
"""
function set_marker!(o::MarkerStyle, v::String)
    @assert get_backend() == GLE "marker // only GLE backend supported"
    v_lc = lowercase(v)
    o.marker = get(GLE_MARKERS, v_lc) do
        throw(OptionValueError("marker", v_lc))
    end
    return o
end

"""
    set_msize!(obj, msize)

Internal function to set the marker size associated with object `obj`.
"""
set_msize!(o::MarkerStyle, v::Float64) = (o.msize = v; o)

"""
    set_mcol!(obj, col)

Internal function to set the marker color.
"""
set_mcol!(o::MarkerStyle, c::Color) = (o.color = c; o)


# generate functions that take vector inputs for linestyle and markerstyle
for case ∈ (:linestyle   => ("lstyle", "lwidth", "smooth"),
            :markerstyle => ("marker", "msize", "mcol"))
    field = case.first
    for opt ∈ case.second
        f_scalar! = Symbol("set_" * opt * "!")  # function with scalar input
        f_vector! = Symbol("set_" * opt * "s!") # e.g. set_markers!
        ex = quote
            # set function for a group of objects
            function $f_vector!(o::Scatter2D, v::Vector)
                if length(v) != length(o.$field)
                    throw(OptionValueError($opt * "s // dimensions don't match", v))
                end
                for i ∈ 1:length(o.$field)
                    $f_scalar!(o.$field[i], v[i]) # call the scalar function
                end
                return o
            end
            # if expects a vector but a scalar is given, a vector of
            # the appropriate size is filled with the scalar value
            $f_vector!(o::Scatter2D, v) = $f_vector!(o, fill(v, length(o.$field)))
        end
        eval(ex)
    end
end

####
#### Bar related
####

"""
    set_width!(obj, v)

Internal function to set the bin width to value `v`.
"""
set_width!(o::Bar2D, v::Float64) = (o.width = v; o)

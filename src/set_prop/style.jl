####
#### COLOR:
####  set_color!, set_colors!, set_fill!, set_fills!, set_alpha!
####

"""
    set_color!(obj, col)

Internal functions to set the color value `col` (after parsing) to the appropriate
field of object `obj`.
"""
set_color!(o::Hist2D, c::CandCol) = (o.barstyle.color = try_parse_col(c); o)
set_color!(o::Ticks, c::CandCol) =  (o.labels.textstyle.color = try_parse_col(c); o)
set_color!(o::Union{Title, Axis}, c::CandCol) = (o.textstyle.color = try_parse_col(c); o)

"""
    set_fill!(obj, col)

Internal functions to set the fill color value `v` (after parsing) to the appropriate
field of object `obj`.
"""
set_fill!(o::Fill2D, c::CandCol) = (o.fillstyle.fill = try_parse_col(c); o)
set_fill!(o::Hist2D, c::CandCol) = (o.barstyle.fill = try_parse_col(c); o)

"""
    set_colors!(obj, cols)

Internal function to set the color values `cols` (after parsing) to `obj.field[i]` where
`i` covers the number of elements (e.g. vector of `LineStyle`).
If a single value is passed, all fields will be assigned to that value.
"""
function set_colors!(@nospecialize(obj), cols::Union{CandCol, Vector{<:CandCol}}; isfill=false)
    if isa(cols, CandCol)
        cols = fill(cols, size(obj.xy, 2)-1)
    end
    # check dimensions match
    @assert length(cols) == size(obj.xy, 2)-1 "Number of $(ifelse(isfill, :fill, :color))s " *
                                              "must match the number of elements. Given: " *
                                              "$(length(cols)), expected: $(size(obj.xy, 2)-1)."
    # assign
    if isa(obj, Scatter2D)
        for (i, col) ∈ enumerate(cols)
            obj.linestyle[i].color = try_parse_col(col)
        end
    elseif isa(obj, Bar2D)
        if isfill
            for (i, col) ∈ enumerate(cols)
                obj.barstyle[i].fill = try_parse_col(col)
            end
        else
            for (i, col) ∈ enumerate(cols)
                obj.barstyle[i].color = try_parse_col(col)
            end
        end
    end
    return obj
end

"""
    set_fills!(obj, cols)

Internal functions to set the fill color values `cols` (after parsing) to the appropriate
fields of object `o`. If a single value is passed, all fields will be assigned to that value.
"""
set_fills!(o::Bar2D, c::Vector{<:CandCol}) = set_colors!(o, c; isfill=true)

"""
    set_alpha!(obj, α)

Internal function to set the alpha value of `obj.field` to `α`. There must be a color
value available, it will be reinterpreted with the given alpha value.
"""
function set_alpha!(@nospecialize(obj), α::Real)
    if !(gcf().transparency == true)
        @warn "Transparent colors are only supported when the figure " *
              "has its transparency property set to 'true'. Ignoring α."
        return obj
    end
    0 ≤ α ≤ 1 || throw(OptionValueError("alpha"), α)
    if isa(obj, Fill2D)
        col = convert(RGB, obj.fillstyle.fill)
        obj.fillstyle.fill = RGBA(col.r, col.g, col.b, α)
    elseif isa(obj, Hist2D)
        col = convert(RGB, obj.barstyle.fill)
        obj.barstyle.fill = RGBA(col.r, col.g, col.b, α)
    end
    return obj
end

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
    @assert get_backend() == GLE "lstyle // only GLE backend supported"
    v_lc = lowercase(v)
    obj.lstyle = get(GLE_LSTYLES, v_lc) do
        throw(OptionValueError("lstyle", v_lc))
    end
    return obj
end

"""
    set_lwidth!(obj, v)

Internal function to set the line width associated with the relevant field of `obj`.
"""
function set_lwidth!(obj::Union{LineStyle, Axis}, v::Real)
    (0 ≤ v) || throw(OptionValueError("lwidth", v))
    obj.lwidth = v
    return obj
end

"""
    set_smooth!(obj, v)

Internal function to determine whether to use splines for a field of `obj`.
"""
set_smooth!(obj::LineStyle, v::Bool) = (obj.smooth = v; obj)

####
#### Marker related
####

"""
    set_marker!(obj, marker)

Internal function to set the marker associated with object `obj`. The style
can be described by `marker` being a String describing the pattern.
"""
function set_marker!(obj::MarkerStyle, v::String)
    @assert get_backend() == GLE "marker // only GLE backend supported"
    v_lc = lowercase(v)
    obj.marker = get(GLE_MARKERS, v_lc) do
        throw(OptionValueError("marker", v_lc))
    end
    return obj
end

"""
    set_msize!(obj, msize)

Internal function to set the marker size associated with object `obj`.
"""
function set_msize!(obj::MarkerStyle, v::Real)
    0 ≤ v || throw(OptionValueError("msize", v))
    obj.msize = v
    return obj
end

"""
    set_mcol!(obj, col)

Internal function to set the marker color.
"""
set_mcol!(obj::MarkerStyle, col::CandCol) = (obj.color = try_parse_col(col); obj)


# generate functions that take vector inputs for linestyle and markerstyle
for case ∈ (:linestyle   => ("lstyle", "lwidth", "smooth"),
            :markerstyle => ("marker", "msize", "mcol"))
    field = case.first
    for opt ∈ case.second
        f!  = Symbol("set_" * opt * "!")
        fs! = Symbol("set_" * opt * "s!") # e.g. set_markers!
        ex = quote
            $f!(obj, v) = $f!(obj.$field, v)
            # set function for a group of objects
            function $fs!(obj::Scatter2D, v::Vector)
                if length(v) != length(obj.$field)
                    throw(OptionValueError($opt * "s // dimensions don't match", v))
                end
                for i ∈ 1:length(obj.$field)
                    $f!(obj.$field[i], v[i])
                end
                return obj
            end
            # if expects a vector but a scalar is given, a vector of
            # the appropriate size is filled with the scalar value
            $fs!(obj::Scatter2D, v) = $fs!(obj, fill(v, length(obj.$field)))
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
function set_width!(obj::Bar2D, v::Real)
    (0 < v) || throw(OptionValueError("bin width", v))
    obj.width = float(v)
    return obj
end

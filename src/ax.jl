"""
    erase!(axes)

Cleans up `axes` for a new drawing, keeps all other properties the same (ticks, ...).
"""
function erase!(a::Axes2D)::Option{PreviewFigure}
    a.drawings = Vector{Drawing2D}()
    a.objects  = Vector{Object2D}()
    a.legend   = ∅
    GP_ENV["CURAXES"] = a
    return _preview()
end

"""
    cla!()

Clears the current axes, removing all drawings and resetting all options.
"""
cla!()::Option{PreviewFigure} = (reset!(gca()); _preview())

"""
    cla()

See [`cla!`](@ref).
"""
cla = cla!

"""
    clo!()

Clears all objects (annotations, arrows, ...) from the current axes, leaves everything else.
"""
clo!() = (gca().objects = Vector{Object2D}(); _preview())

"""
    clo()

See [`clo!`](@ref).
"""
clo = clo!

####
#### [x|y|...]axis(...)
####

for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "axis!")   # :xaxis! ...
    f  = Symbol(axs * "axis")    # :xaxis  ...
    ff = Symbol(axs[1] * "axis") # :x2axis->:xaxis (for grid)
    ex = quote
        $f!(a::Axis; opts...)   = set_properties!(a; opts...)
        $f!(a::Axes; opts...)   = set_properties!(a.$f; opts...)
        $f!(::Nothing; opts...) = $f!(add_axes2d!(); opts...)
        function $f!(s::String=""; opts...)
            isempty(s) && return $f!(gca(); opts...)
            # try to interpret the string as a shorthand
            s_lc = lowercase(s)
            s_lc == "off"  && return $f!(gca(); off=true, opts...)
            s_lc == "log"  && return $f!(gca(); log=true, opts...)
            throw(OptionValueError("Unrecognised shorthand toggle for axis.", s))
        end
        $f = $f! # synonym
    end
    eval(ex)
end

"""
    math!()
    math!(a)

Set the (current) axes to math mode (where the axes go through (0,0)). It is recommended to also
adjust the axis limits via [`xlim!`](@ref) and [`ylim!`](@ref) to make sure that the origin is
somewhere in the drawn area (otherwise the results will be rather ugly).
"""
math!(a::Axes2D) = (a.math = true; nothing)
math!(::Nothing) = (add_axes2d!(); math!(gca()))
math!() = math!(gca())

"""
    math()

See [`math!`](@ref).
"""
math = math!

"""
    grid!()

Set grid mode on. By default the grid will be associated with both `xticks` and `yticks` but you
can also specify one axis to only have horizontal or vertical lines by using `which=["x"]`.
Options can be passed to specify the color of the grid, the style of the lines or their width.
"""
function grid!(a::Axes2D; which::Vector{String}=["x", "y"], opts...)::Option{PreviewFigure}
    for ax ∈ which
        ax_lc = lowercase(ax)
        if ax_lc ∉ ("x", "x2", "y", "y2")
            throw(OptionValueError("Unrecognized ax symbol.", ax))
        end
        # all options affect the ticks (in particular: color and width)
        axsym = Symbol(ax_lc * "axis")
        ticks = eval(:($a.$axsym.ticks))
        ticks.grid = true
        for optname ∈ opts.itr
            if optname ∈ (:col, :color)
                set_color!(ticks, col(opts[optname], optname))
            elseif optname ∈ (:ls, :lstyle, :linestyle)
                set_lstyle!(ticks, opts[optname])
            elseif optname ∈ (:lw, :lwidth, :linewidth)
                set_lwidth!(ticks, posfl(opts[optname], optname))
            else
                throw(UnknownOptionError(optname, a))
            end
        end
    end
    return _preview()
end
grid!(::Nothing; opts...) = grid!(add_axes2d!(); opts...)
grid!(; opts...) = grid!(gca(); opts...)

"""
    grid()

See [`grid!`](@ref).
"""
grid = grid!

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(a::Axes2D, el::Symbol, min::Option{Float64},
               max::Option{Float64})::Option{PreviewFigure}
    if min !== nothing && max !== nothing
        if min > max
            throw(OptionValueError("min must be strictly smaller than max", (min, max)))
        end
    end
    axis = getfield(a, el)
    setfield!(axis, :min, min)
    setfield!(axis, :max, max)
    return _preview()
end
_lim!(::Nothing, el, min, max) = _lim!(add_axes2d!(), el, fl(min), fl(max))

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "lim!")
    f  = Symbol(axs * "lim")
    ex = quote
        $f!(a::Axes2D, min::Option{Real}, max::Option{Real}) =
            _lim!(a, Symbol($axs * "axis"), fl(min), fl(max))
        $f!(min::Option{Real}, max::Option{Real}) =
            _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
        $f!(; min::Option{Real}=∅, max::Option{Real}=∅) =
            _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
        # synonyms
        $f(a::Axes2D, min::Option{Real}, max::Option{Real}) =
            _lim!(a, Symbol($axs * "axis"), fl(min), fl(max))
        $f(min::Option{Real}, max::Option{Real}) =
            _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
        $f(; min::Option{Real}=∅, max::Option{Real}=∅) =
            _lim!(gca(), Symbol($axs * "axis"), fl(min), fl(max))
    end
    eval(ex)
end

####
#### [x|y]scale, [x|y]scale! (synonyms though with ! is preferred)
####

function _scale!(a::Axis, v::String)::Option{PreviewFigure}
    a.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return _preview()
end

# Generate xscale!, xscale, and associated for each axis
for axs ∈ ("x", "y", "x2", "y2")
    f! = Symbol(axs * "scale!")       # xscale!
    f  = Symbol(axs * "scale")        # xscale
    ex = quote
        $f!(a::Axes2D, v::String) = _scale!(getfield(a, Symbol($axs * "axis")), v)
        $f!(::Nothing, v::String) = $f!(add_axes2d!(), v)
        $f!(v::String)            = $f!(gca(), v)
        # synonyms
        $f(a::Axes2D, v::String) = $f!(a, v)
        $f(v::String)            = $f!(gca(), v)
    end
    eval(ex)
end

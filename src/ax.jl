"""
    erase!(axes)

Cleans up `axes` for a new drawing, keeps all other properties the same (ticks, ...).
"""
function erase!(a::Axes2D)
    a.drawings = Vector{Drawing}()
    a.legend   = ∅
    GP_ENV["CURAXES"] = a
    return a
end

"""
    cla!()

Clears the current axes, removing all drawings and resetting all options.
"""
cla!() = reset!(gca()) # erase! removes drawings, clear! removes options
cla = cla!

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

math!(a::Axes2D) = (a.math = true; nothing)
math!(::Nothing) = (add_axes2d!(); math!(gca()))
math!() = math!(gca())
math = math!

function grid!(a::Axes2D; which::Vector{String}=["x", "y"], opts...)
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
    return nothing
end
grid!(::Nothing; opts...) = grid!(add_axes2d!(); opts...)
grid!(; opts...) = grid!(gca(); opts...)
grid = grid!

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(a::Axes2D, el::Symbol, min::Option{Float64}, max::Option{Float64})
    if min !== nothing && max !== nothing
        if min > max
            throw(OptionValueError("min must be strictly smaller than max", (min, max)))
        end
    end
    axis = getfield(a, el)
    setfield!(axis, :min, min)
    setfield!(axis, :max, max)
    return nothing
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

function _scale!(a::Axis, v::String)
    a.log = get(AXSCALE, v) do
        throw(OptionValueError("axis scale", v))
    end
    return nothing
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

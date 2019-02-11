"""
    cla!()

Clears the current axes, removing all drawings and resetting all options.
"""
cla!() = reset!(gca()) # erase! removes drawings, clear! removes options
cla = cla!

####
#### [x|y|...]axis(...)
####

for axs ∈ ["x", "y", "x2", "y2"]
    f! = Symbol(axs * "axis!")   # :xaxis! ...
    f  = Symbol(axs * "axis")    # :xaxis  ...
    ff = Symbol(axs[1] * "axis") # :x2axis->:xaxis (for grid)
    ex = quote
        $f!(a::Axis; opts...)   = (set_properties!(a; opts...); a)
        $f!(a::Axes; opts...)   = (set_properties!(a.$f; opts...); a)
        $f!(::Nothing; opts...) = $f!(add_axes2d!(); opts...)
        function $f!(s::String=""; opts...)
            isempty(s) && return $f!(gca(); opts...)
            # try to interpret the string as a shorthand
            s_lc = lowercase(s)
            s_lc == "off"  && return $f!(gca(); off=true, opts...)
            s_lc == "grid" && return $f!(gca(); grid=true, opts...)
            s_lc == "log"  && return $f!(gca(); log=true, opts...)
            throw(OptionValueError("Unrecognised shorthand toggle for axis.", s))
        end
        $f = $f! # synonym
    end
    eval(ex)
end

math!(a::Axes2D) = (a.math = true; a)
math!(::Nothing) = (add_axes2d!(); math!(gca()))
math!() = math!(gca())
math = math!

function grid!(a::Axes2D, which::Vector{String}=["x", "y"])
    for ax ∈ which
        ax_lc = lowercase(ax)
        @assert ax ∈ ["x", "x2", "y", "y2"] "Unrecognized ax symbol $ax."
        axis = Symbol(ax_lc * "axis")
        setfield!(getfield(a, axis), :grid, true)
    end
    return a
end
grid!(::Nothing) = (add_axes2d!(); grid!(gca()))
grid!() = grid!(gca())
grid = grid!

####
#### [x|y]lim, [x|y]lim! (synonyms though with ! is preferred)
####

function _lim!(a::Axes2D, el::Symbol, min::Option{Real}, max::Option{Real})
    if min isa Real && max isa Real
        @assert min < max "min must be strictly smaller than max"
    end
    axis = getfield(a, el)
    setfield!(axis, :min, float(min))
    setfield!(axis, :max, float(max))
    return a
end
_lim!(::Nothing, el, min, max) = _lim!(add_axes2d!(), el, min, max)

# Generate xlim!, xlim, and associated for each axis
for axs ∈ ["x", "y", "x2", "y2"]
    f! = Symbol(axs * "lim!")
    f  = Symbol(axs * "lim")
    ex = quote
        $f!(a, min, max)    = _lim!(a, Symbol($axs * "axis"), min, max)
        $f!(min, max)       = $f!(gca(), min, max)
        $f!(; min=∅, max=∅) = $f!(gca(), min, max)
        # synonyms
        $f(a, min, max)    = $f!(a, min, max)
        $f(min, max)       = $f!(gca(), min, max)
        $f(; min=∅, max=∅) = $f!(gca(), min, max)
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
    return a
end

# Generate xscale!, xscale, and associated for each axis
for axs ∈ ["x", "y", "x2", "y2"]
    f! = Symbol(axs * "scale!")       # xscale!
    f  = Symbol(axs * "scale")        # xscale
    ex = quote
        $f!(a::Axes2D, v) = _scale!(getfield(a, Symbol($axs * "axis")), v)
        $f!(::Nothing, v) = $f!(add_axes2d!(), v)
        $f!(v)            = $f!(gca(), v)
        # synonyms
        $f(a, v) = $f!(a, v)
        $f(v)    = $f!(gca(), v)
    end
    eval(ex)
end
